# RNA_seq-shellScripting
# Processing raw count to  get  a gene count matrix 

Steps followed in the assignment-

1.	Checking the quality of reads-

 The quality of the reads was checked to determine  the sequence GC content, sequence base quality , to get  an idea of number of duplicated sequence   and amount of adapter sequence present in the read using FastQC. The output of his software is  in the form of graphs showing the above mentioned details.

2.Preprocessing data-

The following software were used in this step. The application of each software is described in the description below.

A.	Scythe- First of all the adapter are trimmed from the 3’ end of the sequence. This is done because the adapter attaches to the end of the DNA being sequenced. During sequencing , primer attaches to this upstream adapter sequences and sequencing start from the DNA portion. But there are chances of adapter being sequenced at the end of the read. This adapter sequence needs to be removed as further analysis would be affected if this step is skipped. Input is the adapter sequence and the sequenced read, further it should be mentioned if the sequence read was from illumina or sanger  or solexa to determine the offset score. 


B.	Sickle-In this step the quality of the read is checked. If the quality of the read is below a  certain threshold then those  reads are removed in this particular step. Input is the fastq file with quality same as the previous step set to sanger.
The minimum length of the read was set to be around 50.


2.	Alignment-  

 Hisat2 was used to align the sequences with the penalty being set as 4 and since it’s a      sanger sequencing phred33 is used. Further in the splice alignment option rna strandness reverse strand is set for the run. The input for hisat2 is the output of sickle and the output of hisat2 is .sam file.


3.	Sorting and converting to bam-

In this step samtools is used to convert the sam format to bam format and further for   sorting this bam format. For doing this we use samtools view and samtools sort. The output of this program is bam file, which is sorted, and this acts the input  for the next program that is Stringtie2.
The command used to for executing the above mentioned steps is as follows-
 

4.	Assembling  into possible transcript- 

  This is done using Stringtie tool. The Stringtie parameters used for this are -e  - B and  -G. -e is used to filter out only those transcripts which are similar to the reference transcript. - B gives the output in ballgown format. The output path of this file is printed out in a list to be used as input for prepDE.py

5.	Conversion of Stringtie output- PrepDE.py is used to convert the output of stringtie into gene_ count and Transcript_count. 

6.	Differential expression analysis in Deseq2- Deseq 2 object is created for both gene_ count and Transcript_count.
