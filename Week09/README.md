
# Assignment 9 (Report on Filtered BAM file)

### Question 1
#### Reads that did not align to the genome for SRA reads

```bash
samtools view -b -f 4 ${SORTED_BAM_SRA} > ${UNMAPPED_SRA}
```
Check unmapped read statistics
```bash
samtools flagstat ${UNMAPPED_SRA}
```
Output
```
558 + 0 in total (QC-passed reads + QC-failed reads)
558 + 0 primary
0 + 0 secondary
0 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
0 + 0 mapped (0.00% : N/A)
0 + 0 primary mapped (0.00% : N/A)
558 + 0 paired in sequencing
278 + 0 read1
280 + 0 read2
0 + 0 properly paired (0.00% : N/A)
0 + 0 with itself and mate mapped
0 + 0 singletons (0.00% : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)
```

### Question 2
####  How many primary, secondary, and supplementary alignments are in the BAM file for SRA reads

Primary alignments
```bash
samtools view -c -F 256 -F 2048 ${SORTED_BAM_SRA}
```
Output
```
17304
```

Secondary alignments
```bash 
samtools view -c -f 256 ${SORTED_BAM_SRA}
```

Output
```
0
```

Supplementary alignments
```bash
samtools view -c -f 2048 ${SORTED_BAM_SRA}
```
Output
```
48
```

### Question 3
#### How many properly paired alignments on the reverse strand are formed by reads contained in the first pair (read1) file?
```bash
samtools view -c -f 99 ${SORTED_BAM_SRA}
```

Output
```
4083
```


### Question 4
#### Create New BAM File with Properly Paired Primary Alignments (Mapping Quality > 10) and save in a new file called properly_paired_primary.bam

```bash
samtools view -b -q 10 -f 2 ${SORTED_BAM_SRA} > ${PROP_PAIRED_PRI}
```
Statistics for the new BAM file with properly paired primary alignment

```bash
samtools flagstat ${PROP_PAIRED_PRI}
```
Output
```
15182 + 0 in total (QC-passed reads + QC-failed reads)
15157 + 0 primary
0 + 0 secondary
25 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
15182 + 0 mapped (100.00% : N/A)
15157 + 0 primary mapped (100.00% : N/A)
15157 + 0 paired in sequencing
7580 + 0 read1
7577 + 0 read2
15157 + 0 properly paired (100.00% : N/A)
15157 + 0 with itself and mate mapped
0 + 0 singletons (0.00% : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)
```

### Question 5
#### Compare the flagstats for your original and your filtered BAM file.

**Total Reads and Mapped Reads**

- **Original BAM**: 17,352 total reads, 16,794 mapped reads (96.78%).

- **Filtered BAM**: 15,182 total reads, 15,182 mapped reads (100%).

In the filtered BAM file, only properly paired primary alignments with a mapping quality over 10 were retained, resulting in fewer total reads but 100% of them being mapped.

**Primary, Secondary, and Supplementary Alignments**

- **Original BAM**: 17,304 primary, 0 secondary, and 48 supplementary alignments.

- **Filtered BAM**: 15,157 primary, 0 secondary, and 25 supplementary alignments.

The filtered BAM file reduced the number of primary and supplementary alignments by retaining only high-quality, properly paired primary alignments.

**Properly Paired Alignments**

- **Original BAM**: 16,386 properly paired (94.69% of total reads).

- **Filtered BAM**: 15,157 properly paired (100% of total reads).

The filtering retained only properly paired reads, improving the proportion to 100%.

**Singletons and Mate Mapping to Different Chromosomes**

- **Original BAM**: 32 singletons and 248 pairs with mates mapped to different chromosomes (200 with mapQ>=5).

- **Filtered BAM**: 0 singletons and 0 pairs with mates mapped to different chromosomes.

Filtering out lower-quality pairs removed all singletons and pairs with mates on different chromosomes, ensuring all retained reads are properly paired and high quality.

**Summary**

The filtered BAM file has a smaller subset of high-quality, properly paired reads, with all reads fully mapped and no singletons or mates mapped to different chromosomes. 