FROM mongo

WORKDIR /data

COPY ./data/mongodump.tar.gz .

WORKDIR /scripts

COPY ./scripts/init_mongo_db.sh .

CMD /scripts/init_mongo_db.sh
