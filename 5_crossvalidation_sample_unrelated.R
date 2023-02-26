rm(list=ls())
library(rrBLUP)
library(reshape2)
library(dplyr)
library(stats)

k=5
phe=readr::read_csv('./input/pheno.csv')
snp=readr::read_csv('./tmp/3_snp_after_callrate_maf_corr.csv')
pedigree=readr::read_csv('./input/pedigree.csv')

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
    #set.seed(1)
    #gr=sample(rep(1:k,length=nrow(d)),size = nrow(d),re=F)
    GRM=A.mat(Z-1)
    gr=kmeans(x=GRM,centers = k)$cluster
    
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

#readr::write_csv('./tmp/5_gebv_rrblup_crossvalidation_check.csv')
readr::write_csv('./tmp/5_5fold_rrblup.csv')
