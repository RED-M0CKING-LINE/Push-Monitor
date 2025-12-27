This is a little push monitor i whipped up primarilly so that i could add exotic things to uptime kuma

It allows the execution of nearly any command and the determination of its up/down status based on exit code

I started writing a script to just monitor the state of an openvpn server, then i dockerized it, then i modularized it. Currently I have examples for netcat and nmap as well

Big thanks to nagios-icinga for having a script for checking openvpn servers
