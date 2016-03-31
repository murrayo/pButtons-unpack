#get-mean-max.awk
#awk -F ',' -v COL=3 -v column="Glorefs" -f minmax.awk inputfileName
 
# Metric, peak, average

 
( NR > 1 ) {
if(max=="")
{
	max=0

	#print "\n"FILENAME
	#print "*** entries with value 0 not counted in average "
	#print "\n"column"\n"
	
};

# awk doesnt seem to handle number gt than 1,000,000
if($COL/100>max/100)
{
	max=$COL
	maxIdx=NR-1
};
	#if($COL!=0) # dont count empty counters - ie begining or end of benchmark runs
	#{  
		total+=$COL;
		count+=1
	#};	
}
#END {printf "Peak    %'d at Idx %d\nAverage %'d\n\n", max, maxIdx, total/count} 
END {printf "%s,%d,%d\n", column, max, total/count} 
