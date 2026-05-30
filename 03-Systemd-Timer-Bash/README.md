# Scheduled Automatic Backup using Systemd (Service unit, Timer unit, Bash Scripting)

## Project Overview
Using Systemd and Timer instrea of cron which lacks error tracking feature. Deploying a Local Configuration Backup Utility managed entirely by a native Systemd Timer and a oneshot service.


## Infrastructure Architecture

### 1. The Script (sys_backup.sh)
- Data Compression: Using the tar utility to compress and archive restricted administrative configurations (/etc/ssh).
- Dynamic Variables: creating runtime timestamps to keep backup history clean.
- Error Capturing: Evaluates the exit code ($?) of the archiving engine and writing in log files for both success as well as failure.

### 2. Systemd units (sys-backup.service and sys-backup.timer)
- Service layer (oneshot): Executes the target script synchronously from start to end daily.
- Timer layer (timers.target): Triggering service unit i.e. script once daily using "OnCalendar=daily" and "Persistent=true" to ensure missed tasks run automatically if the server shuts down unexpectedly.


## To Verify Deployment

# Viewing active timers queue and next execution slots
systemctl list-timers --all | grep sys-backup

# Checking the automation execution logs
cat /var/log/system_backup.log
