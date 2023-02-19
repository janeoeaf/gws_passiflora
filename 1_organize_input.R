rm(list=ls())
library(dplyr)

phe=readr::read_csv('./dowload/phenotypes.csv')

snp=readr::read_csv('./dowload/snp.csv',na='-')[1:21140,1:159] %>% distinct() %>% 
  mutate(snp_id=paste0('snp',1:n()))

snp_info=snp %>% distinct(SNP.CloneID,ClusterConsensusSequence,SNP.variant,snp_id)


snp2=snp[,-c(1:3)]


readr::write_csv(snp2[,ncol(snp2):1],'./intput/1_snp.csv')
readr::write_csv(phe[,-c(1:2)],'./intput/1_pheno.csv')
readr::write_csv(snp_info,'./intput/1_snp_info.csv')
