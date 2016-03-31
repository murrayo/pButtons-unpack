#! /bin/sh 
mo_name=$1
do_snap=$2

# Red Hat
# 1	           2	3	4	5	     6	    7	    8	    9	10	11	12	13	14	15	16	17	18	19
# 08/30/12	9:16:00	r	b	swpd	free	buff	cache	si	so	bi	bo	in	cs	us	sy	id	wa	st
# 
./gnu_graph.sh $1 3 r 0 2 0
awk -F ',' -v COL=3 -v column="r" -f avgmax.awk $1
# 
./gnu_graph.sh $1 4 b 0 2 0
awk -F ',' -v COL=4 -v column="b" -f avgmax.awk $1
# 
./gnu_graph.sh $1 18 wa 1 2 0
awk -F ',' -v COL=18 -v column="w" -f avgmax.awk $1
# 
./gnu_graph.sh $1 15 us 1 2 0
awk -F ',' -v COL=15 -v column="us" -f avgmax.awk $1
# 
./gnu_graph.sh $1 16 sy 1 2 0
awk -F ',' -v COL=16 -v column="sy" -f avgmax.awk $1
# 
./gnu_graph.sh $1 17 id 1 2 0
awk -F ',' -v COL=17 -v column="id" -f avgmax.awk $1
# 

./gnu_graph.sh $1 6 free 0 2 0
awk -F ',' -v COL=6 -v column="free" -f avgmax.awk $1


png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_v ];
then
	mkdir ${png_name}/png_v
fi	

mv ${png_name}/*.png ${png_name}/png_v


if [ "$do_snap" = "Y" ];
then
	./gnu_graphSnap.sh $1 3 "r_snap" 0 2 0
	./gnu_graphSnap.sh $1 4 "b_snap" 0 2 0
	./gnu_graphSnap.sh $1 18 "wa_snap" 1 2 0
	./gnu_graphSnap.sh $1 15 "us_snap" 1 2 0
	./gnu_graphSnap.sh $1 16 "sy_snap" 1 2 0
	./gnu_graphSnap.sh $1 17 "id_snap" 1 2 0
	./gnu_graphSnap.sh $1 6 "free_snap" 0 2 0


	png_name=`dirname ${mo_name}`

	if [ ! -d ${png_name}/png_v_snap ];
	then
		mkdir ${png_name}/png_v_snap
	fi	

	mv ${png_name}/*.png ${png_name}/png_v_snap

fi
