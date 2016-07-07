# RNA-Seq-Tools

## A solution to merge paired and single end reads
One big issue of RNASeq analysis is to deal with both paired and single end reads. 
Most of the programs won't deal both at the same time. 
The __pseudo mate reads__ may be able to trick the program as if they were all paired end reads.
Simply generate pseudo mate reads using the same length of Ns, and the same scores.
Add these pseudo reads to the paired end reads accordingly, you will get paired end reads and 
previousely single reads in one file. 


This tool **pseudoFastqMate.pl** will create pseudo mate reads for given single read fastq.
Each pseudo mate reads have the same length of poly Ns and the same quality score of the given single read mate.

E.g. I have paired_1.fastq, paired_2.fastq, single_1.fastq, single_2.fastq
```
pseudoFastqMate.pl single_1.fastq 1 pseudo_mate_2.fastq
pseudoFastqMate.pl single_2.fastq 2 pseudo_mate_1.fastq

cat paired_1.fastq single_1.fastq pseudo_mate_1.fastq > new_paired_1.fastq
cat paired_2.fastq pseudo_mate_2.fastq single_2.fastq > new_paired_2.fastq
```
Then you get new paired reads contain sequences of the same order. 

The number __1__ indicates the input file is read 1. The pseudo mate sequence header will have /1 added to the end.
When use __2__, it assumes the input file is read 2. The pseudo mate sequence header will have /2 added to the end.


Most of the mapping programs will ignore the poly Ns in the read sequences. 
Your analysis on these sequences will include all the pair and single reads information and appear as paired end sequences.
Enjoy. 

###Example single read:
<pre>
@NIKITA:1008:C3E8HACXX:2:2208:19186:36716/1  
CATTAATGCAACAAAGTTTATCGTG  
+
@?@DDDDD?>CFHBC>FBIHA?AA:  
@NIKITA:1008:C3E8HACXX:2:2211:8302:63655/1  
GTCATCTATGCAAAACATTTTTTTTCNT  
+
CC@FFFFDDHGDDFHGEGGGIJIIE9#0  
@NIKITA:1008:C3E8HACXX:2:2114:2632:58265/1  
CTGCCCTTTAATTTTTTTTTTTGGTG  
</pre>
###Generated pseudo mate reads:
<pre>
@NIKITA:1008:C3E8HACXX:2:2208:19186:36716/2
NNNNNNNNNNNNNNNNNNNNNNNNN
+
@?@DDDDD?>CFHBC>FBIHA?AA:
@NIKITA:1008:C3E8HACXX:2:2211:8302:63655/2
NNNNNNNNNNNNNNNNNNNNNNNNNNNN
+
CC@FFFFDDHGDDFHGEGGGIJIIE9#0
@NIKITA:1008:C3E8HACXX:2:2114:2632:58265/2
NNNNNNNNNNNNNNNNNNNNNNNNNN
</pre>
