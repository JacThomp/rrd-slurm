#!/bin/bash

#creates the rrds if they don't exist

RRDNAME_TEMPLATE="GPFS_INODE_"
FILE_SYSTEMS=$(mmlsfs all | awk $1~/^(?!Name).*$ '{print $1}')

for FILENAME in $FILE_SYSTEMS; do
    if [ ! -f $RRDNAME_TEMPLATE$FILENAME".rrd" ]; then
        rrdtool create $RRDNAME_TEMPLATE$FILENAME".rrd" \
	    DS:Used:GAUGE:3600:U:U \
	    DS:Max:GAUGE:3600:U:U \
	    DS:Available:GAUGE:3600:U:U \
	    RRA:AVERAGE:0.5:4:72 \
	    RRA:AVERAGE:0.5:24:84 \
	    RRA:AVERAGE:0.5:288:93 \
    fi

#1 Day, 20 minute increments
#1 Week, 2 hour increments
#3 Mo., 1 day increments

      used=$(mmlsfs all | awk -v P=$FILENAME '$1 == P {print $12}') ##Inodes used
      max=$(mmlsfs all | awk -v P=$FILENAME '$1 == P {print $11}') ##Maximum Inodes
      avail=$($max-$used) ##Available Inodes
    rrdtool update $RRDNAME_TAMPLATE$FILENAME".rrd"  "N:$used:$max:$avail"
done
