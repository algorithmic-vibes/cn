# ========================================
# Simulation Parameters
# ========================================
set ns [new Simulator]

# Trace & NAM file setup
set tracefile [open out.tr w]
$ns trace-all $tracefile

set namfile [open out.nam w]
$ns namtrace-all $namfile

# ========================================
# Topology
# ========================================
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Links
$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.5Mb 40ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail

# ========================================
# Agents & Applications
# ========================================
# Ping Agent on n0
set ping0 [new Agent/Ping]
$ns attach-agent $n0 $ping0

# Ping Agent on n5
set ping5 [new Agent/Ping]
$ns attach-agent $n5 $ping5

# Connect ping agents
$ns connect $ping0 $ping5
$ns connect $ping5 $ping0

# Start Ping at different times
$ping0 set interval_ 1
$ping5 set interval_ 1.5

proc ping-reply {from rtt} {
    puts "node $from received ping answer with round trip time $rtt ms"
}

$ping0 set callback_ "ping-reply 0"
$ping5 set callback_ "ping-reply 5"

# ========================================
# Simulation End
# ========================================
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}

# ========================================
# Event Scheduling
# ========================================
$ns at 0.5 "$ping0 send"
$ns at 1.0 "$ping5 send"
$ns at 5.0 "finish"

# ========================================
# Run Simulation
# ========================================
$ns run
