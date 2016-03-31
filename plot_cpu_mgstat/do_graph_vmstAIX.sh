#! /bin/sh 
mo_name=$1
do_snap=$2
AIX_Version=$3

# mo_name=$1			# Name of file to plot
# mo_column=$2			# Column to plot
# mo_col_name=$3		# Column name to display in title
# mo_var_y=$4			# 1= y [0:100]
# mo_time_column=$5		# Column with time (defaults to column 1)
# mo_decimals=$6		# 1 = For disk time set y decimal precision to 3 (ms)

time_position=20

if [ $AIX_Version == 6 ] ;
then
	time_position=18
fi
	
	
# oslevel -r: 7100-01 (Thiene)
#   r  b   avm   fre    re  pi  po  fr                  sr                   cy  in  sy  cs   us sy id  wa   pc   ec    hr mi se
#   1  2    3     4      5   6   7   8					9                    10  11  12  13   14 15 16  17   18   19    20 
#   3  1 7201729 41583   0   0   0 4636223281790821470 4636223281790821470   0 580 31652 2954 48 15 37  0    2.22 138.7 00:00:09

## IBM Benchmark March 2014 oslevel -r: 7100-01
#  r  b   avm   fre  re  pi  po  fr   sr  cy  in   sy  cs us sy id wa hr mi se
#  2  0 2290622 1071563   0   0   0   0    0   0  42 8605 910  1  0 99  0 16:02:23

./gnu_graph.sh $1 1 r 0 ${time_position} 0
awk -F ',' -v COL=1 -v column="r" -f avgmax.awk $1

./gnu_graph.sh $1 2 b 0 ${time_position} 0
./gnu_graph.sh $1 17 wa 1 ${time_position} 0
awk -F ',' -v COL=17 -v column="wa" -f avgmax.awk $1

./gnu_graph.sh $1 14 us 1 ${time_position} 0
awk -F ',' -v COL=14 -v column="us" -f avgmax.awk $1


./gnu_graph.sh $1 15 sy 1 ${time_position} 0
awk -F ',' -v COL=15 -v column="sy" -f avgmax.awk $1


./gnu_graph.sh $1 16 id 1 ${time_position} 0
./gnu_graph.sh $1 3 avm 0 ${time_position} 0
./gnu_graph.sh $1 4 fre 0 ${time_position} 0
./gnu_graph.sh $1 6 pi 0 ${time_position} 0
./gnu_graph.sh $1 7 po 0 ${time_position} 0

# Move to separate directory

png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_v ];
then
	mkdir ${png_name}/png_v
fi	

mv ${png_name}/*.png ${png_name}/png_v

if [ "$do_snap" = "Y" ];
then
	./gnu_graphSnap.sh $1 1 "r snap" 0 ${time_position} 0
	./gnu_graphSnap.sh $1 2 "b snap" 0 ${time_position} 0
	./gnu_graphSnap.sh $1 17 "wa snap" 1 ${time_position} 0
	./gnu_graphSnap.sh $1 14 "us snap" 1 ${time_position} 0
	./gnu_graphSnap.sh $1 15 "sy snap" 1 ${time_position} 0
	./gnu_graphSnap.sh $1 16 "id snap" 1 ${time_position} 0
	./gnu_graphSnap.sh $1 3 "avm snap" 0 ${time_position} 0
	./gnu_graphSnap.sh $1 4 "free snap" 0 ${time_position} 0
	./gnu_graphSnap.sh $1 6 "pi snap" 0 ${time_position} 0
	./gnu_graphSnap.sh $1 7 "po snap" 0 ${time_position} 0

	png_name=`dirname ${mo_name}`

	if [ ! -d ${png_name}/png_v_snap ];
	then
		mkdir ${png_name}/png_v_snap
	fi	

	mv ${png_name}/*.png ${png_name}/png_v_snap
fi




