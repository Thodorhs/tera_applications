#!/usr/bin/env bash

###################################################
#
# file: myjstat.sh
#
# @Author:  Iacovos G. Kolokasis
# @Version: 27-02-2022
# @email:   kolokasis@ics.forth.gr
#
# @brief    This script calculate the
# serialziation/deserialization overhead
###################################################

# Output file name
OUTPUT=$1        
NUM_OF_EXECUTORS=$2

ASYNC_PROF="$(pwd)/../../util/async-profiler"

# Get the proccess id from the running
processId=""
numOfExecutors=0

while [ ${numOfExecutors} -lt "${NUM_OF_EXECUTORS}" ] 
do
    # Calculate number of executors running
    numOfExecutors=$(jps | grep -c "BenchmarkRunner")
done

# Executors
processId=$(jps |\
    grep "BenchmarkRunner" |\
    awk '{split($0,array," "); print array[1]}')

# Counter
i=0

for execId in ${processId}
do
	"${ASYNC_PROF}"/profiler.sh -d 40000 -f "${OUTPUT}" "${execId}" &

    i=$((i + 1))
done
