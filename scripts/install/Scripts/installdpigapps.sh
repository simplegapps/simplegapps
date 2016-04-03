#!/sbin/sh
#This file is part of The Simple GApps script of @Alexander Lartsev.
#
#    The Simple GApps scripts are free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    These scripts are distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#

DENSITY=$(grep ro.sf.lcd_density /system/build.prop | cut -d "=" -f 2);

if [ $DENSITY == 120 ]; then
  echo "Installing GApps for 120ppi..."
  cp -f /tmp/simplegapps/priv-app/PrebuiltGmsCore/nodpi/PrebuiltGmsCore.apk /system/priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
  cp -f /tmp/simplegapps/priv-app/Velvet/nodpi/Velvet.apk /system/priv-app/Velvet/Velvet.apk
elif [ $DENSITY == 160 ]; then
  echo "Installing GApps for 160ppi..."
  cp -f /tmp/simplegapps/priv-app/PrebuiltGmsCore/mdpi/PrebuiltGmsCore.apk /system/priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
  cp -f /tmp/simplegapps/priv-app/Velvet/mdpi/Velvet.apk /system/priv-app/Velvet/Velvet.apk
elif [ $DENSITY == 240 ]; then
  echo "Installing GApps for 240ppi..."
  cp -f /tmp/simplegapps/priv-app/PrebuiltGmsCore/hdpi/PrebuiltGmsCore.apk /system/priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
  cp -f /tmp/simplegapps/priv-app/Velvet/hdpi/Velvet.apk /system/priv-app/Velvet/Velvet.apk
elif [ $DENSITY == 320 ]; then
  echo "Installing GApps for 320ppi..."
  cp -f /tmp/simplegapps/priv-app/PrebuiltGmsCore/xhdpi/PrebuiltGmsCore.apk /system/priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
  cp -f /tmp/simplegapps/priv-app/Velvet/xhdpi/Velvet.apk /system/priv-app/Velvet/Velvet.apk
elif [ $DENSITY == 480 ]; then
  echo "Installing GApps for 480ppi..."
  cp -f /tmp/simplegapps/priv-app/PrebuiltGmsCore/xxhdpi/PrebuiltGmsCore.apk /system/priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
  cp -f /tmp/simplegapps/priv-app/Velvet/nodpi/Velvet.apk /system/priv-app/Velvet/Velvet.apk
elif [ $DENSITY == 640 ]; then
  echo "Installing GApps for 640ppi..."
  cp -f /tmp/simplegapps/priv-app/PrebuiltGmsCore/xxxhdpi/PrebuiltGmsCore.apk /system/priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
  cp -f /tmp/simplegapps/priv-app/Velvet/nodpi/Velvet.apk /system/priv-app/Velvet/Velvet.apk
else
  echo "Your density is incorrect!Installing GApps for nodpi..."
  cp -f /tmp/simplegapps/priv-app/PrebuiltGmsCore/nodpi/PrebuiltGmsCore.apk /system/priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
  cp -f /tmp/simplegapps/priv-app/Velvet/nodpi/Velvet.apk /system/priv-app/Velvet/Velvet.apk
rm -rf /tmp/simplegapps/priv-app/