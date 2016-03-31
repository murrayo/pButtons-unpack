#! /bin/sh 

mo_name=$1			# Name of file to plot

# Left hand axis Orders
# Right hand axis Episodes

# Get start date
mo_start_date=`awk -F ',' '( FNR == 2 ) {print $1}' $1`

# Get some averages quickly for the heading

mo_avg_ord=`awk -F ',' '( NR > 1 ) {sum=sum+$'10'} END {printf "%d\n", sum/(NR-1)}' $1`
Ord_year=$(( mo_avg_ord*365 ))

mo_avg=`awk -F ',' '( NR > 1 ) {sum=sum+$'2'} END {printf "%d\n", sum/(NR-1)}' $1`
Ep_year=$(( mo_avg*365 ))

#OrdersPerEp=$Ord_year/$Ep_year. Use different calc method -- expr -- just testing... also like..  Ord_year=$(( mo_avg_ord*365 ))

OrdersPerEp=`expr $Ord_year/$Ep_year`


gnuplot << EOF
#Plot mgstat with gnuplot - output to png

reset
set decimal locale
set terminal pngcairo size 800,600
set size ratio 0.60
set output "/dev/null"

set datafile separator ","

set xdata; 
plot "$mo_name" using 10 axes x1y1 , "$mo_name" using 2 with lines lt 0 axes x2y2;

#To get the max and min value
ymax=GPVAL_DATA_Y_MAX
ymin=GPVAL_DATA_Y_MIN

y2max=GPVAL_DATA_Y2_MAX
y2min=GPVAL_DATA_Y2_MIN

#
#
set decimal locale
set terminal pngcairo size 800,600 font "Arial,9"
set size ratio 0.60
set output "$mo_name.Orders.png"

set title enhanced font "Arial,11"
# set title "$mo_true\n$mo_text"
set title sprintf("Orders: Avg/Day=%'.0f   Peak/Day=%'.0f   Est Year=%'.0f	Orders/Episode=%'.0f \n\n Episodes: Avg/Day=%'.0f  Peak/Day=%'.0f  Est Year=%'.0f", \
$mo_avg_ord, ymax, $Ord_year, $OrdersPerEp, $mo_avg, y2max, $Ep_year  )

set border linecolor rgb "#405460"
set grid layerdefault   linetype -1 linecolor rgb "gray"  linewidth 0.200,  linetype -1 linecolor rgb "gray"  linewidth 0.200

set grid y
set ytics
set y2tics

set grid x
set grid x2

set xtics out nomirror
# set xtics rotate by 270 offset 0,0 out nomirror

# Need to set x2 tics to align with x, but don't want duplicate labels
set x2tics format "" 
set format x2 ""

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set key
set key autotitle columnheader

set xdata time
set x2data time

set timefmt "%d/%m/%Y"
set format x "%d/%m"

set xrange ["$mo_start_date":*] noreverse nowriteback
set x2range ["$mo_start_date":*] noreverse nowriteback
# set xrange [*:*]
# set x2range [*:*]

# set xlabel "Days" tc lt 0 ; 
# set xlabel offset 0,-0.5 enhanced font "Arial,10"

set format y "%'.0f"
set ylabel "\n Orders per day" tc lt 0
set ylabel offset -2,0 enhanced font "Arial,10"

set yrange [0:*]
set autoscale y

set format y2 "%'.0f"
set y2label "\n Episodes per day" tc lt 0
set y2label offset -2,0 enhanced font "Arial,10"

set y2range [0:*]
set autoscale y2  

# set label 1 sprintf("Avg Ordisodes per Day=%'.0f",$mo_avg) at graph 0.02, 0.96, 0 left norotate back textcolor lt 3 nopoint offset character 0, 0, 0

# Finally... 
plot "$mo_name" using 1:10 with lines lt rgb "#4169E1" axes x1y1, "$mo_name" using 1:2 with lines lt rgb "#FFB6C1" axes x2y2;

EOF
