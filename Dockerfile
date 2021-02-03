ARG mykrobe_version=0.9.0

FROM mongo AS builder
ARG mykrobe_version

RUN apt-get update && apt-get install -y git python3-pip python3-setuptools libz-dev unzip

WORKDIR /usr/src/app

# Install Mykrobe
RUN git clone --branch v${mykrobe_version} https://github.com/Mykrobe-tools/mykrobe.git mykrobe-predictor
WORKDIR /usr/src/app/mykrobe-predictor
RUN pip3 install -r requirements.txt && python3 setup.py install

RUN mkdir /mongo-db

WORKDIR /usr/src/app
COPY . .

WORKDIR /usr/src/app/data
RUN unzip 20181031_cortex_decomp_200_vcfs_no_indels.zip
RUN nohup bash -c "mongod --quiet --dbpath /mongo-db &" && \
    sleep 10 && \
    for f in `ls *.vcf`; do mykrobe variants add --db_name mtb $f NC_000962.3.fasta -m CORTEX_DECOMP; done && \
    mongodump -d atlas-mtb -o mongodump/ && \
    mongorestore -d mykrobe-mtb mongodump/atlas-mtb && \
    mongod --shutdown --dbpath /mongo-db

FROM mongo
COPY --from=builder /mongo-db /mongo-db

CMD mongod --quiet --dbpath /mongo-db
