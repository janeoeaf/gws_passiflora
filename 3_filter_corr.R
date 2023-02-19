rm(list=ls())
library(dplyr)
library(tidyr)
snp=readr::read_csv('./tmp/2_snp_after_callrate_maf.csv')
corr_threshold=.95

snp_name=snp$snp_id

snp2=t(as.matrix(snp[,-1]))

rr=cor(snp2,use='pa')
colnames(rr)<-snp$snp_id
rr2=data.frame(snp_1=snp$snp_id,rr,stringsAsFactors = F)

corr<-melt(data=rr2,id.vars='snp_1',variable.name = 'snp_2',value.name = 'r') %>%
  mutate(snp_2=as.character(snp_2)) %>%
  filter(snp_1<snp_2) %>%
  mutate(r2=r^2) %>% arrange(snp_1,snp_2) %>%
  mutate(drop=ifelse(r2>corr_threshold,snp_1,'none'))

readr::write_csv(corr,'./tmp/3_corralation_snp.csv')



snp2=snp %>% filter(!snp_id%in%corr$drop)

readr::write_csv(snp2,'./tmp/3_snp_after_callrate_maf_corr.csv')


