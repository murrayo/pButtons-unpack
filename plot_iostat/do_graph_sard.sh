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

# Red Hat
# 1	           		2			3		4		5	     6	    	7	    	8	    9			10
# 00:01:00          DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
# 

# sar -d
# Report activity for each block device (kernels 2.4 and newer only). When data is displayed, the device specification dev m-n is generally used ( DEV column). m is the major number of the device. With recent kernels (post 2.5), n is the minor number of the device, but is only a sequence number with pre 2.5 kernels. Device names may also be pretty-printed if option -p is used (see below). Values for fields avgqu-sz, await, svctm and %util may be unavailable and displayed as 0.00 with some 2.4 kernels. Note that disk activity depends on sadc options "-S DISK" and "-S XDISK" to be collected. The following values are displayed:

# tps
# # Indicate the number of transfers per second that were issued to the device. Multiple logical requests can be combined into a single I/O request to the device. A transfer is of indeterminate size.

# rd_sec/s
# Number of sectors read from the device. The size of a sector is 512 bytes.

# wr_sec/s
# Number of sectors written to the device. The size of a sector is 512 bytes.

# avgrq-sz
# The average size (in sectors) of the requests that were issued to the device.

# avgqu-sz
# The average queue length of the requests that were issued to the device.

# await
# The average time (in milliseconds) for I/O requests issued to the device to be served. This includes the time spent by the requests in queue and the time spent servicing them.

# svctm
# The average service time (in milliseconds) for I/O requests that were issued to the device.

# %util
# Percentage of CPU time during which I/O requests were issued to the device (bandwidth utilization for the device). Device saturation occurs when this value is close to 100%.
# 

./gnu_graph.sh $mo_name 3 "tps" 0 1 0 0 "${mo_ioname} tps" "transfers/second, multiple logical requests can combine into single I/O, indeterminate size"
./gnu_graphSnap.sh $mo_name 3 "tps_snap" 0 1 0 0 "${mo_ioname} tps" "transfers/second, multiple logical requests can combine into single I/O, indeterminate size"
awk -F ',' -v COL=3 -v column="tps" -f avgmax.awk $mo_name

./gnu_graph.sh $mo_name 8 "await" 0 1 0 0 "${mo_ioname} await" "Average time (milliseconds) for I/O requests inc time spent in queue and time servicing them"
./gnu_graphSnap.sh $mo_name 8 "await_snap" 0 1 0 0 "${mo_ioname} await" "Average time (milliseconds) for I/O requests inc time spent in queue and time servicing them"
awk -F ',' -v COL=4 -v column="await" -f avgmax.awk $mo_name

./gnu_graph.sh $mo_name 4 "rd_sec_s" 0 1 0 0 "${mo_ioname} rd_sec/s" "Number of sectors read from the device. The size of a sector is 512 bytes"
./gnu_graphSnap.sh $mo_name 4 "rd_sec_s_snap" 0 1 0 0 "${mo_ioname} rd_sec/s" "Number of sectors read from the device. The size of a sector is 512 bytes"
awk -F ',' -v COL=4 -v column="rd_sec_s" -f avgmax.awk $mo_name

./gnu_graph.sh $mo_name 5 "wr_sec_s" 0 1 0 0 "${mo_ioname} wr_sec/s" "Number of sectors written to the device. The size of a sector is 512 bytes"
./gnu_graphSnap.sh $mo_name 5 "wr_sec_s_snap" 0 1 0 0 "${mo_ioname} wr_sec/s" "Number of sectors written to the device. The size of a sector is 512 bytes"
awk -F ',' -v COL=5 -v column="wr_sec_s" -f avgmax.awk $mo_name

./gnu_graph.sh $mo_name 10 "util" 0 1 0 0 "${mo_ioname} %util" "% CPU time during which I/O requests were issued to device (bandwidth utilization)"
./gnu_graphSnap.sh $mo_name 10 "util_snap" 0 1 0 0 "${mo_ioname} %util" "% CPU time during which I/O requests were issued to device (bandwidth utilization)"
awk -F ',' -v COL=5 -v column="util" -f avgmax.awk $mo_name


# Move to separate directory

png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_s ];
then
	mkdir ${png_name}/png_s
fi	

mv ${png_name}/*.png ${png_name}/png_s


