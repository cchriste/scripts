# install and configure openvisus for conda, can optionally pass version

if [ -z "$PS1" ]; then
  echo "ERROR: must call this script using \". ~/bin/conda_install_openvisus.sh [version]\")"
  return 1
fi

package="openvisus"
version_str=""
env_version_str=""
if [ "$1" ]; then
  echo "installing version $1..."
  version_str="=$1"
  env_version_str="-$1"
fi

#create conda env if it doesn't already exist
if [ -z "`conda env list | grep ${package}${env_version_str}`" ]; then
  conda create -y -n ${package}${env_version_str}
fi

#activate environment
conda activate ${package}${env_version_str}

#install OpenVisus
conda install -y -c visus ${package}${version_str}
export VISUS_HOME=${CONDA_PREFIX}/OpenVisus

#create symlink from conda install path to VISUS_HOME
ln -s $(python3 -c "import os, OpenVisus; print(os.path.dirname(OpenVisus.__file__))") ${VISUS_HOME}

# create symlink to visus executable (some things are still using visus.sh, so just symlink it too)
if [ `uname` = Darwin ]; then
  ln -s ${VISUS_HOME}/bin/visus.app/Contents/MacOS/visus ${CONDA_PREFIX}/bin/visus
  ln -s ${VISUS_HOME}/bin/visus.app/Contents/MacOS/visus ${CONDA_PREFIX}/bin/visus.sh
else
  ln -s ${VISUS_HOME}/bin/visus ${CONDA_PREFIX}/bin/visus
  ln -s ${VISUS_HOME}/bin/visus ${CONDA_PREFIX}/bin/visus.sh
fi

echo "in the future, activate this environment using \". ~/bin/conda_activate.sh ${package}${env_version_str}\""
