<?php
/********
 * Output JSON format form tweets for Spaces Twitter app.
 * 
 * Use _GET['SPChashtag'] to specify  
 *
 *
 ********/
include 'twConstantsConnect.inc.php';


$contesthashtag = mysql_real_escape_string($_GET['SPChashtag']);

$resultset = mysql_query('SELECT * from '.$appTableAnnouncements);

//Make sure to send the page as UTF-8, as that is format of database;
header('Content-Type: application/json; charset=utf-8'); 

echo '{
   "results":
[
';

if (mysql_num_rows($resultset) > 0) {
	while($row = mysql_fetch_array($resultset, MYSQL_ASSOC)) {
		echo $comma,$row['content'];
		$comma = ',';
	}
}
else {
	echo "\"NONE\"";
}

echo '],
   "max_id":18787119936,
   "since_id":0,
   "refresh_url":"?since_id=18787119936&q=twitpic",
   "next_page":"?page=2&max_id=18787119936&q=twitpic",
   "results_per_page":15,
   "page":1,
   "completed_in":0.030388,
   "query":"fakeresult"

}';
mysql_close($db);

?>
