#!/usr/bin/env bash

SSH_CONFIG_DIR=~/.ssh

[[ -d "$SSH_CONFIG_DIR" ]] && chmod 700 "$SSH_CONFIG_DIR"
[[ -f "$SSH_CONFIG_DIR/authorized_keys" ]] && chmod 600 "$SSH_CONFIG_DIR/authorized_keys"
[[ -f "$SSH_CONFIG_DIR/config" ]] && chmod 600 "$SSH_CONFIG_DIR/config"
[[ -f "$SSH_CONFIG_DIR/known_hosts" ]] && chmod 600 "$SSH_CONFIG_DIR/known_hosts"
find "$SSH_CONFIG_DIR" -type f -name "id_*" -not -name "*.*" -exec chmod 600 {} \;
find "$SSH_CONFIG_DIR" -type f -name "*.pub" -exec chmod 644 {} \;
