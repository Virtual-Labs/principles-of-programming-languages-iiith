<html>

<link rel="stylesheet" type="text/css" href="../css/scheme-interaction.css"> 
<script language="JavaScript" src="../js/scheme-interaction.js"></script>

<head>

<title>PoPL Virtual Lab - Scheme</title>
<?php 
exec("rm ../tmp/*"); 
exec("rm ../usr/*"); 
?>

</head>

<body>

<div id="interface">
	<p style="font-family:arial;color:black;font-size:12px;">Enter your scheme code below and press "SHIFT+ENTER" to execute it :</p>
	<div id="input" class="input_class"> 
	<textarea rows='8' cols='55' name="code" id="command_id" class="command_class" value="" onkeypress="runScheme(event,this.value);"> </textarea>

	<input type='button' name='clear' value="Clear History" onclick="clearHistory();" />
	</div> 
	<div id="output" class="output_class">
	<textarea rows='8' cols='55' name="output">
	
	</textarea>
	</div>
</div>

</body>

</html>
