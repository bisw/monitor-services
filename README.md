# monitor-services

Bash Script to monitor service. If services are not running and then restart the service and sends email to you. Tested with 16.04.

##INSTALL:

put 'monitor-services.sh' file into your scripts folder
set your email address
set the services you want to keep an eye on (by default it has mysql and apache2..you can add or take away whatever you need)
save your changes
create a cronjob as root (sudo crontab -e) and add something like this, which runs every minute (adjust to your needs):

# Monitor services using cron
*/1 *  * * * /bin/bash /scripts_folder_path/monitor-services.sh >> /var/log/monitor-service.log 2>&1



The script will check the status of each service. If the service is stopped, it tries to restart the service. If the service starts, it sends you an email saying the service stopped but was restarted.

If the service does not start for some reason, it sends you an email telling you it was not started.

After that, it will continue to try and start, but not send any more emails until the service is finally started.
