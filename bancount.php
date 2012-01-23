<html><head><title>Fail2BanCount - by k6b</title></head><body><center>
<?php

// Fail2BanCount - Displays information from the database
// I won't claim this is all my original code, as it has
// been borrowed from various places online. Use it as you
// like.

// Database connection info

$db_host = 'localhost';
$db_user = 'fail2bancount';
$db_pwd = 'OJ9tzckQyVqCLzut';
$database = 'fail2bancount';

// Connect to MySQL

if (!mysql_connect($db_host, $db_user, $db_pwd))
	die("Can't connect to database");

// Select the database

if (!mysql_select_db($database))
	die("Can't select database");

// Get some information from the database

// Find IPs banned more than once

$multiplebans = mysql_query("SELECT ip,COUNT(*) count,country FROM bans GROUP BY ip HAVING count > 1");
if (!$multiplebans) {
	die("Query failed.");
}

// Find the IPs currently banned

$currentbans = mysql_query("SELECT ip,ban_date,ban_time,country FROM bans WHERE bans.id NOT IN ( SELECT unbans.id FROM unbans WHERE bans.id=unbans.id)");
if (!$currentbans) {
	die("Query failed.");
}

// Find the total number of IPs banned

$totalbans = mysql_query("SELECT MAX(id) FROM bans");
if (!$totalbans) {
	die("Query failed.");
}
while($row = mysql_fetch_array($totalbans)) {
	$numbans = $row['MAX(id)'];
}

// Find the total number of IPs unbanned

$totalunbans = mysql_query("SELECT MAX(id) FROM unbans");
if (!$totalunbans) {
	die("Query failed.");
}
while($row = mysql_fetch_array($totalunbans)) {
	$numunbans = $row['MAX(id)'];
}

// Find the number of currently banned IP's using subtraction. 
// I'm sure I can do this with a single MySQL query and get 
// rid of the above 2 queries all together.

$currentlybanned = $numbans - $numunbans;

// Print some HTML

echo "<b><u><i>Fail2BanCount - by k6b</i></u></b><br /><br />";
echo "$numbans IPs have been banned.<br /><br />";

// Begin creating the first table of IPs that have been banned
// more than once.

echo "<table border='1'><tr><th>IP</th><th>Bans</th><th>Country</th>";

// Print the data obtained from the MySQL database

$multiplebans_fields = mysql_num_fields($multiplebans);

// Print the first table

for($i=3; $i<$multiplebans_fields; $i++) {
	$field = mysql_fetch_field($multiplebans);
	echo "<td>{$field->name}</td>";
}
echo "</tr>\n";

// Print out the tables rows

while($row = mysql_fetch_row($multiplebans)) {
	echo "<tr>";
	foreach($row as $cell)
		echo "<td>$cell</td>";
	echo "</tr>\n";
}
echo "</table>";

mysql_free_result($multiplebans);

// Use correct grammer

if ($currentlybanned != 1) {
	$grammer = "IPs are";
} else {
	$grammer = "IP is";
}

echo "<br />Currently $currentlybanned $grammer banned.<br /><br />";

// Only print the second table if we have an IP
// currently banned.

if ($numbans > $numunbans) {

// Print the data obtained from the MySQL database

$currentlybanned_fields = mysql_num_fields($currentbans);

// Table title

echo "<u>Currently Banned</u><br /><br />";

// Create the second table, of currently banned IPs

echo "<table border='1'><tr><th>IP</th><th>Date</th><th>Time</th><th>Country</th>";

// Print out the second table 

for($i=4; $i<$currentlybanned_fields; $i++) {
	$field = mysql_fetch_field($currentbans);
	echo "<td>{$field->name}</td>";
}
echo "</tr>\n";

// Print out the second table's rows

while($row = mysql_fetch_row($currentbans)) {
	echo "<tr>";
	foreach($row as $cell)
		echo "<td>$cell</td>";
	echo "</tr>\n";
}
echo "</table>";

mysql_free_result($currentbans);

}
?>
</center></body></html>
