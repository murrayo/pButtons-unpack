#! /bin/sh 
mo_name=$1

# Put whatever loops etc, but this is just straight call
# "Time","Glorefs","RemGrefs","PhyRds","Rdratio","Gloupds","RouLaS","PhyWrs","WDQsz","WDphase","Jrnwrts","BytSnt","BytRcd,"WIJwri"

./gnu_graph.sh $1 2 Glorefs 0 1 0
awk -F ',' -v COL=2 -v column="glorefs" -f avgmax.awk $1

./gnu_graph.sh $1 3 RemGrefs 0 1 0
./gnu_graph.sh $1 4 PhyRds 0 1 0
awk -F ',' -v COL=4 -v column="PhyRds" -f avgmax.awk $1

./gnu_graph.sh $1 5 Rdratio 0 1 0
./gnu_graph.sh $1 6 Gloupds 0 1 0
awk -F ',' -v COL=6 -v column="Gloupds" -f avgmax.awk $1

./gnu_graph.sh $1 7 RouLaS 0 1 0
./gnu_graph.sh $1 8 PhyWrs 0 1 0
./gnu_graph.sh $1 9 WDQsz 0 1 0
./gnu_graph.sh $1 10 WDphase 0 1 0
./gnu_graph.sh $1 11 Jrnwrts 0 1 0
awk -F ',' -v COL=11 -v column="Jrnwrts" -f avgmax.awk $1

./gnu_graph.sh $1 12 BytSnt 0 1 0
./gnu_graph.sh $1 13 BytRcd 0 1 0
./gnu_graph.sh $1 14 WIJwri 0 1 0


# ./gnu_graphSnap.sh $1 2 "Glorefs Snapshot" 0 1 0
# ./gnu_graphSnap.sh $1 3 "RemGrefs Snapshot" 0 1 0
# ./gnu_graphSnap.sh $1 4 "PhyRds Snapshot" 0 1 0
# ./gnu_graphSnap.sh $1 5 "Rdratio Snapshot" 0 1 0
# ./gnu_graphSnap.sh $1 6 "Gloupds Snapshot" 0 1 0
# ./gnu_graphSnap.sh $1 7 "RouLaS Snapshot" 0 1 0
# ./gnu_graphSnap.sh $1 8 "PhyWrs Snapshot" 0 1 0
# ./gnu_graphSnap.sh $1 9 "WDQsz Snapshot" 0 1 0
# ./gnu_graphSnap.sh $1 10 "WDphase Snapshot" 0 1 0
# ./gnu_graphSnap.sh $1 11 "Jrnwrts Snapshot" 0 1 0
# ./gnu_graphSnap.sh $1 14 "WIJwri Snapshot" 0 1 0

# Move to separate directory

png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_m ];
then
	mkdir ${png_name}/png_m
fi	

mv ${png_name}/*.png ${png_name}/png_m


