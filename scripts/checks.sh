#!/bin/bash
if /usr/sbin/service nginx status | grep -q "active (running)"; then
    echo -e "$success Nginx ok"
else
  if [ "$(cat '../nginxOn')" == "0" ];then
    echo -e "$error Nginx inativo"
    _check
  else
    echo -e "$error Nginx continua OFF"
    _recheck
  fi

#    case "$(cat '../nginxOn')" in
#      "0" )
#        echo -e "$error Nginx continua off"
#        
#      ;;
#      "1" )
#        echo -e "$error Nginx inativo"
#        _check
#        
##        _redirect "$slaveIp"
##        _notify "$slaveIp"
#      ;;
#    esac
fi
 
