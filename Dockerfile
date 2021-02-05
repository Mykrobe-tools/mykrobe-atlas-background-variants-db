FROM mongo

WORKDIR /data

COPY ./data/mongodump.tar.gz .

CMD mongod --quiet --dbpath /database/mongo-db
