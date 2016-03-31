#! /bin/sh 

mo_time_column=1

mo_name=$1			# Name of file to plot
mo_column=$2		# Column to plot
mo_col_name=$3		# Column name to display in title
mo_var_y=$4			# 1= y [0:100]
mo_time_column=$5	# Column with time (defaults to column 1)
mo_decimals=$6		# 1 = For disk time set y decimal precision to 3 (ms)

mo_avg=`awk -F ',' '( NR > 1 ) {sum=sum+$'$mo_column'} END {printf "%d\n", sum/(NR-1)}' $1`

gnuplot << EOF
#Plot mgstat with gnuplot - output to png

reset
set decimal locale
###set terminal pngcairo size 800,600
set terminal pngcairo size 500,300
###set size ratio 0.60
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
### set terminal pngcairo size 500,300 font "Arial,8"
### set size ratio 0.60
set output "$mo_name.$mo_col_name.png"

set title enhanced font "Arial Bold,10"
set title "$mo_col_name" tc lt 3

set border linecolor rgb "#405460"
set grid layerdefault   linetype -1 linecolor rgb "gray"  linewidth 0.200,  linetype -1 linecolor rgb "gray"  linewidth 0.200

set grid y
set ytics
set y2tics format ""

set grid x
set grid x2

set xtics out nomirror
# set xtics rotate by 270 offset 0,0 out nomirror

# Need to set x2 tics to align with x, but don't want duplicate labels
set x2tics format "" 

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set key
set key autotitle columnheader

set xdata time
set x2data time

set timefmt "%H:%M:%S"
# set xrange ["00:00:01":"23:59:00"] noreverse nowriteback
set xrange [*:*]
set x2range [*:*]

set format x "%H:%M"

set xlabel "Time" tc lt 0
###set xlabel offset 0,-0.5 enhanced font "Arial,10"
set xlabel offset 0,-0.25 enhanced font "Arial,8"

set format y "%'.0f"
set ylabel "\n$mo_col_name" tc lt 0
### set ylabel offset -2,0 enhanced font "Arial,10"
set ylabel offset -.25,0 enhanced font "Arial,8"

set yrange [0:*]
set y2range [0:*]

if ($mo_var_y == 1) \
  set yrange [0:100]; set y2range [0:100];
  
# Finally... 
# if ($mo_decimals == 1) \
#	set format y "%'.3f" ; plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("Peak=%'.3f",ymax) axes x1y1; \
# 	else plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("Peak=%'.0f",ymax) axes x1y1;

# Average gives the wrong impression - but its here for benchmarks - not used on fractional y axis 
if ($mo_decimals == 1) \
	set format y "%'.3f" ; plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("Peak=%'.3f",ymax) axes x1y1; \
 	else plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("Peak=%'.0f    Avg=%'.0f", ymax, $mo_avg) axes x1y1;
 
#if ($mo_decimals == 1) \
#	set format y "%'.3f" ; plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("Peak=%'.3f",ymax) axes x1y1; \
# 	else plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("Peak=%'.0f",ymax) axes x1y1, \
# 		      "$mo_name" using $mo_time_column:$mo_column:(1.0) with lines lt rgb "#006400" title sprintf("Avg=%'.0f",$mo_avg) axes x1y1 smooth acsplines;
		       

# With smoothing - not so good on long graphs Finally... 
# if ($mo_decimals == 1) \
#	set format y "%'.3f" ; plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("Peak=%'.3f",ymax) axes x1y1, "$mo_name" using $mo_time_column:$mo_column:(1.0) with lines lt rgb "#006400" title "Smoothed" axes x2y2 smooth acsplines; \
# else plot "$mo_name" using $mo_time_column:$mo_column with lines lt rgb "#71C671" title sprintf("Peak=%'.0f",ymax) axes x1y1, "$mo_name" using $mo_time_column:$mo_column:(1.0) with lines lt rgb "#006400" title "Smoothed" axes x2y2 smooth acsplines;


# Average gives the wrong impression - but its here for benchmarks
# plot "$mo_name" using $mo_time_column:$mo_column with lines lt 1 title sprintf("Peak=%'.0f",ymax) axes x1y1,\
# "$mo_name" using (err_len+0.1*err_len):(\$$mo_column):(err_len*1.1)\
# smooth unique with xerrorbars lt rgb "#8B194D" title sprintf("Avg=%'.0f",$mo_avg) axes x1y1


EOF













