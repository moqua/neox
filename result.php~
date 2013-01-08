<?

// $url=mysql_real_escape_string$_GET["url"]);
$url = $_GET["url"];


if (strncmp($url,'http',4) != 0){
	$url='http://'.$url;
}

function isUrl($url)
{
//	return preg_match('|^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)*(:[0-9]+)?(/.*)?$|i', $url);
//	return eregi('^(https?|ftp)\:\/\/([a-z0-9+!*(),;?&=\$_.-]+(\:[a-z0-9+!*(),;?&=\$_.-]+)?@)?[a-z0-9+\$_-]+(\.[a-z0-9+\$_-]+)*(\:[0-9]{2,5})?(\/([a-z0-9+\$_-]\.?)+)*\/?(\?[a-z+&\$_.-][a-z0-9;:@/&%=+\$_.-]*)?(#[a-z_.-][a-z0-9+\$_.-]*)?\$', $url);
	return filter_var($url, FILTER_VALIDATE_URL, FILTER_FLAG_HOST_REQUIRED);
}

if (((strlen($url)) == 0) or (!isUrl($url))) {
	die('please enter a valid url.<br><br>');
}

$out = array();
exec("cd neox24562456252234580349 && ./run.sh $url 2>&1",$out);

$count = count($out);
$file = $out[$count-1];
echo "<pre>";
for ($i = 0; $i < $count; $i++) {
//	echo " {$out[$i]} \n";
//	$fp = fopen($file.'.log', 'w');
//	fwrite($fp, $out[$i]);
}
//fclose($fp);
echo "</pre>";

$link = "http://www.kurtenba.ch/neox/".$file;


$content = fopen($file,'r');
while ($line = fread($content,1024)){
	echo $line;
}


echo "<a href=$link>$file</a>";

/*
if(file_exists($file)){
	$content = readfile($file);
	echo htmlspecialchars($content);
}
*/
