#!/usr/bin/env bash

help="""
bot <Chat ID> <option/msg> <msg:optional>
Tipos de mensagens:
  -w, --warning 
  -e, --error 
  -s, --security
  --------------
  Mensagens vazias serão enviadas como tipos padrão
"""

_send(){
  # 1: Id of chat
  # 2: Msg content
  curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"[_$(curl -4 ifconfig.co)_] $2\"}" \
  $1
}

_warning(){
  _send "$1" ":eyes: *Atenção*: $2"
}

_error(){
  _send "$1" ":warning: *Erro*: $2"
}

_sec(){
  _send "$1" ":lock: *Sec.*: $2"
}

_msg(){
  _send "$1" ":hangloose: *Mensagem*: $2"
}

case "$1" in
  -h* | --hel*)
    echo "$help"
    ;;
    * )
	case "$2" in
	  -h* | --hel*)
	    echo "$help"
	    ;;
	  -w* | --warn*)
	    _warning "$1" "$3"
	    ;;
	  -e* | --err*)
	    _error "$1" "$3"
	    ;;
	  -s* | --sec* )
	    _sec "$1" "$3"
	    ;;
	  *)
	    _msg "$1" "$2"
	    ;;
	esac
    ;;
esac
