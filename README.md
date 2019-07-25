# URLDynDNSUpdater
Update your client's global unicast ipv6 and public router ipv4 via URL to a dynamic DNS provider.

## Copy files
Move dyndns.sh script to some folder.

```
mv dyndns.sh /home/user/Scripts
```

## Make dyndns.sh executable for cron
```
sudo chmod +x /home/user/Scripts/dyndns.sh
```

## Adjust credentials and update URL
Adjust credentials and update URL in script to your credentials and dynamic DNS providers update URL.
```
nano /home/user/Scripts/dyndns.sh
```

## Add cronjob
For example, add a cronjob checking the for a required dynamic DNS  update every 5 minutes.
```
crontab -e
```
Add the follwing line.
```
*/5 * * * * sh /home/user/Scripts/dynv6.sh
```
