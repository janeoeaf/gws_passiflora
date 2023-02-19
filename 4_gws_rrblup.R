rm(list=ls())
library(rrBLUP)
library(aws.s3)
library(reshape2)

bucket='uenf'
phe=s3read_using(FUN=readr::read_csv,object='debora/input/1_pheno.csv',bucket = bucket)
snp=s3read_using(FUN=readr::read_csv,object='debora/tmp/3_snp_after_callrate_maf_corr.csv',bucket=bucket)

impute_fun=function(x){
  x[is.na(x)]<-mean(x,na.rm=T)
  return(x)
}

snp2=t(snp[,-1])
colnames(snp2)<-snp$snp_id
snp3=data.frame(id=rownames(snp2),apply(snp2, 2, impute_fun))
colnames(phe)[1]<-'id'
traits=colnames(phe)[-1]

gebv_out=NULL
snp_eff_out=NULL
tr=traits[1]
for(tr in traits){

    d=inner_join(phe[,c('id',tr)],snp3)
    y=as.matrix(d[,2])
    Z=as.matrix(d[,-c(1,2)])
    
    fit=mixed.solve(y=y,Z=Z)
    
    snp_eff=data.frame(trait=tr,snp_id=names(fit$u),alpha=fit$u,model='RR-BLUP')
    gebv=data.frame(id=d[,1],pheno=y[,1],gebv=Z%*%fit$u,trait=tr,model='RR-BLUP')
  
    gebv_out=gebv %>% bind_rows(gebv_out)
    snp_eff_out=snp_eff %>% bind_rows(snp_eff_out)
    
}


s3write_using(gebv_out,FUN=readr::write_csv,object='debora/tmp/4_gebv_rrblup.csv',bucket=bucket)
s3write_using(snp_eff_out,FUN=readr::write_csv,object='debora/tmp/4_snp_eff_rrblup.csv',bucket=bucket)
