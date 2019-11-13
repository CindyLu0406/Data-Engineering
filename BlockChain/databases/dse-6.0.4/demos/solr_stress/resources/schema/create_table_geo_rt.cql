CREATE KEYSPACE IF NOT EXISTS demo WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

CREATE TABLE IF NOT EXISTS demo.geort (id VARCHAR PRIMARY KEY, name VARCHAR, latitude VARCHAR,
                                       longitude VARCHAR, country VARCHAR, timezone VARCHAR,
                                       published VARCHAR, text TEXT);
