#!/bin/sh

ioreg -n AppleSmartBattery -r | awk '$1~/ExternalConnected/{gsub("Yes", "1");gsub("No", "0"); print substr($0, length, 1)}'
