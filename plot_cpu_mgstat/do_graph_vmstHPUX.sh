#! /bin/sh 
mo_name=$1

# mo_name=$1			# Name of file to plot
# mo_column=$2			# Column to plot
# mo_col_name=$3		# Column name to display in title
# mo_var_y=$4			# 1= y [0:100]
# mo_time_column=$5		# Column with time (defaults to column 1)
# mo_decimals=$6		# 1 = For disk time set y decimal precision to 3 (ms)

# TIME IGNORED - TIME DOES NOT OUTPUT on HP-UX
time_position=1

# uname -a: HP-UX l1a014p1 B.11.23 U ia64 1511424435 unlimited-user license
#     1     2     3      4      5      6    7     8    9     10   11    12     13     14    15  16 17 18 
#     r     b     w      avm    free   re   at    pi   po    fr   de    sr     in     sy    cs  us sy id
#    24     7     0  1749197  801354   22    2     0    0     0    0     0   2583  48954   826  20  3 77


./gnu_graph_nt.sh $1 1 r 0 ${time_position} 0
./gnu_graph_ntSnap.sh $1 1 "r snap" 0 ${time_position} 0

./gnu_graph_nt.sh $1 2 b 0 ${time_position} 0
./gnu_graph_ntSnap.sh $1 2 "b snap" 0 ${time_position} 0

./gnu_graph_nt.sh $1 3 w 1 ${time_position} 0
./gnu_graph_ntSnap.sh $1 3 "w snap" 1 ${time_position} 0


./gnu_graph_nt.sh $1 16 us 1 ${time_position} 0
./gnu_graph_ntSnap.sh $1 16 "us snap" 1 ${time_position} 0

./gnu_graph_nt.sh $1 17 sy 1 ${time_position} 0
./gnu_graph_ntSnap.sh $1 17 "sy snap" 1 ${time_position} 0

./gnu_graph_nt.sh $1 18 id 1 ${time_position} 0
./gnu_graph_ntSnap.sh $1 18 "id snap" 1 ${time_position} 0


./gnu_graph_nt.sh $1 4 avm 0 ${time_position} 0
./gnu_graph_ntSnap.sh $1 4 "avm snap" 0 ${time_position} 0

./gnu_graph_nt.sh $1 5 free 0 ${time_position} 0
./gnu_graph_ntSnap.sh $1 5 "free snap" 0 ${time_position} 0


./gnu_graph_nt.sh $1 8 pi 0 ${time_position} 0
./gnu_graph_ntSnap.sh $1 8 "pi snap" 0 ${time_position} 0

./gnu_graph_nt.sh $1 9 po 0 ${time_position} 0
./gnu_graph_ntSnap.sh $1 9 "po snap" 0 ${time_position} 0


# Move to separate directory

png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_v ];
then
	mkdir ${png_name}/png_v
fi	

mv ${png_name}/*.png ${png_name}/png_v

# Remove zero byte files

cd ${png_name}/png_v

find . -depth -name '* *' | while IFS= read -r f ; do mv -i "$f" "$(dirname "$f")/$(basename "$f"|tr ' ' _)" ; done
for i in `ls *.png`; do if [ ! -s ${i} ]; then echo $i; rm $i; fi; done





