#!/usr/bin/env Rscript

library(sceptre)
data_dir <- "/home/biv22/rds/rds-mrc-bsu-csoP2nj6Y6Y/biv22/SCEPTRE/data"

create_sceptre_obj <- function(cell_line) {
  # cellranger output directories
  directories <- list.files(file.path(data_dir, "raw", cell_line), pattern="batch_", full.names = TRUE)
  # grna target data frame
  grna_target_data_frame <- readRDS(file.path(data_dir, "raw", cell_line, "grna_table.rds"))
  # directory to write
  directory_to_write <- file.path(data_dir, "processed", cell_line)
  # import data into sceptre_object; write sceptre_object without setting analysis params
  sceptre_object <- import_data_from_cellranger(directories = directories,
                                                moi = "low",
                                                grna_target_data_frame = grna_target_data_frame,
                                                use_ondisc = TRUE,
                                                directory_to_write = directory_to_write)
  write_ondisc_backed_sceptre_object(sceptre_object, directory_to_write)
}

create_sceptre_obj("jurkat")
create_sceptre_obj("hepg2")
