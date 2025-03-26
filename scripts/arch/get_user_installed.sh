#!/usr/bin/env bash
# get_user_installed.sh
comm -23 <(pacman -Qeq | sort -u) <(xargs -n 1 pactree -u <<<"${@}" | sort -u)
