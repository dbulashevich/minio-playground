# Actual results #
Failed server-side bucket replication prevents updating file in the source bucket.

# Expected behavior #
Source bucket remains fully operational when replication target fails.

# Steps to reproduce #
- Set up two minIO deployments (later referenced to as PRIMARY and BACKUP)
- Set up server-side bucket replication from PRIMARY to BACKUP
- Copy a file into the source bucket
- Check file stats and make sure its replication status is COMPLETED
- Pause the BACKUP deployment
- Copy the same file into the source bucket again
- Check file stats. Replication status is PENDING now, as BACKUP deployment is down
- Copy the same file into the source bucket again. Operation will stuck.

# Reproducing within Docker environment #
- Install Docker and Docker-compose
- Run __./scenario.sh__ shell script

# Notes #
Looks like the problem is only affecting files with PENDING replication status.
File in such a state can't be removed or updated.

At the same time it doesn't prevent other files from being created.
