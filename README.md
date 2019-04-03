# SysAdminbot
Bot SysAdmin do Slack

Diretório padrão: /etc/SysAdminbot
É necessário apenas criar o link simbólico para que possa ser executado em linha de comando:
```sh
cd /etc/
git clone https://github.com:autoforce/SysAdminbot.git
ln -sf /etc/SysAdminbot/bot.sh /bin/bot
chmod 775 /bin/bot
```
Então assim poderá executá-lo normalmente, consulte o padrão usando `bot --help`

