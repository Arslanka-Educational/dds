#!/bin/bash
chown -Rf postgres:postgres /data/postgres
chmod -R 700 /data/postgres
su -p postgres -c "pg_rewind --config-file=/postgresql.conf --source-server='host=postgres_replica user=postgres password=password' --target-pgdata=/data/postgres"
su -p postgres -c "postgres -c 'config_file=/postgresql.conf'"