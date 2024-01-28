#!/bin/bash

# Filename: run_dd.sh
# run without cache (clear cache)
#./run_dd.sh ../sqw/STO_300K_35meV.sqw 10M 50 50 n
# run without cache (do not clear cache)
#./run_dd.sh ../sqw/STO_300K_35meV.sqw 10M 50 50 n

# Check if the correct number of arguments is passed
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 filename blocksize seek count with_cache(y/n)"
    exit 1
fi

# Assign arguments to variables
filename=$1
blocksize=$2
seek=$3
count=$4
with_cache=$5

# Clear cache if requested
if [ "$with_cache" = "n" ]; then
    echo "Clearing cache..."
    sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
fi

# Execute the dd command
echo "Running dd command..."
dd status=progress if="$filename" of=/dev/null bs="$blocksize" seek="$seek" count="$count"
