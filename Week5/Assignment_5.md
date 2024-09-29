## Creating a reproducible script for Assignment 5 (*S. Cereisiae* genome from ensemble)

Set the trace option
```bash
set -xeu
```

Set Variables
```bash
URL="https://ftp.ensembl.org/pub/release-112/fasta/saccharomyces_cerevisiae/dna/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz"

# name of the file
FILE="Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz"

# name of the unzipped file
GENOME="genome.fa"
```

### ---------------------- QUESTION 1-------------------------
#### 1. Select a genome, then download the corresponding FASTA file.

Download the file
```bash
wget ${URL}
```

Unzip the file and rename to a simpler name
```bash
gunzip ${FILE} -c > ${GENOME}
```

Report the size of the file
```bash
du -lh ${GENOME}
```
    Answer: 12M

Report the size of the genome
```bash
grep -v ">" ${GENOME} | wc -c
```
    Answer: 12359733

Report the number of chromosomes, names of chromosomes and their length
```bash
grep -c ">" ${GENOME}
grep ">" ${GENOME} | awk '{print $1, length($2)}'
```
    Answer: 17 Chromosomes
    Chromosome Names and length
    I-14, II-14, III-14, IV-14, V-14, VI-14, VII-14, VIII-14, IX-14, X-14,XI-14, XII-14, XIII-14, XIV-14, XV-14, XVI-14, Mito-14


### ------------------------- QUESTION 2 -------------------------
#### 2. Generate a simulated FASTQ output for a sequencing instrument of your choice.  
Set the parameters so that your target coverage is 10x
```bash
# set parameters for the simulation
# genome length
GL=12157105
# coverage
C=10
# read length  
L=100
# Files to write the reads to
R1="reads1.fq"
R2="reads2.fq"
```

Simulate the FASTQ output
```bash
wgsim -e 0 -r 0 -R 0 ${GENOME} ${R1} ${R2}
```

Run seqkit to get the statistics of the FASTQ files
```bash
seqkit stats ${R1} ${R2}
```

#### ----- Modifying the parameters to get the target coverage of 10x -----

Calculate the number of reads needed for 10x coverage 
```bash 
N=$((($GL * $C) / ($L * 2)))
```
    Answer: 607855

Simulate the FASTQ output using wgsim
```bash
wgsim -e 0 -r 0 -R 0 -1 $L -2 $L -N $N ${GENOME} ${R1} ${R2}
```

Run seqkit to get the statistics of the FASTQ files
```bash
seqkit stats ${R1} ${R2}
```
will Output

    file       format  type  num_seqs     sum_len  min_len  avg_len  max_len
    reads1.fq  FASTQ   DNA    607,857  60,785,700      100      100      100
    reads2.fq  FASTQ   DNA    607,857  60,785,700      100      100      100

Report Average read length

    The average read length is 100


Get the size of the FASTQ files
```bash
du -h ${R1} 
du -h ${R2}
```
Answer

    The size of the FASTQ files is 140M each fastq files


Compress the files and report the size of the compressed file

Unzip the files
```bash
gzip ${R1} ${R2}
```
Get the file size
```bash
du -h ${R1}.gz 
du -h ${R2}.gz
```
Answer

    The size of the FASTQ files is 28M each fastq files


Space Saved after compression
```bash
# Size before compression
SBC=140000000
# Size after compression
SAC=28000000
# Space saved after compression
SS=$(($SBC - $SAC))
```
Report the saved space

    The space saved after compression is: 112M


#### Discuss if you get the same coverage by changing the read length and the number of reads

Set new parameters
```bash
# Change the read length to 150
L1=150
# Change number of reads
NR1=400000
```

Simulate the FASTQ output using wgsim with the new read length and number of reads
```bash
wgsim -e 0 -r 0 -R 0 -1 $L1 -2 $L1 -N $NR1 ${GENOME} ${R1} ${R2}
```

Run seqkit to get the statistics of the FASTQ files
```bash
seqkit stats ${R1} ${R2}
```

Calculate the coverage
```bash
C1=$(($NR1 * $L1 * 2 / $GL))
```
Report the coverage

    The coverage is: 9x
    Changing the read length and the number of reads gave different coverage.



### ---------------------- QUESTION 3 -------------------------
#### 3. How much data would be generated when covering the Yeast,  the Drosophila or the Human genome at 30x?

Set the variables
```bash
# coverage set to 30x
C2=30
# read length (Using the same read length as in question 2)
L2=100
# Yeast genome in base pairs
GSY=12000000
# Drosohila genome in base pairs
GSD=140000000
# Human genome in base pairs
GSH=3200000000
```

Calculate the number of reads needed for 30x coverage for Yeast
```bash
# NY - number of reads for Yeast
NY=$((($GSY * $C2) / ($L2 * 2)))
```

    Answer: 1800000

Calculate the number of reads needed for 30x coverage for Drosophila
```bash
# ND - number of reads for Drosophilla
ND=$((($GSD * $C2) / ($L2 * 2)))
```

    Answer: 21000000

Calculate the number of reads needed for 30x coverage for Human
```bash
# NH - number of reads for Human
NH=$((($GSH * $C2) / ($L2 * 2)))
```
    Answer: 480000000


##### Estimate the size of the FASTQ files for the three genomes based on question 2 information on the size of the FASTQ files

Old number of reads and file size before compression (from Question 2)
```bash
OLD_NUM_READS=607856
OLD_FILE_SIZE=140  # in M
```

Calculate the new file sizes
```bash
# Yeast
FILE_SIZE_Y=$((($NY / $OLD_NUM_READS) * $OLD_FILE_SIZE))

# Drosophila
FILE_SIZE_D=$((($ND / $OLD_NUM_READS) * $OLD_FILE_SIZE))

# Human
FILE_SIZE_H=$((($NH / $OLD_NUM_READS) * $OLD_FILE_SIZE))
```

Report the new file size (estimated uncompressed FASTQ sizes) 

    Answer: The estimated file sizes for Yeast, Drosophilla and Human are 280M, 4760M and 110460M respectively
 
Estimate the compressed FASTQ file size for Yeast, Drosophila, and Human genomes
```bash
# Old compressed file size (from Question 2)
OLD_COMPRESSED_FILE_SIZE=28  # in MB
```
Calculate the new compressed file size for Yeast
```bash
COMPRESSED_FILE_SIZE_Y=$((($NY / $OLD_NUM_READS) * $OLD_COMPRESSED_FILE_SIZE))
```
Calculate the new compressed file size for Drosophila
```bash
COMPRESSED_FILE_SIZE_D=$((($ND / $OLD_NUM_READS) * $OLD_COMPRESSED_FILE_SIZE))
```
Calculate the new compressed file size for Human
```bash
COMPRESSED_FILE_SIZE_H=$((($NH / $OLD_NUM_READS) * $OLD_COMPRESSED_FILE_SIZE))
```

Report the new compressed file size

    Answer: The new compresses file sizes for Yeast, Drophilla and Human are 56M, 952M and 22092M respectively
























