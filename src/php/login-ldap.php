<?php

echo "Welcome";

$ldaphost = "10.2.48.10";
$ldapport = 389;

$ldapconn = ldap_connect($ldaphost,$ldapport)
	  or die ("Could not connect");
?>
