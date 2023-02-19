rm(list=ls())
library(rrBLUP)
library(aws.s3)
library(reshape2)

bucket='uenf'
k=5
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
    d=d[!is.na(d[,2]),]
    set.seed(1)
    gr=sample(rep(1:k,length=nrow(d)),size = nrow(d),re=F)
    y=as.matrix(d[,2])
    Z=as.matrix(d[,-c(1,2)])
    
    for(kk in 1:k){
        yk=y
        yk[gr==kk,1]<-NA
        fit=mixed.solve(y=yk,Z=Z)
        
        gebv=data.frame(id=d[,1],pheno=y[,1],gebv=Z%*%fit$u,trait=tr,model='RR-BLUP',k=kk,gr=gr) %>%
          filter(gr==k) %>% dplyr::select(-gr)
      
        gebv_out=gebv %>% bind_rows(gebv_out)
    }

}


results=gebv_out %>% group_by(model,trait,k) %>% summarise(r=cor(pheno,gebv),n=n())

s3write_using(gebv_out,FUN=readr::write_csv,object='debora/tmp/5_gebv_rrblup_crossvalidation_check.csv',bucket=bucket)
s3write_using(results,FUN=readr::write_csv,object='debora/tmp/5_5fold_rrblup.csv',bucket=bucket)
