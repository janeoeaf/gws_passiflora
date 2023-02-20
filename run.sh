echo 0_Installpackages_createDirectories_DowloadFiles.R
Rscript 0_Installpackages_createDirectories_DowloadFiles.R

echo 1_organize_input.R
Rscript 1_organize_input.R

echo 2_filter_snp.R
Rscript 2_filter_snp.R

echo 3_filter_corr.R
Rscript 3_filter_corr.R

echo 4_gws_rrblup.R
Rscript 4_gws_rrblup.R

echo 5_crossvalidation_5fold_rrblup.R
Rscript 5_crossvalidation_5fold_rrblup.R

echo 6_gws_heritability_gblup.R
Rscript 6_gws_heritability_gblup.R
