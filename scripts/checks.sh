#!/bin/bash

# Default
ninxOn="$(cat '../nginxOn')"

if /usr/sbin/service nginx status | grep -q "active (running)"; then
    echo -e "$success Nginx ok"
    _clear_rules
    if [ "$ninxOn" != "0" ];then
      printf '0' > ../nginxOn
      _notify_success
    fi
else
  if [ "$nginxOn" == "0" ];then
    echo -e "$error Nginx inativo"
    _check
  else
    echo -e "$error Nginx continua OFF"
    _recheck
  fi
fi
 
