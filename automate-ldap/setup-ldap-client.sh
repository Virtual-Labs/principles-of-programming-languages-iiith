#set proxy
export http_proxy="http://proxy.iiit.ac.in:8080/"
export https_proxy="http://proxy.iiit.ac.in:8080/"
#update
apt-get update
#make installation non interactive
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install libpam-ldapd
apt-get -y install php5-ldap
apt-get -y install ldap-utils
apt-get -y install ldapscripts
#MODIFY /etc/ldapscripts/ldapscripts.conf file
#MODIFY the ldap server url entry
mv /etc/ldapscripts/ldapscripts.conf /etc/ldapscripts/ldapscripts.conf.bak
sed -e "s/\#SERVER\=\"ldap\:\/\/localhost\"/SERVER\=\"ldap\:\/\/10\.2\.58\.135\"/" /etc/ldapscripts/ldapscripts.conf.bak > /etc/ldapscripts/ldapscripts.conf
rm /etc/ldapscripts/ldapscripts.conf.bak
#MODIFY global ldap suffix entry
mv /etc/ldapscripts/ldapscripts.conf /etc/ldapscripts/ldapscripts.conf.bak
sed -e "s/\#SUFFIX\=\"dc\=example\,dc\=com\"/SUFFIX\=\"dc\=virtual\-labs\,dc\=ac\,dc\=in\"/" /etc/ldapscripts/ldapscripts.conf.bak > /etc/ldapscripts/ldapscripts.conf
rm /etc/ldapscripts/ldapscripts.conf.bak
#MODIFY bind parameter entry
mv /etc/ldapscripts/ldapscripts.conf /etc/ldapscripts/ldapscripts.conf.bak
sed -e "s/\#BINDDN\=\"cn\=Manager\,dc\=example\,dc\=com\"/BINDDN\=\"cn\=admin\,dc\=virtual\-labs\,dc\=ac\,dc\=in\"/" /etc/ldapscripts/ldapscripts.conf.bak > /etc/ldapscripts/ldapscripts.conf
rm /etc/ldapscripts/ldapscripts.conf.bak
#MODIFY bind password file entry
mv /etc/ldapscripts/ldapscripts.conf /etc/ldapscripts/ldapscripts.conf.bak
sed -e "s/\#BINDPWDFILE\=\"\/etc\/ldapscripts\/ldapscripts\.passwd\"/BINDPWDFILE\=\"\/etc\/ldapscripts\/ldapscripts\.passwd\"/" /etc/ldapscripts/ldapscripts.conf.bak > /etc/ldapscripts/ldapscripts.conf
rm /etc/ldapscripts/ldapscripts.conf.bak
#MODIFY bind password entry
mv /etc/ldapscripts/ldapscripts.conf /etc/ldapscripts/ldapscripts.conf.bak
sed -e "s/\#BINDPWD\=\"secret\"/BINDPWD\=\"password\"/" /etc/ldapscripts/ldapscripts.conf.bak > /etc/ldapscripts/ldapscripts.conf
rm /etc/ldapscripts/ldapscripts.conf.bak
#CHANGE the password mentioned in /etc/ldapscripts/ldapscripts.passwd file to your ldap-server password
echo -n "password" > /etc/ldapscripts/ldapscripts.passwd
#MODIFY /etc/nsswitch.conf file
mv /etc/nsswitch.conf /etc/nsswitch.conf.bak
sed -e "s/compat/files\ ldap/" /etc/nsswitch.conf.bak > /etc/nsswitch.conf
#MODIFY /usr/share/ldapscripts/runtime file
mv /usr/share/ldapscripts/runtime /usr/share/ldapscripts/runtime.bak
sed -e "s/USER=\$(logname\ 2>\/dev\/null)/USER\=\`id \-nu\`/" /usr/share/ldapscripts/runtime.bak > /usr/share/ldapscripts/runtime
#ldapscripts.passwd file should be readable only by the owner and the group and the group owner of the file should be www-data
chgrp www-data /etc/ldapscripts/ldapscripts.passwd
#The file /var/log/ldapscripts.log should have group ownership of www-data and should have write permissions as well.
#Create /var/log/ldapscripts.log, if needed
if ! touch /var/log/ldapscripts.log; then
	touch /var/log/ldapscripts.log
fi
chgrp www-data /var/log/ldapscripts.log
chmod g+w /var/log/ldapscripts.log
