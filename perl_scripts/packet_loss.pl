#!/usr/bin/perl
# Total No. of packets transmitted
# Total no. of packets dropped
# Average packet loss rate

$infile=$ARGV[0];
#$fromnode=$ARGV[1];
#$tonode=$ARGV[2];
$kind=$ARGV[1];

$num_packt=0;
$drop_packt=0;
$recv_packt=0;
$bits_transmitted=0;
	open(DATA,"<$infile") || die ("Can't open the file $infile");
	#print STDOUT "Hello $_";
	print STDOUT "*************TRACE ANALYZER*****************\n\n";
	while(<DATA>){
		@x=split(' ');
		#if($x[0] eq 's')
		#{
		#	if($x[] )
		#}
		
			if($x[0] eq 's')
			{
				if($x[3] eq 'AGT' && $x[6] eq $kind){
				$send_packt++;
				$bits_transmitted+=8*$x[7];
				}
			}
			elsif($x[0] eq 'r'){
				if($x[3] eq 'AGT' && $x[6] eq $kind){
				$recv_packt++;
				}
			}
			elsif($x[0] eq 'D')
			{
				
				$drop_packt++;	
				
			}
			
		
	
	}
	$loss=$send_packt-$recv_packt;
	$per_loss=100*$loss/$send_packt;
	$bits_transmitted=$bits_transmitted/1024;
	print STDOUT "No. of packets transmitted: $send_packt\n";
	print STDOUT "No. of packets received: $recv_packt\n";
	print STDOUT "No. of packets lost: $loss\n";
	print STDOUT "No. of packets dropped: $drop_packt\n";
	print STDOUT "Loss percentage : $per_loss %\n";
	print STDOUT "Amount of data transmitted : $bits_transmitted Kb \n";
	close DATA;
	exit 0;



