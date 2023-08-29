# VM tools

Simple wrapper around **Vagrant** that sets `$VAGRANT_HOME` to a directory other than `~/.vagrant.d`. The script then executes the `vagrant` command and resets the values to their defaults.

This approach allows VMs to be stored in a removable device.

## Requirements

This script requires **Vagrant** to be installed.

## Installation

First grab the script and have a look at what is included:

    git clone https://github.com/tiagosimoes-euf/vmtools.git
    cd vmtools/ && ls -hAl

Copy the example config file and edit the active config file:

    cp example.vm.cfg vm.cfg
    nano vm.cfg

Make the script executable and put it somewhere in your `$PATH`:

    chmod a+x vm.sh
    sudo ln -s ${PWD}/vm.sh /usr/local/bin/vm

## Usage

Run `vm global-status` and see the output of `vagrant global-status`.
