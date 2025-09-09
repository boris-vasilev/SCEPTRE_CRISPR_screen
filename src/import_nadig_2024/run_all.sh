#$ -l m_mem_free=4G

Rscript download_raw_1.R # download raw data
Rscript organize_data_2.R # organize the data into directories
Rscript create_grna_table_3.R # create the grna data table
Rscript create_sceptre_objects_4.R # create the ondisc-backed sceptre_object
