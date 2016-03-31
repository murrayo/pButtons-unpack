iostat and sar -d are separate due to manual entry device names and possible variable formats etc

Tested with pButtons May 2012 on Red Hat 6.3

All scripts needed should be inside this .zip file

Usage:
Usage_text="Usage: $0 -d directory [-s -S SAR_disk_list -t sar_start_time_string] [-i -I IOSTAT_disk_list [-l Header line_no]] [-a -I IOSTAT_disk_list] \n\tselect one or more of -d directory_to_work_on -[s]ar, -[i]ostat. -[a]ix_iostat"

Select one or more of  -[s]ar, -[i]ostat

-l iostat Header line number - in Red Hat 5 is line 4, in Red Hat 6 is line 3, ie -l4 or -l3

SAR_disk_list and IOSTAT_disk_list are plain text files with lists of device names you are interested in.
Example, ziostat_in_HKBH.txt:
hdisk0
hdisk1
hdisk2
hdisk3
hdisk4
hdisk5

Example:
./do_io_start_here.sh -d ../plot_example -a -I ziostat_in_HKBH.txt

Example HPUX sar -d
./do_io_start_here.sh -d ../ZCust/DoH/test -p -S ./zsar_in_DoH.txt


Input file is simply pButtuons .html file, put all html files in a sub-directory of folder with scripts
Example above, html files are in ./data

Output will be:
.txt 				-- Complete iostat or sar -d listing from pButtons
.txt.clean.csv 		-- Extracted lines for each device in *_disk_list.txt file
					-- This .csv is the input file for graph, and can be opened in xls
.txt.header.txt		-- Just the header line 

./png_i				-- sub-directory with iostat graphs
./png_s				-- sub-directory with sar -d graphs					


For sar similar (not used in plot_example)
./do_io_start_here.sh -d ../ufh*/20130506 -s -S zsar_in_UFH.txt -t 00:01:00 -i -I ziostat_in_UFH.txt


======
Example pButtons html - may help if you need to debug 
NOTE THE START TIME IN pButtons to pass as a parameter to sar unpack
-t sar_start_time_string

Eg: sar -d STARTS WITH A TIME "00:01:00" in column 1, THIS IS USED AS COLUMN HEADING IN SCRIPT:

	@fieldlist=("00:01:00","DEV","tps","rd_sec/s","wr_sec/s","avgrq-sz","avgqu-sz","await","svctm","%util");
	


</pre><p align="right"><a href="#Topofpage">Back to top</a></p>
<hr size="4" noshade><br>
<b><font face="Arial, Helvetica, sans-serif" size="4" color="#0000FF"><div id=iostat></div>iostat</font></b><br><pre>
Linux 2.6.32-279.el6.x86_64 (UFHTRAK2013A.ufh.com) 	05/08/13 	_x86_64_	(32 CPU)
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.07    0.00    0.37    0.16    0.00   98.40
Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.09     1.49    0.34    1.12    17.17    20.88    25.97     0.00    0.79   0.38   0.06
sdb               0.00     0.00    0.00    0.00     0.01     0.00     7.86     0.00    0.44   0.39   0.00
sdd               0.00     0.00    0.00    0.00     0.01     0.00     7.77     0.00    0.50   0.50   0.00
sdf               0.00     0.00    0.00    0.00     0.01     0.00     7.86     0.00    0.42   0.41   0.00
sdc 
:
:
:
VxVM9000          0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
VxVM26000         0.00     0.00    0.00    0.20     0.00     1.20     6.00     0.00    0.00   0.00   0.00
VxVM23000         0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
VxVM8000          0.00     0.00    0.60    1.00    22.40    22.90    28.31     0.00    0.56   0.56   0.09
</pre><p align="right"><a href="#Topofpage">Back to top</a></p>
<hr size="4" noshade><br>
<b><font face="Arial, Helvetica, sans-serif" size="4" color="#0000FF"><div id=sar-d></div>sar -d</font></b><br><pre>
Linux 2.6.32-279.el6.x86_64 (UFHTRAK2013A.ufh.com) 	05/08/13 	_x86_64_	(32 CPU)
00:01:00          DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
00:01:10       dev8-0      1.91     15.28     28.94     23.16      0.01      2.68      2.68      0.51
00:01:10      dev8-16      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
00:01:10      dev8-48      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
00:01:10      dev8-80      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
00:01:10
:
:
:
Average:    dev199-9000     72.55   9083.44    175.76    127.62      0.04      0.49      0.36      2.62
Average:    dev199-26000     40.30    398.54    965.59     33.85      0.45     11.18      0.55      2.21
Average:    dev199-23000      0.02      0.13      0.00      8.00      0.00      0.44      0.43      0.00
Average:    dev199-8000      4.59    175.19    255.56     93.91      0.00      0.51      0.49      0.23
</pre><p align="right"><a href="#Topofpage">Back to top</a></p>
<hr size="4" noshade>
<p><font face="Arial, Helvetica, sans-serif" size="4" color="#0000FF"><b>End of Cach¨¦ Performance Data Report</b></font>
</p>
</body>
</html>









