Steps:

Run the following code in the command line:
snakemake

This snakemake uses parseBamMito.py script to generate all stat files and they are stored in the stat folder

Run the following code in the command line:
python3 table.py

This python script generates raw_table.csv, which stores metrics and parameters for each simulation

Run the following code in the command line:
Rscript preprocessing.R

This R script generates table.csv, which stores precision, sensitivity and specificity for each simulation

Run the following code in the command line:
Rscript analysis.R

This R script generates the final figures: Aligner.jpg, Gen.jpg, Damage.jpg, Length.jpg and Rate.jpg
