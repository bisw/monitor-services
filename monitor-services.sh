#!/bin/bash

# Monitor Services Library
# Author - Biswajit Mondal
# Contact - bisw271923@gmail.com
#

# Set the path ##this works for Ubuntu 14.04 and 16.04
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin


#PROG_PATH="/var/www/html/scripts"

# Set notification email address 
EMAIL="example@example.com"

function restart_service {
  # Get arguments with proper name.
  service=$1
  service_job=$2

  # Echo pressent service status.
  echo "$service service is not running"

  # Restart service.
  service $service restart

  # Verify if restart is worked or not.
  if ps aux | grep -v grep | grep "$service_job" > /dev/null
    then
      # Lets notify that the servise is restarted successefully.
      MESSAGE="$service was down, but I was able to restart it on $(hostname) $(date)"
      SUBJECT="$service was down -but restarted-  on $(hostname) $(date)"
      echo "$MESSAGE"
      echo $MESSAGE | mail -s "$SUBJECT" "$EMAIL"
      ## In case if you want to send mail through script.
      ## Below example is for php script which is written in mail.php file and 
      ## two argument pass $service and 1
      #php "$PROG_PATH/mail.php" "$service" 1
  else
    # Notify the service is not restarted.
    MESSAGE="$service is down on $(hostname)  at $(date). I tried to restart it, but it did not work."
    echo "$MESSAGE"
    SUBJECT=" $service down on $(hostname) $(date)"
    echo $MESSAGE | mail -s "$SUBJECT" "$EMAIL"
    ## In case if you want to send mail through script.
    ## Below example is for php script which is written in mail.php file and 
    ## two argument pass $service and 0
    #php "$PROG_PATH/mail.php" "$service" 0
  fi
}

# list your services you want to check
# Sort the list, so the services start in that order.
declare -A services
services['apache2']="apache2"
services['mysql']="mysql"
## when service and actual running process is different name.
#services['service-1']="php $PROG_PATH/client.php"

# Walk through each service and monitor them.
for service in "${!services[@]}"
do
  ## If you want to find number of process running for the same service.
  #number_of_process=`ps aux --no-heading | grep -v grep | grep "${services[$service]}" | wc -l` > /dev/null

  # @see https://unix.stackexchange.com/questions/295363/function-of-second-grep-in-ps-grep-v-grep?rq=1
  if [ ps aux | grep -v grep | grep "${services[$service]}" > /dev/null ]
    then
      echo "$service service is running"
  else
    restart_service "$service" "${services[$service]}"
  fi
done
