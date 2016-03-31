#! /bin/bash

# ./get_ord.sh ../ZCust/201510_HKBH/EP/LastYear/HKBH_20141014-20150414_EpisodeStats.csv


mo_name=$1			# Name of file to plot

# Eg ./get_eps.sh ../ZCust/066_BPH/20140211_adding_users/Server_Data_BPH/Episodes_20130101_20140215/20130101-20140215_EpisodeStats.csv
# Date	TotalEpisodes	MaxEpisodesPerHour	PeakHour	MaxEpisodesPerMin	PeakMin	TotalInpatient	TotalOutPatient	TotalEmergency
# 1			2					3				4				5				6			7				8				9	
# TotalOrders	PeakOrdersPerMinute	PeakMin	Labs	Drug	Radiology	Consults	Diet	IV	Dental	Rehab	Price	Other	Receipts	Bills	Prescriptions	Results	Appointments	TotLabEp	PeakLabEpPerMinute	PeakMin
#    10			12					13	14		15			16			17		18		19		20		21		22	 23			24			25		26				27		28

# Get start date

# Debug
#awk -F ',' '( FNR == 2) {print}' $mo_name
#awk -F ',' 'END {print}' $mo_name
#exit 1

mo_start_date=`awk -F ',' '( FNR == 2) {printf "%s", $1}' $mo_name`
mo_end_date=`awk -F ',' 'END {print $1}' $mo_name`


# Average orders
mo_avg_ord=`awk -F ',' '( NR > 1 ) {sum=sum+$'10'} END {printf "%d\n", sum/(NR-1)}' $1`

# Peak Orders
declare -i mo_or_peak_min ; mo_or_peak_min=`awk -F ',' '( NR > 1 ) {if(min==""){min=max=$10}; if($10>max) {max=$10}; if($10< min) {min=$10}; total+=$10; count+=1} END { printf "%d\n", max }' $1`

# Orders per year
declare -i Ord_year ; Ord_year=${mo_avg_ord}*365


echo
echo $1  "  Start: " $mo_start_date " End: " $mo_end_date
echo
printf "Orders: Per Year=\t%'.0f \n" $Ord_year
printf "Orders: Avg/day=\t%'.0f \n" $mo_avg_ord
printf "Orders: Peak/day=\t%'.0f \n" $mo_or_peak_min
echo "---------------------------------------------------------------"

# ./gnu_graphOrd.sh $1  &> /dev/null 
./gnu_graphOrd.sh $1  

png_name=`dirname $1`

if [ ! -d ${png_name}/png_orders ]
then	
	mkdir ${png_name}/png_orders
fi	

mv ${png_name}/*.png ${png_name}/png_orders

