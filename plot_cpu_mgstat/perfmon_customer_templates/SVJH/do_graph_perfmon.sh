#! /bin/sh 
mo_name=$1
do_snap=$2

# SVJH

# [Databases]
# CACHESYS=E:\TrakCare\Prod\Trak\Ensemble\mgr\

# PROD-ANALYTICS=F:\trakcare\prod\trak\db\analytics\,,1
# PROD-APPSYS=F:\trakcare\prod\trak\db\appsys\,,1
# PROD-AUDIT0=F:\trakcare\prod\trak\db\audit0\,,1
# PROD-AUDIT1=F:\trakcare\prod\trak\db\audit1\,,1
# PROD-AUDIT2=F:\trakcare\prod\trak\db\audit2\,,1
# PROD-AUDIT3=F:\trakcare\prod\trak\db\audit3\,,1
# PROD-AUDIT4=F:\trakcare\prod\trak\db\audit4\,,1
# PROD-BILLING=F:\trakcare\prod\trak\db\billing\,,1
# PROD-BPXDATA=F:\trakcare\prod\trak\db\BPXDATA\
# PROD-CACHEQUERY=F:\trakcare\prod\trak\db\cachequery\,,1
# PROD-CODES=F:\trakcare\prod\trak\db\codes\,,1
# PROD-DATA=F:\trakcare\prod\trak\db\data\,,1
# PROD-DOCUMENT=F:\trakcare\prod\trak\db\document\,,1
# PROD-DOCUMENTJPG0=F:\trakcare\prod\trak\db\documentjpg0\,,1
# PROD-DOCUMENTJPG1=F:\trakcare\prod\trak\db\documentjpg1\,,1
# PROD-DOCUMENTOTHER0=F:\trakcare\prod\trak\db\documentother0\,,1
# PROD-DOCUMENTOTHER1=F:\trakcare\prod\trak\db\documentother1\,,1
# PROD-DOCUMENTPDF0=F:\trakcare\prod\trak\db\documentpdf0\,,1
# PROD-DOCUMENTPDF1=F:\trakcare\prod\trak\db\documentpdf1\,,1
# PROD-DOCUMENTTXT0=F:\trakcare\prod\trak\db\documenttxt0\,,1
# PROD-DOCUMENTTXT1=F:\trakcare\prod\trak\db\documenttxt1\,,1
# PROD-DSTIME=F:\trakcare\prod\trak\db\dstime\,,1
# PROD-FACTS=F:\trakcare\prod\trak\db\facts\,,1
# PROD-HL7=F:\trakcare\prod\trak\db\hl7\,,1
# PROD-IKNOW=F:\trakcare\prod\trak\db\iknow\,,1

# PROD-LABAPP=H:\trakcare\prod\lab\db\labapp\,SVH-TRAKLCLG
# PROD-LABCODES=H:\trakcare\prod\lab\db\labcodes\,SVH-TRAKLCLG
# PROD-LABDATA=H:\trakcare\prod\lab\db\labdata\,SVH-TRAKLCLG
# PROD-LABDOCS=H:\trakcare\prod\lab\db\labdocs\,SVH-TRAKLCLG
# PROD-LABTEMP=H:\trakcare\prod\lab\db\labtemp\,SVH-TRAKLCLG

# PROD-LOCALENS=F:\trakcare\prod\trak\db\localens\,,1
# PROD-LOG0=F:\trakcare\prod\trak\db\log0\,,1
# PROD-LOG1=F:\trakcare\prod\trak\db\log1\,,1
# PROD-LOG2=F:\trakcare\prod\trak\db\log2\,,1
# PROD-LOG3=F:\trakcare\prod\trak\db\log3\,,1
# PROD-LOG4=F:\trakcare\prod\trak\db\log4\,,1
# PROD-MONITOR=F:\trakcare\prod\trak\db\monitor\,,1
# PROD-ORDER=F:\trakcare\prod\trak\db\order\,,1
# PROD-SYSCONFIG=F:\trakcare\prod\trak\db\sysconfig\,,1
# PROD-ZTEMP=F:\trakcare\prod\trak\db\ztemp\,,1

# AlternateDirectory=N:\TrakCare\Prod\Trak\Ensemble\mgr\AltJournals\
# BackupsBeforePurge=2 
# CurrentDirectory=K:\TrakCare\Prod\Trak\Ensemble\mgr\Journals\


# Put whatever loops etc, but this is just straight call

# mo_name=$1			# Name of file to plot
# mo_column=$2		    # Column to plot
# mo_col_name=$3		# Column name to display in title
# mo_var_y=$4			# 1= y [0:100]
# mo_time_column=$5	    # Column with time (defaults to column 1)
# mo_decimals=$6		# 1 = For disk time set y decimal precision to 3 (ms)


# if ($curfile=="perfmon") {
# 	my @fieldlist=("PDH-CSV",
# 	"Processor(_Total)\\% User Time",
# 	"Processor(_Total)\\% Processor Time",
# 	"Processor(_Total)\\Interrupts/sec",
# 	"Memory\\Available MBytes",
# 	"Memory\\Page Reads/sec",
# 	"Memory\\Page Writes/sec",
# 	"Paging File(_Total)\\% Usage",
# 	"PhysicalDisk(_Total)\\Disk Transfers/sec",
# 	"System\\Processes",
# 	"System\\Processor Queue Length",
# 	"Processor(_Total)\\% Privileged Time");
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



./gnu_graph.sh $1 13 "F data Avg Disk sec Read" 0 1 1
./gnu_graph.sh $1 14 "F data Avg Disk sec Write" 0 1 1
./gnu_graph.sh $1 15 "F data Disk Transfers sec" 0 1 0
./gnu_graph.sh $1 16 "K jnl Avg Disk sec Read" 0 1 1
./gnu_graph.sh $1 17 "K jnl Avg Disk sec Write" 0 1 1
./gnu_graph.sh $1 18 "K jnl Disk Transfers sec" 0 1 0

./gnu_graph.sh $1 19 "N jnl Avg Disk sec Read" 0 1 1
./gnu_graph.sh $1 20 "N jnl Avg Disk sec Write" 0 1 1
./gnu_graph.sh $1 21 "N jnl Disk Transfers sec" 0 1 0


# Use CPU gnuplot (set yrange [1:100]) Param 4

./gnu_graphSnap.sh $1 2 "User Time Snapshot" 1 1 0
./gnu_graphSnap.sh $1 3 "Total Processor Time Snapshot" 1 1 0


# Use Std Gnuplot 
png_name=`dirname ${mo_name}`

if [ ! -d ${png_name}/png_p ];
then
	mkdir ${png_name}/png_p
fi	

mv ${png_name}/*.png ${png_name}/png_p

# Use CPU gnuplot (set yrange [1:100]) Param 4
if [ "$do_snap" = "Y" ];
then


	./gnu_graphSnap.sh $1 4 "Interrupts Snapshot" 0 1 0
	./gnu_graphSnap.sh $1 5 "Available MBytes Snapshot" 0 1 0
	./gnu_graphSnap.sh $1 6 "Memory Page Reads per sec Snapshot" 0 1 0
	./gnu_graphSnap.sh $1 7 "Memory Page Writes per sec Snapshot" 0 1 0
	./gnu_graphSnap.sh $1 8 "Memory Paging File Total Pct usage Snapshot" 1 1 0
	./gnu_graphSnap.sh $1 9 "Total Disk Transfers Snapshot" 0 1 0 
	./gnu_graphSnap.sh $1 10 "Processes Snapshot" 0 1 0

	./gnu_graphSnap.sh $1 11 "Processor Queue Snapshot" 0 1 0

	./gnu_graphSnap.sh $1 12 "Privileged Time Snapshot" 1 1 0

	./gnu_graphSnap.sh $1 13 "F data Avg Disk sec Read" 0 1 1
	./gnu_graphSnap.sh $1 14 "F data Avg Disk sec Write" 0 1 1
	./gnu_graphSnap.sh $1 15 "F data Disk Transfers sec" 0 1 0
	./gnu_graphSnap.sh $1 16 "K jnl Avg Disk sec Read" 0 1 1
	./gnu_graphSnap.sh $1 17 "K jnl Avg Disk sec Write" 0 1 1
	./gnu_graphSnap.sh $1 18 "K jnl Disk Transfers sec" 0 1 0

	./gnu_graphSnap.sh $1 19 "N jnl Avg Disk sec Read" 0 1 1
	./gnu_graphSnap.sh $1 20 "N jnl Avg Disk sec Write" 0 1 1
	./gnu_graphSnap.sh $1 21 "N jnl Disk Transfers sec" 0 1 0

	png_name=`dirname ${mo_name}`

	if [ ! -d ${png_name}/png_p_snap ];
	then
		mkdir ${png_name}/png_p_snap
	fi	

	mv ${png_name}/*.png ${png_name}/png_p_snap

fi

