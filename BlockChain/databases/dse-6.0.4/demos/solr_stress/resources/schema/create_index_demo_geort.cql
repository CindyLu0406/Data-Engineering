CREATE KEYSPACE IF NOT EXISTS demo WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

CREATE TABLE IF NOT EXISTS demo.geort (id VARCHAR PRIMARY KEY, name VARCHAR, latitude VARCHAR,
                                       longitude VARCHAR, country VARCHAR, timezone VARCHAR,
                                       published VARCHAR, text TEXT);

DROP SEARCH INDEX ON demo.geort;

CREATE SEARCH INDEX ON demo.geort WITH COLUMNS * { docValues : true } AND
                                       CONFIG { realtime : true, defaultQueryField : 'name' };

ALTER SEARCH INDEX SCHEMA ON demo.geort ADD types.fieldType[@name='TextShingle',
                                                            @class='solr.TextField',
                                                            @positionIncrementGap='100'];

ALTER SEARCH INDEX SCHEMA ON demo.geort ADD types.fieldType[@name='TextShingle']
                                                 .analyzer
                                                 .tokenizer[@class='solr.StandardTokenizerFactory'];

ALTER SEARCH INDEX SCHEMA ON demo.geort ADD types.fieldType[@name='TextShingle']
                                                 .analyzer
                                                 .filter[@class='solr.LowerCaseFilterFactory'];

ALTER SEARCH INDEX SCHEMA ON demo.geort ADD types.fieldType[@name='TextShingle']
                                                 .analyzer
                                                 .filter[@class='solr.ShingleFilterFactory',
                                                         @maxShingleSize='2',
                                                         @outputUnigrams='true'];

ALTER SEARCH INDEX SCHEMA ON demo.geort ADD fields.field[@name='name_shingle',@type='TextShingle',
                                                         @indexed='true',@stored='false'];

ALTER SEARCH INDEX SCHEMA ON demo.geort ADD copyField[@source='name',@dest='name_shingle'];

RELOAD SEARCH INDEX ON demo.geort;
