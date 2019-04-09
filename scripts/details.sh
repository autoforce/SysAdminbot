#!/usr/env/bin bash

_getMemoryProcess(){
  echo "$(ps -eo %mem,user,comm --sort -%mem | head -n 7)"
}

_getMemory(){
  echo "$(free -h)"
}



_memory(){
  percent="$(free | grep Mem | awk '{print $4}')"
  if [ "$percent" -lt 224288 ];then
    bot "$verbose" -e "Memória ocupando menos de 200 MB, veja os *processos* que estão *consumindo*:"
    bot "$verbose" -e "\`\`\`$(_getMemoryProcess)\`\`\`"
    bot "$verbose" -e "veja o seu consumo:\`\`\`$(_getMemory)\`\`\`"
  elif [ "$percent" -lt "524288" ];then
    if [ -ne "/tmp/live-memorysend" ];then
      bot "$verbose" -w "Memória ocupando 500 MB"
      > /tmp/live-memorysend
    fi
  fi
}

_memory
