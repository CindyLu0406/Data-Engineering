CREATE KEYSPACE IF NOT EXISTS wiki WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

CREATE TABLE IF NOT EXISTS wiki.solr (id VARCHAR PRIMARY KEY, body TEXT, title TEXT, date VARCHAR);

DROP SEARCH INDEX ON wiki.solr;

CREATE SEARCH INDEX ON wiki.solr with COLUMNS * { docValues : true } AND
                                      CONFIG { defaultQueryField : 'body' };

ALTER SEARCH INDEX SCHEMA ON wiki.solr ADD fieldType[@name='TextField',@class='solr.TextField'] WITH $${"analyzer":{"tokenizer":{"class":"solr.WikipediaTokenizerFactory"}}}$$;

ALTER SEARCH INDEX SCHEMA ON wiki.solr SET fields.field[@name='date']@type = 'StrField';
ALTER SEARCH INDEX SCHEMA ON wiki.solr SET fields.field[@name='body']@type = 'TextField';
ALTER SEARCH INDEX SCHEMA ON wiki.solr SET fields.field[@name='title']@type = 'TextField';

ALTER SEARCH INDEX SCHEMA ON wiki.solr SET fields.field[@name='date']@docValues = true;
ALTER SEARCH INDEX SCHEMA ON wiki.solr SET fields.field[@name='title']@docValues = false;
ALTER SEARCH INDEX SCHEMA ON wiki.solr SET fields.field[@name='body']@docValues = false;

RELOAD SEARCH INDEX ON wiki.solr;
