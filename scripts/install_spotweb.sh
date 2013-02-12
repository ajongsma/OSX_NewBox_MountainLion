#------------------------------------------------------------------------------
# Install Spotweb
#------------------------------------------------------------------------------
#export PATH=$PATH:/usr/local/opt/postgresql/bin
sudo -u andries psql postgres -c "create database spotweb_db"
sudo -u andries psql postgres -c "create user spotweb_user with password 'spotweb_user'"
sudo -u andries psql postgres -c "grant all privileges on database spotweb_db to spotweb_user"

open /Applications/pgAdmin3.app
echo "Open pgAdmin and set the password of user: spotweb_user"


## Not used, postgresql instead of MySQL
#echo "-----------------------------------------------------------"
#echo "Enter the following in MySQL:"
#echo "CREATE DATABASE spotweb;"
#echo "CREATE USER spotweb@'localhost' IDENTIFIED BY 'mini_spotweb';"
#echo "GRANT ALL PRIVILEGES ON spotweb.* TO spotweb @'localhost' IDENTIFIED BY 'mini_spotweb';"
#echo "flush privileges;"
#echo "quit"
#echo "-----------------------------------------------------------"

#cd /Library/WebServer/Documents/
#sudo git clone https://github.com/spotweb/spotweb.git
#subl /Library/WebServer/Documents/spotweb/dbsettings.inc.php

sudo mkdir -p /Users/Spotweb/Sites/
sudo mkdir -p /Users/Spotweb/Sites/log/
cd /Users/Spotweb/Sites/
sudo git clone https://github.com/spotweb/spotweb.git

sudo ln -s /Users/Spotweb/Sites/spotweb/ /Library/WebServer/Documents/spotweb
## -------------> TODO

open http://localhost/spotweb/install.php
subl /Users/Spotweb/Sites//spotweb/dbsettings.inc.php

echo "-----------------------------------------------------------"
echo "| Paste the information as seen in the installer:"
echo "| Type                          : PostgreSQL"
echo "| Server                        : localhost"
echo "| Database                      : spotweb_db"
echo "| Username                      : spotweb_user"
echo "| Password                      : <password>"
echo "-----------------------------------------------------------"
echo "| Usenet Server                 : XsNews"
echo "| User Name                     : 105764"
echo "-----------------------------------------------------------"

sudo touch /Users/Spotweb/Sites/spotweb/dbsettings.inc.php
sudo subl /Users/Spotweb/Sites/spotweb/dbsettings.inc.php

#/Library/WebServer/Documents/spotweb/retrieve.php
#sh php /Library/WebServer/Documents/spotweb/retrieve.php
#/bin/bash php /Library/WebServer/Documents/spotweb/retrieve.php

open http://localhost/spotweb

osascript -e 'tell app "Terminal"
    do script "php /Users/Spotweb/Sites/spotweb/retrieve.php"
end tell'

### FORCED QUIT ####
#exit 1

# ?????????????????????????????????????????????????????????????????????????????
#------------------------------------------------------------------------------
# Configure Spotweb as a Newznab Provider
#------------------------------------------------------------------------------
## !!!  Create normal user(s) in Spotweb for the API calls, not the ADMIN account !!!
##
## --------------------
## http://mar2zz.tweakblogs.net/blog/6724/spotweb-als-provider.html#more
##
## /etc/apache2/sites-enabled/blahdieblah (hier naam van bestand of website invullen)
## <VirtualHost *:8080>
##     ServerAdmin blahblah@gmail.com
## 
##     DocumentRoot /var/www
##     <Directory />
##         Options FollowSymLinks
##         AllowOverride None
##     </Directory>
##     <Directory /var/www/>
##         Options Indexes FollowSymLinks MultiViews
##         AllowOverride None
##         Order allow,deny
##         allow from all
##     </Directory>
##     ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
##     <Directory "/usr/lib/cgi-bin">
##         AllowOverride None
##         Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
##         Order allow,deny
##         Allow from all
##     </Directory>
##
## etc etc etc....
## </VirtualHost>
##
## Add:
## <Directory /Users/Spotweb/Sites/spotweb/>
##    RewriteEngine on
##    RewriteCond %{REQUEST_URI} !api/
##    RewriteRule ^api/?$ index.php?page=newznabapi [QSA,L]
##    Options Indexes FollowSymLinks Multiviews
##    AllowOverride None
##    Order allow,deny
##    allow from all
## </Directory>
##
## sudo a2enmod rewrite
## sudo apachectl restart
##
## Check for XML output:
## open http://localhost/spotweb/api?t=c
##
## --------------------
## https://github.com/spotweb/spotweb/wiki/Spotweb-als-Newznab-Provider
##
## Open the page to your CouchPotato configuration (http://url.to.your.couchpotato/config/) and click Providers.
## The item Newznab is listed on this page, you need to enter both a host and an API-key.
## For Host you'll enter http://localhost/spotweb/?page=newznabapi (please change to match your servername)
## For Apikey you need to enter the API key of Spotweb. You can find it in Spotweb by navigating to "Change user" from the main page.
##
## Enable:
## mod_rewrite
## AllowOverride
## 
## file .htaccess:
## RewriteEngine on
## RewriteCond %{REQUEST_URI} !api/
## RewriteRule api/?$ /spotweb/index.php?page=newznabapi [QSA,L]
## 
## sudo a2enmod rewrite
## sudo apachectl restart
## 
## Check for XML output:
## open http://localhost/spotweb/api?t=c
##
## Sick Beard:
## 1. Bij Provider Name kun je zelf bepalen hoe je het wilt noemen, bijvoorbeeld Spotweb.
## 2. Bij Site URL vul je http://server/spotweb/ in (uiteraard na aanpassing aan de eigen omgeving).
## 3. Bij API Key vul je de API-key van Spotweb in. Deze is in Spotweb te vinden onder Gebruiker wijzigen
## open http://localhost:8081/config/providers/
##
## CouchPotato:
## 1. Bij Host vul je server/spotweb in (uiteraard na aanpassing aan de eigen omgeving).
## 2. Bij Apikey vul je de API-key van Spotweb in. Deze is in Spotweb te vinden onder Gebruiker wijzigen
## Op de pagina http://url.naar.couchpotato/config/ en klik op Providers. Op die pagina staat het onderdeel Newznab. Hier dien je een host en een API-key op te geven.
## open open http://localhost:8081/config
##
## Headphones:
## 1. Vink Newznab aan.
## 2. Bij Newznabhost vul je server/spotweb in.
## 3. Bij API Key vul je de API-key van Spotweb in. Deze is in Spotweb te vinden onder Gebruiker wijzigen
## Op de pagina http://url.naar.headphones/config staat Newznab onder Providers.
## --------------------
## http://patrickscholten.com/spotweb-gebruiken-als-newznab-server/
## --------------------

#sudo apachectl restart
