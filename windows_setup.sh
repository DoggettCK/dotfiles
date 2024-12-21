#!/usr/bin/env bash

system_name=$(uname -a)
username=$(whoami)

if [[ ! $system_name =~ WSL ]]; then
  echo "WSL not detected in system name ($system_name), try running setup.sh instead."
  exit 1
fi

alacritty_config_dir="/mnt/c/Users/$username/AppData/Roaming/alacritty"

if [ ! -d "$alacritty_config_dir" ]; then
  echo "Creating Alacritty config dir: $alacritty_config_dir"
  mkdir -p "$alacritty_config_dir"
else
  echo "Alacritty config dir already exists: $alacritty_config_dir"
fi

pushd .config/alacritty > /dev/null || exit

for filename in *.toml; do
  dest_filename="${alacritty_config_dir}/${filename}"
  echo "Copying $filename to $dest_filename"

  if [ -f "$dest_filename" ]; then
    echo "Destination file already exists: $dest_filename"
  fi

  cp -i "$filename" "$dest_filename"
done

popd > /dev/null || exit

exit 0
