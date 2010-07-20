<?php
	static $twitterAccountName = 'spacesgallery';
	static $twitterAccountPass               ;
	static $twitterChallengePrefix = 'SPC';
	static $appTableAnnouncements = 'tweetapp_announcements';
	static $appTableSubmissions = 'tweetapp_submissions';
	static $databaseUser =                   ;
	static $databasePassword =           ;
	static $databaseName =                     ';
	static $databaseHost = 'mysql.bloggedupspaces.org';
//	error_reporting(0);


	$db = mysql_connect($databaseHost, $databaseUser, $databasePassword);
	if (!$db) {
		die('Could not connect: ' . mysql_error());
	}
	mysql_select_db($databaseName);
?>
