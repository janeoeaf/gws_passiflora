mkdir -p input
mkdir -p tmp
mkdir -p output

aws s3 sync s3://uenf/debora/input/ ./input/


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
