#!/bin/bash

if [ -z "$(ls -A /failover_dir_1)" ]; then
	echo "empty"
else
    echo "Run start.sh"
	chown -Rf postgres:postgres /data_1/postgres
	chmod -R 700 /data_1/postgres
	su -p postgres -c "pg_rewind --config-file=/postgresql.conf --source-server='host=postgres_replica user=postgres password=password' --target-pgdata=/data/postgres"
	su -p postgres -c "postgres -c 'config_file=/postgresql.conf'"
fi