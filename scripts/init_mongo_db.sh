#!/bin/bash

TO_INIT_DB=1

if [ -d "/database/mongo-db" ]
then
  TO_INIT_DB=0
else
  mkdir -p /database/mongo-db
fi

mongod --quiet --dbpath /database/mongo-db &

sleep 10

if [ $TO_INIT_DB -eq 1 ]
then
  cp /data/mongodump.tar.gz /database
  cd /database
  tar xzf mongodump.tar.gz
  mongorestore -d mykrobe-mtb mongodump/atlas-mtb
fi