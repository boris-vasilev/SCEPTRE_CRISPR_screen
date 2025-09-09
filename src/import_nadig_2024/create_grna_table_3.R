library(tidyverse)
conflicted::conflicts_prefer(dplyr::filter)
data_dir <- "/home/biv22/rds/rds-mrc-bsu-csoP2nj6Y6Y/biv22/SCEPTRE/data/"

make_grna_target_df <- function(xl_fp, features_fp) {
  vector_info_table <- readxl::read_xlsx(path = file.path(data_dir, xl_fp), sheet = 3,
                                         col_names = c("vector_id", "gene_name", "transcript", "grna_target", "grna_a", "target_sequence_a",
                                                       "grna_b", "target_sequence_b", "duplicated", "either_duplicated"), skip = 1) |>
    select(vector_id, grna_target, grna_a, grna_b)
  vector_info_table$grna_a <- paste0(vector_info_table$grna_a, "_posA")
  vector_info_table$grna_b <- paste0(vector_info_table$grna_b, "_posB")
  feature_table <- data.table::fread(input = file.path(data_dir, features_fp),
                                     col.names = c("grna_id", "name", "modality"))
  grna_table <- feature_table |> filter(modality == "CRISPR Guide Capture") |> dplyr::select(grna_id)

  # reshape vector_info_table
  vector_info_table_reshape <- vector_info_table |>
    pivot_longer(cols = c("grna_a", "grna_b"), values_to = "grna_id", names_to = NULL)
  grna_table_updated <- left_join(x = grna_table, y = vector_info_table_reshape, by = "grna_id") |>
    dplyr::arrange(grna_id)
  na_grnas <- is.na(grna_table_updated$grna_target) | is.na(grna_table_updated$vector_id)
  grna_table_updated$grna_target[na_grnas] <- "unknown"
  grna_table_updated$vector_id[na_grnas] <- "unknown"

  x <- grna_table_updated |>
    filter(grna_target != "unknown") |>
    mutate(non_targeting = (grna_target == "non-targeting")) |>
    group_by(non_targeting) |>
    mutate(vector_id_2 = factor(vector_id,
                                levels = unique(vector_id),
                                labels = paste0(ifelse(non_targeting[1], "non-targeting_", "targeting_"),
                                                "vector_", seq_along(unique(vector_id)))) |> as.character()) |>
    arrange(vector_id_2) |>
    ungroup() |>
    mutate(non_targeting = NULL, vector_id = NULL) |>
    rename("vector_id" = "vector_id_2")
  grna_table_final <- rbind(x, grna_table_updated |> filter(grna_target == "unknown"))
  return(grna_table_final)
}

#############
# Jurkat dataset
#############
xl_fp <- "raw/mmc1.xlsx"
features_fp <- "raw/jurkat/batch_1/GSM8225020_jurkat_1_features.tsv.gz"
grna_table_final_jurkat <- make_grna_target_df(xl_fp, features_fp)
# save result
saveRDS(object = grna_table_final_jurkat,
        file = file.path(data_dir, "raw/jurkat/grna_table.rds"))

#############
# hepg2 dataset
#############
xl_fp <- "raw/mmc1.xlsx"
features_fp <- "raw/hepg2/batch_1/GSM8225076_hepg2_1_features.tsv.gz"
grna_table_final_hepg2 <- make_grna_target_df(xl_fp, features_fp)
saveRDS(object = grna_table_final_hepg2,
        file = file.path(data_dir, "raw/hepg2/grna_table.rds"))
