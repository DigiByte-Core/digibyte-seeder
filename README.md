DigiByte Seeder
===============

DigiByte Seeder is a crawler for the DigiByte network, which exposes a list of reliable nodes via a built-in DNS server.

Features:
* regularly revisits known nodes to check their availability
* bans nodes after enough failures, or bad behaviour
* accepts nodes down to v0.5.0 to request new IP addresses from, but only reports good post-v0.6.9 nodes.
* keeps statistics over (exponential) windows of 2 hours, 8 hours, 1 day and 1 week, to base decisions on.
* very low memory (a few tens of megabytes) and cpu requirements.
* crawlers run in parallel (by default 96 threads simultaneously).

JOIN DIGIBYTE CRITICAL INFRASTRUCTURE TEAM (DGBCIT)
---------------------------------------------------

If you are intending to run a DigiByte Seeder, you are encouraged to join the DigiByte Critical Infrastructure Team (DGBCIT) which helps coordinate the seeders on the network. The team provides a detailed step-by-step tutorial for setting up your DigiByte Seeder and community support if you need help. Find the detailed tutorial [here](https://www.evernote.com/shard/s20/client/snv?noteGuid=46de28c1-9066-4ca5-8048-6f29f9e3bf52&noteKey=66077e0b3f969350ebefe4228d731425&sn=https%3A%2F%2Fwww.evernote.com%2Fshard%2Fs20%2Fsh%2F46de28c1-9066-4ca5-8048-6f29f9e3bf52%2F66077e0b3f969350ebefe4228d731425&title=Setting%2Bup%2Ba%2BDigiByte%2BSeeder). 

Please join the discussion in the [#DGBBCIT channel](https://discord.com/channels/878200503815782400/1133815334013509764) on the DigiByte Discord server. Participation is voluntary but encouraged. (If you are not already a member of the DigiByte Discord server, you can join [here](https://dsc.gg/DigiByteDiscord)).

The objectives of DGBCIT is to help:

* Distribute DigiByte Seeders across the community.
* Distribute the Seeders geographically across the globe.
* Distribute DigiByte Seeders across diferent providers.

As a member of DGBCIT you pledge to keep your seeder online 24/7, and in the event you are no longer able to do so, you will get in touch with the team so that someone can be found to setup a replacement. 

REQUIREMENTS
------------

To setup a DigiByte Seeder you need:

- A server to run it on with a static IP address. A VPS is fine. It does not need many resources - DigiByte Seeder needs <1Gb RAM to run. 
- A domain name where you can edit the DNS settings.

**IMPORTANT** - Before you begin please read this:

- To improve decentralization, mitigate single points of failure, and increase community participation, it is recommended that each person run a maximum of one mainnet seeder and/or one testnet seeder each. The network does not require many testnet seeders, so only a few people need run them.
- Many VPS providers (e.g. Digital Ocean) give you the option to chose from several geographic locations in which to host your VPS. To help better distribute the DigiByte Seeders around the globe, please try and choose a location where the network doesn't already have a Seeder, ideally a good distance from any existing seeders. You can refer to the [www.digibyteseed.com](http://digibyteseed.com/) website to see the locations of the current DigiByte Seeders. Feel free to discuss this in the [DGBCIT Discord channel](https://discord.com/channels/878200503815782400/1133815334013509764) to help choose a good location. 

# HOW TO SETUP A DIGIBYTE SEEDER

STEP 1. SETUP DNS RECORDS
-------------------------

Visit your domain name registrar and edit the DNS settings. Assuming you want to run a DNS seed on seed.example.com, you will need an authorative NS record in example.com's domain record, pointing to a subdomain to identify your server - e.g. server.example.com. You will also need an A record for server.example.com pointing at the IP address of the server.

Create an NS record:

- Host:     ```seed.example.com``` or ```testnetseed.example.com```       [ The desired address of your DigiByte Seeder. ]
- Answer:   ```server.example.com```                                      [ A subdomain to identify your server. ] 

Note: Some providers do not allow you to add an NS record. In that case, you may need to move your domain to one that does, or register a new one.

Create an A record:

- Host:     ```server.example.com```                                      [ Use the same subdomain you set above. ]
- Answer:   ```123.123.123.123```                                         [ The IP address of your server. ] 

Test the NS record:

$ ```dig -t NS seed.example.com```

Expected response: ```seed.example.com.   21600    IN      NS     server.example.com.```

(It should return the URL you chose to identify your server - e.g. server.example.com.)

Test the A record:

$ ```dig -t A server.example.com```

Expected response: ```server.example.com.   161    IN      A     123.123.123.123```

(It should return the IP address of your server.)

STEP 2. COMPILE SOFTWARE
------------------------

These instructions are for Ubuntu. Compiling will require boost and ssl.  On debian systems, these are provided by `libboost-dev` and `libssl-dev` respectively. 

$ ```sudo apt-get update```

Install required software packages for DigiByte Seeder:

$ ```sudo apt-get install gcc g++ build-essential libboost-all-dev libssl-dev git tmux iptables```

Clone the DigiByte Seeder software into your home folder:

$ ```cd ~/```

$ ```git clone https://github.com/DigiByte-Core/digibyte-seeder```

If you are also running a DigiByte full node on the same server, you need to make a change to main.cpp to add the loopback IP address:

$ ```nano ~/digibyte-seeder/main.cpp```

Change line 424 and 425 to add the loopback IP address: ```"127.0.0.1", ```. This will make it possible for the Seeder to connect directly to your local DigiByte full node.

To compile the software:

$ ```cd ~/digibyte-seeder```

$ ```make```

This will produce the `dnsseed` binary.

STEP 3. START DIGIBYTE SEEDER
-----------------------------

To view the software flag options, enter:

$ ```./dnsseed --help```

These are the flags supported by the dnsseed binary:

```
Usage: ./dnsseed -h <host> -n <ns> [-m <mbox>] [-t <threads>] [-p <port>]

Options:
-h <host>       Hostname of the DNS seed
-n <ns>         Hostname of the nameserver
-m <mbox>       E-Mail address reported in SOA records
-t <threads>    Number of crawlers to run in parallel (default 96)
-d <threads>    Number of DNS server threads (default 4)
-a <address>    Address to listen on (default ::)
-p <port>       UDP port to listen on (default 53)
-o <ip:port>    Tor proxy IP/Port
-i <ip:port>    IPV4 SOCKS5 proxy IP/Port
-k <ip:port>    IPV6 SOCKS5 proxy IP/Port
-w f1,f2,...    Allow these flag combinations as filters
--testnet       Use testnet
--wipeban       Wipe list of banned nodes
--wipeignore    Wipe list of ignored nodes
-?, --help      Show this text
```

To make it easy to check on it in future, open a tmux session in which to run your DigiByte Seeder:

$ ```tmux new -s dgbseeder```

To run a mainnet seeder, enter:

$ ```./dnsseed -h seed.example.com -n server.example.com -m email.example.com -p 5353 -a 123.123.123.123```

To run a testnet seeder, enter:

$ ```./dnsseed -h seed.example.com -n server.example.com -m email.example.com -p 5353 -a 123.123.123.123 --testnet```

- Subsitute ```seed.example.com``` with the NS Host record.
- Subsitute ```server.example.com``` with the A Host record.
- Subsitute ```youremail.example.com``` with an email address that you can be reached at for the SOA records, substituting the @ for a period. So youremail@example.com would be youremail.example.com.
- Subsitute ```123.123.123.123``` with IP address of your Server from Step 1.
- If you are running testnet seeder, note that you must include the ```--testnet``` flag.

The software will begin crawling the DigiByte network. You may need to wait or minute or two to see results coming in. Check that the available count is climbing. This is a good sign that it is working correctly.

Disconnect from the tmux session by pressing ```Ctrl-B```, followed by ```D```

### Check on your Seeder

When you need to reconnect to the tmux session later, enter:

$ ```tmux a -t dgbseeder```


STEP 4. MAP PORT 53 WHEN RUNNING AS NON-ROOT
--------------------------------------------

Typically, you'll need root privileges to listen to port 53 (name service).

One solution is using an iptables rule (Linux only) to redirect it to
a non-privileged port.

$ ```sudo iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5353```

$ ```sudo apt-get install iptables-persistent -y```

If properly configured, this will allow you to run dnsseed in userspace, using
the ```-p 5353``` option. iptables-persistent is used to make the change stick after a reboot.



Another solution is allowing a binary to bind to ports < 1024 with setcap (IPv6 access-safe)

$ ```setcap 'cap_net_bind_service=+ep' /path/to/dnsseed```


STEP 5. TEST DIGIBYTE SEEDER
----------------------------

To verify that your DigiByte Seeder is setup correctly, open a web browser and visit:

[https://www.whatsmydns.net/#A/](https://www.whatsmydns.net/#A/)

Enter the address you chose for your Seeder. You should see a list of IP addresses returned for each location.

For an example of what you should be seeing, look at the results for seed.digibyte.org here:

[https://www.whatsmydns.net/#A/seed.digibyte.help](https://www.whatsmydns.net/#A/seed.digibyte.help)


STEP 6. SETUP DIGIBYTE SEEDER TO STARTUP AT BOOT
------------------------------------------------

You can use the included startseeder.sh script to automatically startup your DigiByte Seeder when your system boots.

Copy the script to your home folder:

$ ```cp ~/digibyte-seeder/startseeder.sh ~/```

Edit the script to add your DigiByte Seeder credentials:

$ ```nano ~/startseeder.sh```

Save and exit. Make it executable:

$ ```sudo chmod +x ~/startseeder.sh```

Edit cron:

$ ```crontab -e```

Add this value to the bottom of your cron file. Replace '<user>' with your user account name.

```@reboot sleep 30 && /home/<user>/startseeder.sh```

When your server boots, it will pause for 30 seconds, before launching your DigiByte Seeder. Adjust the duration if needed. Save and exit.


TROUBLESHOOTING
--------------

### Running under Ubuntu

All Ubuntu releases from 16.10 onwards come installed with systemd-resolved, which prevents the seeder from running effectively.

The recommended solution is to bind the seeder to a specific IP address

$ ```./dnsseed -h seed.example.com -n server.example.com -a 123.123.123.123```

If that does not work, you can also try [this](https://www.linuxuprising.com/2020/07/ubuntu-how-to-free-up-port-53-used-by.html).

### Firewall

Be sure to check that port 53 is open on any external firewall.

If your system firewall is enabled, make sure you have opened port 53:

$ ```sudo ufw allow 53```

You can check the status of your system firewall with:

$ ```sudo ufw status```


STEP 7. ADD YOUR DIGIBYTE SEEDER URL TO DIGIBYTE CORE & DIGIBYTE SEEDER SOFTWARE
--------------------------------------------------------------------------------

Once your seeder is up and running, the final step is to make a PR to add your seeder URL to the DigiByte codebase.

On Github, clone the 'develop' branch of the [DigiByte-Core/digibyte](https://github.com/DigiByte-Core/digibyte/tree/develop) repo. 

You then need to edit the /src/chainparams.cpp file [here](https://github.com/DigiByte-Core/digibyte/blob/develop/src/chainparams.cpp):
- Add your mainnet seeder to the bottom of the list found at approximately line 145.
- Add your testnet seeder to the bottom of the list found at approximately line 412.

Note: Line numbers are likely to change over time. If you need help ask in the [#DGBCIT channel](https://discord.com/channels/878200503815782400/1133815334013509764) of the DigiByte Discord server.

Once, you are done, make a PR back to the main repo with your submitted changes.

You will also want to add the URL of your seeder to the DigiByte Seeder software itself. Clone the DigiByte-Core/digibyte-seeder repo [here](https://github.com/DigiByte-Core/digibyte-seeder).

You then need to edit the /main.cpp file [here](https://github.com/DigiByte-Core/digibyte-seeder/blob/master/main.cpp):
- Add your mainnet or testnet seeder to the relevant line found at approximately line 425.

Once, you are done, make a PR back to the main repo with your submitted changes.