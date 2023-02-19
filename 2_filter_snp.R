rm(list=ls())

snp=readr::read_csv('./intput/1_snp.csv')
call_rate_ind=.9
call_rate_snp=.95
maf=.05


n_gen=function(x,value) return(sum(x[!is.na(x)]==value))
n_missing=function(x) return(sum(is.na(x)))
n_nonmissing=function(x) return(sum(!is.na(x)))


#---summary individuals

ind_statistics=data.frame(
  id=colnames(snp[,-1]),
  n_0=apply(snp[,-1],2,n_gen,0),
  n_1=apply(snp[,-1],2,n_gen,1)
  ,n_2=apply(snp[,-1],2,n_gen,2),
  n_missing=apply(snp[,-1],2,n_missing),
  n_nonmissing=apply(snp[,-1],2,n_nonmissing),
  n_total=nrow(snp)
) %>% dplyr::mutate(call_rate=n_nonmissing/n_total,
                    class=ifelse(call_rate<call_rate_ind,'drop_callrate','keep'))


snp2=snp[,c(T,ind_statistics$class=='keep')]


#---summary snp

snp_statistics=data.frame(
            snp_id=snp2$snp_id,
            n_0=apply(snp2[,-1],1,n_gen,0),
            n_1=apply(snp2[,-1],1,n_gen,1),
            n_2=apply(snp2[,-1],1,n_gen,2),
            n_missing=apply(snp2[,-1],1,n_missing),
            n_nonmissing=apply(snp2[,-1],1,n_nonmissing),
            n_total=ncol(snp2[,-1])
            
           ) %>%
  dplyr::mutate(call_rate=n_nonmissing/n_total,
                P=n_0/n_nonmissing,
                H=n_1/n_nonmissing,
                Q=n_2/n_nonmissing,
                p=P+H/2,
                q=Q+H/2,
                MAF=ifelse(p<q,p,q)) %>%
          mutate(class=ifelse(call_rate<call_rate_snp,'drop_callrate','keep'),
                 class=ifelse(class=='keep' & MAF<maf,'drop_maf',class),
                 class=ifelse(class=='keep' & H>.99,'drop_only_heterozygotes',class)
                 )

snp3=snp2[snp_statistics$class=='keep',]


readr::write_csv(snp3,'./tmp/2_snp_after_callrate_maf.csv')
readr::write_csv(ind_statistics,'./tmp/2_individual_summary_callrate.csv')
readr::write_csv(snp_statistics,'./tmp/2_snp_summary_callrate_maf.csv')

