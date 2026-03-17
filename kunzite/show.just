scripts_directory := "scripts"

venv := "venv"
python := venv / "bin/python"

colors:
    {{python}} {{scripts_directory}}/colors.py

