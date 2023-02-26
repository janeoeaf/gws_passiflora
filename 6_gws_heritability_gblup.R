rm(list=ls())
library(rrBLUP)
library(aws.s3)
library(reshape2)
library(dplyr)


phe=readr::read_csv('./input/pheno.csv')
snp=readr::read_csv('./tmp/3_snp_after_callrate_maf_corr.csv')

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


readr::write_csv('./tmp/6_heritability_gblup.csv')
