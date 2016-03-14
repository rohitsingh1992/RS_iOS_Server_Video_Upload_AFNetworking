<?php

// 	$data = trim(file_get_contents('php://input'));
 //	$name = $_POST['name'];
 	//$password = $_POST['phone'];
 	
 	
 	//echo $name;
 	 	
	
// 	echo $name;
 echo "hi upload test";
 die();

  
   $file_path = "uploads/";
  
     $file_path = $file_path . basename( $_FILES['uploaded_file']['name']);
     
   if(move_uploaded_file($_FILES['uploaded_file']['tmp_name'], $file_path))
    {
       echo "success".$_FILES['uploaded_file']['name'];
       
   } else
   {
       echo "fail";
     
      }
       
?>
   

     
  