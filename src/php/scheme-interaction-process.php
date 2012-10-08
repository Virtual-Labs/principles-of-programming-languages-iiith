<?php

$schemeCode = stripslashes($_POST['code']);
//echo "schemeCode";
//echo $schemeCode;
//echo "<br>";

$filename = "../tmp/code.scrbl";
//echo "filename : "; 
//echo $filename;
//echo "<br>";
 
if(file_exists($filename)) {
	$prevCode = file_get_contents($filename);
	//echo "prevCode : ";
	//echo $prevCode;
	//echo "<br>";

	$pattern = "/@interaction\[\n(.*)\n\]/ms";
	//echo "pattern : ";
	//echo $pattern;
	//echo "<br>";

	$num = preg_match($pattern, $prevCode, $matches);
	
	//echo "matches 0 : ";
	//echo $matches[0];
	//echo "<br>";

	//echo "matches 1 : ";
	//echo $matches[1];
	//echo "<br>";

	$schemeCode = $matches[1]."\n".$schemeCode;
	//echo "schemeCode : ";
	//echo $schemeCode;
	//echo "<br>";
}

$scribbleFile = fopen($filename, "w+");

$basic_code =
"#lang scribble/manual 
@(require (for-label racket))
@(require scribble/eval)
@interaction[\n".
	$schemeCode
."\n]";

fwrite($scribbleFile, $basic_code);
fclose($scribbleFile);

chdir("../usr/");
$ret_val = exec("scribble --dest ../tmp/ --html ../tmp/code.scrbl; python ../python/strip.py;");
chdir("../php/");
//echo file_get_contents("../tmp/code.html");
?>
