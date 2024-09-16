#!/bin/sh

usage () 
{
  echo "Usage: `basename $0` [operation: -inc|-dec] [percentage: 1..100]"
}

INTEL_BACKLIGHT=/sys/class/backlight/intel_backlight

MAX_BRIGHTNESS_PATH=$INTEL_BACKLIGHT/max_brightness
BRIGHTNESS_PATH=$INTEL_BACKLIGHT/brightness

E_USAGE=64
E_OSFILE=72

if [ ! -e $INTEL_BACKLIGHT ] || [ ! -e $MAX_BRIGHTNESS_PATH ] || [ ! -e $BRIGHTNESS_PATH ]
then 
  printf "intel_backlight files not found:\n\t%s\n\t%s\n\t%s" $INTEL_BACKLIGHT $MAX_BRIGHTNESS_PATH $BRIGHTNESS_PATH 
  exit $E_OSFILE
fi 

PARAMS=2
DEFAULT_PERCENTAGE=5 
DEFAULT_OP="inc"

if [ $# -ne $PARAMS ] 
then 
  usage
  exit $E_USAGE
fi

op=${1:-$DEFAULT_OP}
percentage=${2:-$DEFAULT_PERCENTAGE}

case $percentage in 
  *[!0-9]*|'') 
    echo "Bad percentage, expected positive integer value">&2
    usage
    exit $E_USAGE
    ;;
  * )
    if [ $percentage -lt 1 ] || [ $percentage -gt 100 ]
    then
      usage
      exit $E_USAGE 
    fi
    ;;
esac

max_brightness=$(< $MAX_BRIGHTNESS_PATH)
curr_brightness=$(< $BRIGHTNESS_PATH)
offset=$((max_brightness*percentage/100))

case $op in 
  "-inc")
    if [ $curr_brightness -eq $max_brightness ]
    then 
        exit 0
    fi
    new_brightness=$((curr_brightness+offset))
    curr_brightness=$((new_brightness>max_brightness ? max_brightness : new_brightness))
    echo $curr_brightness > $BRIGHTNESS_PATH
    ;;
  "-dec" )
    if [ $curr_brightness -eq 0 ]
    then 
        exit 0
    fi
    new_brightness=$((curr_brightness-offset))
    curr_brightness=$((new_brightness<0 ? 0 : new_brightness))
    echo $curr_brightness > $BRIGHTNESS_PATH
    ;; 
  *)
    usage
    exit E_USAGE
    ;;
esac

exit 0
