# SysAdminbot
Bot SysAdmin do Slack

Diretório padrão: /etc/SysAdminbot
É necessário apenas criar o link simbólico para que possa ser executado em linha de comando:
```sh
cd /etc/
git clone https://github.com/autoforce/SysAdminbot.git
ln -sf /etc/SysAdminbot/bot.sh /bin/bot
ln -s /etc/SysAdminbot/bot-verbose.sh /bin/bot-verbose
chmod 775 /bin/bot
chmod 775 /bin/bot-verbose 
```
# Configurando
ATENÇAO, antes de configurar é necessário definir as variaveis de definição em `./infos.conf`
É importante que resolva sua DNS em `/etc/resolv.conf`:
```dns
nameserver 8.8.8.8
```

Então assim poderá executá-lo normalmente, consulte o padrão usando `bot --help`.
