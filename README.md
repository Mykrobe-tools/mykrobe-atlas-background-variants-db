# mykrobe-atlas-background-variants-db
A Mongo db which hosts tb background variants to support Mykrobe make probes functionality for Atlas

### Backgound variants DB generation

The background variants are added from 200 VCFs (as found in `data` directory). The population of these
variants could be illustrated by the Docker build steps as below
```dockerfile
WORKDIR /usr/src/app/data
RUN unzip 20181031_cortex_decomp_200_vcfs_no_indels.zip
RUN nohup bash -c "mongod --quiet --dbpath /mongo-db &" && \
    sleep 10 && \
    for f in `ls *.vcf`; do mykrobe variants add --db_name mtb $f NC_000962.3.fasta -m CORTEX_DECOMP; done && \
    mongodump -d atlas-mtb -o mongodump/ && \
    mongorestore -d mykrobe-mtb mongodump/atlas-mtb && \
    mongod --shutdown --dbpath /mongo-db
```

### Docker image

The Docker image created by this repo will be based on MongoDB image. The image also contains a MongoDB dump
from the process above, stored in `/data` directory. It is assumed that the container will reply on an external
volume in which a MongoDB database could be found in `/database/mongo-db`.
