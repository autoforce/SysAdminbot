#!/bin/bash

. actions.sh

if /usr/sbin/service nginx status | grep -q "active (running)"; then
    echo -e "$success Nginx ok"
else
    case "$(cat '../nginxOn')" in
      "0" )
        echo -e "$error Nginx continua off"
      ;;
      "1" )
        echo -e "$error Nginx inativo"
        printf "0" > ../nginxOn 
	      bot -e "O NGINX CAIU, estou redirecionando ele ao slave: $slaveIp ($slaveName)"
        _redirect "$slaveIp"
      ;;
    esac
fi
 
