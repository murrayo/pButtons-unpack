#! /bin/bash

mo_name=$1			# Name of file to plot

# eg ./get_licence.sh ../ZCust/066_BPH/20140211_adding_users/Server_Data_BPH/Episodes_20130101_20140215/20140218_0506_MonitorLicenseData.csv


# DateTimeStamp	TrakTotal	TrakCare	MedTrak	LabTrak	LabInstruments	CacheConsumed	CacheTotal	CacheAvailable	CacheMaxNo	CacheMinNo	MonitorTime	MonitorDate	ServerName	Namespace	DistributedCurrentUsed	DistributedMaxUsed	DistributedEnforced	DistributedAuthorized

# for i in `ls files/*.csv`; do ./get_licence.sh $i; done

# Reference
# awk -F ',' '( NR > 1 ) {if(min==""){min=max=$5}; if($5>max) {max=$5}; if($5< min) {min=$5}; total+=$5; count+=1} END {print total/count, min, max}' ./files/UFH_20130101-20130507_EpisodeStats.csv


# What are we graphing

list_graphs=([2]=All [3]=Trak [5]=Lab [6]=Inst [7]=Cache [16]=Dist)

# loop through and get averages etc, the files are small so no time, but could make separate function... another day


# Get start and end date
mo_start_date=`awk -F ',' '( FNR == 2 ) {print $1}' $1`
mo_end_date=`awk -F ',' 'END {print $1}' $1`


# if multi server config sort output
# Count unique servers
mo_no_servers=1
mo_no_servers=`awk -F ',' '( NR > 1 ) {print $14}' $1 |sort| uniq | wc -l`

echo $mo_name
echo "Number of servers= " $mo_no_servers

# show servers
awk -F ',' '( NR > 1 ) {print $14}' $1 |sort| uniq

# strip header for simpler counting
awk -F ',' '( NR > 1 ) {print}' ${mo_name} > ${mo_name}_temp.txt


# split output to separate files for simple debug and graph
if [ $mo_no_servers -gt 1 ]
then

	# Sum every n lines
	
	for i in 2 3 5 6 7 16 # column numbers
	do
		my_command="awk -F ',' '{s+=\$${i}}NR% ${mo_no_servers}==0{print s;s=0}'"
	
		eval $my_command ${mo_name}_temp.txt > ${mo_name}_${i}.txt
	done	
	
else
	for i in 2 3 5 6 7 16 # column numbers
	do
		my_command="awk -F ',' '{print \$${i}}'"
		
		eval $my_command ${mo_name}_temp.txt > ${mo_name}_${i}.txt
	done
fi	

declare -i mo_lineno; mo_lineno=`awk -F ',' '{if(max==""){max=$1}; if($1>max) {max=$1; lineno=NR} }; END { printf "%d\n", lineno+1 }' ${mo_name}_2.txt`
printf "Plot peak @\t%'.0f \n" ${mo_lineno}
mo_lineno=${mo_lineno}*${mo_no_servers}
printf "csv peak @\t%'.0f \n" ${mo_lineno}

# Use Array for file name and output details
for i in 2 3 5 6 7 16 # colum numbers
do

	printf "Peak: ${list_graphs[$i]} =\t%'.0f \n" `awk -F ',' '{if(max==""){max=$1}; if($1>max) {max=$1}}; END { printf "%d\n", max }' ${mo_name}_${i}.txt`
	./gnu_graph.sh ${mo_name}_${i}.txt 1 ${list_graphs[$i]} 0 0 0 1 ${list_graphs[$i]} "Start: ${mo_start_date} End: ${mo_end_date}"  &> /dev/null
done


png_name=`dirname $1`

# clean up

for i in 2 3 5 6 7 16 # colum numbers
do
	rm ${mo_name}_${i}.txt
done	

rm ${mo_name}_temp.txt


# park .png files

if [ ! -d ${png_name}/png_licences ]
then	
	mkdir ${png_name}/png_licences
fi	

mv ${png_name}/*.png ${png_name}/png_licences

	
exit 1