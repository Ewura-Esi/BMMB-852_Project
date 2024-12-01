
# -------------------------------SET VARIABLES----------------------------

# Directory for the genome
GENOME_DIR = genome

# URL for the Reference genome
URL = "https://ftp.ensembl.org/pub/release-113/fasta/saccharomyces_cerevisiae/dna/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz"

# name of the file
FILE = "Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz"

# Genome file
GENOME = genome/"genome.fa"

# SRR number for the reads
SRR = SRR10242889

# The name of the sample
SAMPLE= Samplen183

# Number of reads to download
N = 100000

# Directories for reads and reports
RDIR = reads
RPDIR = reports

# Filenames for the reads
RD1 = reads/${SRR}_1.fastq
RD2 = reads/${SRR}_2.fastq

# Filenames for the trimmed reads
T1 = reads/${SRR}_1.trimmed.fastq
T2 = reads/${SRR}_2.trimmed.fastq

# Filenames for the retrimmed reads
RT1 = reads/${SRR}_1.retrimmed.fastq
RT2 = reads/${SRR}_2.retrimmed.fastq

# Directories for bam files
BAMDIR = bam

# BAM files for SRA reads 
BAM_SRA = bam/${SRR}.bam
SORTED_BAM_SRA = bam/${SRR}.sorted.bam

# Directories for vcf files
VCFDIR = vcf

# VCF files for SRA reads
VCF_SRA = vcf/${SRR}.vcf.gz



# -----------------------------------SET USEFUL DEFAULTS------------------------------
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


# ----------------------------------MAKEFILE TARGETS----------------------------------

# Print Help
usage:
	@echo "Makefile targets:"
	@echo "  usage       - Print this help message"
	@echo "  Ref_genome  - Download the Reference genome"
	@echo "  SRA_reads   - Download reads from SRA"
	@echo "  trim        - Trim reads using fastp"
	@echo "  report1     - Generate FastQC reports"
	@echo "  retrim      - Retrim reads by cutting the tails"
	@echo "  report2     - Generate FastQC reports for retrimmed reads"
	@echo "  index       - Create index for the genome"
	@echo "  align_sra   - Align SRA reads to the genome"
	@echo "  vcf         - Variant calling"
	@echo "  merge_vcf_files - Merge the VCF files"
	@echo "  clean       - Clean up generated files"


# ---------------------------------ALL ACTIONS BELOW-----------------------------------


#Step 1. Download Reference genome (run this only once and separately to avoid downloading the genome multiple times)

Ref_genome:
	mkdir -p ${GENOME_DIR}
	wget ${URL} 
	# Unzip the genome and rename it 
	gunzip -c ${FILE} > ${GENOME}
	echo "Genome downloaded and saved as ${GENOME}"
	# Report size of the genome
	echo "Size of the genome:"
	du -h ${GENOME}


#Step 2.-----------------------Run all the steps below for all samples-----------------------

all: SRA_reads trim report1 retrim report2 index align_sra vcf 

# Download reads from SRA and generate FastQC reports
SRA_reads:
	mkdir -p ${RDIR} ${RPDIR}
	fastq-dump -X ${N} --split-files -O ${RDIR} ${SRR}
	fastqc -q -o ${RPDIR} ${RD1} ${RD2}
	echo "Reads downloaded and saved as ${RD1} and ${RD2}"
	
# Trim the reads and generate reports (using default parameters) 
trim: 
	fastp -i ${RD1} -o ${T1} -I ${RD2} -O ${T2}
	fastqc -q -o ${RPDIR} ${T1} ${T2}
	echo "Reads trimmed and quality control report generated"

# Generate FastQC reports for raw and trimmed reads
report1: 
	fastqc -q -o ${RPDIR} ${T1} ${T2}
	echo "Quality control reports generated for retrimmed reads"

# Retrim the reads by cutting the tails
retrim: 
	fastp --cut_tail -i ${T1} -o ${RT1} -I ${T2} -O ${RT2}
	echo "Reads retrimmed and saved as ${RT1} and ${RT2}"

# Generate FastQC reports for retrimmed reads
report2: 
	fastqc -q -o ${RPDIR} ${RT1} ${RT2}
	echo "Quality control reports generated for retrimmed reads"

# Create index for the genome
index: 
	bwa index ${GENOME}
	echo "Index created for the genome"

# Align SRA reads to the genome
align_sra: 
	mkdir -p ${BAMDIR}
	bwa mem ${GENOME} ${RT1} ${RT2} | samtools sort > ${SORTED_BAM_SRA}
	echo "SRA reads aligned to the genome and saved as ${SORTED_BAM_SRA}"
	# Index the BAM file
	samtools index ${SORTED_BAM_SRA}
	# Generate alignment statistics for SRA reads
	samtools flagstat ${SORTED_BAM_SRA}
	echo "Alignment statistics for SRA reads"

# Variant calling
vcf: 
	mkdir -p ${VCFDIR}
	# genotyping
	bcftools mpileup -d 100 --annotate 'INFO/AD,FORMAT/AD,FORMAT/DP,FORMAT/SP,FORMAT/ADR,FORMAT/ADF' -O u -f ${GENOME} ${SORTED_BAM_SRA} | \
	# call variants
	bcftools call --ploidy 2 --annotate 'FORMAT/GQ' -mv -O u | \
	# filter variants
	bcftools norm -f ${GENOME} -d all -O u | \
	# sort variants
	bcftools sort -O z > ${VCF_SRA}
	# index the vcf file
	bcftools index ${VCF_SRA}
	echo "VCF file generated for SRA reads"


#STEP 3.-------------------------- Merge the VCF files--- ------------------
merge_vcf_files:
	# Merge all the VCF files
	bcftools merge ${VCFDIR}/*.vcf.gz -O z -o ${VCFDIR}/merged.vcf.gz
	# Index the merged VCF file
	bcftools index ${VCFDIR}/merged.vcf.gz


#Step 4. -------------------------- Clean files generated--- ------------------

# Clean up generated files
clean:
	rm -rf ${GENOME_DIR} ${FILE} ${RDIR} ${RPDIR} ${BAMDIR} ${VCFDIR} 
	rm -f ${GENOME} ${RD1} ${RD2} ${T1} ${T2} ${RT1} ${RT2} ${SORTED_BAM_SRA} ${VCF_SRA} 
	rm -f *.html *.json *.gz 
	rm -rf results
	echo "Cleaned up generated files"

# Clean up generated files
.PHONY: usage Ref_genome SRA_reads trim report1 retrim report2 index align_sra vcf merge_vcf_files clean
