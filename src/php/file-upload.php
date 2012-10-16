<?php

require_once('auth.php');

//connection and authentication to the test server
$conn = ssh2_connect('10.2.48.13', 22);
ssh2_auth_password($conn, 'evaluator', '123456');

//upload errors
$error_types=array("No error","The uploaded file exceeds the permitted
filesize, which is 20 KB.","The uploaded file was only partially
uploaded.","No file was uploaded","Missing a temporary folder","Failed
to write file to disk.","A PHP extension stopped the file upload.");

//upload files only if they are less than 20KB
if ($_FILES["file"]["size"] < 20000) 
{

	if ($_FILES["file"]["error"] == 0)
	{

		//path to uploaded files
		$upload_path = "../tmp/";

		//path to test files
		$test_path = "../test/";
	
		//extracting the extension
		$file_parts = pathinfo($_FILES["file"]["name"]);

		//upload only zip, ss and rkt files
		if ($file_parts['extension'] == "zip" | "ss" | "rkt")
		{
		  
			//moving the upload file to upload folder
			move_uploaded_file($_FILES["file"]["tmp_name"], $upload_path . $_FILES["file"]["name"]);
			echo "Successfully uploaded : \"" . $_FILES["file"]["name"] . "\"", "\n";
			$file_orig_name = $_FILES["file"]["name"];

			//extracting the file name without any extension
			$file_name = $file_parts['filename'];
			$file = basename($file_name, ".ss");

			//processing on zip file
			if ($file_parts['extension'] = 'zip')
			{
				$output = "cp -r " . $test_path . $file . " " . $upload_path . "; unzip ". $upload_path . $_FILES["file"]["name"] . " -d " . $upload_path . $file . "/;";
				exec($output);
			}

			//runing test cases on the files			
			$test_result_file = $file . "-result";
			$test_result = "racket " . $upload_path . $file . "/" . $file . "-test.rkt > " . $upload_path . $test_result_file . ";";
			exec($test_result);

			//showing contents of the result
			$contents = file($upload_path . $test_result_file);
			$string = implode($contents);
			echo $string; 

			//sending the test result to the server
			ssh2_scp_send($conn, $upload_path . $_FILES["file"]["name"], ‎'/home/evaluator/upload_files/' . $_SESSION['username'] . '_' . $file_orig_name, 0644);
			ssh2_scp_send($conn, $upload_path . $test_result_file, '/home/evaluator/test_results/' . $_SESSION['username'] . '_' . $test_result_file, 0644);

			//copying the files to the user directory
			ssh2_exec($conn, 'sudo -u ' . $_SESSION['username'] . ' /usr/bin/evaluate /home/evaluator/upload_files/' . $_SESSION['username'] . '_' . $file_orig_name);
			ssh2_exec($conn, 'sudo -u ' . $_SESSION['username'] . ' /usr/bin/evaluate /home/evaluator/test_results/' . $_SESSION['username'] . '_' . $test_result_file);

			//deleting tmp folder
			exec("rm ../tmp/*");
		}
		else
		        echo "File Type not recognized.";
		  
		/*if ($ext == "zip")
		{	
			$output = "sudo -Hu www-data chmod 777 ../upload/* ;sudo -Hu www-data unzip ../upload/" . $_FILES["file"]["name"] . " -d ../upload/; sudo -Hu www-data chmod 777 ../upload/*";
			exec($output);
 		}*/
	}
	else
	{
                $error_message = $error_types[$_FILES["file"]["error"]];
		echo "Error Message: " . $error_message . "<br />";
	}
}
else
{
	echo "File size exceeds the permitted limit of 20 KB.";
}	
echo "<br /><a href='member-index.php'>Upload and Test more...</a><br /><br />";
