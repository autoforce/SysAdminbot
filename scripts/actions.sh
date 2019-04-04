#!/usr/bin/env bash

# 1: Ip address
_redirect(){
  echo 1 > /proc/sys/net/ipv4/ip_forward


  iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination $1:80
  iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination $1:443
  iptables -t nat -A POSTROUTING -j MASQUERADE

  response="curl -s -o /dev/null -I -w \"%{http_code}\" \"http://$ip\""

  if [ "$response" == "200" ]; then
    bot "Redirecionamento realizado com sucesso :frenetico:"
  else
    bot "Erro ao fazer o redirecionamento! :coffin:, preciso que alguém configure o master: 'ssh -p 22001 cluster@$ip'"
  fi
}
