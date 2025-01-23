<?php
error_reporting(E_ALL);

mysql_connect("localhost", "ubs", "u85");
mysql_select_db("ubs");

$props = array();
$num = mysql_num_rows(mysql_query("SELECT * FROM `server_chat`")) - 10;
$rows = mysql_query("SELECT * FROM `server_chat` ORDER BY `c_date` ASC LIMIT $num, 10");

//echo mysql_num_rows($rows);

while($row = mysql_fetch_assoc($rows)): ?>
<dl> 
	<dt><img src="images/silk/user.png" class="low"  alt="user" border="0" height="16" width="16" /> <?=$row['c_name'];?></dt> 
		<dd><?=$row['c_text'];?></dd> 
</dl>
<?php endwhile; ?>