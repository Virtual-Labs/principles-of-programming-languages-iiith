function runScheme(event, str) {
	if (event.keyCode == 13 && event.shiftKey) { //SHIFT+ENTER
		if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp=new XMLHttpRequest();
		}
		else {// code for IE6, IE5
			xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState==4 && xmlhttp.status==200)
			{
				//document.getElementById("output_id").innerHTML=unescape(xmlhttp.responseText);
				document.getElementById('command_id').value="";

				document.getElementById('command_id').focus();
				//document.getElementById('output_id').style.display="";
			}
		}
		xmlhttp.open("POST","../php/scheme-interaction-process.php",true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send("code="+encodeURIComponent(str));
	}
}
	function clearHistory() {
		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState==4 && xmlhttp.status==200)
			{
				//document.getElementById("output_id").innerHTML="";
				document.getElementById('command_id').value="";

				document.getElementById('command_id').focus();
				//document.getElementById('output_id').style.display="";
			}
		}
		xmlhttp.open("GET","../php/scheme-interaction-clear.php", true);
		xmlhttp.send();
	}


