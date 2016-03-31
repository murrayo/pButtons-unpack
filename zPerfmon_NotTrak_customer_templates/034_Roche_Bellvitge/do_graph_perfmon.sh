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


# if ($curfile=="perfmon") {
# 1	my @fieldlist=("PDH-CSV",
# 2	"Processor(_Total)\\% User Time",
# 3	"Processor(_Total)\\% Processor Time",
# 4	"Processor(_Total)\\Interrupts/sec",
# 5	"Memory\\Available MBytes",
# 6	"Memory\\Page Reads/sec",
# 7	"Memory\\Page Writes/sec",
# 8	"Paging File(_Total)\\% Usage",
# 9	"PhysicalDisk(_Total)\\Disk Transfers/sec",
# 10"System\\Processes",
# 11"System\\Processor Queue Length",
# 12"Processor(_Total)\\% Privileged Time");
# 	$separator=",";
# 	&handleStatsFile($perfmonfile,\@fieldlist,$separator);
# }
# 


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
./gnu_graph.sh $1 16 "F jnl Avg Disk sec Read" 0 1 1
./gnu_graph.sh $1 17 "F jnl Avg Disk sec Write" 0 1 1
./gnu_graph.sh $1 18 "F jnl Disk Transfers sec" 0 1 0


png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_p ];
then
	mkdir ${png_name}/png_p
fi	

mv ${png_name}/*.png ${png_name}/png_p


if [ "$do_snap" = "Y" ];
then
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

	./gnu_graphSnap.sh $1 13 "E data Avg Disk sec Read" 0 1 1
	./gnu_graphSnap.sh $1 14 "E data Avg Disk sec Write" 0 1 1
	./gnu_graphSnap.sh $1 15 "E data Disk Transfers sec" 0 1 0
	./gnu_graphSnap.sh $1 16 "F jnl Avg Disk sec Read" 0 1 1
	./gnu_graphSnap.sh $1 17 "F jnl Avg Disk sec Write" 0 1 1
	./gnu_graphSnap.sh $1 18 "F jnl Disk Transfers sec" 0 1 0

	png_name=`dirname ${mo_name}`

	if [ ! -d ${png_name}/png_p_snap ];
	then
		mkdir ${png_name}/png_p_snap
	fi	

	mv ${png_name}/*.png ${png_name}/png_p_snap

fi


