#!/bin/sh

TARGET_PRODUCT="ARCHISS PTR66"

files=`find /sys/devices | grep usb | grep product$`
for path in $files
do
  val=`cat $path`
  if [ "$val" = "$TARGET_PRODUCT" ]; then
    break
  fi
done
echo found: $path
addr=`echo $path | grep -E -o "[^/]*?/product$" | sed s,/product$,,`
echo addr: $addr

sudo sh -c "echo -n $addr > /sys/bus/usb/drivers/usb/unbind"
sudo sh -c "echo -n $addr > /sys/bus/usb/drivers/usb/bind"

echo done
sleep 1
