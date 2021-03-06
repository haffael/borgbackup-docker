#!/bin/bash

# Preserve environment variables for cron tasks
jq -n env > borg_parameters.json

# create project git repo export dir
mkdir -p /bundles

# write fingerprint
echo $SSH_HOST_FINGERPRINT > /root/.ssh/known_hosts

# prepare stdout pipe for cronjobs
ln -sf /proc/$$/fd/1 /var/log/output
ln -sf /proc/$$/fd/2 /var/log/errors

# install cronjobs
crontab -r &>/dev/null
echo "$CRON_INTERVAL_INCREMENTAL /backupscripts/backup.py >/var/log/output 2>/var/log/errors" | crontab -
echo "Installed incremental backup cronjob."

# run cron
exec cron -f