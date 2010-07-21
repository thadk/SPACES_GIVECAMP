#!/bin/sh

#over the web method
#/usr/local/bin/setlock -n /tmp/cronlock.3782158186.81354.$$ sh -c $'/usr/bin/curl -s http\072//bloggedupspaces.org/tweetapp/cronContestFetch.php 1\076\0462 \046\076/dev/null'

#local method
export PATH=${PATH}:/usr/local/bin
PHP_SCRIPT=${HOME}/bloggedupspaces.org/tweetapp/cronContestFetch.php
cd `dirname ${PHP_SCRIPT}`
/usr/local/bin/setlock -n /tmp/cronlock.3782158186.81354.$$ php ${PHP_SCRIPT} 2>&1 &> /dev/null
