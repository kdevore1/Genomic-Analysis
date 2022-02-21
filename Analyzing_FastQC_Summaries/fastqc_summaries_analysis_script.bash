# The purpose of this script is to determine: (1) which fastq files did not fail any QC tests, (2) which fastq files failed at least one QC test, 
# (3) for the fastq files that did fail at least one test, which tests did they fail.
# The first section of the script is focused on variable creation. Two different variables are created: one that calls upon the summary.txt file and one that writes to a blank file.
# The second section of the script is focused on answering the tasks asked in the assignment. A short list of commands are called upon to determine which files failed a QC test
# and determine which tests were failed. From this it can be determined which files did not fail a QC test given that 6 unique files are summarized in the summary file.
# echo is used to create a header and is appended to the output file.
# cat is used to call upon the data file from the directory.
# A conditional statement is used within a tab-delimited awk command which will print either the file name (column) or the name of the test (column 2) and the file name (column 3) 
# if column 1 is considered a "FAIL"
# The columns are then sorted and uniq is used to omit repetitive file names. This output is then written to the output file.
#	NOTE: For task 3 the sort and uniq steps are omitted as they are not required.

#-----------------------------------------------------------------
# Variable Creation

# Creates a variable called data_file which contains the text file. This file is located within the working directory.
data_file="fastqc_summaries.txt"

# Creates a variable called output_path which is routed to a blank text file.
output_path=fastqc_summaries_output.txt

#-----------------------------------------------------------------
# Task 1/2

# Creates a header that details the files that failed a QC test
echo "FILES THAT FAILED A QC TEST" >> "${output_path}"

# Reads the data from directory
cat "${data_file}" |

# If statement that will print the file name (column 3) if column 1 contains "FAIL"
        awk -F '\t' '{if ($1 == "FAIL") {print $3}}' |

# Sorts file names (column 3) in ascending order
        sort |

# Omits repetitive file names and writes to the output path
        uniq >> "${output_path}"

# Given that there are six different files listed in the summary file, by determining which files failed a test we can figure out which files did not fail a test.

echo "The only file that did not fail a test is SRR2584863_1.fastq" >> "${output_path}" 

# Files SRR2584863_2.fastq.gz, SRR2584866_1.fastq.gz, SRR2584866_2.fastq.gz, SRR2589044_1.fastq.gz, and SRR2589044_2.fastq.gz failed at least one QC test.
#-----------------------------------------------------------------
# Task 3

# Creates a header that details the test failed and the file name
echo "TEST FAILED, FILE NAME" >> "${output_path}"

# Reads the data from directory
cat "${data_file}" |

# If statement that will print the name of the test (column 2) and the file name (column 3) if column 1 contains "FAIL"
        awk -F '\t' '{if ($1 == "FAIL") {print $2, $3}}' >> "${output_path}"

# The tests that were failed can be seen in the output file.
#-----------------------------------------------------------------
