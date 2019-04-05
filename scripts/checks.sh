#!/bin/bash
if /usr/sbin/service nginx status | grep -q "active (running)"; then
    echo -e "$success Nginx ok"
else
    case "$(cat '../nginxOn')" in
      "0" )
        echo -e "$error Nginx continua off"
      ;;
      "1" )
        echo -e "$error Nginx inativo"
        _check
        
#        _redirect "$slaveIp"
#        _notify "$slaveIp"
#        _reboot
      ;;
    esac
fi
 
