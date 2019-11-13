DROP SEARCH INDEX ON demo.solr;

CREATE SEARCH INDEX ON demo.solr with COLUMNS * { docValues : true } AND
                                      CONFIG { defaultQueryField : 'text' };

ALTER SEARCH INDEX SCHEMA ON demo.solr SET field[@name='type']@type = 'StrField';

ALTER SEARCH INDEX SCHEMA ON demo.solr set field[@name='type']@docValues = true;

RELOAD SEARCH INDEX ON demo.solr;
