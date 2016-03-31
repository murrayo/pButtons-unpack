#! /bin/sh 
mo_name=$1

# RSPI - DB server

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

./gnu_graph.sh $1 13 "E data Avg Disk sec Read" 0 1 1
./gnu_graph.sh $1 14 "E data Avg Disk sec Write" 0 1 1
./gnu_graph.sh $1 15 "E data Disk Transfers sec" 0 1 0

./gnu_graph.sh $1 16 "J jnl Avg Disk sec Read" 0 1 1
./gnu_graph.sh $1 17 "J jnl Avg Disk sec Write" 0 1 1
./gnu_graph.sh $1 18 "J jnl Disk Transfers sec" 0 1 0

./gnu_graph.sh $1 19 "C cache Avg Disk sec Read" 0 1 1
./gnu_graph.sh $1 20 "C cache Avg Disk sec Write" 0 1 1
./gnu_graph.sh $1 21 "C cache Disk Transfers sec" 0 1 0

./gnu_graph.sh $1 22 "PRO_1000 MT Bytes Received sec" 0 1 0
./gnu_graph.sh $1 23 "PRO_1000 MT Bytes Sent sec" 0 1 0

./gnu_graph.sh $1 24 "E data Disk Read Bytes per sec" 0 1 0
./gnu_graph.sh $1 25 "E data Disk Reads per sec" 0 1 0
./gnu_graph.sh $1 26 "E data Disk Write Bytes per sec" 0 1 0
./gnu_graph.sh $1 27 "E data Disk Writes per sec" 0 1 0

./gnu_graph.sh $1 28 "J Journal Disk Read Bytes per sec" 0 1 0
./gnu_graph.sh $1 29 "J Journal Disk Reads per sec" 0 1 0
./gnu_graph.sh $1 30 "J Journal Disk Write Bytes per sec" 0 1 0
./gnu_graph.sh $1 31 "J Journal Disk Writes per sec" 0 1 0

./gnu_graph.sh $1 32 "C OS Disk Read Bytes per sec" 0 1 0
./gnu_graph.sh $1 33 "C OS Disk Reads per sec" 0 1 0
./gnu_graph.sh $1 34 "C OS Disk Write Bytes per sec" 0 1 0
./gnu_graph.sh $1 35 "C OS Disk Writes per sec" 0 1 0

./gnu_graph.sh $1 36 "Total Disk Write Bytes per sec" 0 1 0
./gnu_graph.sh $1 37 "Total Disk Writes per sec" 0 1 0

./gnu_graph.sh $1 38 "vmxnet3 Bytes Received sec" 0 1 0
./gnu_graph.sh $1 39 "isatap B13B21CE... Bytes Received sec" 0 1 0
./gnu_graph.sh $1 40 "isatap E4B4B8BB... Bytes Received sec" 0 1 0
./gnu_graph.sh $1 41 "LAN Bytes Received sec" 0 1 0

./gnu_graph.sh $1 42 "vmxnet3 Bytes Sent sec" 0 1 0
./gnu_graph.sh $1 43 "isatap B13B21CE... Bytes Sent sec" 0 1 0
./gnu_graph.sh $1 44 "isatap E4B4B8BB... Bytes Sent sec" 0 1 0
./gnu_graph.sh $1 45 "LAN Bytes Sent sec" 0 1 0

# Use CPU gnuplot (set yrange [1:100]) Param 4

./gnu_graphSnap.sh $1 2 "User Time Snapshot" 1 1 0
./gnu_graphSnap.sh $1 3 "Total Processor Time Snapshot" 1 1 0


# Use Std Gnuplot 

./gnu_graphSnap.sh $1 4 "Interrupts Snapshot" 0 1 0
./gnu_graphSnap.sh $1 5 "Available MBytes Snapshot" 0 1 0
./gnu_graphSnap.sh $1 6 "Memory Page Reads per sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 7 "Memory Page Writes per sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 8 "Memory Paging File Total Pct usage Snapshot" 1 1 0
./gnu_graphSnap.sh $1 9 "Total Disk Transfers Snapshot" 0 1 0 
./gnu_graphSnap.sh $1 10 "Processes Snapshot" 0 1 0

./gnu_graphSnap.sh $1 11 "Processor Queue Snapshot" 0 1 0

./gnu_graphSnap.sh $1 12 "Privileged Time Snapshot" 1 1 0

./gnu_graphSnap.sh $1 13 "E data Avg Disk sec Read Snapshot" 0 1 1
./gnu_graphSnap.sh $1 14 "E data Avg Disk sec Write Snapshot" 0 1 1
./gnu_graphSnap.sh $1 15 "E data Disk Transfers sec Snapshot" 0 1 0

./gnu_graphSnap.sh $1 16 "J jnl Avg Disk sec Read Snapshot" 0 1 1
./gnu_graphSnap.sh $1 17 "J jnl Avg Disk sec Write Snapshot" 0 1 1
./gnu_graphSnap.sh $1 18 "J jnl Disk Transfers sec Snapshot" 0 1 0

./gnu_graphSnap.sh $1 19 "C cache Avg Disk sec Read Snapshot" 0 1 1
./gnu_graphSnap.sh $1 20 "C cache Avg Disk sec Write Snapshot" 0 1 1
./gnu_graphSnap.sh $1 21 "C cache Disk Transfers sec Snapshot" 0 1 0

./gnu_graphSnap.sh $1 22 "PRO_1000 MT Bytes Received sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 23 "PRO_1000 MT Bytes Sent sec Snapshot" 0 1 0

./gnu_graphSnap.sh $1 24 "E data Disk Read Bytes per sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 25 "E data Disk Reads per sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 26 "E data Disk Write Bytes per sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 27 "E data Disk Writes per sec Snapshot" 0 1 0

./gnu_graphSnap.sh $1 28 "J Journal Disk Read Bytes per sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 29 "J Journal Disk Reads per sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 30 "J Journal Disk Write Bytes per sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 31 "J Journal Disk Writes per sec Snapshot" 0 1 0

./gnu_graphSnap.sh $1 32 "C OS Disk Read Bytes per sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 33 "C OS Disk Reads per sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 34 "C OS Disk Write Bytes per sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 35 "C OS Disk Writes per sec Snapshot" 0 1 0

./gnu_graphSnap.sh $1 36 "Total Disk Write Bytes per sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 37 "Total Disk Writes per sec Snapshot" 0 1 0

./gnu_graphSnap.sh $1 38 "vmxnet3 Bytes Received sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 39 "isatap B13B21CE... Bytes Received sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 40 "isatap E4B4B8BB... Bytes Received sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 41 "LAN Bytes Received sec Snapshot" 0 1 0

./gnu_graphSnap.sh $1 42 "vmxnet3 Bytes Sent sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 43 "isatap B13B21CE... Bytes Sent sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 44 "isatap E4B4B8BB... Bytes Sent sec Snapshot" 0 1 0
./gnu_graphSnap.sh $1 45 "LAN Bytes Sent sec Snapshot" 0 1 0

# Move to separate directory

png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_p ];
then
	mkdir ${png_name}/png_p
fi	

mv ${png_name}/*.png ${png_name}/png_p

