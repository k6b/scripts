<!DOCTYPE html>
<html><head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>Fail2BanCount - by k6b</title>
<meta name="author" content="k6b" />
<meta name="description" content="Fail2BanCount - by k6b" />
<link rel="stylesheet" href="/bancount.css" type="text/css" />
</head>
<body>
<div id="header"> 
<?php

// Fail2BanCount - Displays information from the database
// I won't claim this is all my original code, as it has
// been borrowed from various places online. Use it as you
// like.

// Database connection info

$db_host = '';
$db_user = '';
$db_pwd = '';
$database = '';

// Connect to MySQL

if (!mysql_connect($db_host, $db_user, $db_pwd))
	die("Can't connect to database");

// Select the database

if (!mysql_select_db($database))
	die("Can't select database");

// Get some information from the database

// Find IPs banned more than once

$multiplebans = mysql_query("SELECT ip,COUNT(*) count,country FROM bans GROUP BY ip HAVING count > 1 ORDER BY count DESC");
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

// Find multiple country bans

$countrybans = mysql_query("SELECT country,COUNT(*) count FROM bans GROUP BY country ORDER BY count DESC LIMIT 10");
if (!$countrybans) {
	die("Query failed.");
}

// Find the number of currently banned IP's using subtraction. 
// I'm sure I can do this with a single MySQL query and get 
// rid of the above 2 queries all together.

$currentlybanned = $numbans - $numunbans;

// Print some HTML

echo "\t<h1><u>Fail2BanCount - by k6b</u></h1>\n";
echo "</div>\n";
echo "<div id='container'>\n";
echo "\t<h3>$numbans IPs have been banned.</h3>\n";

// Begin creating the first table of IPs that have been banned
// more than once.

echo "\t<div class='table'>\n";
echo "\t\t<div class='row'>\n";
echo "\t\t\t<div class='cell'><b><u>IP</u></b></div>\n\t\t\t<div class='cell'><b><u>Bans</u></b></div>\n\t\t\t<div class='cell'><b><u>Country</u></b></div>\n";
echo "\t\t</div>\n";

// Print the data obtained from the MySQL database

// Print the first table

while($row = mysql_fetch_row($multiplebans)) {
	echo "\t\t<div class='row'>\n";
	foreach($row as $cell)
		echo "\t\t\t<div class='cell'>$cell</div>\n";
	echo "\t\t</div>\n";
}

echo "\t</div>\n";

mysql_free_result($multiplebans);

// Use correct grammer

if ($currentlybanned != 1) {
	$grammer = "IPs are";
} else {
	$grammer = "IP is";
}

echo "\t<h3>Currently $currentlybanned $grammer banned.</h3>\n";

// Only print the second table if we have an IP
// currently banned.

if ($numbans > $numunbans) {

// Print the data obtained from the MySQL database

// Table title

echo "\t<h2><u>Currently Banned</u></h2>\n";

// Create the second table, of currently banned IPs

echo "\t<div class='table'>\n";
echo "\t\t<div class='row'>\n";
echo "\t\t\t<div class='cell'><b><u>IP</u></b></div>\n\t\t\t<div class='cell'><b><u>Date</u></b></div>\n\t\t\t<div class='cell'><b><u>Time</u></b></div>\n\t\t\t<div class='cell'><b><u>Country</u></b></div>\n";
echo "\t\t</div>\n";

// Print out the second table 

while($row = mysql_fetch_row($currentbans)) {
	echo "\t\t<div class='row'>\n";
	foreach($row as $cell)
		echo "\t\t\t<div class='cell'>$cell</div>\n";
	echo "\t\t</div>\n";

}

echo "\t</div>\n";

mysql_free_result($currentbans);

}

// Print more HTML
echo "\t<h2><u>Top 10 Countries</u></h2>\n";

// Begin creating the second table of counrtys  that have been banned
// more than once.

echo "\t<div class='table'>\n";
echo "\t\t<div class='row'>\n";
echo "\t\t\t<div class='cell'><b><u>Country</u></b></div>\n\t\t\t<div class='cell'><b><u>Bans</u></b></div>\n";
echo "\t\t</div>\n";

// Print the first table



while($row = mysql_fetch_row($countrybans)) {
	echo "\t\t<div class='row'>\n";
	foreach($row as $cell)
		echo "\t\t\t<div class='cell'>$cell</div>\n";
	echo "\t\t</div>\n";
}

echo "\t</div>\n";

mysql_free_result($countrybans);

?>
</div>
<div id="footer">
	©2012 released under GNU GPL contact <a href="mailto:kyle@kylefberry.net">k6b</a> with any questions.
</div>
</body>
</html>
