#!/usr/bin/env bash
set -euf -o pipefail

if [[ -f runtime.txt ]] ; then
  python_exe=$(cat runtime.txt)
else
  python_exe=$(cat runtime.txt.default)
  echo "Using default runtime of $python_exe. You can create runtime.txt to override."
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

. $venvdir/bin/activate
pip install -U pip wheel pip-tools

if [[ ! -f requirements.txt ]] ; then
  if [[ ! -f requirements_project.in ]] ; then touch requirements_project.in; fi
  pip-compile requirements.in
fi

pip-sync requirements.txt
pre-commit install
pre-commit run --all-files
