#!/usr/bin/env perl 
use utf8;

my $home = $ENV{"HOME"};

my $history;
$history = '/.bash_history' if($ENV{"SHELL"} eq "/bin/bash");

open(HISTORY,$home.$history) or die "can't open history file: ".$!;
my @history_string = <HISTORY>;
close(HISTORY);

my $num_string = scalar @history_string;
my %utils=();

foreach my $line (@history_string)
{
	if($line =~ /(.*?)\s+.*/gm)
	{
		add($1);
		if($1 eq "sudo")
		{
			if( $line =~ /sudo\s+(.*?)\s+.*/)
			{
				add($1);
				$num_string++;
			}
		}
	}
}

foreach(keys %utils)
{
	$utils{$_} = (($utils{$_}/$num_string)*100)
}

foreach my $value (sort { $utils{$b} <=> $utils{$a} } keys %utils)
{
	printf "%s : %.2f%\n",$value,$utils{$value};
}

sub add
{
	my $command = shift;
	$utils{$command}=0 if(!$utils{$command});
	$utils{$command}++;
}
