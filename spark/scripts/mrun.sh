#!/bin/bash
#server hosting block device
hostname="sith6"
#username of user in cluster
user="thodp"
#interface used for transmiting-receiving data
interface="ens10d1"
#directory of results where teraheap is running
res="/spare/thodp/res/ssspresultNBD"
#cluster home directory of user 
home="/home1/public/thodp"

rm -rf "$res"/*
rm -rf "$home/resultNBD"

output=$(ethtool -S $interface)

ssh "$user"@"$hostname" "mpstat 1 > $home/tempssh.txt" &
sleep 1
mpstat_pid_ssh=$(ssh "$user"@"$hostname" pgrep -o mpstat)

rx_bytes=$(echo "$output" | grep -oE 'rx_bytes: [0-9]+' | awk '{print $2}')
tx_bytes=$(echo "$output" | grep -oE 'tx_bytes: [0-9]+' | awk '{print $2}')

STARTTIME=$(date +%s)
./run.sh -n 1 -o "$res/" -t
ENDTIME=$(date +%s)

output2=$(ethtool -S $interface)
ELAPSEDTIME=$(($ENDTIME - $STARTTIME))

rx_bytes2=$(echo "$output2" | grep -oE 'rx_bytes: [0-9]+' | awk '{print $2}')
tx_bytes2=$(echo "$output2" | grep -oE 'tx_bytes: [0-9]+' | awk '{print $2}')

total_rx_bytes=$((rx_bytes2-rx_bytes))
total_tx_bytes=$((tx_bytes2-tx_bytes))

total_bytes=$((total_rx_bytes+total_tx_bytes))

tx_throughput=$((total_tx_bytes / ELAPSEDTIME / 1048576))
rx_throughput=$((total_rx_bytes / ELAPSEDTIME / 1048576))
total_throughput=$((total_bytes / ELAPSEDTIME / 1048576))

ssh "$user"@"$hostname" "kill $mpstat_pid_ssh"
head -n -2 "$home/tempssh.txt" | awk 'BEGIN{OFS=";"} NR>3 && !/^Average:/ {print $3,$4,$5,$6,$7,$8,$9,$10,$11,$12}' > "$res/cpu_utilssh.txt"
truncate -s 0 "$home/tempssh.txt"
python3 calculate_averages.py "$res/cpu_utilssh.txt" "$res/cpu_avgssh.txt"

mkdir "$res/net_stats/"

echo "$tx_throughput" >> "$res/net_stats/tx_throughput.txt"
echo "$rx_throughput" >> "$res/net_stats/rx_throughput.txt"
echo "$total_throughput" >> "$res/net_stats/throughput.txt"

cp -R "$res" "$home/"

