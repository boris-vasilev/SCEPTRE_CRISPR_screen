# load R.utils; increase timeout to 5 hours
library(R.utils)
options(timeout = 10 * 60 * 60)

data_dir <- "/home/biv22/rds/rds-mrc-bsu-csoP2nj6Y6Y/biv22/SCEPTRE/data"

# create raw directory; also create subdirectories for the four datasets
raw_data_dir <- file.path(data_dir, "raw")
raw_data_dir_rep <- file.path(raw_data_dir, c("hepg2", "jurkat"))
for (dir in raw_data_dir_rep) {
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
}

# Download MTX files
print("Downloading Jurkat and Hep2G data")
jurkat_hep2g_url <- "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE264667&format=file"
dest <- file.path(raw_data_dir, "GSE264667_RAW.tar")
download.file(url = jurkat_hep2g_url, destfile = dest)
untar(dest, exdir = "GSE264667")
files <- list.files(paste0(dest, "GSE264667"), pattern = "hepg2", full.names = TRUE)
file.rename(files, file.path("hepg2", basename(files)))
files <- list.files(paste0(dest, "GSE264667"), pattern = "jurkat", full.names = TRUE)
file.rename(files, file.path("jurkat", basename(files)))

# Download gRNA library table
download.file(url="https://ars.els-cdn.com/content/image/1-s2.0-S0092867422005979-mmc1.xlsx",
              destfile=file.path(raw_data_dir, "mmc1.xlsx"))
