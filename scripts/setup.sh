#!/usr/bin/env bash

# shellcheck disable=1091
source common_functions

# Detect OS
shopt -s nocasematch
case $(uname -a) in
*"Arch"*) warning_msg "Installation process has changed. Run setup_arch.sh instead." ;;
*"Darwin"*) warning_msg "Installation process has changed. Run setup_osx.sh instead." ;;
esac

exit 1
