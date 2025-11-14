#!/bin/bash

NAME=`basename $0`

usage () 
{
  cat <<EOF
Usage:  $NAME [OPTION]

Sets screen brightness using intel backlight.

Options:
  -s, --set <percentage>       Set brightness to <percentage>
  -i, --increase <percentage>  Increase the current brightness with <percentage> 
  -d, --decrease <percentage>  Decrease the current brightness with <percentage>
  -r, --reset                  Reset to maximum brightness (100%)

  -h, --help                   Display this help and exit

Percentage should be between 0 and 100.
EOF
}

INTEL_BACKLIGHT=/sys/class/backlight/intel_backlight
MAX_BRIGHTNESS_PATH=$INTEL_BACKLIGHT/max_brightness
BRIGHTNESS_PATH=$INTEL_BACKLIGHT/brightness

if [ ! -e $INTEL_BACKLIGHT ] 
then 
  echo "Error: $INTEL_BACKLIGHT is not found" >&2
  echo "This tool controls brightness using backlight for intel cards only, sorry!" >&2
  exit 1
fi 

if [ ! -e $MAX_BRIGHTNESS_PATH ] || [ ! -e $BRIGHTNESS_PATH ]
then 
  echo "Error: files $MAX_BRIGHTNESS_PATH or $BRIGHTNESS_PATH are not found" >&2
  exit 1
fi

OPTIONS=s:i:d:rh
LONG_OPTIONS=set:,increase:,decrease:,reset,help

PARSED=$(getopt -o $OPTIONS -l $LONG_OPTIONS -n $NAME -- "$@")

if [ $? -ne 0 ]; then
  exit 1
fi

eval set -- "$PARSED"
unset PARSED

operation=""
percentage=""

while true; do
  case "$1" in
    '-s'|'--set')
      operation="set"
      percentage="$2"
      shift 2
      continue
      ;;
    '-i'|'--increase')
      operation="inc"
      percentage="$2"
      shift 2
      continue
      ;;
    '-d'|'--decrease')
      operation="dec"
      percentage="$2"
      shift 2
      continue
      ;;
    '-r'|'--reset')
      shift
      operation="res"
      continue
      ;;
    '-h'|'--help')
      usage
      exit 0
      ;;
    '--')
      break
      ;;
    *)
      echo "Error: Invalid option '$1'" >&2
      exit 1
      ;;
  esac
done


if [ -z $operation ]; then
    echo "Error: no operation specified" >&2
    usage
    exit 1
fi

max_brightness=$(< $MAX_BRIGHTNESS_PATH)

if [[ $operation == res ]]; then
  echo $max_brightness > $BRIGHTNESS_PATH
  exit 0
fi

case $percentage in 
  ''|*[!0-9]*|0[0-9]*) 
    echo "Error: Bad percentage, expected integer value between 0..100" >&2
    exit 1
    ;;
  * )
    if [ $percentage -lt 0 ] || [ $percentage -gt 100 ]
    then
      echo "Error: Bad percentage, expected integer value between 0..100" >&2
      exit 1
    fi
    ;;
esac

offset=$((max_brightness*percentage/100))
curr_brightness=$(< $BRIGHTNESS_PATH)

case "$operation" in
  'set')
    echo $offset > $BRIGHTNESS_PATH
    exit 0
    ;;
  'inc')
    new_brightness=$((curr_brightness+offset))
    ;;
  'dec')
    new_brightness=$((curr_brightness-offset))
    ;;
esac

[ "$new_brightness" -lt 0 ] && new_brightness=0
[ "$new_brightness" -gt "$max_brightness" ] && new_brightness=$max_brightness

echo $new_brightness > $BRIGHTNESS_PATH

exit 0
