#!/bin/bash
# dont forget to set chmod 755 to the script in order to be able to run it

SECONDS=0

# navigate to working directory
cd /mnt/c/Users/angel/Desktop/Bash_workflows/RNAseq_pipeline

# Step 1: FastQC (quality control)
  fastqc data/demo.fastq -o data/

# Step 2: Trimmomatic (trimming)
  java -jar /mnt/c/Users/angel/apps/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 4 data/demo.fastq data/demo_trimmed.fastq TRAILING:10 -phred33 
  echo "Trimmomatic finished running."

  fastqc data/demo_trimmed.fastq -0 data/ 

# Step 3: HISAT2 (alignment to genome)
# mkdir HISAT2
# get the genome indiced
# wget https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz

# run alignment
  hisat2 -q --rna-strandness R -x HISAT2/grch38/genome -U data/demo_trimmed.fastq | samtools sort -o HISAT2/demo_trimmed.bam
  echo "HISAT2 finished running."

# Step 4: featureCounts 
# get the genome annotation file
# wget https://ftp.ensembl.org/pub/release-109/gtf/homo_sapiens/Homo_sapiens.GRCh38.109.gtf.gz

 featureCounts -S 2 -a Homo_sapiens.GRCh38.109.gtf -o quants/demo_featurecounts.txt HISAT2/demo_trimmed.bam
 echo "featureCounts finished running."

# check counts for each gene id
#cd quants
#cat demo_featurecounts.txt| cut -f1,7 | less








duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed"