#!/bin/bash

IP=$(wget -qO- ipv4.icanhazip.com)
echo -e "\033[1;36m VC ESTA PRESTE A INSTALAR O PAINEL SSH/DROP/SSL V.15 MODERNO \033[0m"
echo ""
echo -ne "\033[1;33m Enter, Para Prosseguir!\033[1;37m"; read
clear
echo -e "\E[44;1;37m           PAINEL SSH/DROP/SSL V.15 MODERNO           \E[0m"
echo ""
echo -e "                \033[1;31m ATENCAO"
echo ""
echo -e "\033[1;32m INFORME SEMPRE A MESMA SENHA"
echo -e "\033[1;32m SEMPRE COMFIME AS QUESTOES COM\033[1;37m Y"
echo ""
echo -e "\033[1;36m INICIANDO INSTALACAO"
echo ""
echo -e "\033[1;33m AGUARDE..."
apt-get update > /dev/null 2>&1
echo ""
echo -e "\033[1;36m INSTALANDO O APACHE2\033[0m"
echo ""
echo -e "\033[1;33m AGUARDE..."
apt-get install apache2 -y > /dev/null 2>&1
apt-get install cron curl unzip -y > /dev/null 2>&1
echo ""
echo -e "\033[1;36m INSTALANDO DEPENDENCIAS\033[0m"
echo ""
echo -e "\033[1;33m AGUARDE..."
apt-get install php5 libapache2-mod-php5 php5-mcrypt -y > /dev/null 2>&1 php5_invoke
service apache2 restart 
echo ""
echo -e "\033[1;36m INSTALANDO O MySQL\033[0m"
echo ""
sleep 1
apt-get install mariadb-server mariadb-client -y
#apt-get install mysql-server -y 
echo ""
clear

echo -e "                \033[1;31m ATENCAO"
echo ""
echo -e "\033[1;32m INFORME SEMPRE A MESMA SENHA QUANDO PEDIR"
echo ""
echo -e "\033[1;32m NESTE ,Enter current password for root (enter for none): colaca\033[1;37m a senha que vc criou"
echo ""
echo -e "\033[1;32m NESTE AKI ,Set root password? [Y/n] colaca\033[1;37m n"
echo ""
echo -e "\033[1;32m NAS DEMAIS COMFIME AS QUESTOES COM\033[1;37m Y"
echo ""
echo -ne "\033[1;33m Enter, Para Prosseguir!\033[1;37m"; read
#mysql_install_db
mysql_secure_installation
clear
echo -e "\033[1;36m INSTALANDO O PHPMYADMIN\033[0m"
echo ""
echo -e "\033[1;31m ATENCAO \033[1;33m!!!"
echo ""
echo -e "\033[1;32m SELECIONE A OPCAO \033[1;31mAPACHE2 \033[1;32mCOM A TECLA '\033[1;33mESPACO\033[1;32m'"
echo ""
echo -e "\033[1;32m SELECIONE \033[1;31mYES\033[1;32m NA OPCAO A SEGUIR (\033[1;36mdbconfig-common\033[1;32m)"
echo -e "PARA CONFIGURAR O BANCO DE DADOS"
echo ""
echo -e "\033[1;32m LEMBRE-SE INFORME A MESMA SENHA QUANDO SOLICITADO"
echo ""
echo -ne "\033[1;33m Enter, Para Prosseguir!\033[1;37m"; read
apt-get install phpmyadmin -y
php5enmod mcrypt
service apache2 restart
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
apt-get install libssh2-1-dev libssh2-php -y > /dev/null 2>&1
if [ "$(php -m |grep ssh2)" = "ssh2" ]; then
  true
else
  clear
  echo -e "\033[1;31m ERRO CRITICO\033[0m"
  rm $HOME/install > /dev/null 2>&1
  exit
fi
apt-get install php5-curl > /dev/null 2>&1
service apache2 restart
clear
echo ""
echo -e "\033[1;31m ATENCAO \033[1;33m!!!"
echo ""
echo -ne "\033[1;32m INFORME A MESMA SENHA\033[1;37m: "; read senha
echo -e "\033[1;32mOK\033[1;37m"
sleep 1
mysql -h localhost -u root -p$senha -e "CREATE DATABASE sshplus"
clear
echo -e "\033[1;36m FINALIZANDO INSTALACAO\033[0m"
echo ""
echo -e "\033[1;33m AGUARDE..."
echo ""

cd /var/www/html
wget https://drive.google.com/drive/folders/1HEMANPtYveQm4_w16NTNWZmb3Of9LGLu?usp=sharing/painel15.tar  > /dev/null 2>&1
sleep 1
tar -xvf painel15.tar > /dev/null 2>&1
rm -rf painel15.tar index.html > /dev/null 2>&1
service apache2 restart
sleep 1
if [[ -e "/var/www/html/pages/system/pass.php" ]]; then
sed -i "s;2585;$senha;g" /var/www/html/pages/system/pass.php > /dev/null 2>&1
fi
sleep 1
cd
wget http://painelweb.tk/BD-Painel-v15.sql > /dev/null 2>&1
sleep 1
if [[ -e "$HOME/BD-Painel-v15.sql" ]]; then
    mysql -h localhost -u root -p$senha --default_character_set utf8 sshplus < BD-Painel-v15.sql
    rm /root/BD-Painel-v15.sql
else
    clear
    echo -e "\033[1;31m ERRO AO IMPORTAR BANCO DE DADOS\033[0m"
    sleep 2
    rm /root/install > /dev/null 2>&1
    exit
fi
echo '* * * * * root /usr/bin/php /var/www/html/pages/system/cron.php' >> /etc/crontab
echo '* * * * * root /usr/bin/php /var/www/html/pages/system/cron.ssh.php ' >> /etc/crontab
echo '* * * * * root /usr/bin/php /var/www/html/pages/system/cron.sms.php' >> /etc/crontab
echo '* * * * * root /usr/bin/php /var/www/html/pages/system/cron.online.ssh.php' >> /etc/crontab
echo '10 * * * * root /usr/bin/php /var/www/html/pages/system/cron.servidor.php' >> /etc/crontab
/etc/init.d/cron reload > /dev/null 2>&1
/etc/init.d/cron restart > /dev/null 2>&1
chmod 777 /var/www/html/admin/pages/servidor/ovpn
chmod 777 /var/www/html/admin/pages/download
chmod 777 /var/www/html/admin/pages/faturas/comprovantes
service apache2 restart
sleep 1
service apache2 restart
clear
echo -e "\033[1;32m PAINEL V.15 INSTALADO COM SUCESSO!"
echo ""
echo -e "\033[1;36m SEU PAINEL\033[1;37m http://$IP/admin |OU http://$IP:81/admin\033[0m"
echo -e "\033[1;36m USUARIO\033[1;37m admin\033[0m"
echo -e "\033[1;36m SENHA\033[1;37m admin\033[0m"
echo ""
echo -e "\033[1;33m Altere a senha quando logar no painel>> Configuracoes>> Senha Antiga: admin >> Nova Senha: \033[0m"
echo -e "$barra"
echo -e "         \033[1;33mâ— \033[1;32mINSTALACAO CONCLUIDA \033[1;33mâ—\033[0m"
echo ""
