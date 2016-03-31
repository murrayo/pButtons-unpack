#! /bin/sh 

# Chile
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
./gnu_graph.sh $1 6 "Processes" 0 1 0
./gnu_graph.sh $1 7 "Processor Queue" 0 1 0
./gnu_graph.sh $1 8 "Privileged Time" 1 1 0



png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_p ];
then
	mkdir ${png_name}/png_p
fi	

mv ${png_name}/*.png ${png_name}/png_p


if [ "$do_snap" = "Y" ];
then
	# Use CPU gnuplot (set yrange [1:100]) Param 4

# Use CPU gnuplot (set yrange [1:100]) Param 4

./gnu_graphSnap.sh $1 2 "User Time" 1 1 0
./gnu_graphSnap.sh $1 3 "Total Processor Time" 1 1 0

# Use Std Gnuplot 

./gnu_graphSnap.sh $1 4 "Interrupts" 0 1 0
./gnu_graphSnap.sh $1 5 "Available MBytes" 0 1 0
./gnu_graphSnap.sh $1 6 "Processes" 0 1 0
./gnu_graphSnap.sh $1 7 "Processor Queue" 0 1 0
./gnu_graphSnap.sh $1 8 "Privileged Time" 1 1 0


	png_name=`dirname ${mo_name}`

	if [ ! -d ${png_name}/png_p_snap ];
	then
		mkdir ${png_name}/png_p_snap
	fi	

	mv ${png_name}/*.png ${png_name}/png_p_snap

fi


