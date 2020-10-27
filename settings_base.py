import os

import django.conf.global_settings  # defaults

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
assert __file__ == os.path.join(PROJECT_DIR, "settings_base.py")

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    # Disable Django's own staticfiles handling in favour of WhiteNoise, for
    # greater consistency between gunicorn and `./manage.py runserver`. See:
    # http://whitenoise.evans.io/en/stable/django.html#using-whitenoise-in-development
    "whitenoise.runserver_nostatic",
    "django.contrib.staticfiles",
    "constance",
    "constance.backends.database",
]


MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    # The WhiteNoise middleware should be placed directly after the Django SecurityMiddleware (if you are using it) and before all other middleware
    "whitenoise.middleware.WhiteNoiseMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "urls"  # Why isn't this the default?
USE_TZ = True
USE_L10N = True
