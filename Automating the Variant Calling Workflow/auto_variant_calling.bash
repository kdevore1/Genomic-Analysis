# Automating the Variant Calling Workflow
#
# The purpose of this script is to process 6 FASTQ files (2 for each base name) such that it:
# 	(1) Aligns paired-end FASTQ data against a reference genome to produce SAM files
# 	(2) Sorts the SAM files
# 	(3) Generates pileup data from the SAM files
# 	(4) Detects single-nucleotide variants from the pileups
# 	(5) Filters single nucleotide variants to produce high-quality VCF files
#
# 
# References used: https://datacarpentry.org/wrangling-genomics/04-variant_calling/index.html
# --------------------------------------------------------------------------------------------
# Exits script if error occurs
set -e

# Loading necessary modules
module add bcftools/1.12.0
module add samtools/1.12.0
module add bwa/0.7.17


# Indexing the reference genome
echo "Indexing reference genome..."
bwa index ~/dc_workshop/data/ref_genome/ecoli_rel606.fasta


# Align reads to reference genome
echo "Aligning to reference genome..."
bwa mem ~/dc_workshop/data/ref_genome/ecoli_rel606.fasta ~/dc_workshop/data/trimmed_fastq_small/SRR2584863_1.trim.sub.fastq\
 ~/dc_workshop/data/trimmed_fastq_small/SRR2584863_2.trim.sub.fastq\
 > ~/dc_workshop/results/sam/SRR2584863.aligned.sam

bwa mem ~/dc_workshop/data/ref_genome/ecoli_rel606.fasta ~/dc_workshop/data/trimmed_fastq_small/SRR2584866_1.trim.sub.fastq\
 ~/dc_workshop/data/trimmed_fastq_small/SRR2584866_2.trim.sub.fastq\
 > ~/dc_workshop/results/sam/SRR2584866.aligned.sam

bwa mem ~/dc_workshop/data/ref_genome/ecoli_rel606.fasta ~/dc_workshop/data/trimmed_fastq_small/SRR2589044_1.trim.sub.fastq\
 ~/dc_workshop/data/trimmed_fastq_small/SRR2589044_2.trim.sub.fastq\
 > ~/dc_workshop/results/sam/SRR2589044.aligned.sam


# BAM file creation (Converts SAM file input (-S) to BAM file output (-b))
echo "BAM file creation..."
samtools view -S -b ~/dc_workshop/results/sam/SRR2584863.aligned.sam > ~/dc_workshop/results/bam/SRR2584863.aligned.bam
samtools view -S -b ~/dc_workshop/results/sam/SRR2584866.aligned.sam > ~/dc_workshop/results/bam/SRR2584866.aligned.bam
samtools view -S -b ~/dc_workshop/results/sam/SRR2589044.aligned.sam > ~/dc_workshop/results/bam/SRR2589044.aligned.bam


# Sort BAM file by coordinates (-o indicates output)
echo "Sorting BAM files..."
samtools sort -o ~/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam ~/dc_workshop/results/bam/SRR2584863.aligned.bam
samtools sort -o ~/dc_workshop/results/bam/SRR2584866.aligned.sorted.bam ~/dc_workshop/results/bam/SRR2584866.aligned.bam
samtools sort -o ~/dc_workshop/results/bam/SRR2589044.aligned.sorted.bam ~/dc_workshop/results/bam/SRR2589044.aligned.bam


# Variant calling: pileup data production (-O b generates a bcf output file, -o specifies the output path, and -f indicates the reference genome path)
echo "Calculating read coverage of positions in the genome..."
bcftools mpileup -O b -o ~/dc_workshop/results/vcf/SRR2584863_raw.bcf -f ~/dc_workshop/data/ref_genome/ecoli_rel606.fasta ~/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
bcftools mpileup -O b -o ~/dc_workshop/results/vcf/SRR2584866_raw.bcf -f ~/dc_workshop/data/ref_genome/ecoli_rel606.fasta ~/dc_workshop/results/bam/SRR2584866.aligned.sorted.bam
bcftools mpileup -O b -o ~/dc_workshop/results/vcf/SRR2589044_raw.bcf -f ~/dc_workshop/data/ref_genome/ecoli_rel606.fasta ~/dc_workshop/results/bam/SRR2589044.aligned.sorted.bam


# Variant calling: Detecting SNVs (--ploidy 1 indicates a haploid genome, -m indicates multiallelic and rare calling, -v indicates to output the variants, -o indicates output path)
echo "Detecting SNVs..."
bcftools call --ploidy 1 -m -v -o ~/dc_workshop/results/vcf/SRR2584863_variants.vcf ~/dc_workshop/results/vcf/SRR2584863_raw.bcf 
bcftools call --ploidy 1 -m -v -o ~/dc_workshop/results/vcf/SRR2584866_variants.vcf ~/dc_workshop/results/vcf/SRR2584866_raw.bcf 
bcftools call --ploidy 1 -m -v -o ~/dc_workshop/results/vcf/SRR2589044_variants.vcf ~/dc_workshop/results/vcf/SRR2589044_raw.bcf 


# Variant calling: Filter and report the SNV variants
echo "Filtering / reporting the SNV variants..."
vcfutils.pl varFilter ~/dc_workshop/results/vcf/SRR2584863_variants.vcf  > ~/dc_workshop/results/vcf/SRR2584863_final_variants.vcf
vcfutils.pl varFilter ~/dc_workshop/results/vcf/SRR2584866_variants.vcf  > ~/dc_workshop/results/vcf/SRR2584866_final_variants.vcf
vcfutils.pl varFilter ~/dc_workshop/results/vcf/SRR2589044_variants.vcf  > ~/dc_workshop/results/vcf/SRR2589044_final_variants.vcf

echo "Done!"
