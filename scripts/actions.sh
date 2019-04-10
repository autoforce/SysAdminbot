#!/usr/bin/env bash

# 1: Ip address
_pong(){
  echo "$(proxychains curl -o /dev/null --silent --head --write-out \"%{http_code}\" \"https://$ip\" &3>/dev/null)"
}

_email(){
  # 1: Title
  # 2: Text

  curl -d "to=$to&amp;toname=Desenvolvimento&amp;subject=SysAdminBot%20$1&amp;text=$2&amp;from=$from&amp;api_user=$user&amp;api_key=$pass" \
    https://api.sendgrid.com/api/mail.send.json || bot "$verbose" -e "Ao enviar email para $to contendo: \`\`\`$2\`\`\`"
}

_notify_redirect() {
  response="$(echo $(_pong) | awk '{ print $3 }')" 

  if [ "$response" == '"000"' ]; then
    bot "$info" "Erro ao fazer o redirecionamento! :coffin:, preciso que alguém configure o master: 'ssh -p 22001 cluster@$ip'"
    _email 'Down erro, redirecionamento' 'Houve algum erro ao configurar o iptables, contudo o redirecionamento não funcionou, preciso que alguém configure-me, estou indisponível'
  else
    bot "$info" "Redirecionamento realizado com sucesso :frenetico:"
    _email 'Sucesso, redirecionado' 'O redirecionamento através do iptables foi realizado com sucesso'
  fi
}

_notify_success(){
  bot "$info" "NGINX FUNCIONANDO E OPERANTE :god:"
  _email 'Sucesso, normalizado' 'Normalizado, disponível através do Nginx normalmente'
}

_redirect(){
  printf "$(($(cat ../nginxOn)+1))" > ../nginxOn
  echo 1 > /proc/sys/net/ipv4/ip_forward

  /sbin/iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination $1:80
  /sbin/iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination $1:443
  /sbin/iptables -t nat -A POSTROUTING -j MASQUERADE || bot "$info" -e "Não consegui nem se quer configurar o IPTABLES, houve algum erro :empenado:"
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
    if [ "$(cat ../nginxOn)" == "0" ];then
        bot "$info" -w "NGINX iniciado, mas com problemas de conexão, reestabelecendo regras de redirect :loucuracara:" 
        _email 'Nginx instável' 'Nginx iniciando, mas com problemas de conexão... Estou reestabelecendo regras de redirct pelo iptables.'
    fi
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
    _redirect "$slaveIp"
    _reboot 
  else
    _notify_success
    printf "$(date) - De acordo com sua regra de cron, houveram $(cat ../nginxOn) consultas e instabilidade" > ../downtime.log
    printf '0' > ../nginxOn
  fi
}

