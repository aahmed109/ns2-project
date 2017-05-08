################################################################802.15.4 in Grid topology with random flow

################################################################command line input check start
if { $argc !=4 } {
	puts "Invalid Parameter!"
	puts "Format: ns <tclFileName> <#nodes> <#flows> <#packets/sec> <speed of nodes m/sec>"
	puts "Example: 1305074_802_15_4_random.tcl 40 40 300 25"
	exit 0;
}
################################################################command line input check end

################################################################set changable variables start

set cbr_type CBR
set num_node [lindex $argv 0]

set cbr_pckt_per_sec [lindex $argv 2]
set node_speed [lindex $argv 3]
set cbr_size 28 ;
set cbr_rate 0.256Mb

set cbr_interval [expr 1.0/$cbr_pckt_per_sec] ;

set num_row [lindex $argv 0] ;#number of row
set num_col [lindex $argv 0] ;#number of column
set x_dim 500 ; 
set y_dim 500 ; 
set time_duration 25 ;
set start_time 2 ;#50
set parallel_start_gap 0.1s
set cross_start_gap 0.2s

################################################################set changable variables end

#############################################################ENERGY PARAMETERS
set val(energymodel_11)    EnergyModel     ;
set val(initialenergy_11)  1000            ;# Initial energy in Joules

set val(idlepower_11) 869.4e-3			;#LEAP (802.11g) 
set val(rxpower_11) 1560.6e-3			;#LEAP (802.11g)
set val(txpower_11) 1679.4e-3			;#LEAP (802.11g)
set val(sleeppower_11) 37.8e-3			;#LEAP (802.11g)
set val(transitionpower_11) 176.695e-3		;#LEAP (802.11g)	??????????????????????????????/
set val(transitiontime_11) 2.36			;#LEAP (802.11g)

#set val(idlepower_11) 900e-3			;#Stargate (802.11b) 
#set val(rxpower_11) 925e-3			;#Stargate (802.11b)
#set val(txpower_11) 1425e-3			;#Stargate (802.11b)
#set val(sleeppower_11) 300e-3			;#Stargate (802.11b)
#set val(transitionpower_11) 200e-3		;#Stargate (802.11b)	??????????????????????????????/
#set val(transitiontime_11) 3			;#Stargate (802.11b)

#puts "$MAC/802_11.dataRate_"
#Mac/802_11 set dataRate_ 11Mb

#CHNG
set num_random_flow [lindex $argv 1]

set extra_time 10 ;#10

#set tcp_src Agent/TCP/Vegas ;# Agent/TCP or Agent/TCP/Reno or Agent/TCP/Newreno or Agent/TCP/FullTcp/Sack or Agent/TCP/Vegas
#set tcp_sink Agent/TCPSink ;# Agent/TCPSink or Agent/TCPSink/Sack1

set tcp_src Agent/UDP
set tcp_sink Agent/Null

# TAHOE:	Agent/TCP		Agent/TCPSink
# RENO:		Agent/TCP/Reno		Agent/TCPSink
# NEWRENO:	Agent/TCP/Newreno	Agent/TCPSink
# SACK: 	Agent/TCP/FullTcp/Sack	Agent/TCPSink/Sack1
# VEGAS:	Agent/TCP/Vegas		Agent/TCPSink
# FACK:		Agent/TCP/Fack		Agent/TCPSink
# LINUX:	Agent/TCP/Linux		Agent/TCPSink

#	http://research.cens.ucla.edu/people/estrin/resources/conferences/2007may-Stathopoulos-Lukac-Dual_Radio.pdf

#set frequency_ 2.461e+9
#Phy/WirelessPhy set Rb_ 11*1e6            ;# Bandwidth
#Phy/WirelessPhy set freq_ $frequency_



set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model

set val(netif) Phy/WirelessPhy/802_15_4 ;# network interface type
#set val(mac) Mac/802_11 ;# MAC type
set val(mac) Mac/802_15_4 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 50 ;# max packet in ifq
set val(rp) DSDV ; # [lindex $argv 4] ;# routing protocol
#set val(x) 670 ; # X dimension of the topography
#set val(y) 670 ; # Y dimension of the topography
set val(nn) $num_node ; # number of mobilenodes
set val(energymodel) EnergyModel;
set val(initialenergy) 100;

#Mac/802_11 set syncFlag_ 1

#Mac/802_11 set dutyCycle_ cbr_interval

set nm multi_radio_802_15_4_random.nam
set tr /home/akib/NS2_Things/ns2_1305074/802_15_4_random.tr
set topo_file topo_multi_radio_802_15_4_random.txt

#set topo_file 5.txt
# 
# Initialize ns
#
set ns_ [new Simulator]

set tracefd [open $tr w]
$ns_ trace-all $tracefd

#$ns_ use-newtrace ;# use the new wireless trace file format

set namtrace [open $nm w]
$ns_ namtrace-all-wireless $namtrace $x_dim $y_dim

#set topofilename "topo_ex3.txt"
set topofile [open $topo_file "w"]

set dist(5m)  7.69113e-06
set dist(9m)  2.37381e-06
set dist(10m) 1.92278e-06
set dist(11m) 1.58908e-06
set dist(12m) 1.33527e-06
set dist(13m) 1.13774e-06
set dist(14m) 9.81011e-07
set dist(15m) 8.54570e-07
set dist(16m) 7.51087e-07
set dist(20m) 4.80696e-07
set dist(25m) 3.07645e-07
set dist(30m) 2.13643e-07
set dist(35m) 1.56962e-07
set dist(40m) 1.20174e-07
Phy/WirelessPhy set CSThresh_ $dist(40m)
Phy/WirelessPhy set RXThresh_ $dist(40m)

# set up topography object
set topo       [new Topography]
$topo load_flatgrid $x_dim $y_dim

create-god $val(nn)

#remove-all-packet-headers
#add-packet-header DSDV AODV ARP LL MAC CBR IP



#set val(prop)		Propagation/TwoRayGround
#set prop	[new $val(prop)]

$ns_ node-config -adhocRouting $val(rp) -llType $val(ll) \
	     -macType $val(mac)  -ifqType $val(ifq) \
	     -ifqLen $val(ifqlen) -antType $val(ant) \
	     -propType $val(prop) -phyType $val(netif) \
	     -channel  [new $val(chan)] -topoInstance $topo \
	     -agentTrace ON -routerTrace OFF\
	     -macTrace ON \
	     -movementTrace OFF \
             -energyModel $val(energymodel) \
             -initialEnergy $val(initialenergy) \
             -rxPower 35.28e-3 \
             -txPower 31.32e-3 \
	     -idlePower 712e-6 \
	     -sleepPower 144e-9
 

puts "start node creation"

for {set i 0} {$i < $num_node } { incr i} {
	set node_($i) [$ns_ node]
	$node_($i) random-motion 0 ; # may need change

	set x_pos [expr int($x_dim*rand())] ;#random settings
	if { $x_pos == 0 } {
		incr $x_pos
	}
	set y_pos [expr int($y_dim*rand())] ;#random settings
	if { $y_pos == 0 } {
		incr $y_pos
	}
	
	$node_($i) set X_ $x_pos;
	$node_($i) set Y_ $y_pos;
	$node_($i) set Z_ 0.0

	puts -nonewline $topofile "$i x: [$node_($i) set X_] y: [$node_($i) set Y_] \n"
}

for {set i 0} {$i < $val(nn)  } { incr i} {
	$ns_ initial_node_pos $node_($i) 4
}

#create random movements for mobilenodes start
for {set i 0} {$i < $num_node } {incr i} {
	set dest_x [expr int($x_dim*rand()+0.25) % int($x_dim-50)]

	if { $dest_x == 0 } {
		incr $dest_x
	}
	set dest_y [expr int($y_dim*rand()+0.25) % int($y_dim-50)]

	if { $dest_y == 0 } {
		incr $dest_y
	}
	$ns_ at $start_time "$node_($i) setdest $dest_x $dest_y $node_speed"
}

for {set i 0} {$i < $num_node} {incr i} {
    set udp_($i) [new Agent/UDP]
    set null_($i) [new Agent/Null]
} 


#create random movements for mobilenodes end
puts "node creation complete"

#######################################################################RANDOM FLOW

for {set i 0} {$i <  $num_random_flow} {incr i} { 

	set udp_($i) [new $tcp_src]
	$udp_($i) set class_ $i #may need change
	set null_($i) [new $tcp_sink]
	$udp_($i) set fid_ $i
	if { [expr $i%2] == 0} {
		$ns_ color $i Blue
	} else {
		$ns_ color $i Red
	}

} 

set rt 0

for {set i 1} {$i < [expr $num_random_flow+1]} {incr i} {
	set udp_node [expr int($num_node*rand())] ;# src node
	set null_node $udp_node
	while {$null_node==$udp_node} {
		set null_node [expr int($num_node*rand())] ;# dest node
	}
	$ns_ attach-agent $node_($udp_node) $udp_($rt)
  	$ns_ attach-agent $node_($null_node) $null_($rt)
	puts -nonewline $topofile "RANDOM:  Src: $udp_node Dest: $null_node\n"
	incr rt
} 

set rt 0
for {set i 1} {$i < [expr $num_random_flow+1]} {incr i} {
	$ns_ connect $udp_($rt) $null_($rt)
	incr rt
}
set rt 0
for {set i 1} {$i < [expr $num_random_flow+1]} {incr i} {
	set cbr_($rt) [new Application/Traffic/CBR]
	$cbr_($rt) set packetSize_ $cbr_size
	$cbr_($rt) set rate_ $cbr_rate
	$cbr_($rt) set interval_ $cbr_interval
	$cbr_($rt) attach-agent $udp_($rt)
	incr rt
} 

set rt 0
for {set i 1} {$i < [expr $num_random_flow+1]} {incr i} {
	$ns_ at [expr $start_time] "$cbr_($rt) start"
	incr rt
}

puts "flow creation complete"
##########################################################################END OF FLOW GENERATION

# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at [expr $start_time+$time_duration] "$node_($i) reset";
}

$ns_ at [expr $start_time+$time_duration +$extra_time] "finish"

$ns_ at [expr $start_time+$time_duration +$extra_time] "$ns_ nam-end-wireless [$ns_ now]; puts \"NS Exiting...\"; $ns_ halt"

$ns_ at [expr $start_time+$time_duration/2] "puts \"half of the simulation is finished\""
$ns_ at [expr $start_time+$time_duration] "puts \"end of simulation duration\""

proc finish {} {
	puts "finishing"
	global ns_ tracefd namtrace topofile nm	
	#global ns_ topofile
	$ns_ flush-trace
	close $tracefd
	close $namtrace
	close $topofile
        #exec xgraph $tr &
        exit 0
}


puts "Starting Simulation..."
$ns_ run 
#$ns_ nam-end-wireless [$ns_ now]

