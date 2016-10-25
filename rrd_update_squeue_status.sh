#!/bin/bash

#creates the rrd if it does not already exist

RRDFILENAME_TEMPLATE="squeue_job_status_"

for PARTITION in `sinfo -h -o "%R"`; do
    if [ ! -f $RRDFILENAME_TEMPLATE$PARTITION".rrd" ] ; then              #No clobbering
        rrdtool create $RRDFILENAME_TEMPLATE$PARTITION".rrd" \
            DS:Running:GAUGE:600:U:U \
            DS:Pending:GAUGE:600:U:U \
            RRA:AVERAGE:0.5:1:288 \
            RRA:AVERAGE:0.5:6:240 \
            RRA:AVERAGE:0.5:24:1116 \
            RRA:AVERAGE:0.5:288:730 \
            RRA:MAX:0.5:1:288 \
            RRA:MAX:0.5:6:240 \
            RRA:MAX:0.5:24:1116 \
            RRA:MAX:0.5:288:730
    fi

#1 Day, 5 min. increments
#5 Days, 30 min. increments
#3 Mo., 2 hr. incremen:wqts
#2 Yr., 1 Day increments

    running=$(squeue -h -o "%.18i %.9P %.8T" | awk -v P=$PARTITION '$3 == "RUNNING" && $2 == P {print $1}' | wc | awk '{print $1}')   ##processes running
    pending=$(squeue -h -o "%.18i %.9P %.8T" | awk -v P=$PARTITION '$3 == "PENDING" && $2 == P {print $1}' | wc | awk '{print $1}')   ##processes pending
    rrdtool update $RRDFILENAME_TEMPLATE$PARTITION".rrd"  "N:$running:$pending"
done
