<html><head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>Fail2BanCount - by k6b</title>
<style type="text/css">
/* <![CDATA[ */

	body {
		margin:0; padding:0;
		font-size:80%;
		font-family: sans-serif;
		}

	#header {
		display: block;
		width: 80%;
		margin: auto;
		}

	#container {
		width: 80%;
		margin: auto;
		padding:0;
		display: table;
		}

	#row  {
		display: table-row;
		}

	#cell {
		width:150px;
		padding:1em;
		background: #FFF;
		display: table-cell;
		}

/* ]]> */
</style>
</head><body><center>
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

echo "<div id='container'>";

echo "<center>";

echo "<h1><u>Fail2BanCount - by k6b</u></h1>";
echo "<h3>$numbans IPs have been banned.</h3>";

// Begin creating the first table of IPs that have been banned
// more than once.

//echo "<table border='1'><tr><th>IP</th><th>Bans</th><th>Country</th>";

echo "<div id='row'>";
echo "<div id='cell'><b><u>IP</u></b></div><div id='cell'><b><u>Bans</u></b></div><div id='cell'><b><u>Country</u></b></div>";

// Print the data obtained from the MySQL database

$multiplebans_fields = mysql_num_fields($multiplebans);

// Print the first table

for($i=3; $i<$multiplebans_fields; $i++) {
	$field = mysql_fetch_field($multiplebans);
	echo "<div id='cell'>{$field->name}</div>";
}
echo "</div>\n";

// Print out the tables rows

while($row = mysql_fetch_row($multiplebans)) {
	echo '<div id="row">';
	foreach($row as $cell)
		echo "<div id='cell'>$cell</div>";
	echo "</div>\n";
}
echo "</div>";

mysql_free_result($multiplebans);

// Use correct grammer

if ($currentlybanned != 1) {
	$grammer = "IPs are";
} else {
	$grammer = "IP is";
}

echo "<h3>Currently $currentlybanned $grammer banned.</h3>";

// Only print the second table if we have an IP
// currently banned.

if ($numbans > $numunbans) {

// Print the data obtained from the MySQL database

$currentlybanned_fields = mysql_num_fields($currentbans);

// Table title

echo "<h2><u>Currently Banned</u></h2>";

// Create the second table, of currently banned IPs

//echo "<table border='1'><tr><th>IP</th><th>Date</th><th>Time</th><th>Country</th>";

echo "<div id='row'>";
echo "<div id='cell'><b><u>IP</u></b></div><div id='cell'><b><u>Date</u></b></div><div id='cell'><b><u>Time</u></b></div><div id='cell'><b><u>Country</u></b></div>";

// Print out the second table 

for($i=4; $i<$currentlybanned_fields; $i++) {
	$field = mysql_fetch_field($currentbans);
	echo "<div id='cell'>{$field->name}</div>";
}
echo "</div>\n";

// Print out the second table's rows

while($row = mysql_fetch_row($currentbans)) {
	echo "<div id='row'>";
	foreach($row as $cell)
		echo "<div id='cell'>$cell</div>";
	echo "</div>\n";

echo "</div>";
}

mysql_free_result($currentbans);

}

// Print more HTML

echo "<h2><u>Top 10 Countries</u></h2>";

// Begin creating the second table of counrtys  that have been banned
// more than once.

//echo "<table border='1'><tr><th>Country</th><th>Bans</th>";

echo "<div id='row'>";
echo "<div id='cell'><b><u>Country</u></b></div><div id='cell'><b><u>Bans</u></b></div>";

// Print the data obtained from the MySQL database

$multiplebans_fields = mysql_num_fields($countrybans);

// Print the first table

for($i=2; $i<$countrybans_fields; $i++) {
	$field = mysql_fetch_field($countrybans);
	echo "<div id='cell'>{$field->name}</div>";
}
echo "</div>\n";

// Print out the tables rows

while($row = mysql_fetch_row($countrybans)) {
	echo "<div id='row'>";
	foreach($row as $cell)
		echo "<div id='cell'>$cell</div>";
	echo "</div>\n";
}
echo "</div>";

mysql_free_result($countrybans);

echo "<br /><br />";

?>
</center>
</div>
</center></body></html>
