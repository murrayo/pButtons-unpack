#! /bin/sh 

mo_name=$1
mo_ioname=$2
do_snap=$3

# AIX
#	Disks:                     xfers                                read                                write                                  queue                    time
#                 %tm    bps   tps  bread  bwrtn   rps    avg    min    max time fail   wps    avg    min    max time fail    avg    min    max   avg   avg  serv
#                 act                                    serv   serv   serv outs              serv   serv   serv outs        time   time   time  wqsz  sqsz qfull


#   1     2     3    4     5        6      7     8         9       10       11         12     13    14        15      16       17         18      19       20         21         22         23         24          25
# Disk,x_%tm,x_bps,x_tps,x_bread,x_bwrtn,r_rps,r_avg_sv,r_min_sv,r_max_sv,r_time_out,r_fail,w_wps,w_avg_sv,w_min_sv,w_max_sv,w_time_out,w_fail,q_avg_tim,q_min_time,q_max_time,q_avg_wqsz,q_avg_sqsz,q_serv_qfull,time

    

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

./gnu_graph.sh $mo_name 4 "x_tps" 0 25 0 0 "${mo_ioname}  xfers tps" "Transfers per second. Multiple logical requests can combine in single I/O. Indeterminate size."

./gnu_graph.sh $mo_name 7 "r_s" 0 25 0 0 "${mo_ioname}  rps" "Number of read transfers per second"

./gnu_graph.sh $mo_name 13 "w_s" 0 25 0 0 "${mo_ioname}  wps" "Number of write transfers per second"

./gnu_graph.sh $mo_name 8 "r_avg_srv" 0 25 1 0 "${mo_ioname}  read avgserv" "Average service time per read transfer. Default is in milliseconds"

./gnu_graph.sh $mo_name 14 "w_avg_srv" 0 25 1 0 "${mo_ioname}  write avgserv" "Average service time per write transfer. Default is in milliseconds."

# Move to separate directory

png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_xfer ];
then
	mkdir ${png_name}/png_xfer
fi	

mv ${png_name}/*x_tps.png ${png_name}/png_xfer

if [ ! -d ${png_name}/png_i ];
then
	mkdir ${png_name}/png_i
fi	

mv ${png_name}/*.png ${png_name}/png_i


if [ "$do_snap" == "Y" ];
then

	# --- Snap shots

	./gnu_graphSnap.sh $mo_name 4 "x_tps" 0 25 0 0 "${mo_ioname}  xfers tps" "Transfers per second. Multiple logical requests can combine in single I/O. Indeterminate size."

	./gnu_graphSnap.sh $mo_name 7 "r_s" 0 25 0 0 "${mo_ioname}  rps" "Number of read transfers per second"

	./gnu_graphSnap.sh $mo_name 13 "w_s" 0 25 0 0 "${mo_ioname}  wps" "Number of write transfers per second"

	./gnu_graphSnap.sh $mo_name 8 "r_avg_srv" 0 25 1 0 "${mo_ioname}  read avgserv" "Average service time per read transfer. Default is in milliseconds"

	./gnu_graphSnap.sh $mo_name 14 "w_avg_srv" 0 25 1 0 "${mo_ioname}  write avgserv" "Average service time per write transfer. Default is in milliseconds."

	# Move to separate directory
	
	if [ ! -d ${png_name}/png_i_snap ];
	then
		mkdir ${png_name}/png_i_snap
	fi	

	mv ${png_name}/*.png ${png_name}/png_i_snap

fi


