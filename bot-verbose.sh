#!/usr/bin/env bash

here=`dirname "$0"`
cd "$here"

. info.conf

_send(){
  curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"$1\"}" \
  "$verbose"

}

_warning(){
  _send ":eyes: *Atenção*: $1"
}

_error(){
  _send ":warning: *Erro*: $1"
}

_sec(){
  _send ":lock: *Sec.*: $1"
}

_msg(){
  _send ":hangloose: *Mensagem*: $1"
}
case "$1" in
  -h* | --hel*)
    echo """
Tipos de mensagens:
  -w, --warning 
  -e, --error 
  -s, --security
  --------------
  Mensagens vazias serão enviadas como tipos padrão
    """
    ;;
  -w* | --warn*)
    _warning "$2"
    ;;
  -e* | --err*)
    _error "$2"
    ;;
  -s* | --sec* )
    _sec "$2"
    ;;
  *)
    _msg "$1"
    ;;
esac
