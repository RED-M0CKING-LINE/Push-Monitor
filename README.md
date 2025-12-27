This is a little push monitor i whipped up primarilly so that i could add exotic things to uptime kuma

It allows the execution of nearly any command and the determination of its up/down status based on exit code

I started writing a script to just monitor the state of an openvpn server, then i dockerized it, then i modularized it. Currently I have examples for netcat and nmap as well

Big thanks to liquidat for having a script for checking openvpn servers

---

I have the monitor running as the healthcheck, since it runs regularly anyway can more easily report unhealthy containers

The only downside to this is that logs from the healthcheck process are not directed to the standard log

  `docker inspect pushmonitor-name-1 --format '{{range .State.Health.Log}}{{printf "%s %s\n" .Start .Output}}{{end}}'` is a useful command for checking the output of the monitor

---

This repo contains submodules (references to other git repos)

  `git clone --recurse-submodules URL` will pull the repo with submodules
  
  `git submodule update --init --recursive` will pull submodules if youve already cloned the repo without them

---

Other things I could add
- Wireguard
- 
