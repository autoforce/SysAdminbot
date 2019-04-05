#!/usr/bin/env bash

# 1: Ip address
_redirect(){
  echo 1 > /proc/sys/net/ipv4/ip_forward


  iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination $1:80
  iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination $1:443
  iptables -t nat -A POSTROUTING -j MASQUERADE

  response="$(proxychains curl -o /dev/null --silent --head --write-out \"%{http_code}\" \"http://$ip\" &3>/dev/null) "

  if [ "printf \"$response\" | awk '{ print $3 }'" == "000" ]; then
    bot "Erro ao fazer o redirecionamento! :coffin:, preciso que alguém configure o master: 'ssh -p 22001 cluster@$ip'"
  else
    bot "Redirecionamento realizado com sucesso :frenetico:"
  fi
}

_return(){
  if [ $(systemctl start nginx) ]; then
    echo -e "$success Nginx iniciado com sucesso, removendo regras do iptables..."
    bot 'Opa, o nginx iniciou normalmente por aqui, estou parando de redirecionar :oliver:'
    iptables -t mangle -F
    iptables -t nat -F
    printf '1' > nginx
  else
    echo -e "$error Ops, nginx não está subindo :/"
    bot-verbose -w "O NGINX nao está subindo, ele retorna:\`\`\`$(systemctl status nginx)\`\`\`"
  fi
}

