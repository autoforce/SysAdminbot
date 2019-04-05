#!/usr/bin/env bash

# 1: Ip address
_pong(){
  echo "$(proxychains curl -o /dev/null --silent --head --write-out \"%{http_code}\" \"https://$ip\" &3>/dev/null)"
}

_notify_redirect() {
  response="$(echo $(_pong) | awk '{ print $3 }')" 

  if [ "$response" == '"000"' ]; then
    bot "$info" "Erro ao fazer o redirecionamento! :coffin:, preciso que alguém configure o master: 'ssh -p 22001 cluster@$ip'"
  else
    bot "$info" "Redirecionamento realizado com sucesso :frenetico:"
  fi
}

_notify_success(){
  bot "$info" "NGINX FUNCIONANDO E OPERANTE :god:"
}

_redirect(){
  printf '0' > ../nginxOn
  echo 1 > /proc/sys/net/ipv4/ip_forward

  iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination $1:80
  iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination $1:443
  iptables -t nat -A POSTROUTING -j MASQUERADE || bot "$info" -e "Não consegui nem se quer configurar o IPTABLES, houve algum erro :empenado:"
}

_reboot(){ 
  systemctl restart nginx
}

_clear_rules(){
  iptables -t mangle -F
  iptables -t nat -F
}

_check(){
  response="$(echo $(_pong) | awk '{ print $3 }')"

  if [ "$response" == '"000"' ]; then
    bot "$info" -w "NGINX iniciado, mas com problemas de conexão, reestabelecendo regras de redirect :loucuracara:"
    _redirect "$slaveIp"
    _reboot
  else
    _clear_rules
    _recheck
  fi
}

_recheck() {
  response="$(echo $(_pong) | awk '{ print $3 }')"

  if [ "$response" == '"000"' ]; then
    bot "$info" -w "NGINX iniciado, mas com problemas de conexão, reestabelecendo regras de redirect"
    _redirect "$slaveIp"
    _reboot 
  else
    _notify_success
    printf '1' > ../nginxOn
  fi
}

