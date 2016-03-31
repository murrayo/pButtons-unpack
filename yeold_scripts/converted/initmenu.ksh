#!/bin/ksh

#
# @(#) Menu - call programs depending on menu selections
#
# Sundata, Brisbane, Australia
#


#-- Program variables and one time only processing

LNS1="\n"
LNS2="\n\n"
LNS3="\n\n\n"
LNS4="\n\n\n\n"
LNS5="\n\n\n\n\n"

SPC1=" "
SPC2="  "
SPC3="   "
SPC4="    "
SPC5="     "
SPC6="      "
SPC7="       "
SPC8="        "
SPC9="         "
SPC10="          "
SPC11="           "
SPC12="            "
SPC13="             "
SPC14="              "
SPC15="               "
SPC16="                "
SPC17="                 "
SPC18="                  "
SPC19="                   "
SPC20="                    "
SPC21="                     "
SPC22="                      "
SPC23="                       "
SPC24="                        "
SPC25="                         "
SPC26="                          "
SPC27="                           "
SPC28="                            "
SPC29="                             "
SPC30="                              "
SPC76="${SPC20}${SPC20}${SPC20}${SPC16}"


YES=0           #  Yes
NO=1            #  No

UPALEVEL=96     #  Up a level in terms of menus
EXMENU=99       #  Forced exit from menu system
NOMENU=98       #  No menu at all i.e. natural exit from menu system
TPMENU=100      #  Top menu


BOLD="`tput smso 2> /dev/null`"         #  Start standout mode
NORM="`tput rmso 2> /dev/null`"         #  End standout mode

UP="`tput cuu1 2> /dev/null`"           #  Cursor up one line

CLS="`tput clear 2> /dev/null`"         #  Clear screen
CLL="`tput el 2> /dev/null`"            #  Clear line

if [ -z "${CLS}" ]                      #  If TERM is unusual or tput
then                                    #  does not exist, then use 3
        CLS="${LNS3}"                   #  blank lines (25 is a bit silly
fi                                      #  - try it and see).

if [ -z "${CLL}" ]                      #  If TERM is unusual or tput
then                                    #  does not exist, then use spaces.
        CLL="${SPC76}${UP}${SPC4}"
fi


BADINST="A serious problem has occurred - call your administrator"

BIGKO="\nMenu has terminated abnormally\n\
Please contact the System administrator\n"

CHOICE="${SPC4}Enter choice   --->   \c"

INVCHOICE1="${BOLD} Invalid choice: \c"
INVCHOICE2=" - please re-enter ${NORM}${CLL}"

EXIT="${CLL}${SPC4}Exit Menu (y/n) ? --->   \c"


clearscreen()
{
        echo "${CLS}\c"

} # clearscreen()


pressreturn()
{
        echo "${PRESSCR}"
        read carriagereturn

} # pressreturn()


centrestring()
{
        headersize=`echo "$1" | wc -c`
        termcols=`tput cols`
        marginsize=`expr $termcols - $headersize`
        leftmarginsize=`expr $marginsize / 2`
        case $leftmarginsize in

                0)      spacestring=""
                        ;;
                1)      spacestring="${SPC1}"
                        ;;
                2)      spacestring="${SPC2}"
                        ;;
                3)      spacestring="${SPC3}"
                        ;;
                4)      spacestring="${SPC4}"
                        ;;
                5)      spacestring="${SPC5}"
                        ;;
                6)      spacestring="${SPC6}"
                        ;;
                7)      spacestring="${SPC7}"
                        ;;
                8)      spacestring="${SPC8}"
                        ;;
                9)      spacestring="${SPC9}"
                        ;;
                10)     spacestring="${SPC10}"
                        ;;
                11)     spacestring="${SPC11}"
                        ;;
                12)     spacestring="${SPC12}"
                        ;;
                13)     spacestring="${SPC13}"
                        ;;
                14)     spacestring="${SPC14}"
                        ;;
                15)     spacestring="${SPC15}"
                        ;;
                16)     spacestring="${SPC16}"
                        ;;
                17)     spacestring="${SPC17}"
                        ;;
                18)     spacestring="${SPC18}"
                        ;;
                19)     spacestring="${SPC19}"
                        ;;
                20)     spacestring="${SPC20}"
                        ;;
                21)     spacestring="${SPC21}"
                        ;;
                22)     spacestring="${SPC22}"
                        ;;
                23)     spacestring="${SPC23}"
                        ;;
                24)     spacestring="${SPC24}"
                        ;;
                25)     spacestring="${SPC25}"
                        ;;
                26)     spacestring="${SPC26}"
                        ;;
                27)     spacestring="${SPC27}"
                        ;;
                28)     spacestring="${SPC28}"
                        ;;
                29)     spacestring="${SPC29}"
                        ;;
                *)      spacestring="${SPC30}"
                        ;;
        esac

} # centrestring()


#-- Screen headings etc


centrestring " Bells Transport - Main Menu"

CHANGEHERE=""

MAINMENU="${spacestring}\
${BOLD} \
Bells Transport - Main Menu\
 ${NORM}\
${LNS3}${SPC4}1  -  Practice \
${LNS1}${SPC4}2  -  Word Processing \
${LNS1}${SPC4}3  -  Mail \
${LNS1}${SPC4}4  -  Transport System \
${LNS1}${SPC4}5  -  Menu option 5 \
${LNS1}${SPC4}e  -  Exit\
${LNS5}"


centrestring " Please try again "

PLSTRYAGN="${spacestring}\
${BOLD} \
Please try again\
 ${NORM}"                                           


#-- standard functions

getvalidans()
{

        valopts=$*

        echo "${QUESTION}"
        read ans


        valid=${NO}


        while [ $valid -eq ${NO} ]
        do
                for param in $valopts
                do
                        if [ "X$ans" = "X$param" ]
                        then
                                valid=${YES}
                        fi
                done
                if [ $valid -eq ${NO} ]
                then
                        echo "\n${SPC4}${INVCHOICE1}\c"
                        echo "${ans}\c"
                        echo "${INVCHOICE2}\c"
                        echo "${UP}${UP}${UP}\n${CLL}${QUESTION}"
                        read ans
                fi
        done


        case "$ans" in

           "Y"|"y")
                return ${YES}
                ;;
           "N"|"n")
                return ${NO}
                ;;
           "E"|"e")
                return ${EXMENU}
                ;;
           *)
                return $ans
                ;;
        esac

} # getvalidans()


confirmexit()
{
        echo
        QUESTION="${EXIT}"
        getvalidans Y N y n
        return $?

} # confirmexit()


terminate()
{
        if [ $exitontrap -eq ${YES} ]
        then
                echo "\n${BIGKO}"
                exit 1
        fi

} # terminate()


doexit()
{
        clearscreen
        echo "\nExiting Menu at user's request."
        exit 0

} # doexit()


#-- Main menu


showmenu()
{
        menu=${TPMENU}
        while [ $menu -eq ${TPMENU} ]
        do
		CURRDIR=`pwd`
                displaymainmenu
                answermainmenu
                menu=$?
		cd $CURRDIR
        done

} # showmenu()



answermainmenu()
{

        QUESTION="${CHOICE}"
        getvalidans 1 2 3 4 5 E e
        answer=$?

	CHANGEHERE=""

        case "$answer" in

           "1")
			cd /u/practice
			foxplus acct
                        return ${TPMENU}
                ;;
           "2")
		        cd /u/wp51
			wpbin/wp
                        return ${TPMENU}
                ;;
           "3")

		        mail
			sleep 3
                        return ${TPMENU}

                ;;
           "4")
			cd /u/acct
		        foxplus acct
                        return ${TPMENU}
                ;;
           "5")
		        echo "Option 5 taken"
			sleep 3
                        return ${TPMENU}
                ;;
           "${EXMENU}")
                confirmexit
                if [ $? -eq ${YES} ]
                then
                        doexit
                else
                        return ${TPMENU}
                fi
                ;;
            *)
                echo "${BADINST}"
                exit 999
                ;;
        esac

} # answermainmenu()


displaymainmenu()
{
        clearscreen
        echo "${MAINMENU}"

} # displaymainmenu()



#----------------------------------------------------------------------------
# MAINLINE 
#----------------------------------------------------------------------------


#-- trap all errors

        exitontrap=${YES}
        trap terminate 1 2 3 9 15 16 17


#-- Display main menu


	showmenu



#-- end program




