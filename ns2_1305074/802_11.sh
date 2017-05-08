cd /home/akib/NS2_Things/ns2_1305074
#		CHANGE PATH IN 4 PLACES *******************************************************

#INPUT: output file AND number of iterations
output_file_format="multi_radio_802_11_random";
iteration_float=5.0;

t="throughput";
d="delay";
dl="delivery";
dr="drop";
e="energy";
vs="_vs_"
tx=".txt";
n="node";
f="flow";
p="packet";
s="speed";

dir="/home/akib/NS2_Things/ns2_1305074/"
under="_"
var=4
graphFolder="./graphs/"
start=5
end=5

iteration=$(printf %.0f $iteration_float);

r=$start

while [ $r -le $end ]
do
echo "total iteration: $iteration"
###############################START A ROUND
j=1;
while [ $j -le $var ]
do
l=0;thr=0.0;del=0.0;s_packet=0.0;r_packet=0.0;d_packet=0.0;del_ratio=0.0;
dr_ratio=0.0;time=0.0;t_energy=0.0;energy_bit=0.0;energy_byte=0.0;energy_packet=0.0;total_retransmit=0.0;energy_efficiency=0.0;

i=1
while [ $i -le $iteration ]
do
#################START AN ITERATION
echo "                             EXECUTING $(($i)) th ITERATION"
case "$j" in
	1) num_node=$((20*$i));num_random_flow=20;num_packet=150;pckt_speed=10;;
	2) num_node=50;num_random_flow=$((10*$i));num_packet=150;pckt_speed=10;;
	3) num_node=50;num_random_flow=25;num_packet=$((100*$i));pckt_speed=10;;
	4) num_node=50;num_random_flow=25;num_packet=150;pckt_speed=$((5*$i));;
esac


#                            CHNG PATH		1		######################################################

ns 1305074_802_11_random.tcl $num_node $num_random_flow $num_packet $pckt_speed

echo "SIMULATION COMPLETE. BUILDING STAT......"
#awk -f rule_th_del_enr_tcp.awk 802_11_grid_tcp_with_energy_random_traffic.tr > math_model1.out
#                            CHNG PATH		2		######################################################
awk -f rule_wireless_udp.awk 802_11_random.tr > "$dir$output_file_format$under$i.out"

while read val
do
	l=$(($l+1))
	output_file="$dir$output_file_format$under$r.out"

	if [ "$l" == "1" ]; then
		thr=$(echo "scale=5; $thr+$val/$iteration_float" | bc)
		echo -ne "throughput: $val " >> $output_file
		case "$j" in
		1) echo "$num_node $val" >> "$graphFolder""throughput_vs_node.txt" ;;
		2) echo "$num_random_flow $val" >> "$graphFolder""throughput_vs_flow.txt" ;;
		3) echo "$num_packet $val" >> "$graphFolder""throughput_vs_packet.txt" ;;
		4) echo "$pckt_speed $val" >> "$graphFolder""throughput_vs_speed.txt" ;;
		esac
	elif [ "$l" == "2" ]; then
		del=$(echo "scale=5; $del+$val/$iteration_float" | bc)
		echo -ne "delay: $val" >> $output_file
		case "$j" in
		1) echo "$num_node $val" >> "$graphFolder""delay_vs_node.txt" ;;
		2) echo "$num_random_flow $val" >> "$graphFolder""delay_vs_flow.txt" ;;
		3) echo "$num_packet $val" >> "$graphFolder""delay_vs_packet.txt" ;;
		4) echo "$pckt_speed $val" >> "$graphFolder""delay_vs_speed.txt" ;;
		esac

	elif [ "$l" == "3" ]; then
		del_ratio=$(echo "scale=5; $del_ratio+$val/$iteration_float" | bc)
		echo -ne "delivery ratio: $val" >> $output_file
		case "$j" in
		1) echo "$num_node $val" >> "$graphFolder""delivery_vs_node.txt" ;;
		2) echo "$num_random_flow $val" >> "$graphFolder""delivery_vs_flow.txt" ;;
		3) echo "$num_packet $val" >> "$graphFolder""delivery_vs_packet.txt" ;;
		4) echo "$pckt_speed $val" >> "$graphFolder""delivery_vs_speed.txt" ;;
		esac

	elif [ "$l" == "4" ]; then
		dr_ratio=$(echo "scale=5; $dr_ratio+$val/$iteration_float" | bc)
		echo -ne "drop ratio: $val" >> $output_file
		case "$j" in
		1) echo "$num_node $val" >> "$graphFolder""drop_vs_node.txt" ;;
		2) echo "$num_random_flow $val" >> "$graphFolder""drop_vs_flow.txt" ;;
		3) echo "$num_packet $val" >> "$graphFolder""drop_vs_packet.txt" ;;
		4) echo "$pckt_speed $val" >> "$graphFolder""drop_vs_speed.txt" ;;
		esac

	elif [ "$l" == "5" ]; then
		t_energy=$(echo "scale=5; $t_energy+$val/$iteration_float" | bc)
		echo -ne "total_energy: $val" >> $output_file
		case "$j" in
		1) echo "$num_node $val" >> "$graphFolder""energy_vs_node.txt" ;;
		2) echo "$num_random_flow $val" >> "$graphFolder""energy_vs_flow.txt" ;;
		3) echo "$num_packet $val" >> "$graphFolder""energy_vs_packet.txt" ;;
		4) echo "$pckt_speed $val" >> "$graphFolder""energy_vs_speed.txt" ;;
		esac

	fi

#                            CHNG PATH		3		######################################################
done < "$out_dir$output_file_format$under$i.out"

i=$(($i+1))
l=0
#################END AN ITERATION
done

j=$(($j+1))
done
dir="/home/akib/NS2_Things/ns2_1305074/"
#under="_"

output_file="$dir$output_file_format$under$r$under$r.out"

echo -ne "Throughput:          $thr " >> $output_file
echo -ne "AverageDelay:         $del " >> $output_file
echo -ne "PacketDeliveryRatio:      $del_ratio " >> $output_file
echo -ne "PacketDropRatio:      $dr_ratio " >> $output_file
echo -ne "Total energy consumption:        $t_energy " >> $output_file

enr_nj=$(echo "scale=2; $energy_efficiency*1000000000.0" | bc)

#dir="/home/ubuntu/ns2\ programs/raw_data/"
#tdir="/home/ubuntu/ns2\ programs/multi-radio\ random\ topology/"
#                            CHNG PATH		4		######################################################
#dir="/home/akib/NS2_Things/ns2_1305074/"
#under="_"
#output_file="$dir$output_file_format$under$r$under$r.out"


r=$(($r+1))
#######################################END A ROUND
done

#######################################GRAPH PROJECTION

r=$start

echo "Select which graph you want to see......"
echo "Type:- x_y"
echo "x: 1->node 2->flow 3->packet 4->speed"
echo "y: 1->throughput 2->delay 3->delivery ratio 4->drop ratio 5->energy consumption"
echo "Type anything else to exit"
while [ $r -le $end ]
do
    read graph_choice
    case "$graph_choice" in
	1_1) xgraph "$graphFolder$t$vs$n$tx" -geometry 800x400;;
	1_2) xgraph "$graphFolder$d$vs$n$tx" -geometry 800x400;;
	1_3) xgraph "$graphFolder$dl$vs$n$tx" -geometry 800x400;;
	1_4) xgraph "$graphFolder$dr$vs$n$tx" -geometry 800x400;;
	1_5) xgraph "$graphFolder$e$vs$n$tx" -geometry 800x400;;
	2_1) xgraph "$graphFolder$t$vs$f$tx" -geometry 800x400;;
	2_2) xgraph "$graphFolder$d$vs$f$tx" -geometry 800x400;;
	2_3) xgraph "$graphFolder$dl$vs$f$tx" -geometry 800x400;;
	2_4) xgraph "$graphFolder$dr$vs$f$tx" -geometry 800x400;;
	2_5) xgraph "$graphFolder$e$vs$f$tx" -geometry 800x400;;		
	3_1) xgraph "$graphFolder$t$vs$p$tx" -geometry 800x400;;
	3_2) xgraph "$graphFolder$d$vs$p$tx" -geometry 800x400;;
	3_3) xgraph "$graphFolder$dl$vs$p$tx" -geometry 800x400;;
	3_4) xgraph "$graphFolder$dr$vs$p$tx" -geometry 800x400;;
	3_5) xgraph "$graphFolder$e$vs$p$tx" -geometry 800x400;;	
	4_1) xgraph "$graphFolder$t$vs$s$tx" -geometry 800x400;;
	4_2) xgraph "$graphFolder$d$vs$s$tx" -geometry 800x400;;
	4_3) xgraph "$graphFolder$dl$vs$s$tx" -geometry 800x400;;
	4_4) xgraph "$graphFolder$dr$vs$s$tx" -geometry 800x400;;
	4_5) xgraph "$graphFolder$e$vs$s$tx" -geometry 800x400;;
	*) r=$(($r+1));;
    esac
done
