<pre>
<?php
error_reporting(E_ALL);

mysql_connect("localhost", "ubs", "u85");
mysql_select_db("ubs");

$props = array();
$exp = array();
$rows = mysql_query("SELECT * FROM `server_propspawns`");

echo "Total props spawned: ".mysql_num_rows($rows)."\n\n";

while($row = mysql_fetch_assoc($rows)):
	$p_name = str_replace("//", "/", $row['ps_p_name']);
	$p_name = str_replace("models/", "", $p_name);
	
	$u_name = $row['ps_name'];
	
	if($p_name == "props_c17/oildrum001_explosive.mdl"):
		if(!$exp[$u_name]):
			$exp[$u_name] = 1;
		else:
			$exp[$u_name] = $exp[$u_name] + 1;
		endif;
	endif;
	
	if(!$props[$p_name]):
		$props[$p_name] = 1;
	else:
		$props[$p_name] = $props[$p_name] + 1;
	endif;
endwhile;

arsort($props);
arsort($exp);

echo "Most explosive barrels spawned: ".reset($exp)." by '".key($exp)."'\n\n";

foreach($props as $model => $count):
	echo $count." x ".$model."<br />";
endforeach;
?>
</pre>