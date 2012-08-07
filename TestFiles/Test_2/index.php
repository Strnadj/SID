<?php
/**
 * Test file #2 - SID
 */
 
 // Save global post 
 $globalPost = $_POST;
 $globalGet  = $_GET;
 
 echo $globalPost['var1'];
 echo $globalGet['var2'];
 
?>