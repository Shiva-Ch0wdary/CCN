# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(stop)   10.0                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]
$ns rtproto DV
#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile

#===================================
#        Nodes Definition        
#===================================
#Create 9 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes
$ns duplex-link $n0 $n1 10.0Mb 10ms DropTail
$ns queue-limit $n0 $n1 50
$ns duplex-link-op $n0 $n1 cost 2
$ns duplex-link-op $n0 $n1 label "cost=2"

$ns duplex-link $n1 $n2 10.0Mb 10ms DropTail
$ns duplex-link-op $n1 $n2 cost 3
$ns duplex-link-op $n1 $n2 label "cost=3"

$ns queue-limit $n1 $n2 50
$ns duplex-link $n1 $n4 10.0Mb 10ms DropTail
$ns duplex-link-op $n1 $n4 cost 4
$ns duplex-link-op $n1 $n4 label "cost=4"
$ns queue-limit $n1 $n4 50
$ns duplex-link $n2 $n5 10.0Mb 10ms DropTail
$ns queue-limit $n2 $n5 50
$ns duplex-link-op $n2 $n5 cost 1
$ns duplex-link-op $n2 $n5 label "cost=1"
$ns duplex-link $n4 $n5 10.0Mb 10ms DropTail
$ns queue-limit $n4 $n5 50
$ns duplex-link-op $n4 $n5 cost 3
$ns duplex-link-op $n4 $n5 label "cost=3"
$ns duplex-link $n3 $n4 10.0Mb 10ms DropTail
$ns queue-limit $n3 $n4 50
$ns duplex-link-op $n3 $n4 cost 5
$ns duplex-link-op $n3 $n4 label "cost=5"

$ns duplex-link $n0 $n3 10.0Mb 10ms DropTail
$ns queue-limit $n0 $n3 50
$ns duplex-link-op $n0 $n3 cost 2
$ns duplex-link-op $n0 $n3 label "cost=2"

$ns duplex-link $n3 $n6 10.0Mb 10ms DropTail
$ns queue-limit $n3 $n6 50
$ns duplex-link-op $n3 $n6 cost 5
$ns duplex-link-op $n3 $n6 label "cost=5"

$ns duplex-link $n6 $n7 10.0Mb 10ms DropTail
$ns queue-limit $n6 $n7 50
$ns duplex-link-op $n6 $n7 cost 8
$ns duplex-link-op $n6 $n7 label "cost=8"

$ns duplex-link $n4 $n7 10.0Mb 10ms DropTail
$ns queue-limit $n4 $n7 50
$ns duplex-link-op $n4 $n7 cost 2
$ns duplex-link-op $n4 $n7 label "cost=2"
$ns duplex-link $n7 $n8 10.0Mb 10ms DropTail
$ns queue-limit $n7 $n8 50
$ns duplex-link-op $n7 $n8 cost 1
$ns duplex-link-op $n7 $n8 label "cost=1"
$ns duplex-link $n5 $n8 10.0Mb 10ms DropTail
$ns queue-limit $n5 $n8 50
$ns duplex-link-op $n5 $n8 cost 2
$ns duplex-link-op $n5 $n8 label "cost=2"

#Give node position (for NAM)
$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n2 orient right

$ns duplex-link-op $n1 $n4 orient down
$ns duplex-link-op $n2 $n5 orient down
$ns duplex-link-op $n4 $n5 orient right
$ns duplex-link-op $n3 $n4 orient right
$ns duplex-link-op $n0 $n3 orient down
$ns duplex-link-op $n3 $n6 orient down
$ns duplex-link-op $n6 $n7 orient right
$ns duplex-link-op $n4 $n7 orient down
$ns duplex-link-op $n7 $n8 orient right

$ns duplex-link-op $n5 $n8 orient down

#===================================
#        Agents Definition        
#===================================
#Setup a TCP connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink1 [new Agent/TCPSink]
$ns attach-agent $n8 $sink1
$ns connect $tcp0 $sink1
$tcp0 set packetSize_ 1000


#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 0.5 "$ftp0 start"
$ns at 5.0 "$ftp0 stop"
$ns rtmodel-at 1 down $n1 $n2
$ns rtmodel-at 1.5 down $n1 $n4
$ns rtmodel-at 2 up $n1 $n4
$ns rtmodel-at 2.69 up $n1 $n2
$ns rtmodel-at 3 down $n5 $n8
$ns rtmodel-at 3.4 up $n5 $n8

#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exec awk -f throughput.awk out.tr &
    exec awk -f packet.awk out.tr &
    exec awk -f delay.awk out.tr &
    exit 0
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
