#!/bin/sh

    while ! nmcli device wifi rescan
    do
      sleep 1s &&
      true
    done &&
    nmcli device wifi list | grep "^\s" | cut --bytes 1-29 | sed -e "s#^\s*##" -e "s#\s*\$##" | while read SSID
    do
      case "${SSID}" in
        "Richmond Sq Guest")
          nmcli device wifi connect "${SSID}" password guestwifi &&
            true
        ;;
        "56LY")
          nmcli device wifi connect "${SSID}" password "$(pass show wifi/${SSID})" &&
            true
        ;;
      esac &&
        true
    done &&
    true
