#install.packages('BGLR')
#install.packages('rrBLUP')
#install.packages('dplyr')
# install.packages('readr')

install.packages("boot")
install.packages("class")
install.packages("codetools")
install.packages("foreign")
install.packages("MASS")
install.packages("Matrix")
install.packages("nlme")
install.packages("spatial")
install.packages("survival")

install.packages("BiocManager")
BiocManager::install("bibtex")
BiocManager::install("snpStats")
install.packages('bigsnpr')



dir.create('./dowload')
dir.create('./intput')
dir.create('./tmp')
dir.create('./output')




#install.packages('aws.s3')
library(aws.s3)

bucket='uenf'

snp=s3read_using(FUN=read.csv,object ='debora/Dados_SNPs_Maracuja_UENF_15_11_21 - 21140 SNPs CR_0.8 + metrica MAF.csv' ,bucket = bucket)
phe=s3read_using(FUN=read.csv,object ='debora/Fenotipagem 150 ind.xlsx - Plan1.csv' ,bucket = bucket)

readr::write_csv(snp,'./dowload/snp.csv')
readr::write_csv(phe,'./dowload/phenotypes.csv')
