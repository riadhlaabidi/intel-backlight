#!/bin/sh

script_dir=$(readlink -f $(dirname $0))

cp -i $script_dir/backlight.rules -t /etc/udev/rules.d

echo "Copied backlight udev rule"

# TODO: Install intel-backlight bin to /usr/local/bin
# TODO: Install brightness bin to /usr/local/bin
# TODO: Write steps in README.md

exit 0
