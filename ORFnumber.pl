#! /usr/bin/perl -w
##lina 2013.9.
##calculate the ORF numbers

use Bio::SeqIO;
use strict;

my $input = shift @ARGV;
my $output = shift @ARGV;

my $in = Bio::SeqIO ->new (-file => $input, -format => "Genbank");
open OUT, ">$output";
print OUT "ACC\tname\tlength\tORF_number\tORFs\n";

while (my $seq = $in ->next_seq() ){
	my $acc = $seq ->accession_number;
	my $name = $seq ->species->node_name;
	my $length = $seq ->length;

	print OUT $acc."\t".$name."\t".$length."\t";

	my $ORF_number=0;
	my @ORFs;

	for my $feature ($seq->top_SeqFeatures){
		if ($feature->primary_tag eq "CDS") {                                    
			my $start = $feature->location->start;
			my $end = $feature->location->end;
			$ORF_number++;
			my $orf= $start."_".$end;
			push @ORFs, $orf;
		}
	}

	my $detail = join "\t", @ORFs;
	print OUT $ORF_number."\t".$detail."\n";
}
close OUT;
