open(file2,"Barcode.txt");
@a1=<file2>;
chomp @a1;
close(file2);

open(file3,"Name.txt");
@a2=<file3>;
chomp @a2;
close(file3);

print "Select file :\t";
$IP_file=<>;
chomp $IP_file;
open(STDLOG,"$IP_file");
my $previous;

for($j=0;$j<scalar(@a2);$j++)											#For multiple output files.
{
	$file1="xyz".$j;
	open($file1, '>', "@a2[$j].txt") or die "Could not open file $!";
}

$start_run = time();

while (my $current = <STDLOG>)
{
	for($i=0;$i<scalar(@a1);$i++)
	{
		$file1="xyz".$i;
		if($current =~ m/^@a1[$i]/)
		{		
			$current =~ s/@a1[$i]//;									#substitute barcode from read line.
			$length=length(@a1[$i]);
			$plus=scalar<STDLOG>;										#store 1st line after pattern match.
			$QS=scalar<STDLOG>;											#store 2ndt line after pattern match.
			$header = @a1[$i]."_".$previous;							#concatenate barcode and header.
			$QS1 = substr( $QS, 0, $length );
			$QS =~ s/$QS1//;											#trim quality score of barcode.
			print $file1 "@".@a2[$i]."_".$header.$current,$plus,$QS;
		}
	}
		$previous = $current;
}	

my $end_run = time();
my $run_time = $end_run - $start_run;
print "Job took $run_time seconds\n";

for($j=0;$j<scalar(@a2);$j++)
{
	$file1="xyz".$j;
	close $file1;
}	
close(STDLOG);