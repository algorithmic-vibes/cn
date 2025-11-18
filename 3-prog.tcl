# Create Simulator
set ns [new Simulator]

# Colors for NAM
$ns color 1 Red
$ns color 2 Blue

# NAM and Trace Files
set na [open lab3.nam w]
$ns namtrace-all $na

set nt [open lab3.tr w]
$ns trace-all $nt

# TCP congestion window trace files
set ng1 [open tcp1.xg w]
set ng2 [open tcp2.xg w]

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Create LANs
$ns make-lan "$n0 $n1 $n2" 1Mb 10ms LL Queue/DropTail Mac/802_3
$ns make-lan "$n3 $n4 $n5" 2Mb 10ms LL Queue/DropTail Mac/802_3

# Connect the two LANs
$ns duplex-link $n0 $n3 1Mb 10ms DropTail

# TCP Agents
set tcp1 [new Agent/TCP]
$tcp1 set fid_ 1

set tcp2 [new Agent/TCP]
$tcp2 set fid_ 2

# CBR Traffic sources
set cbr1 [new Application/Traffic/CBR]
set cbr2 [new Application/Traffic/CBR]

# Attach TCP to nodes
$ns attach-agent $n4 $tcp1
$cbr1 attach-agent $tcp1

$ns attach-agent $n1 $tcp2
$cbr2 attach-agent $tcp2

# TCP Sinks
set sink1 [new Agent/TCPSink]
set sink2 [new Agent/TCPSink]

# Attach sinks to nodes
$ns attach-agent $n2 $sink1
$ns attach-agent $n5 $sink2

# Establish connections
$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2

# Procedure to end simulation
proc finish {} {
    global ns na nt
    $ns flush-trace
    close $na
    close $nt
    exec nam lab3.nam &
    exec xgraph tcp1.xg tcp2.xg &
    exit 0
}

# Procedure to log congestion window
proc Draw {Agent File} {
    global ns
    set cwnd [$Agent set cwnd_]
    set time [$ns now]
    puts $File "$time $cwnd"
    $ns at [expr $time + 0.01] "Draw $Agent $File"
}

# Start traffic and cwnd plotting
$ns at 0.0 "$cbr1 start"
$ns at 0.7 "$cbr2 start"

$ns at 0.0 "Draw $tcp1 $ng1"
$ns at 0.0 "Draw $tcp2 $ng2"

$ns at 10.0 "finish"

# Run simulation
$ns run
