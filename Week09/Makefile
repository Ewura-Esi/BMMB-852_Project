
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

# BAM files for simulated and SRA reads
BAM_SIM = "aligned_simulated.bam"
SORTED_BAM_SIM = "sorted_simulated.bam"

BAM_SRA = "aligned_sra.bam"
SORTED_BAM_SRA = "sorted_sra.bam"

# Unmapped reads
UNMAPPED_SRA = "unmapped_sra.bam"

# Properly paired primary alignments
PROP_PAIRED_PRI = "properly_paired_primary.bam"


# --------------SET USEFUL DEFAULTS--------------
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
	@echo "  index       - Create index for the genome"
	@echo "  align_sim   - Align simulated reads to the genome"
	@echo "  stats_sim   - Generate alignment statistics for simulated reads"
	@echo "  align_sra   - Align SRA reads to the genome"
	@echo "  stats_sra   - Generate alignment statistics for SRA reads"
	@echo "  unmapped_sra_reads - Reads that didnot align to the genome for SRA reads"
	@echo "  alignment_type_sra - Primary, secondary, and supplementary alignments in the BAM file for SRA reads"
	@echo "  properly_paired_reverse_strand - Properly paired alignments on the reverse strand in Read1"
	@echo "  properly_paired_primary_alignments - New BAM File with Properly Paired Primary Alignments (QC > 10)"
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
simulate: 
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

# Align simulated reads to the genome
align_sim: 
	bwa mem ${GENOME} ${R1} ${R2} | samtools sort > ${SORTED_BAM_SIM}
	echo "Simulated reads aligned to the genome and saved as ${SORTED_BAM_SIM}"
	# Index the BAM file
	samtools index ${SORTED_BAM_SIM}

# Generate alignment statistics for simulated reads
stats_sim: 
	samtools flagstat ${SORTED_BAM_SIM}

# Align SRA reads to the genome
align_sra: 
	bwa mem ${GENOME} ${RT1} ${RT2} | samtools sort > ${SORTED_BAM_SRA}
	echo "SRA reads aligned to the genome and saved as ${SORTED_BAM_SRA}"
	# Index the BAM file
	samtools index ${SORTED_BAM_SRA}

# Generate alignment statistics for SRA reads
stats_sra: 
	samtools flagstat ${SORTED_BAM_SRA}
	echo "Alignment statistics for SRA reads"

# Reads that didnot align to the genome for SRA reads
unmapped_sra_reads:
	samtools view -b -f 4 ${SORTED_BAM_SRA} > ${UNMAPPED_SRA}
	samtools flagstat ${UNMAPPED_SRA}
	echo "Unmapped reads saved as ${UNMAPPED_SRA}"

# Primary, secondary, and supplementary alignments in the BAM file for SRA reads
alignment_type_sra:
	# Primary alignments
	samtools view -c -F 256 -F 2048 ${SORTED_BAM_SRA}
	echo "Primary alignments in the BAM file for SRA reads"
	# Secondary alignments
	samtools view -c -f 256 ${SORTED_BAM_SRA}
	echo "Secondary alignments in the BAM file for SRA reads"
	# Supplementary alignments
	samtools view -c -f 2048 ${SORTED_BAM_SRA}
	echo "Supplementary alignments in the BAM file for SRA reads"

# Properly paired alignments on the reverse strand in Read1
properly_paired_reverse_strand:
	samtools view -c -f 99 ${SORTED_BAM_SRA}
	echo "Properly paired alignments on the reverse strand in Read1"

# New BAM File with Properly Paired Primary Alignments (QC > 10)
properly_paired_primary_alignments:
	samtools view -b -q 10 -f 2 ${SORTED_BAM_SRA} > ${PROP_PAIRED_PRI}
	echo "New BAM file with properly paired primary alignments saved as ${PROP_PAIRED_PRI}"
	samtools flagstat ${PROP_PAIRED_PRI}
	echo "Alignment statistics for properly paired primary alignments"
	

# Clean up generated files
clean:
	rm -rf ${GENOME} ${FILE} ${R1} ${R2} ${RD1} ${RD2} ${T1} ${T2} ${RT1} ${RT2} ${RDIR} ${RPDIR} ${SORTED_BAM_SIM} ${SORTED_BAM_SRA} ${UNMAPPED_SRA} ${PROP_PAIRED_PRI}
	rm -f *.html *.json *.amb *.ann *.bwt *.pac *.sa *.bam *.bai
	echo "Cleaned up generated files"

# Clean up generated files
.PHONY: usage genome simulate download trim report1 retrim report2 index align_sim stats_sim align_sra stats_sra 
