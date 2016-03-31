#! /bin/sh 

mo_time_column=1
mo_notime=0

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

if ($mo_notime == 1) set xdata; \
else set xdata time; set timefmt "%H:%M:%S"; set format x "%H:%M"; set xrange [*:*] ;

if ($mo_notime == 1) plot "$mo_name" using $mo_column; \
else plot "$mo_name" using $mo_time_column:$mo_column;

#To get the max and min value
ymax=GPVAL_DATA_Y_MAX
ymin=GPVAL_DATA_Y_MIN
ylen=ymax-ymin

if ($mo_notime != 1) xmax=GPVAL_DATA_X_MAX; xmin=GPVAL_DATA_X_MIN; xlen=xmax-xmin; err_len=xlen/2;

#
#
set decimal locale
set terminal pngcairo size 800,600 font "Arial,9"
set size ratio 0.60
set output "$mo_name.$mo_col_name.png"

set title enhanced font "Arial,12"
set title "$mo_true\n$mo_text" tc lt 3

set border linecolor rgb "#405460"
set grid layerdefault   linetype -1 linecolor rgb "gray"  linewidth 0.200,  linetype -1 linecolor rgb "gray"  linewidth 0.200

set grid y
set ytics

set key
set key autotitle columnheader

if ($mo_notime == 1) set xdata; \
else set xdata time; set timefmt "%H:%M:%S"; set format x "%H:%M"; set xrange [*:*];

# set xrange ["00:00:01":"23:59:00"] noreverse nowriteback

if ($mo_notime == 1) set xlabel "Count" tc lt 0 ; \
else set xlabel "Time" tc lt 0 ;

set xlabel offset 0,-0.5 enhanced font "Arial,10"

set format y "%'.0f"
set ylabel "\n$mo_true" tc lt 0
set ylabel offset -2,0 enhanced font "Arial,10"

set yrange [0:*]
if ($mo_var_y == 1) \
  set yrange [0:100];
  
# set label 1 enhanced font "Arial bold,12"  
# set label 1 "$mo_true" at graph 0.02, 0.96, 0 left norotate back textcolor lt 3 nopoint offset character 0, 0, 0

# Finally... 
if ($mo_notime == 1) plot "$mo_name" using $mo_column with lines lt rgb "#71C671" title sprintf("Peak=%'.0f",ymax) axes x1y1; \
else plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("Peak=%'.0f",ymax) axes x1y1;



EOF
