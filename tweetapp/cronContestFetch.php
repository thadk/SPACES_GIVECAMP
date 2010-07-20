<?php 
/********************
 * Cronjob for SPACES iPhone app
 * Grab the submitters' tweets mentioning @spacesgallery, take those with #SPC000, drop into tweetapp_submissions
 * Grab the host's tweets (@spacesgallery), take those with #SPC000, drop into tweetapp_announcements
 * @author Thad Kerosky (thadknull@gmail.com)
 *
 *******************/
	//connect to database + set static variables
	include 'twConstantsConnect.inc.php';

	function file_get_contents_utf8($fn) { 
	     $content = file_get_contents($fn); 
	      return mb_convert_encoding($content, 'UTF-8', 
		  mb_detect_encoding($content, 'UTF-8, ISO-8859-1', true)); 
	}
	
	function hashtagFilter($haystack) {
		$pattern= '/.*#((SPC|spc)[0-9]{3}).*/';
		$matches = array();
		preg_match($pattern, $haystack, $matches);
		$code = strtoupper($matches[1]);
		return $code;
	} 

	//Make sure to send the page as UTF-8, as that is format of database;
	header('Content-Type: application/json; charset=utf-8'); 


//PART 1: NEW SUBMISSIONS
	//The maximum tweetid in the *submissions* table, grab everything newer than this via twitter api
	$maxid = 1024; //not zero
	$resultset = mysql_query('SELECT max(tweetid) as maxid from '.$appTableSubmissions);
	if (mysql_num_rows($resultset) > 0) {
			$row = mysql_fetch_array($resultset, MYSQL_ASSOC);
			$maxid = $row['maxid'];
	}
	echo 'Submission MAXID: '.$maxid."\n";
	//PART 1: Open the JSON file of the MENTIONS for reading
	if ($data = file_get_contents_utf8("http://$twitterAccountName:$twitterAccountPass@api.twitter.com/1/statuses/mentions.json?since_id=".$maxid))
	{

		$mentions = JSON_decode($data,true);
		$firstContestTag = ""; 
		print_r($mentions);

		foreach ($mentions as $tweetdata) {
			$firstContestTag = hashtagFilter($tweetdata['text']); 
			if (!empty($firstContestTag)) {	
				echo $firstContestTag.' noted with username:'.$tweetdata['user']['screen_name'];
				$sql = 'INSERT INTO '.$appTableSubmissions.
					' (tweetid,content,SPChashtag,twituser) VALUES ("'
					.mysql_real_escape_string($tweetdata['id']).'","' //master tweetid (parsed from raw JSON)
					.mysql_real_escape_string(json_encode($tweetdata)) //raw JSON content from twitter
					."\",\"$firstContestTag\",\"" //SPC000
					.mysql_real_escape_string($tweetdata['user']['screen_name'])."\")"; //tweet user name to put into twituser
				mysql_query($sql);
				printf(mysql_error()."Records inserted: %d\n", mysql_affected_rows());
			}
			
		}
	}	

//PART 2: NEW ANNOUNCEMENTS
	//The maximum tweetid in the *announcements* table, grab everything newer than this via twitter api
	$annoMaxId = 1024;
	$resultset = mysql_query('SELECT max(tweetid) as maxid from '.$appTableAnnouncements);
	if (mysql_num_rows($resultset) > 0) {
			$row = mysql_fetch_array($resultset, MYSQL_ASSOC);
			$annoMaxId = $row['maxid'];
	}
	 
	echo 'Announcements MAXID: '.$annoMaxId."\n";
	//PART 2: Open the JSON file of the SPACES user timeline for reading
	if ($data = file_get_contents_utf8("http://$twitterAccountName:$twitterAccountPass@api.twitter.com/1/statuses/user_timeline/$twitterAccountName.json?since_id=".$annoMaxId))
	{

		$announcements = JSON_decode($data,true);
	 
		print_r($announcements);

		foreach ($announcements as $tweetdata) {
			$firstContestTag = hashtagFilter($tweetdata['text']);
			if (!empty($firstContestTag)) {
				$sql = 'REPLACE INTO '.$appTableAnnouncements.
					' (tweetid,content,SPChashtag) VALUES ("'
					.mysql_real_escape_string($tweetdata['id']).'","' //master tweetid (parsed from raw JSON)
					.mysql_real_escape_string(json_encode($tweetdata)) //raw JSON content from twitter
					."\",\"$firstContestTag\")"; 
				mysql_query($sql);
				#echo "$sql<br/><br/>!!".hashtagFilter($tweetdata['text']);
				printf(mysql_error()."Records inserted: %d\n", mysql_affected_rows());
			}
			
		}
	}	

?>

