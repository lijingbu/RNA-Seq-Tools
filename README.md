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


```
pseudoFastqMate.pl single_read1.fastq 1 single_read2.fastq
```
Where the __single_read2.fastq__ is the pseudo mate reads of __single_read1.fastq__. 
Then you can add single_read1.fastq and single_read2.fastq to your pair end reads correspondingly. 
Most of the mapping programs will ignore the poly Ns in the read sequences. 
You analysis on these sequences will include all the pair and single reads information and appear as paired end sequences.
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
