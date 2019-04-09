#!/usr/env/bin bash

_getMemoryProcess(){
  printf "$(ps -eo %mem,user,comm --sort -%mem | head -n 7)"
}

_getMemory(){
  printf "$(free -h)"
}

_memory(){
  percent="$(free | grep Mem | awk '{print $4}')"
  if [ "$percent" -lt 524288 ];then
    bot "$verbose" -e "Memória ocupando menos de 500 MB, veja os *processos* que estão *consumindo*:"
    bot "$verbose" -e "\`\`\`$(_getMemoryProcess)\`\`\`"
    bot "$verbose" -e "veja o seu consumo:\`\`\`$(_getMemory)\`\`\`"
  elif [ "$percent" -lt "624288" ];then
    bot "$verbose" -w "Memória ocupando 600 MB"
  fi
}

_memory
