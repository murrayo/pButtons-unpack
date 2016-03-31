#! /bin/sh 

mo_name=$1
mo_ioname=$2

# ./gnu_graph.sh $1 3 r 0 2 0

# mo_name=$1			# Name of file to plot
# mo_column=$2			# Column to plot
# mo_col_name=$3		# File name
# mo_var_y=$4			# 1= y [0:100]
# mo_time_column=$5		# Column with time (defaults to column 1)
# mo_decimals=$6		# 1 = For disk time set y decimal precision to 3 (ms)
# mo_notime=$7			# 1 = x data is NOT time ie iostat
# mo_true=$8			# true column name
# mo_text=$9			# Additional text to display on graph

# HP-UX
#               1	  	2		3		4		5	     6	   	7	   

# HP-UX l1a014p1 B.11.23 U ia64    10/07/13
# 00:00:05   device   %busy   avque   r+w/s  blks/s  avwait  avserv
# 00:00:10   c2t1d0   39.44    2.38     116    4004   11.02   17.84
             c3t0d0   35.06    2.12     114    4079    9.74   15.51

# sar -d

# %busy
# Portion of time device was busy servicing a transfer request. This is the same as the %tm_act column in the iostat command report.

# avque
# Average number of requests outstanding from the adapter to the device during that time. There may be additional I/O operations in the queue of the device driver. This number is a good indicator if an I/O bottleneck exists.

# r+w/s
# Number of read/write transfers from or to device. This is the same as tps in the iostat command report.

# blks/s
# Number of bytes transferred in 512-byte units

# avgqu-sz
# The average queue length of the requests that were issued to the device.

# avwait
# Average number of transactions waiting for service (queue length). Average time (in milliseconds) that transfer requests waited idly on queue for the device. This number is currently not reported and shows 0.0 by default.

# avserv
# Number of milliseconds per average seek. Average time (in milliseconds) to service each transfer request (includes seek, rotational latency, and data transfer times) for the device. This number is currently not reported and shows 0.0 by default.



./gnu_graph.sh $mo_name 2 "busy" 0 1 0 1 "${mo_ioname} %busy" "Portion of time device was busy servicing a transfer request"
awk -F ',' -v COL=3 -v column="tps" -f avgmax.awk $mo_name

./gnu_graph.sh $mo_name 3 "avque" 0 1 0 1 "${mo_ioname} avque" "Average number of requests outstanding from the adapter to the device during that time"
awk -F ',' -v COL=4 -v column="await" -f avgmax.awk $mo_name

./gnu_graph.sh $mo_name 4 "r+w_s" 0 1 0 1 "${mo_ioname} r+w/s" "Number of read/write transfers from or to device"
awk -F ',' -v COL=4 -v column="rd_sec_s" -f avgmax.awk $mo_name

./gnu_graph.sh $mo_name 5 "blks_s" 0 1 0 1 "${mo_ioname} blks/s" "Number of bytes transferred in 512-byte units"
awk -F ',' -v COL=5 -v column="wr_sec_s" -f avgmax.awk $mo_name

./gnu_graph.sh $mo_name 6 "avwait" 0 1 0 1 "${mo_ioname} avwait" "Average time (in milliseconds) that transfer requests waited idly on queue for the device"
awk -F ',' -v COL=5 -v column="util" -f avgmax.awk $mo_name

./gnu_graph.sh $mo_name 7 "avserv" 0 1 0 1 "${mo_ioname} avserv" "Average time (in milliseconds) to service each transfer request (seek, rotational latency, data transfer)"
awk -F ',' -v COL=5 -v column="util" -f avgmax.awk $mo_name


# Move to separate directory

png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_s ];
then
	mkdir ${png_name}/png_s
fi	

mv ${png_name}/*.png ${png_name}/png_s


