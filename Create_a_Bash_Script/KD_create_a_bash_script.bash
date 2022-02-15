# Create a Bash Script Assignment 

# The purpose of this script is to find the 100 longest verified ORFs and write their feature names and lengths to a file. 
# This script begins by making two different variables: one that calls upon the data file in the directory and another which leads to a tab file) that will contain the output.
# The script makes use of the echo command in order to create two different headers "Feature_name" and "Sequence_length" which will be useful to any user reading the output.
# The cat function is used to read in the data set which is saved in the working directory.
# awk is used to extract the entries that contain verified ORFs.
# awk is then used to create a new column which contains the length of the sequence. 
# 	This is completed by subtracting the start coordinate of the seq from the stop coordinate of the seq. 
#	Given that awk cannot determine the absolute value of a number the square root of the squared column value is taken.
# The output file is then numerically sorted in ascending order according to the second column (sequence length).
# tail is used to show the last (and biggest) 100 entries.
# The output of this script is appended to the output_path variable (SGD_features_output.tab).
# Therefore, the output file will contain two columns which contain the feature name and the length of the of the sequence.

# Resources used:
# https://stackoverflow.com/questions/11184915/absolute-value-in-awk-doesnt-work
# https://datacarpentry.org/shell-genomics/03-working-with-files/index.html#examining-files
# I also had help from Dr. Cartwright with this assignment.

#----------------------------------------------------------------

# Creates a variable called data_url which contains the tab file detailing yeast chromosome data. This file is located within the working directory.
data_url="SGD_features.tab"

# Creates a variable called output_path which is routed to a blank tab file called SGD_features_output.tab
output_path=SGD_features_output.tab

# Will display the string "Feature_name , Sequence_length" at the top of the tab file
echo "Feature_name , Sequence_length" > "${output_path}"

# Reads the data from directory
cat "${data_url}" |

# Filters for verified ORFs
	awk -F '\t' '$2 == "ORF" && $3 == "Verified"' | 
 
# Creates a column that calculates the length of the sequence (stop coordinate - start coordinate)
	awk -F '\t' '{$17=$11-$10; print $4, sqrt($17^2)}' | # NOTE: No way to print absolute value in awk so a work around is used

# Sorts file numerically by the sequence length column in ascending order 	
	sort -k2,2n |

# Shows 100 longest entries by displaying only the last 100 entries. This output is then appended and saved in the output_path variable (tab file) made at the beginning.
	tail -n 100 >> "${output_path}"

#----------------------------------------------------------


