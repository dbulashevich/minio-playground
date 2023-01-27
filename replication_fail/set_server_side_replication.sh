#!/bin/sh
mc alias set primary http://primary:9000 minioadmin minioadmin
mc alias set backup http://backup:9000 minioadmin minioadmin

mc mb --with-versioning --ignore-existing primary/bucket
mc mb --with-versioning --ignore-existing backup/bucket

mc replicate add primary/bucket --remote-bucket http://minioadmin:minioadmin@backup:9000/bucket --replicate "delete,delete-marker,existing-objects"
