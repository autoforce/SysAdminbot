#!/bin/bash

# Default
nginxOn="$(cat '../nginxOn')"
nginxStatus="$(/usr/sbin/service nginx status)"
if printf "$nginxStatus" | grep -q "active (running)"; then
    echo -e "$success Nginx ok"
    _clear_rules
    if [ "$nginxOn" != "0" ];then
      printf '0' > ../nginxOn
      _notify_success
    fi
else
  if [ "$nginxOn" == "0" ];then
    echo -e "$error Nginx inativo" 
    bot "$verbose" -e "\`\`\`$nginxStatus\`\`\`"
    _check
  else
    echo -e "$error Nginx continua OFF"
    _recheck
  fi
fi
 
