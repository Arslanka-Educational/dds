#!/bin/bash
failed_node=$1
trigger_file=$2

touch /failover_dir/$trigger_file
exit 0;