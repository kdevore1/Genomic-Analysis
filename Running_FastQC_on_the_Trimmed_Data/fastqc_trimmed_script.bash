# Running FastQC on the Trimmed Data

# The purpose of this script is to run FastQC on the trimmed data and determine: 
#	(1) which trimmed fastq files did not fail any QC tests, 
#	(2) which trimmed fastq files failed at least one QC test,
#	(3) for the trimmed fastq files that did fail at least one test, which tests did they fail.
# NOTE: Prior to running this script all files containing "un.trim" in the file name were moved to a directory un/ using the following commands to ensure fastqc
# was not run on these files
# 	cd ~/dc_workshop/data/trimmed_fastq
#	mkdir un
# 	mv *un.trim* un/
# This script requires .trim.fastq files and manipulates the data such that 2 output files are created.
# The first file is a summary file that contains information on the performance of all of the files that underwent FastQC.
# The second file further manipulates the summary file created above and contains information that answers the three questions.
# --------------------------------------------------------------------------------------------------------------------------------------------

# Exits the script if an error occurs
set -e

# Creates a directory under results which houses the fastqc results on the trimmed reads
mkdir -p ~/dc_workshop/results/fastqc_trimmed_reads

# ---------------------------------------------------------------------------------------------------------------------------------------------
# A. Running FastQC

# Goes to directory with trimmed_fastq data
cd ~/dc_workshop/data/trimmed_fastq

# Adds fastqc to shell
module add fastqc/0.11.7

# Runs fastqc on all files that contain .trim.fastq
echo "Running FastQC ..."
fastqc *.trim.fastq*

# ---------------------------------------------------------------------------------------------------------------------------------------------
# B. Creating a trimmed_fastqc_summaries.txt file

# Moves .zip and .html files to directory created above
echo "Saving FastQC results..."
mv *.zip ~/dc_workshop/results/fastqc_trimmed_reads/
mv *.html ~/dc_workshop/results/fastqc_trimmed_reads/

# Changes directory to one created above
cd ~/dc_workshop/results/fastqc_trimmed_reads/

# For loop that expands .zip files
echo "Unzipping..."
for filename in *.zip; do unzip $filename; done

# Puts summary.txt for each read into one text file
echo "Saving summary..."
cat */summary.txt > ~/dc_workshop/docs/trimmed_fastqc_summaries.txt

# ---------------------------------------------------------------------------------------------------------------------------------------------
# C. Extracting information
# Task 1/2

# Creates a variable called output_path which is routed to a blank file
output_path=script_output.txt

# Creates a header that details the files that failed a QC test
echo "FILES THAT FAILED A QC TEST" >> "${output_path}"

# Reads the data 
cat ~/dc_workshop/docs/trimmed_fastqc_summaries.txt |

# If statement that will print the file name (column 3) if column 1 contains "FAIL"
        awk -F '\t' '{if ($1 == "FAIL") {print $3}}' |

# Sorts file names (column 3) in ascending order
        sort |

# Omits repetitive file names and writes to the output path
        uniq >> "${output_path}"

# Given that there are six different files listed in the summary file, by determining which files failed a test we can figure out which files did not fail a test.

echo "FILES THAT DID NOT FAIL A TEST: SRR2584863_1.trim.fastq.gz , SRR2584866_2.trim.fastq.gz , SRR2589044_1.trim.fastq.gz" >> "${output_path}"

# Files SRR2584863_2.trim.fastq.gz , SRR2584866_1.trim.fastq.gz , SRR2589044_2.trim.fastq.gz failed at least one QC test.

#------------------------------------------------------------------------------

# Task 3

# Creates a header that details the test failed and the file name
echo "TEST FAILED, FILE NAME" >> "${output_path}"

# Reads the data from directory
cat ~/dc_workshop/docs/trimmed_fastqc_summaries.txt |

# If statement that will print the name of the test (column 2) and the file name (column 3) if column 1 contains "FAIL"
        awk -F '\t' '{if ($1 == "FAIL") {print $2, $3}}' >> "${output_path}"

# ---------------------------------------------------------------------------------------------------------------------------------------------

# Moves script_output.txt back to docs
mv script_output.txt ~/dc_workshop/docs

# ---------------------------------------------------------------------------------------------------------------------------------------------


