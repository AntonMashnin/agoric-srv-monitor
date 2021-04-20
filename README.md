# agoric-srv-monitor
Agoric Server Monitoring Script

This is a bash script to monitor your server and collect important information if the server has a High Load!

## Requirements
There are no special requirements. The bash script will install all necessary software and perform all configuration automatically

You just need to install 'wget' tool to make possibility run and install it:
```
sudo apt install wget -y
```

## Feauters
- Collects statistic if the load average on the server high then "5"

## Notes
- Please note: You may change the "load average" value in the script if you want that it run for example when the "load average" on the server is equal to 5, etc
You need to open script and change in this line if [ \`cat /proc/loadavg | /usr/bin/awk '{ print $1 }' | /usr/bin/cut -d. -f1-1\` -ge 5 ] "-ge 5"  to "-ge 6" etc
 
## Installation
To configure "srvstat" tool please run:
```
sudo wget https://raw.githubusercontent.com/AntonMashnin/agoric-srv-monitor/main/monitoring.sh
sudo chmod +x monitoring.sh
sudo ./monitoring.sh
```
