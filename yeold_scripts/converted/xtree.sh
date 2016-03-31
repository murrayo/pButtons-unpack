#!/bin/sh

# @(#) xtree - simple xtree like utility for rs/6000

Program=`basename $0`
trap 'echo "$Program aborted"; exit 2' 1 2 3 15

Usage="					\n
xtree [ -f  <directory_name> ] [ -d <directory_name> ]	\n
\t-d = dirctory only list		\n
\t-f = file level list			\n
\t use full path for directory with -d flag \n
\t may use partial path for directory with -f flag if used with -d\n
\n
\t Always specify -f flag prior to -d flag  if both used \n
"

errexit() {
        echo "Usage: $*" >&2
        exit 1
}


# F U N C T I O N S

files_list() {

	echo "\nXtree FILE LEVEL list of : $FDIR \n\n"

        find $FDIR -print | \
        awk -F/ ' {
                        for ( i = 1 ; i < (NF - 1) ; i++ ) {
                                printf "\t"
                        }

                        printf "  :.... "
                        printf "%s", $NF
			# system( "what " $0 "&2>/dev/null" ) | getline
			printf "\n" 
			
                }'

} # end files_list    


directory_list() {

	echo "\nXtree list of : $DIR \n\n"

 	find $DIR -type d -print | \
	awk -F/ ' BEGIN { "basename '$FDIR'" | getline FILES }

	 	$0 !~ /SLM$/ {
			if ( FILES != "" && $NF == FILES ) {
				system("xtree -f " $0)
				next
			}

			for ( i = 1 ; i < (NF - 1) ; i++ ) {
				printf "\t"
			}
			
			printf "  Á---- " 
			printf "%s\n", $NF
		}'

} # end directory_list
			 


			


# M A I N L I N E

	DIR="/u/murray"			# Default directory

	set -- `getopt f:d: $*`
	if [ $? != 0 ]
	then
		errexit $Usage
	fi

	while [ $1 != -- ]
	do
        	case $1 in
                -f)
			FDIR=$2
			function="files_list"
			shift; shift;;
                -d)
			DIR=$2
			function="directory_list"
			shift; shift;;
        	esac
	done
	shift


        [ -z "$function" ] && errexit $Usage
        eval $function


