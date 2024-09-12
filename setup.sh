#!/bin/sh

script_dir=$(readlink -f $(dirname $0))

cp -i $script_dir/backlight.rules -t /etc/udev/rules.d

echo "Copied backlight udev rule"

exit 0
