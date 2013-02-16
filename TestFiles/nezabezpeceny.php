<?php
$stranka = $_GET['stranka'];
$podstranka = $_GET['podstranka'];
$res = mysql_connect('localhost', 'root', '');
mysql_select_db('exploit');

echo "SELECT * FROM `test` WHERE `name` = '".$stranka."'";
$data = mysql_query("SELECT * FROM `test` WHERE `name` = '".$stranka."'");

echo mysql_fetch_row($data);

while($row = mysql_fetch_array($data)) {
    var_dump($row);
}

$data2 = mysql_query("SELECT * FROM `test` WHERE `name` = '".$podstranka."'");

echo mysql_fetch_row($data2);

while($row = mysql_fetch_array($data2)) {
    var_dump($row);
}
?>
