#!/usr/env/bin bash

_getMemoryProcess(){
  echo "$(ps -eo %mem,user,comm --sort -%mem | head -n 7)"
}

_getMemory(){
  echo "$(free -h)"
}

_getStorage(){
  echo "$(df --output=source,pcent,target)"
}

_memory(){
  percent="$(free | grep Mem | awk '{print $4}')"
  if [ "$percent" -lt 224288 ];then
    bot "$verbose" -e "Memória ocupando menos de 200 MB, veja os *processos* que estão *consumindo*:"
    bot "$verbose" -e "\`\`\`$(_getMemoryProcess)\`\`\`"
    bot "$verbose" -e "veja o seu consumo:\`\`\`$(_getMemory)\`\`\`"
    > /tmp/live-memorysend
  elif [ "$percent" -lt "524288" ];then
    if [ ! -e "/tmp/live-memorysend" ];then
      bot "$verbose" -w "Memória ocupando 500 MB"
      > /tmp/live-memorysend
    fi
  else
    if [ -e "/tmp/live-memorysend" ];then
      rm -rf "/tmp/live-memorysend"
      bot "$verbose" "Consumo de memória normalizado :frenetico:"
    fi
  fi
}

_storage(){
  percent="$(df -l / --output=pcent | tail -n 1 | sed 's/\%//')"
  
  if [ "$percent" -gt "95" ];then
    bot "$verbose" -e 'Partição `/` está ocupando mais de 95%, olhe:'
    bot "$verbose" -e "\`\`\`$(_getStorage)\`\`\`"
  fi
}

_memory
_storage
