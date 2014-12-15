set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)           Queue/DropTail/PriQueue    ;# interface queue type
#set val(ifq)            CMUPriQueue    		   ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             12                         ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol
set val(x)              500                        ;# X dimension of topography
set val(y)              400                        ;# Y dimension of topography
set val(stop)           150                        ;# time of simulation end

set ns          [new Simulator]
set tracefd       [open sun.tr w]
set windowVsTime2 [open win.tr w]
set namtrace      [open sun.nam w]

set xcord(0) 90
set xcord(1) 90
set xcord(2) 410
set xcord(3) 410

set xcord(4) 250
set xcord(5) 250
set xcord(6) 130
set xcord(7) 370
set xcord(8) 250

set xcord(9) 1
set xcord(10) 1
set xcord(11) 499

set ycord(0) 90
set ycord(1) 310
set ycord(2) 90
set ycord(3) 310

set ycord(4) 130
set ycord(5) 270
set ycord(6) 200
set ycord(7) 200
set ycord(8) 200

set ycord(9) 1
set ycord(10) 399
set ycord(11) 200

$ns color 1 Blue
$ns color 2 Red

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

$ns node-config \
     -adhocRouting $val(rp) \
     -llType $val(ll) \
     -macType $val(mac) \
     -ifqType $val(ifq) \
     -ifqLen $val(ifqlen) \
     -antType $val(ant) \
     -propType $val(prop) \
     -phyType $val(netif) \
     -channelType $val(chan) \
     -topoInstance $topo \
     -agentTrace ON \
     -routerTrace ON \
     -macTrace OFF \
     -movementTrace ON

    for {set i 0} {$i < $val(nn) } { incr i } {
        set node_($i) [$ns node]
        $node_($i) set X_ $xcord($i)
        $node_($i) set Y_ $ycord($i)
        $node_($i) set Z_ 0.0
    }
    
$ns at 0 "$node_(9) setdest 499 1 25"
$ns at 0 "$node_(10) setdest 499 399 25"
$ns at 25 "$node_(9) setdest 1 1 25"
$ns at 25 "$node_(10) setdest 1 399 25"
$ns at 50 "$node_(9) setdest 499 1 25"
$ns at 50 "$node_(10) setdest 499 399 25"
$ns at 75 "$node_(9) setdest 1 1 25"
$ns at 75 "$node_(10) setdest 1 399 25"

$ns at 0 "$node_(5) setdest 130 200 3"
$ns at 0 "$node_(6) setdest 250 130 3"
$ns at 0 "$node_(4) setdest 370 200 3"
$ns at 0 "$node_(7) setdest 250 270 3"

$ns at 50 "$node_(5) setdest 250 130 3"
$ns at 50 "$node_(6) setdest 370 200 3"
$ns at 50 "$node_(4) setdest 250 270 3"
$ns at 50 "$node_(7) setdest 130 200 3"

$ns at 0 "$node_(11) setdest 499 399 25"
$ns at 10 "$node_(11) setdest 499 200 25"
$ns at 25 "$node_(11) setdest 499 1 25"
$ns at 35 "$node_(11) setdest 499 200 25"

$ns at 50 "$node_(11) setdest 499 399 25"
$ns at 60 "$node_(11) setdest 499 200 25"
$ns at 75 "$node_(11) setdest 499 1 25"
$ns at 85 "$node_(11) setdest 499 200 25"

$ns at 100 "$node_(11) setdest 499 399 25"
$ns at 110 "$node_(11) setdest 499 200 25"
$ns at 125 "$node_(11) setdest 499 1 25"
$ns at 135 "$node_(11) setdest 499 200 25"

$ns at 100 "$node_(0) setdest 90 310 25"
$ns at 100 "$node_(1) setdest 410 310 25"
$ns at 100 "$node_(2) setdest 90 90 25"
$ns at 100 "$node_(3) setdest 410 90 25"

$ns at 125 "$node_(0) setdest 410 310 25"
$ns at 125 "$node_(1) setdest 410 90 25"
$ns at 125 "$node_(2) setdest 90 310 25"
$ns at 125 "$node_(3) setdest 90 90 25"


set tcp0 [new Agent/TCP/Newreno]
$tcp0 set class_ 2
set sink [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp0
$ns attach-agent $node_(11) $sink
$ns connect $tcp0 $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp0
$ns at 0.1 "$ftp start"

set tcp1 [new Agent/TCP/Vegas]
$tcp1 set class_ 1
set sink [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp1
$ns attach-agent $node_(11) $sink
$ns connect $tcp1 $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp1
$ns at 0.1 "$ftp start"

proc plotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file"
}

$ns at 0.15 "plotWindow $tcp0 $windowVsTime2"

for {set i 0} {$i < $val(nn)} { incr i } {
	$ns initial_node_pos $node_($i) 30
}

for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}


$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 150 "puts \"end simulation\" ; $ns halt"
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
}

$ns run
