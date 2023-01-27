#!/bin/sh

RUN="docker-compose run client"

echo "Clearing any leftovers from previous runs"
docker-compose down


echo "Setting up PRIMARY and BACKUP replicas with server-side bucket replication"
docker-compose up -d primary backup
$RUN ./set_server_side_replication.sh

$RUN mc stat primary/bucket

echo "\n\n\nCopying a file to the PRIMARY replica few times in row..."
$RUN mc cp ./init.sh primary/bucket
$RUN mc cp ./init.sh primary/bucket
echo "\n\n\nState with BACKUP UP"
$RUN mc stat primary/bucket/init.sh

echo "\n\n\nStopping BACKUP"
docker-compose pause backup

echo "\n\n\nCopying the file once more time"
$RUN mc cp ./init.sh primary/bucket

echo "\n\n\nState with BACKUP DOWN. Note replication status PENDING"
$RUN mc stat primary/bucket/init.sh

echo "\n\n\nCopying the file once more. Operation will stuck, so aborting after 10 seconds"
$RUN mc cp ./init.sh primary/bucket
