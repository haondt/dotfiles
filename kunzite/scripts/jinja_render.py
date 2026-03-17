#!/usr/bin/env python3
"""
Usage examples:

Render using a YAML vars file:
    python render.py -v values.yaml -t template.j2 -d output.txt

Render using a JSON vars file:
    python render.py -v values.json -t template.j2 -d output.txt

Render using an .env vars file:
    python render.py -v values.env -t template.j2 -d output.txt
"""

import os
import json
import yaml
import argparse
from jinja2 import Environment, FileSystemLoader

def load_vars(path):
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
        raise ValueError("Unsupported vars file type")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--vars", required=True, help="Path to vars file (.yaml|.json|.env)")
    parser.add_argument("-t", "--template", required=True, help="Path to Jinja2 template file")
    parser.add_argument("-d", "--dest", required=True, help="Path to destination output file")
    args = parser.parse_args()

    vars_data = load_vars(args.vars)

    env = Environment(loader=FileSystemLoader(os.path.dirname(args.template) or "."))
    template = env.get_template(os.path.basename(args.template))
    rendered = template.render(vars_data)

    with open(args.dest, "w") as f:
        f.write(rendered)

if __name__ == "__main__":
    main()

