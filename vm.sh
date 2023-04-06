#!/usr/bin/env bash

# Set the main variables.
SCRIPTPATH=$(dirname $(realpath $0))
CONFIGEXAMPLE='example.vm.cfg'
CONFIGFILE='vm.cfg'

# Assert a configuration file.
if ! [ -f ${SCRIPTPATH}/${CONFIGFILE} ]; then
  cp ${SCRIPTPATH}/${CONFIGEXAMPLE} ${SCRIPTPATH}/${CONFIGFILE}
fi

# Import configuration.
source ${SCRIPTPATH}/${CONFIGFILE}

# Check requirements and set new variables.
if ! [ -z ${VAGRANT_HOME_EXTERNAL} ]; then
  if ! [ -x "$(command -v vagrant)" ]; then
    echo 'Error: vagrant is not installed.'
    exit 1
  fi

  if ! [ -d ${VAGRANT_HOME_EXTERNAL} ]; then
    echo "Error: ${VAGRANT_HOME_EXTERNAL} is not accessible."
    exit 1
  fi

  # Record preset environment variables.
  VAGRANT_HOME_PRESET=${VAGRANT_HOME}

  # Set new environment variables.
  export VAGRANT_HOME=${VAGRANT_HOME_EXTERNAL}
fi

if ! [ -z ${VBOX_FOLDER_EXTERNAL} ]; then
  if ! [ -x "$(command -v vboxmanage)" ]; then
    echo 'Error: vboxmanage is not installed.'
    exit 1
  fi

  if ! [ -d ${VBOX_FOLDER_EXTERNAL} ]; then
    echo "Error: ${VBOX_FOLDER_EXTERNAL} is not accessible."
    exit 1
  fi

  vboxmanage setproperty machinefolder ${VBOX_FOLDER_EXTERNAL}
fi

# Extract arguments as an array
ARGS=("$@")
VAGRANT_COMMAND="${ARGS[0]}"

# Require confirmation for certain vagrant commands
case ${VAGRANT_COMMAND} in
  "destroy" )
    echo "WARNING: this might be a bad idea!"
    ;;
  "exec" )
    echo "$@"
    $@
    ;;

esac

# Run 'vagrant' command with all arguments
echo "vagrant $@"
vagrant $@

# Reset environment variables.
if ! [ -z ${VAGRANT_HOME_EXTERNAL} ]; then
  if ! [ -z ${VAGRANT_HOME_PRESET} ]; then
    export VAGRANT_HOME=${VAGRANT_HOME_PRESET}
  else
    unset VAGRANT_HOME
  fi
fi

if ! [ -z ${VBOX_FOLDER_EXTERNAL} ]; then
  vboxmanage setproperty machinefolder default
fi

exit 0
