#!/bin/bash          
PATH_TO_DATA_INTEGRATION=
PATH_TO_LOGS=

function run
{
		JOB=$1
		DEBUG_LEVEL=$2
		LOG_NAME=$3
		GENERATION_DATE=$4
		NOW=$(date -u +%Y-%0m-%0d:%H:%M:%S)
		LOG="${PATH_TO_LOGS}${NOW}_${LOG_NAME}.log"

		cd $PATH_TO_DATA_INTEGRATION
		if [[ $JOB =~ \.kjb$ ]]; then
			echo -e "-> Running ETL process $JOB for day $GENERATION_DATE at $NOW" > $LOG
			cmd="./kitchen.sh -file=$JOB -level=$DEBUG_LEVEL >> $LOG"
		else
			echo -e "-> Running ETL transformation $JOB for day $GENERATION_DATE at $NOW" > $LOG
			cmd="./pan.sh -file=$JOB -level=$DEBUG_LEVEL  >> $LOG"
		fi

		case  $?  in

	    0) echo  "-> The job ran without a problem. \n " >> $LOG ;;
	    1) echo  "-> Errors occurred during processing \n " >> $LOG ;;
	    2) echo  "-> An unexpected error occurred during loading / running of the job \n " >> $LOG ;;
	    7) echo  "-> The job couldn't be loaded from XML or the Repository \n " >> $LOG ;;
	    8) echo  "-> Error loading steps or plugins (error in loading one of the plugins mostly) \n " >> $LOG ;;
	    9) echo  "-> Command line usage printing \n " >> $LOG ;;
	    *) echo  "-> Unknown error code: $?" >> $LOG ;;

		esac 
}

JOB=$1
DEBUG_LEVEL=${2:-'Debug'}
LOG_NAME=${3:-$(basename $JOB)}

if [! -f $1 ];
	echo"\033[31m Error!!!! the ETL process don't exist please check the path"
else
	run ${LOAD_FILE} ${LOG_LEVEL}
	getPid;
fi