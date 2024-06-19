#!/bin/bash
failed_node=$1
trigger_file=$2

if [ $failed_node == 0 ];
then 
	touch /failover_dir_1/$trigger_file;
fi

if [ $failed_node == 1 ];
then 
	touch /failover_dir_2/$trigger_file;
fi

exit 0;