#!/bin/sh -i

INSTALL_DIR=/usr/local/bin
RULES_DIR=/etc/udev/rules.d

script_dir=$(readlink -f $(dirname $0))

echo "Copying backlight udev rules to $RULES_DIR"
cp -i $script_dir/backlight.rules -t $RULES_DIR
cp_br=$?
if [ $cp_br -eq 0 ]
then 
  echo
  echo "Overwritten backlight udev rules to $RULES_DIR"
fi
echo
 
echo "Copying intel-backlight binary to $INSTALL_DIR"
cp -i $script_dir/intel-backlight.sh $INSTALL_DIR/intel-backlight
cp_ib=$?
if [ $cp_ib -eq 0 ] 
then 
  echo
  echo "Overwritten intel-backligh to $INSTALL_DIR"
fi

if [ $cp_br -eq 0 ] && [ $cp_ib -eq 0 ]
then 
  echo
  echo "Installed intel-backlight."
fi

if [ $cp_br -ne 0 ] && [ $cp_ib -ne 0 ]
then 
  echo
  echo "intel-backlight already installed."
fi

exit 0
