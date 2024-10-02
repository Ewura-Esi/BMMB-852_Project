## Report from Assignment

#### Organism Used and tested
I used a different organism *Mycobacterium tuberculosis* from Assignmnet 3 and I was able to generate the data with the script. Examples of data generated include the following

Number of genes
```
3978
```

The top ten features in the gff file
```
3978    gene
3906    CDS
262     repeat_region
70      exon
56      mobile_genetic_element
45      tRNA
34      sequence_feature
30      pseudogene
20      ncRNA
3       rRNA
```

#### Reproduce peer review report
I used my script to reproduce data generated from my peer's script

I initially was not able to reproduce their data because of the different file names for different organisms from NCBI datasets. So, I had to modify my scripts by defining a uniform file path for all ncbi-datasets considering that the files comes in different name format. By doing this, I was able to reproduce the data for Jessica Eckard using the accession number (GCF_000005845.2) she used for her assignment .

Additionally, one of my peer's (Paul Yu) used data from ensemble and I had to modify the script to be able to regenerate her data. For example, by specifying the URL variable etc. Otherwise, everything worked.


#### Sequence ontology

I chose exon and used the bio command to look it up

```bash 
# Install bio command if not installed by typing bio --download
bio explain exon
```

Definition
```
A region of the transcript sequence within a gene which is not removed from the primary RNA transcript by RNA splicing.
```

Parent
```
 transcript_region
```

Children
```
- coding_exon
- noncoding_exon
- interior_exon
- decayed_exon (non_functional_homolog_of)
- pseudogenic_exon (non_functional_homolog_of)
- exon_region (part_of)
- exon_of_single_exon_gene
```

