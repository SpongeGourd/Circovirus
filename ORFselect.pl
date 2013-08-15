#!/usr/bin/perl -w
#2013.8.15 
#by lina
#sort different ORFs according to their products
use strict;
use Bio::SeqIO;

my $usage="perl ORFselect.pl infile \n";
my $infile=shift or die $usage;
my $outfile_one=${[split /\./,$infile]}[0]."_cap.fasta";
my $outfile_two=${[split /\./,$infile]}[0]."_rep.fasta";
my $outfile_three=${[split /\./,$infile]}[0]."_other.fasta";

my $seqin=Bio::SeqIO -> new(-format => 'fasta', -file =>$infile);
my $seqout_cap=Bio::SeqIO -> new(-format => 'fasta', -file => '>'.$outfile_one);
my $seqout_rep=Bio::SeqIO -> new(-format => 'fasta', -file => '>'.$outfile_two);
my $seqout_other=Bio::SeqIO -> new(-format => 'fasta', -file => '>'.$outfile_three);

while(my $seq=$seqin->next_seq()) {
       
	my $display_id= $seq->display_id;
	my $desc= $seq->desc;

#$display_id is "gi|18693035|gb|CAD23544.1|or|2|st|-1|lo|1154-1906|gn|AJ301633|tx|Viruses;ssDNA"
#$desc is "viruses;Circoviridae;Circovirus| putative capsid protein [Porcine circovirus 2]"
       
	my $seq_obj=Bio::Seq->new( -seq=> $seq->seq,
                               -display_id=>$display_id,
                               -desc=>$desc);	

	if ($desc=~/viruses;Circoviridae;Circovirus\| (.*) \[.*/){
	my $product=$1;
		
		if($product=~/.*\bcap.*/i){
			$seqout_cap->write_seq($seq_obj); 
		}
		elsif($product=~/.*\brep.*/i){
			$seqout_rep->write_seq($seq_obj); 
		} 
		else{
			$seqout_other->write_seq($seq_obj);
		}
	}
}
