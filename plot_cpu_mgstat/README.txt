./do_graph_start_here.sh -d ../ZCust/SVJH/20140104_Sat_busy_DB -m -p



It's easiest if the scripts are one level below the directory with the pButtons *.html file(s)
 
1. Start here

do_graph_start_here.sh 


Usage: 
$0 [-m] [-p] [-v|-a [-6]|-b] -d directory ... 
select one or more of -d directory_to_work_on -[m]gstat, -[p]erfmon, -[v]mstat -[a]ix_vmstat -[6]aix 6 vmstat"


EG. Just mgstat data, pButtons file is in ../plot_Example
./do_graph_start_here.sh -d -m ../plot_Example

If the data is from AIX 6 (as in the example)
./do_graph_start_here.sh -d ../plot_Example -m -a6


For iostat a different set of scripts is used:
For details see the README in ../plot_iostat
 



-------------- Thats it, all the rest of the scripts are called based on the options above

2. Extract mgstat from html

prepare-logs.pl


3. Graph selected columns

do_graph_mgst.sh ---> gnu_graph.sh
do_graph_perfmon.sh  ---> gnu_graph.sh
exvmstat.pl ---> do_graph_vmstat.sh  ---> gnu_graph.sh

Includes:
avgmax.awk --- calculate and display max and average

*******************
Note: gnu_graph.sh <filename> <column# to plot> <column name to display> <1= y axis max 100> <column# with time>

./gnu_graph.sh $1 1 r 0 18

-------------- Other 

Benchmark runs are fixed to 400 on x axis

Also vmstat and sar-m are preprocessed on the server, so only mgstat is extracted by scripts

1. This script calls all the scripts below:

do_bench_0start_here.sh <Directory where html files are>


2. Extract mgstat from html, Calculate averages and max (goes to text file), plot svg graphs
do_bench_mgst.sh
do_bench_sar_m.sh
do_bench_vmst.sh

avgmax.awk
exmgstat.pl


3. This one does the graphing
gnu_graph_bench.sh


---------------

Want to get rid of zero byte files?

find . -depth -name '* *' | while IFS= read -r f ; do mv -i "$f" "$(dirname "$f")/$(basename "$f"|tr ' ' _)" ; done

for i in `ls *.png`; do if [ ! -s ${i} ]; then echo $i; rm $i; fi; done



