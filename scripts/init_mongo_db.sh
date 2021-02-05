#!/bin/bash

if [ ! -d "/database/mongo-db" ]
then
  mkdir -p /database/mongo-db
  mongod --quiet --dbpath /database/mongo-db &
  sleep 10
  cp /data/mongodump.tar.gz /database
  cd /database
  tar xzf mongodump.tar.gz
  mongorestore -d mykrobe-mtb mongodump/atlas-mtb
  sleep 10
  mongod --shutdown --dbpath /database/mongo-db
  sleep 10
fi

mongod --quiet --dbpath /database/mongo-db