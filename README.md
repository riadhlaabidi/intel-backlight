# intel-backlight

`intel-backlight` is a replacement utility tool for `xbacklight` to control screen brightness for laptops having an Intel graphic card.

This script is mainly created because of the `xbacklight` error: 

```
No outputs have backlight property
```

for which nothing really seems to fix the issue following the steps described in [here](https://wiki.archlinux.org/title/Backlight).

## Install

To install `intel-backlight`, clone this repository:

```bash
git clone https://github.com/riadhlaabidi/intel-backlight
```

This script uses the interface provided in `/sys/class/backlight` to write the power level of the backlight LEDs. In case of Intel graphic cards this directory
will be named `intel_backlight`, inside it there are two main files `max_brightness` and `brightness`, which are used to write power level values.
 
For this to work, you need to create a group (`video` for example), if it doesn't exist already, and add your current user to it. This way the setup script will add 
a udev rule `backlight.rules` in `/etc/udev/rules.d` giving the group needed permissions to edit the brightness file on boot.

```bash
sudo groupadd video

# add current user to the group
sudo usermod -aG video $USER
```

Next, install the tool using `setup.sh`

```bash
sudo ./setup.sh
```
> [!NOTE]
> You may need to logout/reboot in order for the changes in udev rules to take effect.

You can then verify it's working by running:

```bash
intel-backlight

```

## Usage

There are 2 options to update brightness: 

```bash 
# increase brightness by x % 
intel-backlight -inc 20
```

```bash 
# decrease brightness by x % 
intel-backlight -dec 20
```

Increasing and decreasing operations take a value between `0..100`, if the actual brightness is at max (100%): any further increasing will not take effect. Same as for decreasing, if the actual brightness is at min (0%): any further decreasing will be ignored.
