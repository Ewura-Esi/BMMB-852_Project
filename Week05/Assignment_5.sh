# Creating a reproducible script for Assignment 5 (use fasta ofr S. Cereisiae genome from ensemble)
# Set the trace option
set -xeu


# SET VARIABLES
URL="https://ftp.ensembl.org/pub/release-112/fasta/saccharomyces_cerevisiae/dna/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz"
# name of the file
FILE="Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz"
# name of the unzipped file
GENOME="genome.fa"


#----------------------Question 1-------------------------
# 1. Select a genome, then download the corresponding FASTA file.

# Download the file
wget ${URL}

# Unzip the file and rename to a simpler name
gunzip ${FILE} -c > ${GENOME}


# Report the size of the file
FS=$(du -h ${GENOME})
echo "The size of the file is:" ${FS}

# Report the size of the genome
GS=$(grep -v ">" ${GENOME} | wc -c)
echo "The size of the genome is:" ${GS}


# Report the number of chromosomes, names of chromosomes and their length
Num_Chr=$(grep -c ">" ${GENOME})
echo "The number of chromosomes is:" ${Num_Chr}
Chr_Len=$(grep ">" ${GENOME} | awk '{print $1, length($2)}')
echo "The names of chromosomes and their length are:" ${Chr_Len}


#-------------------------QUESTION 2-------------------------
# 2. Generate a simulated FASTQ output for a sequencing instrument of your choice.  Set the parameters so that your target coverage is 10x

# Simulate the FASTQ output using wgsim

# set parameters for the simulation
# coverage
GL=12157105
C=10
# read length  
L=100
# Files to write the reads to
R1="reads1.fq"
R2="reads2.fq"

# simulate the FASTQ output
wgsim -e 0 -r 0 -R 0 ${GENOME} ${R1} ${R2}

# Run seqkit to get the statistics of the FASTQ files
seqkit stats ${R1} ${R2}

# -----Modifying the parameters to get the target coverage of 10x-----

# Calculate the number of reads needed for 10x coverage for paired-end reads
N=$(((($GL * $C) / ($L * 2))))

# Simulate the FASTQ output using wgsim
wgsim -e 0 -r 0 -R 0 -1 $L -2 $L -N $N ${GENOME} ${R1} ${R2}

# Run seqkit to get the statistics of the FASTQ files
seqkit stats ${R1} ${R2}

# Report number of reads in the FASTQ files
echo "The number of reads in the FASTQ files is:" ${N}

# Report Average read length
echo "The average read length is:" ${L}

# Report size of the FASTQ files
SF1=$(du -h ${R1})
SF2=$(du -h ${R2})
echo "The size of the FASTQ files is:" ${SF1} "and" ${SF2}

# Compress the files and report the size of the compressed files
gzip ${R1} ${R2}
CS1=$(du -h ${R1}.gz)
CS2=$(du -h ${R2}.gz)
echo "The size of the FASTQ files is:" ${CS1} "and" ${CS2}

# Space Saved after compression
SBC=140000000
SAC=28000000
SS=$(($SBC - $SAC))
echo "The space saved after compression is:" ${SS}

# Discuss if you get the same coverage by changing the read length and the number of reads

# Change the read length to 150
# new read length
L1=150
NR1=400000

# Simulate the FASTQ output using wgsim with the new read length and number of reads
wgsim -e 0 -r 0 -R 0 -1 $L1 -2 $L1 -N $NR1 ${GENOME} ${R1} ${R2}

# Run seqkit to get the statistics of the FASTQ files
seqkit stats ${R1} ${R2}

# Calculate the coverage
C1=$(($NR1 * $L1 * 2 / $GL))

# Report the coverage
echo "The coverage is:" ${C1}



#----------------------QUESTION 3-------------------------
# 3. How much data would be generated when covering the Yeast,  the Drosophila or the Human genome at 30x?

# Set the variables
C2=30
# read length (Using the same read length as in question 2)
L2=100

# Yeast genome in base pairs
GSY=12000000

# Calculate the number of reads needed for 30x coverage
NY=$((($GSY * $C2) / ($L2 * 2)))

# Drosohila genome in base pairs
GSD=140000000

# Calculate the number of reads needed for 30x coverage
ND=$((($GSD * $C2) / ($L2 * 2)))

# Human genome in base pairs
GSH=3200000000

# Calculate the number of reads needed for 30x coverage
NH=$((($GSH * $C2) / ($L2 * 2)))

echo "The number of reads needed for 30x coverage for Yeast, Drosophila and Human genomes are:" ${NY} ${ND} ${NH} respectively

# Estimate the size of the FASTQ files for the three genomes based on question 2 information on the size of the FASTQ files
# Estimate the FASTQ file size for Yeast, Drosophila, and Human genomes

# Old number of reads and file size before compression (from Question 2)
OLD_NUM_READS=607856
OLD_FILE_SIZE=140  # in M


# Calculate the new file size
# Yeast
FILE_SIZE_Y=$((($NY / $OLD_NUM_READS) * $OLD_FILE_SIZE))

# Drosophila
FILE_SIZE_D=$((($ND / $OLD_NUM_READS) * $OLD_FILE_SIZE))

# Human
FILE_SIZE_H=$((($NH / $OLD_NUM_READS) * $OLD_FILE_SIZE))

# Report the new file size (estimated uncompressed FASTQ sizes) 
echo "Estimated FASTQ file size for Yeast: ${FILE_SIZE_Y} M"
echo "Estimated FASTQ file size for Drosophila: ${FILE_SIZE_D} M"
echo "Estimated FASTQ file size for Human: ${FILE_SIZE_H} M"


# Estimate the size of the compressed FASTQ files for the three genomes 
# Estimate the compressed FASTQ file size for Yeast, Drosophila, and Human genomes
# Old compressed file size (from Question 2)
OLD_COMPRESSED_FILE_SIZE=28  # in M

# Calculate the new compressed file size
# Yeast
COMPRESSED_FILE_SIZE_Y=$((($NY / $OLD_NUM_READS) * $OLD_COMPRESSED_FILE_SIZE))

# Drosophila
COMPRESSED_FILE_SIZE_D=$((($ND / $OLD_NUM_READS) * $OLD_COMPRESSED_FILE_SIZE))

# Human
COMPRESSED_FILE_SIZE_H=$((($NH / $OLD_NUM_READS) * $OLD_COMPRESSED_FILE_SIZE))

# Report the new compressed file size
echo "Estimated compressed FASTQ file size for Yeast: ${COMPRESSED_FILE_SIZE_Y} M"
echo "Estimated compressed FASTQ file size for Drosophila: ${COMPRESSED_FILE_SIZE_D} M"
echo "Estimated compressed FASTQ file size for Human: ${COMPRESSED_FILE_SIZE_H} M"
























