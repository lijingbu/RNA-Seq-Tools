#!/usr/bin/perl

my $usage = "single read mate";
my @inputParameters = split /\s+/, $usage;
$usage_warning = $0;    $usage_warning =~ s/.*\\//; $usage_warning =~ s/.*\///;
my $usage_warning = "\n Usage: $usage_warning <".(join "> <", @inputParameters).">\n
Example: $0 single_read1.fastq 1 single_read2.fastq\n";
unless ( $#inputParameters == $#ARGV )  { die $usage_warning };
for (my $para_counts=0;$para_counts<=$#inputParameters;$para_counts++){ ${$inputParameters[$para_counts]} = $ARGV[$para_counts];        }
##-------End of preparation.---------------------------------------------


my ($id, @ids, %seq);

my $materead = 3 - $read;

open in, "$single" or die "$single $!\n";
open out, ">$mate" or die "$mate $!\n";
while (my $line = <in>){
        chomp $line;
        if ($line =~ /(@\S+\/)$read$/){
                $id = $1;
                $mateid = $id.$materead;
                print out "$mateid\n";

                my $line2 = <in>; chomp $line2;
                $numN = "N" x length($line2);
                print out $numN."\n";

                my $line3 = <in>;
                chomp $line3;
                print out "$line3\n";

                my $line4 = <in>;
                chomp $line4;
                print out "$line4\n";

        }
}

close in;
close out;
