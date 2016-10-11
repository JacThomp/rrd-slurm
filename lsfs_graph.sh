#!/bin/bash

RRDNAME_TEMPLATE="GPFS_INODE_"
IMGTYPE="PNG"
COL_RED="#ff0000"
COL_GREEN="#00ff00"
COL_BLUE="#0000ff"

for FILENAME in 'mmlsfs all | awk $1~/^(?!Name).*$ '{print $1}''; do
    OUTFILE=$RRDNAME_TEMPLATE$FILENAME

#One Day
    rrdtool graph $OUTFILE"_daily."$IMGTYPE -a $IMGTYPE --start N-1D --end N --title="$FILENAME Daily Queue Depth" \
    --vertical-label "#Inodes" "DEF:probe1=$OUTFILE.rrd:Used:AVERAGE:step=4" \
    "DEF:probe2=$OUTFILE.rrd:Max:AVERAGE:step=4" "DEF:probe3=$OUTFILE.rrd:Available:AVERAGE:step=4" \
    "LINE1:probe1$COL_GREEN:Used" "LINE1:probe2$COL_BLUE:Max" "LINE1:probe3$COL_RED:Available" 

#One Week
    rrdtool graph $OUTFILE"_weeky."$IMGTYPE -a $IMGTYPE --start N-7D --end N --title="$FILENAME Weekly Queue Depth" \
    --vertical-label "#Inodes" "DEF:probe1=$OUTFILE.rrd:Used:AVERAGE:step=24" \
    "DEF:probe2=$OUTFILE.rrd:Max:AVERAGE:step=24" "DEF:probe3=$OUTFILE.rrd:Available:AVERAGE:step=24" \
    "LINE1:probe1$COL_GREEN:Used" "LINE1:probe2$COL_BLUE:Max" "LINE1:probe3$COL_RED:Available"


#3 Months
    rrdtool graph $OUTFILE"_3Months."$IMGTYPE -a $IMGTYPE --start N-93D --end N --title="$FILENAME 3 Month Queue Depth" \
    --vertical-label "#Inodes" "DEF:probe1=$OUTFILE.rrd:Used:AVERAGE:step=288" \
    "DEF:probe2=$OUTFILE.rrd:Max:AVERAGE:step=288" "DEF:probe3=$OUTFILE.rrd:Available:AVERAGE:step=288" \
    "LINE1:probe1$COL_GREEN:Used" "LINE1:probe2$COL_BLUE:Max" "LINE1:probe3$COL_RED:Available"

done
