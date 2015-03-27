#set proxy
export http_proxy="http://proxy.iiit.ac.in:8080/"
export https_proxy="http://proxy.iiit.ac.in:8080/"
#update
apt-get update
#make installation non interactive
export DEBIAN_FRONTEND=noninteractive
#install required packages
apt-get -q -y install libpam-ldapd
apt-get -y install php5-ldap
apt-get -y install ldap-utils
apt-get -y install ldapscripts
#update /etc/ldapscripts/ldapscripts.conf file
#update the ldap server url entry
mv /etc/ldapscripts/ldapscripts.conf /etc/ldapscripts/ldapscripts.conf.bak
sed -e "s/\#SERVER\=\"ldap\:\/\/localhost\"/SERVER\=\"ldap\:\/\/10\.2\.58\.135\"/" /etc/ldapscripts/ldapscripts.conf.bak > /etc/ldapscripts/ldapscripts.conf
rm /etc/ldapscripts/ldapscripts.conf.bak
#update global ldap suffix entry
mv /etc/ldapscripts/ldapscripts.conf /etc/ldapscripts/ldapscripts.conf.bak
sed -e "s/\#SUFFIX\=\"dc\=example\,dc\=com\"/SUFFIX\=\"dc\=virtual\-labs\,dc\=ac\,dc\=in\"/" /etc/ldapscripts/ldapscripts.conf.bak > /etc/ldapscripts/ldapscripts.conf
rm /etc/ldapscripts/ldapscripts.conf.bak
#update bind parameter entry
mv /etc/ldapscripts/ldapscripts.conf /etc/ldapscripts/ldapscripts.conf.bak
sed -e "s/\#BINDDN\=\"cn\=Manager\,dc\=example\,dc\=com\"/BINDDN\=\"cn\=admin\,dc\=virtual\-labs\,dc\=ac\,dc\=in\"/" /etc/ldapscripts/ldapscripts.conf.bak > /etc/ldapscripts/ldapscripts.conf
rm /etc/ldapscripts/ldapscripts.conf.bak
#update bind password file entry
mv /etc/ldapscripts/ldapscripts.conf /etc/ldapscripts/ldapscripts.conf.bak
sed -e "s/\#BINDPWDFILE\=\"\/etc\/ldapscripts\/ldapscripts\.passwd\"/BINDPWDFILE\=\"\/etc\/ldapscripts\/ldapscripts\.passwd\"/" /etc/ldapscripts/ldapscripts.conf.bak > /etc/ldapscripts/ldapscripts.conf
rm /etc/ldapscripts/ldapscripts.conf.bak
#update /etc/ldapscripts/ldapscripts.passwd file
echo -n "password" > /etc/ldapscripts/ldapscripts.passwd
