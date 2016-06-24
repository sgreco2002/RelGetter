#!/usr/bin/expect -f

set port [lindex $argv 0] 
set user [lindex $argv 1] 
set password [lindex $argv 2]
set server [lindex $argv 3]
set cmd [lindex $argv 4] 

spawn -noecho ssh -p $port $user@$server $cmd
expect {
	"*?fingerprint?*" {
	send -- "Yes\r"
	}
	"*?password" {
	send -- "$password\r"
	send -- "\r"
	}
}
expect eof
sergio

