#!/usr/env/bin bash

_getMemoryProcess(){
  echo "$(ps -eo %mem,user,comm --sort -%mem | head -n 7)"
}

_memory(){
  percent="$(free -t | grep Mem | awk '{print $3/$2 * 100.0}')"
  if [ "$percent" > "90" ];then
    bot "$verbose" -e "Memória ocupando $percent%, veja os *processos* que estão *consumindo*:"
    bot "$verbose" -e "\`\`\`$(_getMemoryProcess)\`\`\`"
  elif [ "$percent" > "85" ];then
    bot "$verbose" -w "Memória ocupando $percent%"
  fi
}

_memory
