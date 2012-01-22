<html><head><title>Fail2BanCount - by k6b</title></head><body><center>
<?php
$db_host = '';
$db_user = '';
$db_pwd = '';

$database = '';

if (!mysql_connect($db_host, $db_user, $db_pwd))
	die("Can't connect to database");

if (!mysql_select_db($database))
	die("Can't select database");

// sending query
$bans = mysql_query("SELECT ip,COUNT(*) count,country FROM bans GROUP BY ip HAVING count > 1");
if (!$bans) {
	die("Query to show fields from table failed");
}
$totalbans = mysql_query("SELECT MAX(id) FROM bans");
if (!$totalbans) {
	die("Query failed.");
}
$totalunbans = mysql_query("SELECT MAX(id) FROM unbans");
if (!$totalunbans) {
	die("Query failed.");
}

while($row = mysql_fetch_array($totalbans)) {
	$numbans = $row['MAX(id)'];
}

while($row = mysql_fetch_array($totalunbans)) {
	$numunbans = $row['MAX(id)'];
}

$currentlybanned = $numbans - $numunbans;

$fields_num = mysql_num_fields($bans);

echo "<b><u><i>Fail2BanCount - by k6b</i></u></b><br /><br />";
echo "$numbans IPs have been banned.<br /><br />";
echo "<table border='1'><tr><th>IP</th><th>Bans</th><th>Country</th>";
// printing table headers
for($i=3; $i<$fields_num; $i++)
{
	$field = mysql_fetch_field($bans);
	echo "<td>{$field->name}</td>";
}
echo "</tr>\n";
// printing table rows
while($row = mysql_fetch_row($bans))
{
	echo "<tr>";

	// $row is array... foreach( .. ) puts every element
	// of $row to $cell variable
	foreach($row as $cell)
		echo "<td>$cell</td>";

	echo "</tr>\n";
}
mysql_free_result($bans);


$currentbans = mysql_query("SELECT ip,ban_date,ban_time,country FROM bans WHERE bans.id NOT IN ( SELECT unbans.id FROM unbans WHERE bans.id=unbans.id)");
if (!$bans) {
	die("Query to show fields from table failed");
}

$fields_num2 = mysql_num_fields($currentbans);

echo "<table border='1'><tr><th>IP</th><th>Date</th><th>Time</th><th>Country</th>";
if ($currentlybanned = 1) {
	echo "<br />Currently $currentlybanned IP is banned.<br /><br /><u>Currently Banned</u><br /><br />";
} else {
	echo "<br />Currently $currentlybanned IPs are banned.<br /><br /><u>Currently Banned</u><br /><br />";
}
// printing table headers
for($i=4; $i<$fields_num2; $i++)
{
	$field = mysql_fetch_field($currentbans);
	echo "<td>{$field->name}</td>";
}
echo "</tr>\n";
// printing table rows
while($row = mysql_fetch_row($currentbans))
{
	echo "<tr>";

	// $row is array... foreach( .. ) puts every element
	// of $row to $cell variable
	foreach($row as $cell)
		echo "<td>$cell</td>";

	echo "</tr>\n";
}
mysql_free_result($currentbans);

?>
</center></body></html>
