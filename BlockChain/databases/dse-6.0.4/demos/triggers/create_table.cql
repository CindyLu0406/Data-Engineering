CREATE KEYSPACE triggerdemo WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : '1' };
CREATE TABLE triggerdemo.audit (key timeuuid, keyspace_name text, table_name text, primary_key text, PRIMARY KEY(key));

CREATE TABLE triggerdemo.names (first text, last text, PRIMARY KEY(first));
CREATE TRIGGER audittest ON triggerdemo.names USING 'org.apache.cassandra.triggers.AuditTrigger';

COPY triggerdemo.names (first, last) from 'names.csv';
