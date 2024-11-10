# Set trace
set -xue

# SET  VARIABLES

# SRR number
SRR=SRR800855

# Number of reads to sample
N=10000

# The output read names
R1=reads/${SRR}_1.fastq
R2=reads/${SRR}_2.fastq

# Trimmed read names
T1=reads/${SRR}_1.trimmed.fastq
T2=reads/${SRR}_2.trimmed.fastq

# Retrimmed read names
RT1=reads/${SRR}_1.retrimmed.fastq
RT2=reads/${SRR}_2.retrimmed.fastq

# The reads directory
RDIR=reads

# The reports directory
RPDIR=reports

#-----------------ACTIONS BELOW-----------------#

# Make the directories
mkdir -p ${RDIR} ${RPDIR}

# Download the FastQ file
fastq-dump -X ${N} --split-files -O ${RDIR} ${SRR}

# Run FastQC on the raw reads to visualize the quality
fastqc -q -o ${RPDIR} ${R1} ${R2}

# Run fastp by default to trim the reads
fastp -i ${R1} -o ${T1} -I ${R1} -O ${T2} 

# Run FastQC on the trimmed reads to visualize the quality
fastqc -q -o ${RPDIR} ${T1} ${T2}

# Perform another round of trimming with fastp to cut the tails from the trimmed reads
fastp --cut_tail -i ${T1} -o ${RT1} -I ${T2} -O ${RT2}

# Run FastQC on the trimmed reads to visualize the quality
fastqc -q -o ${RPDIR} ${RT1} ${RT2}


