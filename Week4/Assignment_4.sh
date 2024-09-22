# Set the trace to show the commands as executed
set -uex

# Get the accesion number for organism from NCBI Datasets
# https://www.ncbi.nlm.nih.gov/datasets/

# If using Ensemble to download the data, set variable for URL(example below)

# -----SET VARIABLES-----

# The selected accesion number 
GCF=GCF_000195955.2 

# Directory where the data is downloaded
DOWNLOAD_DIR="ncbi_dataset"

# Define the path based on the known folder structure after unzipping
GENOMIC_DATA_DIR="${DOWNLOAD_DIR}/data/${GCF}"

# The name of the gff3 file inside the unzipped foler
GFF="${GENOMIC_DATA_DIR}/genomic.gff"

# The name of the genes file
GENES=genes.gff


# -----DOWNLOAD DATA AND ANALYSE-----

# Update NCBI DATASET
micromamba update ncbi-datasets-cli jq

# Check metadata of the dataset
datasets summary genome accession ${GCF} | jq

# Download dataset (include both fna and the gff3 files)
datasets download genome accession ${GCF} --include gff3,genome

# Unzip the file
unzip ncbi_dataset.zip 

# Check features present
 cat ${GFF} | head

# View annotations for gene features only
cat ${GFF} | awk ' $3=="gene" { print $0 }'

# Make a new GFF file with only the features of type gene
cat ${GFF} | awk ' $3=="gene" { print $0 }' > ${GENES}

# After unzipping, find the .fna file in the directory (because name can vary)
FNA=$(find ${GENOMIC_DATA_DIR} -name "*.fna")

# Obtain the chromosome accession for my gff file
cat ${FNA} | head -1

# Make my own gff file
code my_own.gff
