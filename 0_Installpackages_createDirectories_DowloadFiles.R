install.packages('BGLR')
install.packages('rrBLUP')
install.packages('dplyr')
install.packages('readr')
install.packages('tidyr')
install.packages('reshape2')


dir.create('./dowload')
dir.create('./intput')
dir.create('./tmp')
dir.create('./output')




install.packages('aws.s3')
library(aws.s3)

bucket='uenf'

snp=s3read_using(FUN=read.csv,object ='debora/Dados_SNPs_Maracuja_UENF_15_11_21 - 21140 SNPs CR_0.8 + metrica MAF.csv' ,bucket = bucket)
phe=s3read_using(FUN=read.csv,object ='debora/Fenotipagem 150 ind.xlsx - Plan1.csv' ,bucket = bucket)

#readr::write_csv(snp,'./dowload/snp.csv')
#readr::write_csv(phe,'./dowload/phenotypes.csv')

s3write_using(snp,FUN=read.csv,object='debora/dowload/snp.csv',bucket = bucket)
s3write_using(phe,FUN=read.csv,object='debora/dowload/phenotypes.csv',bucket = bucket)
