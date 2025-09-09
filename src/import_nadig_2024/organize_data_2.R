repl_offsite <- paste0(.get_config_path("LOCAL_REPLOGLE_2022_DATA_DIR"))
jurkat_dir <- file.path(repl_offsite, "jurkat")
hepg2_dir <- file.path(repl_offsite, "hepg2")

organize_files_for_dir <- function(curr_dir) {
  fs <- list.files(curr_dir)
  batch_no <- strsplit(x = fs, split = "_", fixed = TRUE) |> lapply(FUN = function(l) l[3]) |> unlist()
  for (curr_batch_no in unique(batch_no)) {
    dir <- file.path(curr_dir, paste0("batch_", curr_batch_no))
    if (!dir.exists(dir)) dir.create(dir)
  }
  for (i in seq_along(fs)) {
    from <- file.path(curr_dir, fs[i])
    to <- file.path(curr_dir, paste0("batch_", batch_no[i]), fs[i])
    file.rename(from = from, to = to)
  }
}

organize_files_for_dir(jurkat_dir)
organize_files_for_dir(hepg2_dir)
