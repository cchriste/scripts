# activate an openvisus env

#usage:
# . ~/bin/conda_activate.sh <conda_envname>

if [ -z "$PS1" ] || [ -z "$1" ]; then
  echo "ERROR: must call this script using \". ~/bin/conda_activate.sh <conda_envname>\")"
else
  echo "activating $1..."
  conda activate $1
  export VISUS_HOME=${CONDA_PREFIX}/OpenVisus
fi

