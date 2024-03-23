#!/bin/bash

# Define the cron job details
cron_job="57 10 * * * $(pwd)/q2_code.sh"

# Add the cron job to the user's crontab
{ crontab -l; echo "$cron_job"; } | crontab -
