import os
import pandas as pd
import re
import glob

# Directory where your .stat files are located
root = "stat/*"

# Get a list of all .stat files in the directory

stat_files = glob.glob(root)

stat_table = list()

# Loop through each .stat file
for idx, stat_file in enumerate(stat_files):

    # Read the lines from the .stat file into a list
    
    infile = open(stat_file,"r")
    metrics = []
    
    for line in infile:
        line = line.split()
        metric = line[-1]
        if metric != "NA":
            metric = float(metric)
        metrics.append(metric)
    
    #File stats
    stat_file_2 = re.search(r"(.+)\.stat", stat_file).group(1) 
    params = stat_file_2.split("_")[3:]
    
    if params[-1] == "anc":
        params[5] = "aln_anc"
        params = params[:6]
    stat_table.append(metrics + params)
    
stat_dataframe = pd.DataFrame(stat_table)

#Col names
col_names = ["Total","Mt","Nuc","Unmapped","Unmapped_mt","Unmapped_nuc","Mapped","Mapped_mt","Mapped_mt_corr","Mapped_mt_corr_MQ","Mapped_mt_nocorr","Mapped_nuc","Mapped_nuc_MQ","Alignscore_mpileup","Alignscore_ecnodam","Alignscore_angsd","Gen","Numfrags","Length","Damage","Rate","Aligner"]

stat_dataframe.columns = col_names

# Save the result DataFrame to an XLSX file
stat_dataframe.to_csv('raw_table.csv', index = False)

print("CSV file 'raw_table.csv' has been created.")
