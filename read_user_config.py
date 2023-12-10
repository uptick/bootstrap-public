
""" Generates a default user_config.json

user_config.json isn't added to git and is used for customization.
permanent settings can be added there and kept between ansible runs.
"""
import json
import pathlib
import subprocess

config_file = pathlib.Path("~/user_config.json").expanduser()

keys = {"full_name", "email", "git_path"}

def guess_name():
    name = subprocess.check_output(['stat', '-f%Su', '/dev/console']).strip().decode('utf-8')
    full_name = subprocess.check_output(['id', '-P',name]).decode('utf-8').split(':')[7]
    return full_name, f"{'.'.join(full_name.split(' '))}@uptickhq.com".lower()

def read_user_config() -> dict:
    return json.loads(config_file.read_text())

def read_user_input(defaults) -> dict:
    default_name = defaults["full_name"]
    default_email = defaults["email"]
    default_git_path = defaults["git_path"]
    full_name = input(f"Your full name [default: {default_name}]?").strip() or default_name
    email = input(f"Your full work email [default: {default_email}]: ").strip().lower() or default_email

    folder = input(f"Your prefered base directory for work git repositories [default: {default_git_path}]: ").strip() or default_git_path

    folder_path = pathlib.Path(folder).expanduser().absolute()
    folder_path.mkdir(parents=True, exist_ok=True)
    git_path = str(folder_path)

    return {
        "full_name": full_name,
        "email": email,
        "git_path": git_path
    }

try:
    current_config = read_user_config()
    config = read_user_input(current_config)
except FileNotFoundError:
    default_name, default_email = guess_name()
    config = read_user_input(defaults={"full_name": default_name, "email": default_email, "git_path": "~/dev"})

config_file.write_text(json.dumps(config, indent=2))

