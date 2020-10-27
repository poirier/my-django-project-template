#!/usr/bin/env bash
set -euf -o pipefail

if [[ -f runtime.txt ]] ; then
  python_exe=$(cat runtime.txt)
else
  cp runtime.txt.default runtime.txt
  python_exe=$(cat runtime.txt)
  echo "Did not find runtime.txt file, so creating one with $python_exe. You can edit runtime.txt to change it."
fi

if $python_exe -V >/dev/null 2>&1 ; then
  : okay
else
  echo "ERROR: $python_exe is not available. Recommend installing with pythonz or your own favorite method, then running this again."
  exit 1
fi

if [[ -f projectname.txt ]] ; then
  project=$(cat projectname.txt)
else
  thisdir=$(cd $(dirname $0);/bin/pwd)
  project=$(basename $thisdir)
  echo "Did not find projectname.txt file, so creating one with project name $project. You can edit projectname.txt to change it."
  echo $project >projectname.txt
fi

venvdir=../${project}.venv
$python_exe -m venv $venvdir
# Set up .envrc for direnv users
venv_activation_command=". $venvdir/bin/activate"
if [[ ! -e .envrc ]] ; then
  echo $venv_activation_command >.envrc
elif grep "$venv_activation_command" .envrc ; then
  :
else
  echo $venv_activation_command >>.envrc
fi

$venv_activation_command
pip install -U --quiet pip wheel pip-tools

if [[ ! -f requirements.txt ]] ; then
  if [[ ! -f requirements_project.in ]] ; then touch requirements_project.in; fi
  pip-compile requirements.in
fi

pip-sync --quiet requirements.txt

pre-commit install
pre-commit run --all-files

