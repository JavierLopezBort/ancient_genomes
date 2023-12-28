#!/usr/bin/python
import pysam
import sys
import re
import os

# Function to check if two intervals intersect
def intersects(left1, right1, left2, right2):
    return not (right1 < left2 or left1 > right2)

def main(bam_file_path):
    # Suppress SAM-format errors
    pysam.set_verbosity(0)

    # Open the BAM file for reading
    bamInputFile = pysam.Samfile(bam_file_path, "rb")

    # Initialize counters
    total = 0
    mt = 0
    nuc = 0
    unmapped = 0  # Initialize counter for unmapped reads
    unmapped_mt = 0
    unmapped_nuc = 0
    mapped = 0
    mapped_mt = 0
    mapped_mt_corr = 0
    mapped_mt_corr_MQ = 0
    mapped_mt_nocorr = 0
    mapped_nuc = 0
    mapped_nuc_MQ = 0

    # Loop through each read in the BAM file
    for read in bamInputFile:
        total += 1  # Increment total read counter

        if read.query_name.startswith("generation"):
            mt += 1
        else:
            nuc += 1

        # Check for unmapped reads
        if read.is_unmapped:
            unmapped += 1

            if read.query_name.startswith("generation"):
                unmapped_mt += 1
            else:
                unmapped_nuc += 1
        else:
            mapped += 1
            # Check if read is from mitochondrial genome based on query name
            if read.query_name.startswith("generation"):
                mapped_mt += 1
                
                # Check for correct location and orientation
                fields = read.query_name.split(":")
                intcs = intersects(
                    int(fields[2]), int(fields[3]),
                    read.reference_start - 50, read.reference_start + read.reference_length + 50
                )
                if intcs:
                    mapped_mt_corr += 1
                    
                    # Check for MQ > 30
                    if read.mapping_quality > 30:
                        mapped_mt_corr_MQ += 1
                else:
                    mapped_mt_nocorr += 1
            else:
                mapped_nuc += 1
                
                # Check for MQ > 30
                if read.mapping_quality > 30:
                    mapped_nuc_MQ += 1

    # Close the BAM file
    bamInputFile.close()

    # Assertions
    assert total == (unmapped + mapped), "Mismatch in total mapped and unmapped reads!"
    assert total == (mt + nuc), "Mismatch in total mito and nuc reads!"
    assert mt == (mapped_mt + unmapped_mt), "Mismatch in total mito reads!"
    assert nuc == (mapped_nuc + unmapped_nuc), "Mismatch in total mito and nuc reads!"
    assert unmapped == (unmapped_mt + unmapped_nuc), "Mismatch in total unmapped reads!"
    assert mapped == (mapped_mt + mapped_nuc), "Mismatch in total mapped reads!"
    assert mapped_mt == (mapped_mt_corr + mapped_mt_nocorr), "Mismatch in total mapped mitochondrial reads!"
    assert mapped_mt_corr_MQ <= mapped_mt_corr, "More reads with MQ>30 than reads in the correct location!"
    assert mapped_nuc_MQ <= mapped_nuc, "More nuclear reads with MQ>30 than total nuclear reads!"
    
    # Output statistics in table form
    print(f"Total reads: {total}")
    print(f"Total mitochondrial reads: {mt}")
    print(f"Total nuclear reads: {nuc}")
    print(f"Unmapped reads: {unmapped}")
    print(f"Unmapped mitochondrial reads: {unmapped_mt}")
    print(f"Unmapped nuclear reads: {unmapped_nuc}")
    print(f"Mapped reads: {mapped}")
    print(f"Mapped mitochondrial reads: {mapped_mt}")
    print(f"Mapped mitochondrial reads (Correct Location): {mapped_mt_corr}")
    print(f"Mapped mitochondrial reads (Correct Location, MQ>30): {mapped_mt_corr_MQ}")
    print(f"Mapped mitochondrial reads (Incorrect Location): {mapped_mt_nocorr}")
    print(f"Mapped nuclear reads: {mapped_nuc}")
    print(f"Mapped nuclear reads (MQ>30): {mapped_nuc_MQ}")

    # CONSENSUS
    consensus = ["mpileup","ec_nodam","angsd"]
    
    for cons in consensus:

       cons_file_path = bam_file_path
       cons_file_path = "consensus/" + re.search(r"alignments/(.+)\.bam", bam_file_path).group(1) + "_" + cons + ".fa.nw"
       align_score = "NA"

       if os.path.exists(cons_file_path):
       
          cons_file = open(cons_file_path, "r")
          flag = False
          for line in cons_file:
             
             if line.startswith("# Score"):
                line = line.split()
                align_score = line[2]
                flag = True
             
             if flag:
                break

       print(f"Alignment score using {cons} from consensus: {align_score}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <bam_file_path>")
    else:
        main(sys.argv[1])

