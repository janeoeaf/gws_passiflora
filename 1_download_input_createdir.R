
#---creating folders
dir.create('./input')
dir.create('./tmp')
dir.create('./output')
bucket=Sys.getenv('bucket')
#---download
snp=aws.s3::s3read_using(FUN=readr::read_csv,object='debora/input/snp.csv',bucket = bucket)
pheno=aws.s3::s3read_using(FUN=readr::read_csv,object='debora/input/pheno.csv',bucket = bucket)
pedigree=aws.s3::s3read_using(FUN=readr::read_csv,na='-',object='debora/input/pedigree.csv',bucket = bucket)
snp_info=aws.s3::s3read_using(FUN=readr::read_csv,na='-',object='debora/input/snp_info.csv',bucket = bucket)

#---save local
readr::write_csv(snp,'./input/snp.csv')
readr::write_csv(pheno,'./input/pheno.csv')
readr::write_csv(pedigree,'./input/pedigree.csv')
readr::write_csv(snp_info,'./input/snp_info.csv')