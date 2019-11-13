CREATE KEYSPACE IF NOT EXISTS demo WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

CREATE TABLE IF NOT EXISTS demo.solr (id VARCHAR PRIMARY KEY, type VARCHAR, text TEXT);
