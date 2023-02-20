rm(list=ls())
library(rrBLUP)
library(aws.s3)
library(reshape2)
library(dplyr)

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

h2_out=NULL
tr=traits[1]
for(tr in traits){

    d=inner_join(phe[,c('id',tr)],snp3)
    y=as.matrix(d[,2])
    Z=as.matrix(d[,-c(1,2)])
    GRM=A.mat(Z-1)
    
    fit=mixed.solve(y=y,K=GRM)
    
    Vg=fit$Vu
    Ve=fit$Ve
    Vp=Vg+Ve
    h2=Vg/Vp
    n=sum(!is.na(y))
    out=data.frame(trait=tr,Vg=Vg,Ve=Ve,Vp=Vp,h2=h2,n=n,model='GBLUP')
    h2_out=out %>% bind_rows(h2_out)
}


s3write_using(h2_out,FUN=readr::write_csv,object='debora/tmp/6_heritability_gblup.csv',bucket=bucket)
