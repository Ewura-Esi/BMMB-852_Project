# All lines starting with # are all commments and not codes that can be executed.

# Q1. For this assignment, I chose the organism Hucho hucho commonly known as the huchen
# or Danube salmon. is a large species of freshwater fish in the salmon family, 
# Salmonidae. It is native to the Danube River basin in Central and Eastern Europe. 
# The huchen is known for its size, with some individuals growing over 1.5 meters 
# (about 5 feet) in length and weighing up to 50 kg (110 lbs)

# To download the GFF file of the organism, I went to the website with the Esemble FTP server url,
#http://ftp.ensembl.org/pub/current_gff3/Links and copied the link from the organism

# Command Used to download the GFF3 file
wget https://ftp.ensembl.org/pub/current_gff3/hucho_hucho/Hucho_hucho.ASM331708v1.112.gff3.gz

# Unzip the file downloaded (I unzipped because the file I downloaded was a zip file)
gunzip Hucho_hucho.ASM331708v1.112.gff3.gz

# Q2. Obtain features of the file
cat Hucho_hucho.ASM331708v1.112.gff3 | wc 
# Asnwer: 2449149 lines, 20872079 words, 373624698 characters

# Q3. Number of sequence regions (chromosomes) in the file
cat Hucho_hucho.ASM331708v1.112.gff3 | grep '##sequence-region' | wc -l
# Answer: 71639

# Before moving forward to check the number of genes and the top ten most annotated feature types,
# I filtered out all the comments using the command below and saved to a different file called hucho.gff3
 
# Save lines not starting with '#' to hucho.gff3
cat Hucho_hucho.ASM331708v1.112.gff3 | grep -v '#' > hucho.gff3

# Q4. Number of Genes listed for Hucho hucho
cat hucho.gff3 | cut -f 3 | sort-uniq-count-rank | head
# OR
cat hucho.gff3 | awk '$3 == "gene"' | wc -l
# Answer: 50114

# Q5. Finding the top-ten most annotated feature types (column 3) across the genome
cat hucho.gff3 | cut -f 3 | sort-uniq-count-rank | head
# Answer: 
# 936981  exon
# 897978  CDS
# 91708   mRNA
# 80360   five_prime_UTR
# 71639   region
# 61879   three_prime_UTR
# 56505   biological_region
# 50114   gene
# 2215    ncRNA_gene
# 744     snoRNA

# Q6. Having analyzed this GFF file, does it seem like a complete and well-annotated organism? 
# Answer: This looks like a well-anotated genome.