library(tidyr)
library(readr)
library(dplyr)
library(ggplot2)
library(data.table)
library(plyr)
library(stringr)

oak = "/oak/stanford/groups/dekas/sequences/OAST/orca_basin2023/JGI_MGMT_2024/Raw_Data/fastq/"
rootdir = "/scratch/users/rsalcedo/orca_JGI/"

# define the source and destination dir
source_dir <- oak
destination_dir <- paste0(rootdir, "reads/raw_reads/")

# create destination directory 
dir.create(destination_dir)

summary_df <- data.frame(Old_File = character(), New_File = character(), stringsAsFactors = FALSE)

# get file list
files <- list.files(source_dir, full.names = TRUE)

for (file in files) {
  # get file basename
  file_name <- basename(file)
  
  # only get the DNA files
  if (str_detect(file_name, "DNA")) {
    
    # use regex to capture sample name
    new_file_name <- str_extract(file_name, "^.*?DNA_")
    
    # add filter to the new file name if they are the filtered reads
    if (str_detect(file_name, "filter")) {
      new_file_name <- paste0(new_file_name, "filter.fastq.gz")
    } else {
      new_file_name <- paste0(new_file_name, "fastq.gz")
    }
    
    destination_file <- file.path(destination_dir, new_file_name)
    file.copy(file, destination_file)
    
    # make summary df to track which file ended up where and save it
    summary_df <- rbind(summary_df, data.frame(Old_File = file, New_File = destination_file))
  }
}

write.csv(summary_df, paste0(rootdir, "/file_transfer_log.csv"), row.names = FALSE)

