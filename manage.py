#!/usr/bin/env python
import os
import sys

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "settings")

    if not os.path.exists("settings.py"):
        from django.utils.crypto import get_random_string

        chars = "abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)"
        SECRET_KEY = get_random_string(50, chars)
        with open("settings.py", "w") as f:
            f.write(
                f'''from settings_base import *\nSECRET_KEY = """{SECRET_KEY}"""\n#EDIT BELOW HERE\n'''
            )

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
