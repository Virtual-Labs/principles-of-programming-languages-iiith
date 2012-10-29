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
		$upload_path = '../tmp/';

		//extracting the extension
		$file_parts = pathinfo($_FILES["file"]["name"]);

		//upload only zip, ss and rkt files
		if ($file_parts['extension'] == "zip" | "ss" | "rkt")
		{

			move_uploaded_file($_FILES["file"]["tmp_name"], $upload_path . $_FILES["file"]["name"]);
			echo "Successfully uploaded : \"" . $_FILES["file"]["name"] . "\"", "\n";
			$upload_file_name = $_FILES["file"]["name"];
		
			//create file storage directory for each user
			$cmd1 = 'mkdir upload-files/' . $_SESSION['username'] .'; mkdir test-results/' . $_SESSION['username'] . ';';
			ssh2_exec($conn, $cmd1);
  		
			//path to uploaded files on server
			$server_upload_path = 'upload-files/' . $_SESSION['username'];

			//path to test files on server
			$server_test_files_path = 'test-cases/';
	
			//path to test results on server
			$server_test_results_path = 'test-results/' . $_SESSION['username'];
	
	 		//send the uploaded file to the directory created
			ssh2_scp_send($conn, $upload_path . $upload_file_name, $server_upload_path . "/" . $upload_file_name, 0644);
		
			//extracting the file name without any extension
			$file_name = $file_parts['filename'];
			$file = basename($file_name, ".ss");

			//processing on zip file
			if ($file_parts['extension'] = 'zip')
			{
				$cmd2 = "cp -r " . $server_test_files_path . $file . " " . $server_upload_path . "/; unzip ". $server_upload_path . "/" . $upload_file_name . " -d " . $server_upload_path . "/" . $file . "/; sudo -u" . $_SESSION['username'] . " /usr/bin/evaluate " . $server_upload_path . "/" . $upload_file_name . ";";
				ssh2_exec($conn, $cmd2);

			}

			//runing test cases on the files and generating result files			
			$test_result_file = $file . "-result";
			$cmd3 = "racket " . $server_upload_path . "/" . $file . "/" . $file . "-test.rkt >& " . $server_test_results_path . "/" . $test_result_file . "; sudo -u" . $_SESSION['username'] . " /usr/bin/evaluate " . $server_test_results_path . "/" . $test_result_file . "; rm -rf " . $server_upload_path . "/" .$file . ";";
			ssh2_exec($conn, $cmd3);

		}

		else
		        echo "File Type not recognized.";
		  
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
