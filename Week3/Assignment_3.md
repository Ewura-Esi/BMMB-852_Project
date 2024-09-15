# BMMB 852 Assignment 3

## I chose the organism *Mycobacterium tuberculosis*

### I used NCBI Datasets (https://www.ncbi.nlm.nih.gov/datasets/) to get the accession number (GCF_000195955.2) and downloaded the fna and the gff files from the command line

### Before downloading the files, I activated my bioinfo conda environment
By Typing
```bash
micromamba activate bioinfo
```

### I went ahead to update the ncbi datasets before starting the download
By Typing
```bash
micromamba update ncbi-datasets-cli jq
```
### I checked the summary or metadata of the genome using the accession number GCF_000195955.2  before downloading 
By typing 
```bash
datasets summary genome accession GCF_000195955.2 | jq
```

Will Output (this is just showing a bit of the output)
```
{
  "reports": [
    {
      "accession": "GCF_000195955.2",
      "annotation_info": {
        "name": "Annotation submitted by NCBI RefSeq",
        "provider": "NCBI RefSeq",
        "release_date": "2017-12-14",
        "stats": {
          "gene_counts": {
            "non_coding": 70,
            "other": 2,
            "protein_coding": 3906,
            "pseudogene": 30,
            "total": 4008
          }
        }
```

### Download the file
By typing
```bash
datasets download genome accession GCF_000195955.2 
```

### I noticed I didn't have the unzip command so I installed the unzip command before unzipping the file
By typing
```bash
micromamba install unzip
```
### Unzip the file
By typing
```bash
unzip ncbi_dataset.zip
```
Will output

```
Archive:  ncbi_dataset.zip
  inflating: README.md
  inflating: ncbi_dataset/data/assembly_data_report.jsonl
  inflating: ncbi_dataset/data/GCF_000195955.2/GCF_000195955.2_ASM19595v2_genomic.fna
  inflating: ncbi_dataset/data/dataset_catalog.json
  inflating: md5sum.txt
  ```

### Download the gff3 and the gtf files (including additional information for the genome)
```bash
datasets download genome accession GCF_000195955.2 --include gff3,gtf
 ```

### View the top 10 lines of the gff file (I wanted to know the features present)
Typing
```bash
 cat genomic.gff | head
 ```
 Will output
 ```
 ##gff-version 3
#!gff-spec-version 1.21
#!processor NCBI annotwriter
#!genome-build ASM19595v2
#!genome-build-accession NCBI_Assembly:GCF_000195955.2
##sequence-region NC_000962.3 1 4411532
##species https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=83332
NC_000962.3     RefSeq  region  1       4411532 .       +       .       ID=NC_000962.3:1..4411532;Dbxref=taxon:83332;gbkey=Src;genome=genomic;mol_type=genomic DNA;strain=H37Rv;type-material=type strain of Mycobacterium tuberculosis
NC_000962.3     RefSeq  gene    1       1524    .       +       .       ID=gene-Rv0001;Dbxref=GeneID:885041;Name=dnaA;experiment=DESCRIPTION:Mutation analysis%2C gene expression[PMID: 10375628];gbkey=Gene;gene=dnaA;gene_biotype=protein_coding;locus_tag=Rv0001
NC_000962.3     RefSeq  CDS     1       1524    .       +       0       ID=cds-NP_214515.1;Parent=gene-Rv0001;Dbxref=GenBank:NP_214515.1,GeneID:885041;Name=NP_214515.1;experiment=DESCRIPTION:Mutation analysis%2C gene expression[PMID: 10375628],EXISTENCE:Mass spectrometry[PMID:15525680],EXISTENCE:Mass spectrometry[PMID:21085642],EXISTENCE:Mass spectrometry[PMID:21920479];gbkey=CDS;gene=dnaA;inference=protein motif:PROSITE:PS01008;locus_tag=Rv0001;product=chromosomal replication initiator protein DnaA;protein_id=NP_214515.1;transl_table=11
```
### View all the annotation for only the genes
By typing 
```bash
cat genomic.gff | awk ' $3=="gene" { print $0 }'
```
Will output (I am only showing a bit of the output)
```
NC_000962.3     RefSeq  gene    1       1524    .       +       .       ID=gene-Rv0001;Dbxref=GeneID:885041;Name=dnaA;experiment=DESCRIPTION:Mutation analysis%2C gene expression[PMID: 10375628];gbkey=Gene;gene=dnaA;gene_biotype=protein_coding;locus_tag=Rv0001
NC_000962.3     RefSeq  gene    2052    3260    .       +       .       ID=gene-Rv0002;Dbxref=GeneID:887092;Name=dnaN;gbkey=Gene;gene=dnaN;gene_biotype=protein_coding;locus_tag=Rv0002
NC_000962.3     RefSeq  gene    3280    4437    .       +       .       ID=gene-Rv0003;Dbxref=GeneID:887089;Name=recF;gbkey=Gene;gene=recF;gene_biotype=protein_coding;locus_tag=Rv0003
NC_000962.3     RefSeq  gene    4434    4997    .       +       .       ID=gene-Rv0004;Dbxref=GeneID:887088;Name=Rv0004;gbkey=Gene;gene_biotype=protein_coding;locus_tag=Rv0004
```

### Extract all intervals for genes and saved them into a different file called gene.gff to view them on IGV
By typing 
```bash
cat genomic.gff | awk ' $3=="gene" { print $0 }' > gene.gff
```
### Making my own gff file manually (I named it my_own.gff)
By typing 
```bash
code my_own.gff
```
### Obtain the chromosome accession for making my gff file 
By typing
```bash
cat GCF_000195955.2_ASM19595v2_genomic.fna | head -1
 ```
 Will output
```
NC_000962.3 Mycobacterium tuberculosis H37Rv, complete genome
```

### I created my gff using by typing the following in vs code I created a custom GFF file with intervals representing hypothetical regions of interest I visualized this file alongside the main annotations in IGV.
```
NC_000962.3	RefSeq	gene	900670	1278684	.	+	.	ID=mygene
```

### The screenshots to the IGV visualization of my genome of interest can be found here
https://github.com/Ewura-Esi/BMMB-852_Project/blob/main/Week3/igv_snapshot.png
