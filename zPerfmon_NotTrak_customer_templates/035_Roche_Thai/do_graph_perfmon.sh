#! /bin/sh 

# $1 is csv file name

mo_name=$1
do_snap=$2

# Put whatever loops etc, but this is just straight call

# mo_name=$1			# Name of file to plot
# mo_column=$2		    # Column to plot
# mo_col_name=$3		# Column name to display in title
# mo_var_y=$4			# 1= y [0:100]
# mo_time_column=$5	    # Column with time (defaults to column 1)
# mo_decimals=$6		# 1 = For disk time set y decimal precision to 3 (ms)

# Use CPU gnuplot (set yrange [1:100]) Param 4

./gnu_graph.sh $1 2 "User Time" 1 1 0
./gnu_graph.sh $1 3 "Total Processor Time" 1 1 0

# Use Std Gnuplot 

./gnu_graph.sh $1 4 "Interrupts" 0 1 0
./gnu_graph.sh $1 5 "Available MBytes" 0 1 0
./gnu_graph.sh $1 6 "Memory Page Reads per sec" 0 1 0
./gnu_graph.sh $1 7 "Memory Page Writes per sec" 0 1 0
./gnu_graph.sh $1 8 "Memory Paging File Total Pct usage" 1 1 0
./gnu_graph.sh $1 9 "Total Disk Transfers" 0 1 0 
./gnu_graph.sh $1 10 "Processes" 0 1 0
./gnu_graph.sh $1 11 "Processor Queue" 0 1 0
./gnu_graph.sh $1 12 "Privileged Time" 1 1 0

# -- Non Standard -- disks

./gnu_graph.sh $1 13 "C cache and Jnl Avg Disk sec Read" 0 1 1
./gnu_graph.sh $1 14 "C cache Avg Jnl Disk sec Write" 0 1 1
./gnu_graph.sh $1 15 "C cache Disk Jnl Transfers sec" 0 1 0
./gnu_graph.sh $1 16 "C Disk Reads/sec" 0 1 0 
./gnu_graph.sh $1 17 "C Disk Writes/sec" 0 1 0 

./gnu_graph.sh $1 18 "D cache and Jnl Avg Disk sec Read" 0 1 1
./gnu_graph.sh $1 19 "D cache Avg Jnl Disk sec Write" 0 1 1
./gnu_graph.sh $1 20 "D cache Disk Jnl Transfers sec" 0 1 0
./gnu_graph.sh $1 21 "D Disk Reads/sec" 0 1 0 
./gnu_graph.sh $1 22 "D Disk Writes/sec" 0 1 0 
./gnu_graph.sh $1 23 "Total Disk Writes/sec" 0 1 0 
./gnu_graph.sh $1 24 "Total Disk Reads/sec" 0 1 0 

png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_p ];
then
	mkdir ${png_name}/png_p
fi	

mv ${png_name}/*.png ${png_name}/png_p


if [ "$do_snap" = "Y" ];
then
	# Use CPU gnuplot (set yrange [1:100]) Param 4

	./gnu_graphSnap.sh $1 2 "User Time" 1 1 0
	./gnu_graphSnap.sh $1 3 "Total Processor Time" 1 1 0

	# Use Std Gnuplot 

	./gnu_graphSnap.sh $1 4 "Interrupts" 0 1 0
	./gnu_graphSnap.sh $1 5 "Available MBytes" 0 1 0
	./gnu_graphSnap.sh $1 6 "Memory Page Reads per sec" 0 1 0
	./gnu_graphSnap.sh $1 7 "Memory Page Writes per sec" 0 1 0
	./gnu_graphSnap.sh $1 8 "Memory Paging File Total Pct usage" 1 1 0
	./gnu_graphSnap.sh $1 9 "Total Disk Transfers" 0 1 0 
	./gnu_graphSnap.sh $1 10 "Processes" 0 1 0
	./gnu_graphSnap.sh $1 11 "Processor Queue" 0 1 0
	./gnu_graphSnap.sh $1 12 "Privileged Time" 1 1 0

	# -- Non Standard -- disks

	./gnu_graphSnap.sh $1 13 "C Cache and Jnl Avg Disk sec Read" 0 1 1
	./gnu_graphSnap.sh $1 14 "C Cache and Jnl Avg Disk sec Write" 0 1 1
	./gnu_graphSnap.sh $1 15 "C Cache and Jnl Disk Transfers sec" 0 1 0
	./gnu_graphSnap.sh $1 16 "C Disk Reads/sec" 0 1 0 
	./gnu_graphSnap.sh $1 17 "C Disk Writes/sec" 0 1 0 

	./gnu_graphSnap.sh $1 18 "D DATA Disk Avg sec Read" 0 1 1
	./gnu_graphSnap.sh $1 19 "D DATA Disk Avg sec Write" 0 1 1
	./gnu_graphSnap.sh $1 20 "D DATA Disk Transfers sec" 0 1 0
	./gnu_graphSnap.sh $1 21 "D DATA Disk Reads/sec" 0 1 0 
	./gnu_graphSnap.sh $1 22 "D DATA Disk Writes/sec" 0 1 0 
	./gnu_graphSnap.sh $1 23 "Total Disk Writes/sec" 0 1 0 
	./gnu_graphSnap.sh $1 24 "Total Disk Reads/sec" 0 1 0 

	png_name=`dirname ${mo_name}`

	if [ ! -d ${png_name}/png_p_snap ];
	then
		mkdir ${png_name}/png_p_snap
	fi	

	mv ${png_name}/*.png ${png_name}/png_p_snap

fi


