#! /bin/bash

mo_name=$1			# Name of file to plot

# Eg ./get_eps.sh ../ZCust/066_BPH/20140211_adding_users/Server_Data_BPH/Episodes_20130101_20140215/20130101-20140215_EpisodeStats.csv
# Date	TotalEpisodes	MaxEpisodesPerHour	PeakHour	MaxEpisodesPerMin	PeakMin	TotalInpatient	TotalOutPatient	TotalEmergency	TotalOrders	PeakOrdersPerMinute	PeakMin	Labs	Drug	Radiology	Consults	Diet	IV	Dental	Rehab	Price	Other	Receipts	Bills	Prescriptions	Results	Appointments	TotLabEp	PeakLabEpPerMinute	PeakMin
# 1			2					3				4				5				6			7				8				9			10			12					13	14		15			16			17		18		19		20		21		22	 23			24			25		26				27		28
# Get start date

mo_start_date=`awk -F ',' '( FNR == 2) {printf "%s", $1}' $mo_name`
mo_end_date=`awk -F ',' 'END {print $1}' $mo_name`

# Average Episodes
mo_ep_avg=`awk -F ',' '( NR > 1 ) {sum=sum+$'2'} END {printf "%d\n", sum/(NR-1)}' $1`

# Peak episodes - declare so can run calcs
declare -i mo_ep_peak ; mo_ep_peak=`awk -F ',' '( NR > 1 ) {if(min==""){min=max=$2}; if($2>max) {max=$2}; if($2< min) {min=$2}; total+=$2; count+=1} END { printf "%d\n", max }' $1`

# Peak episodes hour
declare -i mo_ep_peak_hour ; mo_ep_peak_hour=`awk -F ',' '( NR > 1 ) {if(min==""){min=max=$3}; if($3>max) {max=$3}; if($3< min) {min=$3}; total+=$3; count+=1} END { printf "%d\n", max }' $1`

# Peak episodes minute
declare -i mo_ep_peak_min ; mo_ep_peak_min=`awk -F ',' '( NR > 1 ) {if(min==""){min=max=$5}; if($5>max) {max=$5}; if($5< min) {min=$5}; total+=$5; count+=1} END { printf "%d\n", max }' $1`

# Average outpatients (outpatients + emergency)
declare -i mo_avg_out ; mo_avg_out=`awk -F ',' '( NR > 1 ) {sum=sum+$8+$9} END {printf "%d\n", sum/(NR-1)}' $1`

# Pct outpatients (outpatients + emergency)/(outpatients + emergency+inpatients)
declare -i mo_pct_out ; mo_pct_out=`awk -F ',' '( NR > 1 ) {sum=sum+$8+$9} ; {sum_all=sum_all+$7+$8+$9} END {printf "%d\n", (sum/sum_all)*100}' $1`

# Average orders
mo_avg_ord=`awk -F ',' '( NR > 1 ) {sum=sum+$'10'} END {printf "%d\n", sum/(NR-1)}' $1`

# Peak Orders
declare -i mo_or_peak_min ; mo_or_peak_min=`awk -F ',' '( NR > 1 ) {if(min==""){min=max=$10}; if($10>max) {max=$10}; if($10< min) {min=$10}; total+=$10; count+=1} END { printf "%d\n", max }' $1`

# Episodes year
declare -i Ep_year ; Ep_year=${mo_ep_avg}*365

# Orders per year
declare -i Ord_year ; Ord_year=${mo_avg_ord}*365
declare -i Ord_Ep ; Ord_Ep=${Ord_year}/${Ep_year}

echo
echo $1  "  Start: " $mo_start_date " End: " $mo_end_date
echo


echo "---------------------------------------------------------------"
echo `basename $1`
printf "Episodes: Est Year=\t%'.0f \n" $Ep_year
printf "Orders: Per Year=\t%'.0f \n" $Ord_year
printf "Orders: Orders/Episode=\t%'.0f \n" $Ord_Ep
echo "==============================================================="
echo
printf "Episodes: Avg/Day=\t%'.0f \n" $mo_ep_avg
printf "Episodes: Peak/Day=\t%'.0f \n" $mo_ep_peak
printf "Episodes: Peak/hour=\t%'.0f \n" $mo_ep_peak_hour
printf "Episodes: Peak/minute=\t%'.0f \n" $mo_ep_peak_min
printf "Orders: Avg/day=\t%'.0f \n" $mo_avg_ord
printf "Orders: Peak/day=\t%'.0f \n" $mo_or_peak_min
printf "Outpatients: Avg/day=\t%'.0f \n" $mo_avg_out
printf "Outpatients: Pct=\t%'.0f \n" $mo_pct_out
echo "---------------------------------------------------------------"

outfile=`dirname $1`"/summary.csv"

if [ ! -f $outfile ]
then
	echo  "Site,Episodes per year,Orders per year,Orders per episode" >> ${outfile}
else
	echo "Appending to end of existing $outfile"
fi

printf `basename $1`,  >>${outfile}
printf "%.0f," ${Ep_year} >>${outfile}
printf "%.0f," ${Ord_year} >>${outfile}
printf "%.0f\n" ${Ord_Ep} >>${outfile}


./gnu_graphEp.sh $1  &> /dev/null 

png_name=`dirname $1`

if [ ! -d ${png_name}/png_episodes ]
then	
	mkdir ${png_name}/png_episodes
fi	

mv ${png_name}/*.png ${png_name}/png_episodes

