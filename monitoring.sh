#!/bin/sh
chkpackage=`dpkg-query -W -f='${Status} ${Version}\n' apache2 | awk {'print $2'}`
if [ "$chkpackage" = "ok" ]; then
        echo "\e[32m The \"Apache\" package has already installed\e[0m"
        echo "\e[32m Skip installation!\e[0m"
else
echo "\e[34m --------------------------------------\e[0m"
echo "\e[32m The installation process of Apache package is in progress!\e[0m"
sudo apt install apache2 iotop -y >> /dev/null

echo "\e[32m The \"Apache\" package has been installed successfully\e[0m"
fi

### Check if direction to store script exists, if doesn't - create it ###
if [ ! -d /root/scripts ]; then
    mkdir /root/scripts
fi

sudo cat <<EOF > /root/scripts/servstat.sh

#!/bin/sh
path="/var/www/html"
logfile=\$path/report.txt

### Add blank line and head 5 of top on every script run ###
echo >> \$logfile
echo "!-------------------------------------------- top 20 --------------------------------" >> \$logfile
COLUMNS=512 /usr/bin/top -cSb -n 1 | head -20               >> \$logfile
echo "!---------------------------------------- vmstat 1 4 --------------------------------" >> \$logfile
/usr/bin/vmstat 1 4                                         >> \$logfile
### Check if load average is greater or equal 5 if it does - collect needed stats ###
if [ \`cat /proc/loadavg | /usr/bin/awk '{ print $1 }' | /usr/bin/cut -d. -f1-1\` -ge 5 ]
then
### INSERT custom gathering commands after this line, they are executed only when LA is above 5
###
echo "!-------------------------------- ps by memory usage --------------------------------" >> \$logfile
ps aux | sort -nk +4 | tail                                 >> \$logfile
echo "!------------------------------------- iotop -b -n 3 --------------------------------" >> \$logfile
/usr/sbin/iotop -b -o -n 3                                  >> \$logfile
echo "!------------------------------------------- ps axuf --------------------------------" >> \$logfile
ps axuf                                                     >> \$logfile
fi
EOF

chmod +x /root/scripts/servstat.sh

echo "\e[34m --------------------------------------\e[0m"
echo "\e[32m Creating cron task - /etc/cron.d/servstat!\e[0m"
echo "* * * * * root /bin/sh /root/scripts/servstat.sh" > /etc/cron.d/servstat
