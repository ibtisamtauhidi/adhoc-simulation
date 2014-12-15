#!usr/local/bin/perl
#Calculation of delay for TCP or CBR packet

if(@ARGV ne 4)
{
	print STDERR "Usage: delay.pl <tracefile> <kind_of_packet>\n";
	exit;
}

$infile=$ARGV[0];
$kind=$ARGV[1];
$src=$ARGV[2];
$dest=$ARGV[3];

$total_delay=0;
$count=0;
%packet_array=();
%src_array=();
open(DATA,"<$infile") || die "Can't open $infile";

while(<DATA>){

	@x=split(' ');
	$id=$x[5];
	if($x[0] eq 's' && $x[2] eq $src){
		if($x[3] eq 'AGT' && $x[6] eq $kind)
		{
			#print STDOUT "I am in send\n";
			$packet_array{$id}=$x[1];
			$src_array{$id}=$x[2];
		}	
	}
	elsif($x[0] eq 'r' && $x[2] eq $dest && $src_array{$id} eq $src){
		 if($x[3] eq 'AGT' && $x[6] eq $kind)    
                {
			
                        $delay=$x[1]-$packet_array{$id};
			
			#if($count le 1000){
			#print STDOUT "delay in packet no. $id: $delay\n";
			#}
			$total_delay=$total_delay+$delay;
			$count++;
                }
	}
	#if($x[6] eq $kind && $x[3] eq 'AGT' ){
	#	if ($x[0] eq 's'){
	#		$packet_array{$id}=$x[1];
	#	}
	#	elsif ($x[0] eq 'r'){
	#		$delay=$x[1]-$packet_array{$id};
	#		$total_delay=$total_delay+$delay;
	#		$count=$count+1;
	#		print STDOUT "Delay: $delay\n";
	#	}
	#}
	
}
	$avg=$total_delay/$count;
	print STDOUT "Average delay in transmission of $kind packets was: $avg sec\n";
	close DATA;
	exit(0);

