#!/bin/sh
 
# Example script to get content using Firefox cookies.
# by Jean-Sebastien Morisset (http://surniaulula.com/)
 
cookie_file="`echo $HOME/.mozilla/firefox/237h1pcm.default/cookies.sqlite`"
user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20100101 Firefox/15.0.1"
 
echo ".mode tabs
select host, case when host glob '.*' then 'TRUE' else 'FALSE' end,
path, case when isSecure then 'TRUE' else 'FALSE' end,
expiry, name, value from moz_cookies;" | \
	sqlite3 "$cookie_file" | \
		wget --load-cookies=/dev/stdin --user-agent="$user_agent" --output-document=/dev/stdout "$1" 2>/dev/null #| \
#			grep b-staff-icon_status
#			sed -n -e "/>/G" -e "s/^.*href=['\"]\([^\"]*\)['\"].*$/\1/p" | \
#				while read line; do echo -e "$1\t$line"; done
