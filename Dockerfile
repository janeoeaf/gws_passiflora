FROM rocker/rstudio
WORKDIR /tmp
RUN R --no-save -e "install.packages('BGLR')"
RUN R --no-save -e "install.packages('rrBLUP')"
RUN R --no-save -e "install.packages('dplyr')"
RUN R --no-save -e "install.packages('readr')"
RUN R --no-save -e "install.packages('tidyr')"
RUN R --no-save -e "install.packages('reshape2')"
RUN R --no-save -e "install.packages('aws.s3')"
COPY . .
ENTRYPOINT /bin/bash ./run.sh 
