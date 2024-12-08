
# -------------------------------SET VARIABLES----------------------------

# Directory for the genome
GENOME_DIR = genome

# URL for the genome
URL = "https://ftp.ensembl.org/pub/release-113/fasta/saccharomyces_cerevisiae/dna/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz"

# name of the file
FILE = "Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz"

# Genome file
GENOME = genome/"genome.fa"

# SRR number for the reads
SRR = SRR31230567

# The name of the sample
SAMPLE= IUP4+isoprenol-2

# Number of reads to download
N = 500000

# Directories for reads and reports
RDIR = reads
RPDIR = reports

# Filenames for the reads
RD1 = ${RDIR}/${SRR}_1.fastq
RD2 = ${RDIR}/${SRR}_2.fastq

# Filenames for the trimmed reads
T1 = ${RDIR}/${SRR}_1.trimmed.fastq
T2 = ${RDIR}/${SRR}_2.trimmed.fastq

# Filenames for the retrimmed reads
RT1 = ${RDIR}/${SRR}_1.retrimmed.fastq
RT2 = ${RDIR}/${SRR}_2.retrimmed.fastq

# Directories for bam files
BAMDIR = bam

# BAM files for SRA reads 
BAM_SRA = bam/${SRR}.bam
SORTED_BAM_SRA = bam/${SRR}.sorted.bam

# URL for the GFF file
GTF_URL = "https://ftp.ensembl.org/pub/current_gtf/saccharomyces_cerevisiae/Saccharomyces_cerevisiae.R64-1-1.113.gtf.gz"

# GFF file
GTF_FILE = "Saccharomyces_cerevisiae.R64-1-1.113.gtf.gz"

# GFF file
GTF = "genome.gtf"

# Flags passed to parallel.
FLAGS = --eta --lb --header : --colsep ,

# Number of CPUs
NCPU = 4

# Counts directory
COUNTS_DIR = count

COUNTS_TXT = count/featureCountscounts.txt

# CSV file for the final count matrix
COUNTS_CSV = count/featureCountscounts.csv


# Design file
DESIGN = design.csv


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
	@echo "usage: Print this help message"
	@echo "Ref_genome: Download the reference genome and generate HISAT2 index"
	@echo "gtf: Download the GTF file and generate the index"
	@echo "process_all: Download reads, trim, retrim and generate qc reports for all samples in the design file"
	@echo "all: Run all the steps below for all samples"
	@echo "SRA_reads: Download reads from SRA and generate FastQC reports"
	@echo "trim: Trim the reads and generate reports"
	@echo "report1: Generate FastQC reports for raw and trimmed reads"
	@echo "retrim: Retrim the reads by cutting the tails"
	@echo "report2: Generate FastQC reports for retrimmed reads"
	@echo "align_sra: Align the SRA reads to the genome"
	@echo "countmatrix: Generate countmatrix using featureCounts"
	@echo "final_countmatrix: Generate final count matrix in CSV format"
	@echo "clean: Clean up generated files"


# ---------------------------------ALL ACTIONS BELOW-----------------------------------

#Step 1. Download Reference genome (run this only once and separately to avoid downloading the genome multiple times) and get GTF file

Ref_genome:
	mkdir -p ${GENOME_DIR}
	wget ${URL} 
	# Unzip the genome and rename it 
	gunzip -c ${FILE} > ${GENOME}
	echo "Genome downloaded and saved as ${GENOME}"
	# Report size of the genome
	echo "Size of the genome:"
	du -h ${GENOME}
	# Generate the HISAT2 index
	hisat2-build ${GENOME} ${GENOME}

# Get GTF file
gtf:
	# Download the GTF file
	wget ${GTF_URL}
	# Unzip the GTF file
	gunzip -c ${GTF_FILE} > ${GTF}
	# Sort the GFF file and compress it
	cat ${GTF} | sort -k1,1 -k4,4n -k5,5n -t$$'\t' | bgzip -c > ${GTF}.gz
	# Index the GFF file
	tabix -p gff ${GTF}.gz


#Step 2.-----------------------Run all the steps below for all samples-----------------------

# Run all the steps below for all samples using GNU parallel

# NB// process_all download the reads, trim, retrim and generate qc reports for all samples in the design file 
process_all: 
	cat ${DESIGN} | head -7 | \
	parallel --lb -j -4 --colsep , --header : make all SRR={run_accession} SAMPLE={sample}

all: SRA_reads trim report1 retrim report2

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


# Step 3. ----------------------------Align the SRA reads to the genome---------------------------------

# Align the SRA reads to the genome using GNU parallel and HISAT2 

align_sra:
	mkdir -p $(BAMDIR)
	ls $(RDIR)/*_1.retrimmed.fastq | sed 's/_1.retrimmed.fastq//' | sed 's/reads\///' | parallel -j $(NCPU) \
		"hisat2 -p 4 -x $(GENOME) \
		-1 $(RDIR)/{}_1.retrimmed.fastq \
		-2 $(RDIR)/{}_2.retrimmed.fastq \
		-S $(BAMDIR)/{}.bam && \
		samtools sort -@ 4 -o $(BAMDIR)/{}.sorted.bam $(BAMDIR)/{}.bam && \
		samtools index $(BAMDIR)/{}.sorted.bam"
	echo "All reads aligned and BAM files generated."

# Step 4.-------------------------Generate countmatrix using featureCounts--------------------------------

countmatrix:
	mkdir -p ${COUNTS_DIR}
	featureCounts -T 4 -a ${GTF} -o ${COUNTS_TXT} ${BAMDIR}/*.sorted.bam
	echo "Final count matrix generated at ${COUNTS_TXT}."


# Step 5.-------------------------Generate final count matrix in CSV format---------------------------------

final_countmatrix:
	micromamba run -n stats Rscript src/r/format_featurecounts.r -c ${COUNTS_TXT} -o ${COUNTS_CSV} 
	echo "Final count matrix generated in count/featureCountscounts.csv."


# Clean up generated files
clean:
	rm -rf ${GENOME_DIR} ${RDIR} ${RPDIR} ${BAMDIR} ${COUNTS_DIR} ${GTF} ${GTF}.gz ${GENOME} ${FILE} ${GTF_FILE}
	rm -f ${COUNTS_TXT} ${COUNTS_CSV} 
	rm -f *.html *.json *.gtf *.gtf.gz *.gtf.gz.tbi
	echo "All generated files cleaned up."

# Clean up generated files
.PHONY: usage Ref_genome gtf process_all all SRA_reads trim report1 retrim report2 align_sra countmatrix final_countmatrix clean
