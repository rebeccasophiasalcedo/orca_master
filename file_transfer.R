library(tidyr)
library(readr)
library(dplyr)
library(ggplot2)
library(data.table)
library(plyr)
library(stringr)

oak = "/oak/stanford/groups/dekas/sequences/OAST/orca_basin2023/JGI_MGMT_2024/Raw_Data/fastq/"
rootdir = "/scratch/users/rsalcedo/orca_JGI/"

# Define the source and destination directories
source_dir <- oak
destination_dir <- paste0(rootdir, "reads/raw_reads/")

# Create destination directory if it doesn't exist
if (!dir.exists(destination_dir)) {
  dir.create(destination_dir)
}

summary_df <- data.frame(Old_File = character(), New_File = character(), stringsAsFactors = FALSE)

# Get the list of files in the source directory
files <- list.files(source_dir, full.names = TRUE)

# Loop through each file
for (file in files) {
  # Extract the base name of the file (without path)
  file_name <- basename(file)
  
  # Check if 'DNA' is in the file name
  if (str_detect(file_name, "DNA")) {
    
    # Extract everything up to and including the first "DNA_" using a proper regex pattern
    new_file_name <- str_extract(file_name, "^.*?DNA_")
    
    # Check if 'filter' is in the file name
    if (str_detect(file_name, "filter")) {
      # Add '_filter' if 'filter' is in the original file name
      new_file_name <- paste0(new_file_name, "filter.fastq.gz")
    } else {
      # Otherwise, just append '.fastq.gz'
      new_file_name <- paste0(new_file_name, "fastq.gz")
    }
    
    # Define the full path for the destination file
    destination_file <- file.path(destination_dir, new_file_name)
    
    # Copy the file to the destination directory with the new name
    file.copy(file, destination_file)
    
    # Add the old and new file paths to the summary dataframe
    summary_df <- rbind(summary_df, data.frame(Old_File = file, New_File = destination_file))
  }
}

write.csv(summary_df, paste0(rootdir, "/file_transfer_log.csv"), row.names = FALSE)

