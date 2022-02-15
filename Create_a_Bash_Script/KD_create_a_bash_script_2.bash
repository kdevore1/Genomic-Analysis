# Create a Bash Script 2

# The purpose of this script is to count the total amounts of sequence length taken up by CDSes, centromeres, pseudogenes, and tRNA_genes (separately) and write them to a file.
# This script begins by making two different variables: one that calls upon the data file in the directory and another which leads to a tab file) that will contain the output.
# The script makes use of the echo command in order to create the header "Total_sequence_length" which will be useful to any user reading the output.
# The script makes use of the echo command in order to create a variable header containing the feature_type which will be useful to avoid mixups.
# The cat function is used to read in the data set which is saved in the working directory.
# awk is used to extract the entries that contain the feature_type of interest.
# awk is then used to create a new column which contains the length of the sequence.
#       This is completed by subtracting the start coordinate of the seq from the stop coordinate of the seq.
#       Given that awk cannot determine the absolute value of a number the square root of the squared column value is taken.
# awk is then used to summate the column and append this to the output file.
# This chain of events is repeated for each feature_type until the output file contains an entry for CDSes, centromeres, pseudogenes, and tRNA_genes.

# Resources used: https://stackoverflow.com/questions/28905083/how-to-sum-a-column-in-awk/28905292
# I received help from Dr. Cartwright.

#-----------------------------------------------------------------------------------------------------------

# Creates a variable called data_url which contains the tab file detailing yeast chromosome data. This file is located within the working directory.
data_url="SGD_features.tab"

# Creates a variable called output_path which is routed to a blank tab file called SGD_features_output_2.tab
output_path=SGD_features_output_2.tab

# Will display the string "Total_sequence_length" at the top of the output file
echo "Total_sequence_length" >> "${output_path}"

# Will display the string "CDS" above the sequence length
echo "CDS" >> "${output_path}"

# Reads the data from directory
cat "${data_url}" |

# Filters feature type for CDS
	awk -F '\t' '$2 == "CDS"' |

# Creates a column that calculates the length of the sequence (stop coordinate - start coordinate)
        awk -F '\t' '{$17=$11-$10; print sqrt($17^2)}' |

# Summates the length column and appends to the output file
	awk -F '\t' '{sum+=$1}END{print sum}' >> "${output_path}"

#----------------------------------------------------------------------------------------------------------
# Will display the string "Centromere" 
echo "Centromere" >> "${output_path}"

# Reads the data from directory
cat "${data_url}" |

# Filters feature_type for centromere
        awk -F '\t' '$2 == "centromere"' |

# Creates a column that calculates the length of the sequence (stop coordinate - start coordinate)
        awk -F '\t' '{$17=$11-$10; print sqrt($17^2)}' |

# Summates the length column and appends to the output file
        awk -F '\t' '{sum+=$1}END{print sum}' >> "${output_path}"

#----------------------------------------------------------------------------------------------------------
# Will display the string "Pseudogene"  
echo "Pseudogene" >> "${output_path}"

# Reads the data from directory
cat "${data_url}" |

# Filters feature_type for pseudogene
        awk -F '\t' '$2 == "pseudogene"' |

# Creates a column that calculates the length of the sequence (stop coordinate - start coordinate)
        awk -F '\t' '{$17=$11-$10; print sqrt($17^2)}' |

# Summates the length column and appends to the output file
        awk -F '\t' '{sum+=$1}END{print sum}' >> "${output_path}"

#------------------------------------------------------------------------------------------------------------
# Will display the string "tRNA_gene"  
echo "tRNA_gene" >> "${output_path}"

# Reads the data from directory
cat "${data_url}" |

# Filters feature_type for tRNA_gene
        awk -F '\t' '$2 == "tRNA_gene"' |

# Creates a column that calculates the length of the sequence (stop coordinate - start coordinate)
        awk -F '\t' '{$17=$11-$10; print sqrt($17^2)}' |

# Summates the length column and appends to the output file
        awk -F '\t' '{sum+=$1}END{print sum}' >> "${output_path}"

#------------------------------------------------------------------------------------------------------------
