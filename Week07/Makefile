
# ------------SET VARIABLES------------

# URL for the genome
URL = "https://ftp.ensembl.org/pub/release-112/fasta/saccharomyces_cerevisiae/dna/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz"

# name of the file
FILE = "Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz"

# Genome file
GENOME = "genome.fa"

# genome length
GL = 12157105

# coverage
C = 10
# read length  
L = 100

# Files to write the reads to
R1 = "reads1.fq"
R2 = "reads2.fq"

# SRR number for the reads
SRR = SRR800855

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

# Number of reads to simulate
N = 10000

# Read length
L = 100


# --------------SET SHELL OPTIONS--------------
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


# --------------MAKEFILE TARGETS--------------

# Print Help
usage:
	@echo "Makefile targets:"
	@echo "  usage       - Print this help message"
	@echo "  genome      - Download the genome and prepare it for simulation"
	@echo "  simulate    - Simulate reads from the genome"
	@echo "  download    - Download reads from SRA"
	@echo "  trim        - Trim reads using fastp"
	@echo "  report1      - Generate FastQC reports"
	@echo "  retrim      - Retrim reads by cutting the tails"
	@echo "  report2      - Generate FastQC reports for retrimmed reads"
	@echo "  clean       - Clean up generated files"


# --------------ALL ACTIONS BELOW--------------

# Download genome and prepare it for simulation
genome:
	wget ${URL} 
	# Unzip the genome and rename it 
	gunzip -c ${FILE} > ${GENOME}
	echo "Genome downloaded and saved as ${GENOME}"
	# Report size of the genome
	echo "Size of the genome:"
	du -h ${GENOME}

# Simulate reads for the genome using wgsim
simulate: genome
	wgsim -e 0 -r 0 -R 0 ${GENOME} ${R1} ${R2}
	echo "Reads simulated and saved as ${R1} and ${R2}"
	# Get stats for the simulated reads
	echo "Stats for the simulated reads:"
	seqkit stats ${R1} ${R2}
	# Calculate the number of reads needed for 10x coverage 
	N=$((($GL * $C) / ($L * 2)))
	echo "Number of reads needed for 10x coverage: ${N}"
	# Simulate reads for 10x coverage
	wgsim -e 0 -r 0 -R 0 -1 $L -2 $L -N $N ${GENOME} ${R1} ${R2}
	echo "Reads simulated for 10x coverage and saved as ${R1} and ${R2}"

# Download reads from SRA and generate FastQC reports
download:
	mkdir -p ${RDIR} ${RPDIR}
	fastq-dump -X ${N} --split-files -O ${RDIR} ${SRR}
	fastqc -q -o ${RPDIR} ${RD1} ${RD2}
	echo "Reads downloaded and saved as ${RD1} and ${RD2}"
	
# Trim the reads and generate reports (using default parameters) 
trim: download
	fastp -i ${RD1} -o ${T1} -I ${RD2} -O ${T2}
	fastqc -q -o ${RPDIR} ${T1} ${T2}
	echo "Reads trimmed and quality control report generated"

# Generate FastQC reports for raw and trimmed reads
report1: trim
	fastqc -q -o ${RPDIR} ${T1} ${T2}
	echo "Quality control reports generated for retrimmed reads"

# Retrim the reads by cutting the tails
retrim: trim
	fastp --cut_tail -i ${T1} -o ${RT1} -I ${T2} -O ${RT2}
	echo "Reads retrimmed and saved as ${RT1} and ${RT2}"

# Generate FastQC reports for retrimmed reads
report2: retrim
	fastqc -q -o ${RPDIR} ${RT1} ${RT2}
	echo "Quality control reports generated for retrimmed reads"

# Clean up generated files
clean:
	rm -rf ${GENOME} ${FILE} ${R1} ${R2} ${RD1} ${RD2} ${T1} ${T2} ${RT1} ${RT2} ${RDIR} ${RPDIR}
	rm -f *.html *.json
	echo "Cleaned up generated files"

# Clean up generated files
.PHONY: usage genome simulate download trim report1 retrim report2 
