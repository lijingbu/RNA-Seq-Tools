# RNA-Seq-Tools

## A solution to merge paired and single end reads
One big issue of RNASeq analysis is to deal with both paired and single end reads that passed trimming/filtering QC step. Most of the mapping/counting programs won't deal both at the same time. Ignoring those single reads and only use the paired reads is a easy way to deal with the situation. But it risk losing useful information in the single reads. The __pseudo mate reads__ may be able to trick the program as if they were all paired end reads.
Simply generate pseudo mate reads using the same length of Ns, and the same scores.
Add these pseudo reads to the paired end reads accordingly, you will get paired end reads and 
previousely single reads in one file. Most of the mapping programs will ignore the poly Ns in the read sequences. 
Your analysis on these sequences will include all the pair and single reads information and appear as paired end sequences.


This tool **pseudoFastqMate.pl** will create pseudo mate reads for given single read fastq.
Pseudo mate read will be generated using Ns only. Each has the same read length as its mate read.
The read quality score is also copied from its single read mate.

### Warning
If your sequences looks like 
<pre>
@NIKITA:1008:C3E8HACXX:2:2208:19186:36716 1:N::0:GTGGCC
CATTAATGCAACAAAGTTTATCGTG  
+
@?@DDDDD?>CFHBC>FBIHA?AA:  
@NIKITA:1008:C3E8HACXX:2:2211:8302:63655 1:N::0:GTGGCC  
GTCATCTATGCAAAACATTTTTTTTCNT  
+
CC@FFFFDDHGDDFHGEGGGIJIIE9#0  
@NIKITA:1008:C3E8HACXX:2:2114:2632:58265 1:N::0:GTGGCC
CTGCCCTTTAATTTTTTTTTTTGGTG  
</pre>

Please use command 
```
sed -i.bak 's/ 1:N.*/\/1/' single_1.fastq
sed -i.bak 's/ 2:N.*/\/2/' single_2.fastq
```

to conver the reads to the following format

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

## Example
We have 4 files: paired_1.fastq, paired_2.fastq, single_1.fastq, single_2.fastq, merge to 2 files: new_paired_1.fastq and new_paired_2.fastq
```
pseudoFastqMate.pl single_1.fastq 1 pseudo_mate_2.fastq
pseudoFastqMate.pl single_2.fastq 2 pseudo_mate_1.fastq

cat paired_1.fastq single_1.fastq pseudo_mate_1.fastq > new_paired_1.fastq
cat paired_2.fastq pseudo_mate_2.fastq single_2.fastq > new_paired_2.fastq
```
Then you get new paired reads contain sequences of the same order:   
*  the original paired reads 
*  the single read 1 
*  the single read 2 

for both forward reads and reverse reads. 

The number __1__ indicates the input file is read 1. The pseudo mate sequence header will have /2 added to the end.
When use __2__, it assumes the input file is read 2. The pseudo mate sequence header will have /1 added to the end.



### Example single read:
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
### Generated pseudo mate reads:
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

### The Ns will not affect the mapping nor the reads counting
```
NIKITA:1008:C3E8HACXX:2:2316:6604:36112 77      *       0       0       *       *       0       0       NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN       ++1=BD;:2A+CBEFEHDHCEB?CE991?9?FHGD6D:FG9DHII       YT:Z:UP YF:Z:NS
NIKITA:1008:C3E8HACXX:2:2316:6604:36112 141     *       0       0       *       *       0       0       GACACTGCAAAGATTTCATTTGGGGATTAGGAATACAGGGAGTACAATG       ++1=BD;:2A+CBEFEHDHCEB?CE991?9?FHGD6D:FG9DHII       YT:Z:UP
NIKITA:1008:C3E8HACXX:2:2316:8084:36031 77      *       0       0       *       *       0       0       NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN        ?=?D??8BDF7FD?CCFGBCHEH2AFGG@9:)?FH9?DGCFH@B;=        YT:Z:UP YF:Z:NS
NIKITA:1008:C3E8HACXX:2:2316:8084:36031 141     *       0       0       *       *       0       0       TACAACACAACCTGCTCAAATCACATTGGACGAACAATGGAACGAGTG        ?=?D??8BDF7FD?CCFGBCHEH2AFGG@9:)?FH9?DGCFH@B;=        YT:Z:UP
NIKITA:1008:C3E8HACXX:2:2316:12311:36074        77      *       0       0       *       *       0       0       NNNNNNNNNNNNNNNNNNNNNNNNNNNN    BB8+4ADBFH3?AGGIF:C3A+A+):    YT:Z:UP YF:Z:NS
NIKITA:1008:C3E8HACXX:2:2316:12311:36074        141     *       0       0       *       *       0       0       CAACCATCCCTAGTCAGAACACCAACCC    BB8+4ADBFH3?AGGIF:C3A+A+):    YT:Z:UP
```
