#!/usr/bin/env python3
import sys, os, yaml, typing
from types import NoneType
from jinja2 import Environment, FileSystemLoader
from pathlib import Path 
import json, argparse

def _represent_str(dumper, data):
    """
        configures yaml for dumping multiline strings
        Ref: https://stackoverflow.com/questions/8640959/how-can-i-control-what-scalar-form-pyyaml-uses-for-my-data

        I am intentionally not stripping trailing newlines, meaning if you have them it will go back to the default style. I am doing this in order to avoid changing the contents of the string in any way.
    """
    
    if data.count('\n') > 0:
        return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
    return dumper.represent_scalar('tag:yaml.org,2002:str', data)

yaml.add_representer(str, _represent_str)

def _to_yaml(data):
    return yaml.dump(data)

def deep_merge(d1, d2, conflicts="new", path="", overwrite_with_none=True):
    if conflicts not in ["new", "old", "err"]:
        raise ValueError("Unexpected conflict resolution:" + conflicts)
    if d1 is None:
        return d2
    if d2 is None and overwrite_with_none:
        return None
    def merge_list(l1, l2):
        l3 = []
        added = set()
        for item in l1 + l2:
            if isinstance(item, typing.Hashable):
                if item in added:
                    continue
                added.add(item)
            l3.append(item)
        return l3
    result = d1.copy()
    for k, v in d2.items():
        if k not in result:
            result[k] = v
            continue
        if v is None:
            if not overwrite_with_none:
                continue
        if type(v) != type(result[k]):
            if conflicts == "new":
                result[k] = v
            elif conflicts == "err":
                raise KeyError(f"Multiple entries found for key: {path}.{k}")
            continue
        if isinstance(v, dict):
            result[k] = deep_merge(result[k], v, conflicts, path + "." + k, overwrite_with_none=overwrite_with_none)
            continue
        if isinstance(v, (tuple, list)):
            result[k] = merge_list(result[k], v)
            continue
        if conflicts == "new":
            result[k] = v
        elif conflicts == "err":
            raise KeyError(f"Multiple entries found for key: {path}.{k}")
    return result

env_stack = []

jinja_env = Environment(
    loader=FileSystemLoader("/"),
    variable_start_string="[[",
    variable_end_string="]]",
    block_start_string="[%",
    block_end_string="%]",
    comment_start_string="[#",
    comment_end_string="#]"
)

jinja_env.filters['to_yaml'] = _to_yaml

def load_yaml_with_env(file_path, env):
    with open(file_path) as f:
        content = f.read()
    template = jinja_env.from_string(content)
    rendered = template.render(**env)
    return yaml.safe_load(rendered) or {}

def create_directory_skeleton(path: str) -> None | dict | list:
    result = None
    for entry in os.scandir(path):
        name = os.path.splitext(entry.name)[0]
        if name == '.yml' or name == '.yaml':
            result = result or {}
            continue
        if name.startswith('.'):
            continue
        if result is None:
            result = {}
        if entry.is_dir() or entry.name.endswith(('.yml', '.yaml')):
            result[name] = None
        else:
            result[entry.name] = None
    if result is not None \
        and len(result) > 0 \
        and all([i.isdigit() for i in result.keys()]):
        result = [None for _ in range(max([int(i) for i in result.keys()])+1)]
    return result

def process_directory(base_dir, parent_env={}):
    result = create_directory_skeleton(base_dir)
    if result is None:
        return result

    current_env = parent_env
    for env_file in ['.env.yaml', '.env.yml']:
        env_file_path = os.path.join(base_dir, env_file)
        if os.path.exists(env_file_path):
            with open(env_file_path, 'r') as f:
                env_content = yaml.safe_load(f) or {}
            current_env = deep_merge(parent_env, env_content)
            break

    def merge_into_result(data, data_name: str, result):
        if data_name == '.yml' or data_name == '.yaml':
            return deep_merge(result, data)
        if isinstance(result, dict):
            return deep_merge(result, {data_name: data})
        assert isinstance(result, list)
        new_result = [i for i in result]
        index = int(data_name)
        new_result[index] = deep_merge(result[index], data)
        return new_result

    for entry in sorted(os.listdir(base_dir)):
        path = os.path.join(base_dir, entry)
        name = os.path.splitext(entry)[0]
        if name.startswith('.') and name != '.yaml' and name != '.yml':
            continue
        if os.path.isdir(path):
            sub_result = process_directory(path, current_env)
            result = merge_into_result(sub_result, name, result)
        elif entry.endswith((".yaml", ".yml")):
            data = load_yaml_with_env(path, current_env)
            result = merge_into_result(data, name, result)
        elif entry.endswith((".sh",)):
            with open(path, "r") as f:
                data = f.read()
            result = merge_into_result(data, entry, result)
    return result

def load_vars(path: str):
    if path.endswith((".yaml", ".yml")):
        with open(path) as f:
            return yaml.safe_load(f)
    elif path.endswith(".json"):
        with open(path) as f:
            return json.load(f)
    elif path.endswith(".env"):
        vars_dict = {}
        with open(path) as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#"):
                    continue
                if "=" in line:
                    k, v = line.split("=", 1)
                    vars_dict[k.strip()] = v.strip()
        return vars_dict
    else:
        raise ValueError(f"Unsupported vars file type: {path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("directory", type=Path, help="path to template directory")
    parser.add_argument("-v", "--vars", action='append', nargs=2, metavar=("KEY", "FILE"), help="Key and file to load into template (.yaml|.json|.env)")
    args = parser.parse_args()

    initial_env = {}
    if args.vars:
        for k, fp in args.vars:
            initial_env = deep_merge(initial_env, {k: load_vars(fp)})

    final_data = process_directory(args.directory, initial_env)
    print(yaml.dump(final_data, sort_keys=False))

