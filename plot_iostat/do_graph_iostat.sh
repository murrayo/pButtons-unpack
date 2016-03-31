#! /bin/sh 

mo_name=$1
mo_ioname=$2
do_snap=$3
mo_redhat7=$4

 
# Red Hat 6 + SLES11
# 1	           		2			3		4		5	     6	    7	   	8	    9		10       11     12
# Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util

# Red Hat 7 August 2015
#    1         2        3          4      5      6        7          8          9          10      11        12       13      14
#"Device:","rrqm\/s","wrqm\/s","r\/s","w\/s","rkB\/s","wkB\/s",  "avgrq-sz","avgqu-sz","await","r_await","w_await","svctm","%util");


# rrqm/s
#     The number of read requests merged per second that were queued to the device.
# 
# wrqm/s
#     The number of write requests merged per second that were queued to the device.
# 
# r/s
#     The number of read requests that were issued to the device per second.
# 
# w/s
#     The number of write requests that were issued to the device per second.
# 
# rsec/s
#     The number of sectors read from the device per second.
# 
# wsec/s
#     The number of sectors written to the device per second.
#     
# avgrq-sz
#     The average size (in sectors) of the requests that were issued to the device.
# 
# avgqu-sz
#     The average queue length of the requests that were issued to the device.
# 
# await
#     The average time (in milliseconds) for I/O requests issued to the device to be served. This includes the time spent by the requests in queue and the time spent servicing them.
# 
# svctm
#     The average service time (in milliseconds) for I/O requests that were issued to the device. Warning! Do not trust this field any more. This field will be removed in a future sysstat version.
# 
# %util
#     Percentage of CPU time during which I/O requests were issued to the device (bandwidth utilization for the device). Device saturation occurs when this value is close to 100%.
# 
    

# ./gnu_graph.sh $1 3 r 0 2 0 1

# mo_name=$1			# Name of file to plot
# mo_column=$2			# Column to plot
# mo_col_name=$3		# File name
# mo_var_y=$4			# 1= y [0:100]
# mo_time_column=$5		# Column with time (defaults to column 1)
# mo_decimals=$6		# 1 = For disk time set y decimal precision to 3 (ms)
# mo_notime=$7			# 1 = x data is NOT time ie iostat
# mo_true=$8			# true column name
# mo_text=$9			# Additional text to display on graph

# Red Hat 7 August 2015
#    1         2        3          4      5      6        7          8          9          10      11        12       13      14
#"Device:","rrqm\/s","wrqm\/s","r\/s","w\/s","rkB\/s","wkB\/s",  "avgrq-sz","avgqu-sz","await","r_await","w_await","svctm","%util");

# Red Hat 7

if [ "$mo_redhat7" == "Y" ];
then
	
	echo "RED HAT 7"
	echo
		

	./gnu_graph.sh $mo_name 4 "r_s" 0 1 0 1 "${mo_ioname}  r/s" "Number of read requests that were issued to the device per second"

	./gnu_graph.sh $mo_name 5 "w_s" 0 1 0 1 "${mo_ioname}  w/s" "Number of write requests that were issued to the device per second"

	./gnu_graph.sh $mo_name 8 "avgqu-sz" 0 1 1 1 "${mo_ioname}  avgqu-sz" "Average queue length of the requests that were issued to the device"

	./gnu_graph.sh $mo_name 10 "await" 0 1 1 1 "${mo_ioname}  await" "Average time (milliseconds) for I/O requests inc time spent in queue and time servicing them"

	./gnu_graph.sh $mo_name 13 "svctim" 0 1 1 1 "${mo_ioname}  svctim" "The average service time (in milliseconds) for I/O requests that were issued to the device"
else

# Red Hat 6

	echo "RED HAT 6"
	echo


	./gnu_graph.sh $mo_name 4 "r_s" 0 1 0 1 "${mo_ioname}  r/s" "Number of read requests that were issued to the device per second"

	./gnu_graph.sh $mo_name 5 "w_s" 0 1 0 1 "${mo_ioname}  w/s" "Number of write requests that were issued to the device per second"

	./gnu_graph.sh $mo_name 9 "avgqu-sz" 0 1 1 1 "${mo_ioname}  avgqu-sz" "Average queue length of the requests that were issued to the device"

	./gnu_graph.sh $mo_name 10 "await" 0 1 1 1 "${mo_ioname}  await" "Average time (milliseconds) for I/O requests inc time spent in queue and time servicing them"

	./gnu_graph.sh $mo_name 11 "svctim" 0 1 1 1 "${mo_ioname}  svctim" "The average service time (in milliseconds) for I/O requests that were issued to the device"

fi
# Move to separate directory

png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_i ];
then
	mkdir ${png_name}/png_i
fi	

mv ${png_name}/*.png ${png_name}/png_i

if [ "$do_snap" == "Y" ];
then

	# --- Snap shots

	echo
	echo
	echo "----------------------------------------------------------------"
	echo "Snap can only be done for time indexed columns, please use excel for shorter times"
	echo
	echo

fi



