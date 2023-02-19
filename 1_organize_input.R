rm(list=ls())
library(dplyr)

#phe=readr::read_csv('./dowload/phenotypes.csv')
#snp=readr::read_csv('./dowload/snp.csv',na='-')[1:21140,1:159] %>% distinct() %>% mutate(snp_id=paste0('snp',1:n()))


bucket='uenf'
snp=s3read_using(FUN=read.csv,object='debora/dowload/snp.csv',bucket = bucket)[1:21140,1:159] %>% distinct() %>% mutate(snp_id=paste0('snp',1:n()))
phe=s3read_using(FUN=read.csv,object='debora/dowload/phenotypes.csv',bucket = bucket)

snp_info=snp %>% distinct(SNP.CloneID,ClusterConsensusSequence,SNP.variant,snp_id)


snp2=snp[,-c(1:3)]


#readr::write_csv(snp2[,ncol(snp2):1],'./intput/1_snp.csv')
#readr::write_csv(phe[,-c(1:2)],'./intput/1_pheno.csv')
#readr::write_csv(snp_info,'./intput/1_snp_info.csv')


s3write_using(snp2[,ncol(snp2):1],FUN=readr::write_csv,object='debora/input/1_snp.csv',bucket = bucket)
s3write_using(phe[,-c(1:2)],FUN=readr::write_csv,object='debora/input/1_pheno.csv',bucket = bucket)
s3write_using(snp_info,FUN=readr::write_csv,object='debora/input/1_snp_info.csv',bucket = bucket)

