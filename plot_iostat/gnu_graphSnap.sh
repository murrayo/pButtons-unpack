#! /bin/sh 

## Snap shot of short period of time
# See xrange for time
# set xrange ["10:45:00":"11:00:00"] noreverse nowriteback

SnapStart1="10:30:00"
SnapEnd1="12:00:00"
SnapName1="1030-1200"

SnapStart2="11:00:00"
SnapEnd2="11:15:00"
SnapName2="1100-1115"

mo_time_column=0
# Snap can only be for time based graphs

mo_name=$1			# Name of file to plot
mo_column=$2		# Column to plot
mo_col_name=$3		# File name
mo_var_y=$4			# 1= y [0:100]
mo_time_column=$5	# Column with time (defaults to column 1)
mo_decimals=$6		# 1 = For disk time set y decimal precision to 3 (ms)
mo_notime=$7		# 1 = x data is NOT time ie iostat
mo_true=$8			# true column name
mo_text=$9			# Additional text to display on graph


mo_avg=`awk -F ',' '( NR > 1 ) {sum=sum+$'$mo_column'} END {printf "%d\n", sum/(NR-1)}' $1`

gnuplot << EOF
#Plot mgstat with gnuplot - output to png

reset
set decimal locale
set terminal pngcairo size 800,600
set size ratio 0.60
set output "/dev/null"

set datafile separator ","
set xdata time
set timefmt "%H:%M:%S"
set xrange [*:*]
set format x "%H:%M"


plot "$mo_name" using $mo_time_column:$mo_column	#To get the max and min value
ymax=GPVAL_DATA_Y_MAX
ymin=GPVAL_DATA_Y_MIN
ylen=ymax-ymin
xmax=GPVAL_DATA_X_MAX
xmin=GPVAL_DATA_X_MIN
xlen=xmax-xmin
err_len=xlen/2

#
#
set decimal locale
set terminal pngcairo size 800,600 font "Arial,9"
set size ratio 0.60
set output "$mo_name.$mo_col_name.$SnapName1.png"

set title enhanced font "Arial,12"
set title "$mo_true - $SnapName1\n$mo_text" tc lt 3

set border linecolor rgb "#405460"
set grid layerdefault   linetype -1 linecolor rgb "gray"  linewidth 0.200,  linetype -1 linecolor rgb "gray"  linewidth 0.200

set grid y
set ytics

set key
set key autotitle columnheader

set xdata time
set timefmt "%H:%M:%S"
set xrange ["$SnapStart1":"$SnapEnd1"] noreverse nowriteback
# set xrange [*:*]
set format x "%H:%M"

set xlabel "Time" tc lt 0
set xlabel offset 0,-0.5 enhanced font "Arial,10"

set format y "%'.0f"
set ylabel "\n$mo_true" tc lt 0
set ylabel offset -2,0 enhanced font "Arial,10"

set yrange [0:*]
if ($mo_var_y == 1) \
  set yrange [0:100];

# Finally... 
if ($mo_decimals == 1) \
	set format y "%'.3f" ; plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("24 hour Peak=%'.3f",ymax) axes x1y1; \
else plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("24 hour Peak=%'.0f",ymax) axes x1y1;



# Second snapshot

set title "$mo_true - $SnapName2\n$mo_text" tc lt 3
set xrange ["$SnapStart2":"$SnapEnd2"] noreverse nowriteback
set output "$mo_name.$mo_col_name.$SnapName2.png"

if ($mo_decimals == 1) \
	set format y "%'.3f" ; plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("24 hour Peak=%'.3f",ymax) axes x1y1; \
else plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("24 hour Peak=%'.0f",ymax) axes x1y1;


# Average gives the wrong impression - but its here for benchmarks
# plot "$mo_name" using 2:$mo_column with lines lt 1 title sprintf("Peak=%'.0f",ymax) axes x1y1,\
# "$mo_name" using (err_len+0.1*err_len):(\$$mo_column):(err_len*1.1)\
# smooth unique with xerrorbars lt rgb "#8B194D" title sprintf("Avg=%'.0f",$mo_avg) axes x1y1


EOF
