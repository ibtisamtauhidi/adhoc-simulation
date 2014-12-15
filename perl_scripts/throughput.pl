
$infile=$ARGV[0];
$frm=$ARGV[1];
$tonode=$ARGV[2];
$kind=$ARGV[3];
$granularity=$ARGV[4];

$sum=0;
$clock=0;
%packet_array=();
open (DATA,"<$infile")
	|| die "Can't open $infile $!";
while (<DATA>) {
	@x=split(' ');
	$id=$x[5];
	#print STDOUT "time=$x[7]\n";
	#if($x[1] ge 2 && $x[1] le 8){
	if($x[0] eq 's' && $x[2] eq $frm)
	{
		$packet_array{$id}=1;
	}
	if($x[1]-$clock<=$granularity)
	{
		if($x[0] eq 'r' && $packet_array{$id} eq '1')
		{
			if($x[3] eq 'AGT')
			{
				if($x[2] eq $tonode)
				{
					if($x[6] eq $kind)
					{
						#$sum=$sum+8*($x[7]-20);
						$sum=$sum+8*($x[7]-20);
					}
				}
			}
		}
	}
	else
	{
		$throughput=$sum/$granularity;
		$throughput=$throughput/1000;
		print STDOUT "time=$x[1] throughput=$throughput kbps\n";
		$clock=$clock+$granularity;
		$sum=0;
	}
	#}
 }
	$throughput=$sum/$granularity;
	$throughput=$throughput/1000;

		print STDOUT "time=$x[1] throughput=$throughput kbps\n";

		$clock=$clock+$granularity;
		$sum=0;
	close DATA;
	exit(0);


