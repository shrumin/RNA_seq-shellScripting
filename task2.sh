#! /bin/bash
#PBS -l nodes=1:ppn=4:centos6,cput=24:00:00,walltime=48:00:00 #PBS -N job_1
#PBS -d /export/home/biostuds/2498862s/tx2dm/nondiscovery
#PBS -m abe
#PBS -M 2498862S@student.gla.ac.uk
#PBS -q bioinf-stud
#
## RESOURCE FILES
adapter="/export/projects/polyomics/biostuds/data/illumina_adapter.fa"
hs2index="/export/projects/polyomics/Genome/Mus_musculus/mm10/Hisat2Index/chr2"
data="/export/home/biostuds/2498862s/assignment1/data/"
gtf="/export/projects/polyomics/Genome/Mus_musculus/mm10/annotations/chr2.gtf"

# MAKE FEW SUBDIRS UNLESS THEY EXIST
hisat_dir="/export/home/biostuds/2498862s/assignment1/hisat_dir"
 # path to directory for hisat2 results
 stringtie_dir="/export/home/biostuds/2498862s/assignment1/stringtie_dir"
sort="/export/home/biostuds/2498862s/assignment1/sort"
 # path to directory for stringtie results
 mkdir -p ${hisat_dir}
 # make above hisat2 directory
mkdir -p ${stringtie_dir}
mkdir -p ${sort}
# make above stringtie directory
gtflist=""
#RUNNING a single LOOP for all the work
for sample in s1.c2 s2.c2 s3.c2 s4.c2 s5.c2 s6.c2 s7.c2 s8.c2 s9.c2 s10.c2 s11.c2 s12.c2
 do
fastq="${data}/${sample}.fq" 
trim1="${sample}.t1.fq" 
trim2="${sample}.t2.fq" 
sam="${sample}.sam"
bam1="${sample}_b1"
bam="${sample}.bam"
gtf_output="${sample}_gtfout.gtf"
scythe -o ${trim1} -a ${adapter} -q sanger ${fastq}
sickle se -f ${trim1} -o ${trim2} -t sanger -q 10 -l 50
hisat2 -p 4 --rna-strandness R --phred33 -x ${hs2index} -U ${trim2} -S ${hisat_dir}/${sam}
samtools view -bS -o ${sort}/${bam} ${hisat_dir}/${sam}
samtools sort ${sort}/${bam} ${sort}/${bam1}
rm ${trim1} ${trim2}
strdir=("/export/home/biostuds/2498862s/assignment1"${sample})
mkdir -p $strdir
stringtie "${sort}/${bam1}.bam" -e -B -p 4 -G ${gtf} -o ${strdir}/${gtf_output} 
gtflist="${gtflist} ${strdir}/${gtf_output}"
done
echo $gtflist >>list.txt
python2.7 /export/projects/polyomics/App/prepDE.py -i list.txt 
done

