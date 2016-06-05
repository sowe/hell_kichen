#!/bin/bash

set -e
set -u

KETTLE_HOME="";
KETTLE_JNDI_ROOT='';
TIMER='';
DEBUGLEVEL='';
LOGNAME='';
KETTLE_PAT='';
KETTLE_LOG='';
JOB='';
ENVIRONMENT='';

function _console(){
    local message=${1:-''}
    [[ -n "$message" ]] && echo -e "$message"
}


function _die(){
    local message=${1:-''}
    local exit_code=${2:-0}
    _console "$message"
    exit $exit_code
}

##
# Set a environment the kettele.properties 
# JDBC files
#
function setEnvironment
{
    local environment=${1:-$HOME'/.kettle'}
	_console 'environment'

	export KETTLE_HOME=$environment
	export KETTLE_JNDI_ROOT=$KETTLE_HOME
}

##
# This function include the time
#
function timer(){
	export TIMER = 'time';
}   


function setKettleHome(){

    local kettle_home=${1:-''}
	export KETTLE_HOME=$kettle_home
}

function setKettleJndiRoot(){

    local kettle_jndi=${1:-''}
	export KETTLE_JNDI_ROOT=$kettle_jndi
}


function setPath
{
    local kettle_path=${1:-''}
    local kettle_log=${2:-''}
    _console "<<<<" + $KETTLE_HOME
    if [ ! -f "$KETTLE_HOME/hellkitchen.properties" ]; then
        echo "kettle_path=/foler_with_pdi/" >> ${KETTLE_HOME}/hellkitchen.properties;
        echo "kettle_log=/tmp/logs/" >> ${KETTLE_HOME}/hellkitchen.properties;
        _die "You need define the pdi/kettle path and log" 12
    fi

    source "$KETTLE_HOME/hellkitchen.properties";

    _console "Parameters PDI:" $kettle_path "and LOGS" $kettle_log

}

function help(){
cat <<EOF
    Usage: hells_kitchen.sh <[options]>
    Options:
        -t = time (Optional)
        -j = job file (ktr or kjb)
        -l = bug level in pdi:
             Error: Only show errors
             Nothing: Don't show any output
             Minimal: Only use minimal logging
             Basic: This is the default basic logging level (Default)
             Detailed: Give detailed logging output
             Debug: For debugging purposes, very detailed output.
             Rowlevel: Logging at a row level, this can generate a lot of data.
        -n = Name of log
        -e = dynamic envairoment (please see the secction enviaroment) (Optional)
        -p = path of pdi (Optinal)
        -ln= path of log folder (Optinal)
        -x = extra parameter in JSON file (is mandatory pass to etl like paremeter)(Optinal)
EOF
_die    
}

function run(){
    local timer=${1:-''}
    local job=${2:-''}
    local debug_level=${3:-'Basic'}
    local log_name=${4:-''}
    local kettle_path=${5:-''}
    local kettle_log=${6:-''}
    local enviaroment=${7:-''}
    local now=$(date -u +%Y%0m%0d%H%M%S)
    local log="${kettle_log}${LOG_NAME}_${NOW}.log"

    ##
    # ::if don't exit the job ::
    #
    if [ !-e $job ]; then
       _die "Error!!!! the ETL process don't exist please check the path" 4
    fi

    ##
    # :: Engineer ::
    #
    if [[ $job =~ \.kjb$ ]]; then
       cmd="./kitchen.sh -file=$job -level=$debug_level  >> $kettle_log"
    else
       cmd="./pan.sh -file=$job -level=$debug_level  >> $kettle_log"
    fi
    _console "Executing: $cmd"


    sleep 1
    eval $cmd 2>>$log
    case  $?  in
       0) _console "The job ran without a problem." >>$log ;;
       1) _console "Errors occurred during processing" >>$log ;;
       2) _console "An unexpected error occurred during loading / running of the job" >>$log ;;
       7) _console "The job couldn't be loaded from XML or the Repository" >>$log ;;
       8) _console "Error loading steps or plugins (error in loading one of the plugins mostly)" >>$log ;;
       9) _console "Command line usage printing" >>$log ;;
       *) _console "Unknown error code: $?" >>$log ;;
    esac 
}

##
# ::main::
#
while getopts ":t:j:l:e:p:ln:h:n" opts; do
      case ${opts} in
            t)  TIMER=${OPTARG};;
            j)  JOB=${OPTARG} ;;
            l)  DEBUGLEVEL=${OPTARG};;
            e)  setEnvironment ${OPTARG};;
            p)  setKettleHome=${OPTARG};;
            ln) setKettleJndiRoot=${OPTARG};;
            h)  help;;
      esac
 done


setEnvironment
setPath

##
# ::launcher::
#
run $TIMER $JOB $DEBUGLEVEL $logNAME $KETTLE_PAT $KETTLE_LOG $ENVIRONMENT