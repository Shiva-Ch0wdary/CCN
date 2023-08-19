BEGIN {
hpid = 0;
}

{
action = $1;
time = $2;
N1 = $3;
N2 = $4;
src = $5;
flow_id = $8;
N1_add = $9;
N2_add = $10;
seq_no = $11;
packetid = $12;

if ( packetid > hpid ) hpid = packetid;
if ( s_time[packetid] == 0 ) s_time[packetid] = time;
if ( action != "d" ) {
if ( action == "r" ) {
end_time[packetid] = time;
}
} else {
end_time[packetid] = -1;
}
}
END {
printf(" End to End Delay\n\n")
for ( packetid = 0; packetid <= hpid; packetid++ ) {
start = s_time[packetid];
end = end_time[packetid];
packet_dur = end - start;

if ( start < end ) 
printf(" Node: %d | Time: %f\n", start, packet_dur);
}
}
