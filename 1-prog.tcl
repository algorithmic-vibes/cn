# Create Simulator instance
set ns [new Simulator]

# Open trace and NAM output files
set ntrace [open prog1.tr w]
set namfile [open prog1.nam w]

# Define a procedure to finish the simulation
proc Finish {} {
    global ns ntrace namfile
    $ns flush-trace
    close $ntrace
    close $namfile

    # Open NAM for animation
    exec nam prog1.nam &
    
    # Show number of packet drops from trace file
    set num_drops [exec grep -c "^d" prog1.tr]
    puts "The number of packet drops is $num_drops"

    exit 0
}

# Enable tracing
$ns trace-all $ntrace
$ns namtrace-all $namfile

# Create three nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

# Optional: Label nodes
$n0 label "TCP Source"
$n2 label "Sink"

# Create links between nodes
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail

# Set link orientation (for NAM)
$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n2 orient right

# Set queue limits
$ns queue-limit $n0 $n1 10
$ns queue-limit $n1 $n2 10

# Setup transport layer
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n2 $sink0

$ns connect $tcp0 $sink0

# Setup application layer
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 100
$cbr0 set rate_ 1Mb
$cbr0 attach-agent $tcp0
$cbr0 set random_ false

# Schedule events
$ns at 0.0 "$cbr0 start"
$ns at 5.0 "Finish"

# Run the simulation
$ns run
