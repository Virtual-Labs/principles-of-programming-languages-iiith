<?php

$login_message = "Login";

if (isset($_REQUEST['login'])) {
  include_once('ldapexec.php');

  if (check_user_account($_REQUEST['login'], $_REQUEST['password'])) {
    session_start();
    $_SESSION['authenticated'] = true;
    $_SESSION['username'] = $_REQUEST['login'];
    $_SESSION['password'] = $_REQUEST['password'];	
    header('Location: member-index.php');
  } else {
    $login_message = 'Login failed, please try again';
  }
}
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Login Form</title>
<link href="loginmodule.css" rel="stylesheet" type="text/css" />
</head>
<body>
<h2><?php echo $login_message;?></h2>
<p>&nbsp;</p>
<form id="loginForm" name="loginForm" method="post" action="login-form.php">
  <table width="300" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="112"><b>Login</b></td>
      <td width="188"><input name="login" type="text" class="textfield" id="login" /></td>
    </tr>
    <tr>
      <td><b>Password</b></td>
      <td><input name="password" type="password" class="textfield" id="password" /></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td><input type="submit" name="Submit" value="Login" /></td>
    </tr>
  </table>

  <center>For new users, <a href="register-form.php">register here</a>.</center> 
</form>
</body>
</html>
