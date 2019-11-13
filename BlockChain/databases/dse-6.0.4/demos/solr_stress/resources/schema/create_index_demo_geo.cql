DROP SEARCH INDEX ON demo.geo;

CREATE SEARCH INDEX ON demo.geo WITH COLUMNS * { docValues : true } AND
                                     CONFIG { defaultQueryField : 'name' };

ALTER SEARCH INDEX SCHEMA ON demo.geo ADD types.fieldType[@name='TextShingle',
                                                          @class='solr.TextField',
                                                          @positionIncrementGap='100'];

ALTER SEARCH INDEX SCHEMA ON demo.geo ADD types.fieldType[@name='TextShingle']
                                               .analyzer
                                               .tokenizer[@class='solr.StandardTokenizerFactory'];

ALTER SEARCH INDEX SCHEMA ON demo.geo ADD types.fieldType[@name='TextShingle']
                                               .analyzer
                                               .filter[@class='solr.LowerCaseFilterFactory'];

ALTER SEARCH INDEX SCHEMA ON demo.geo ADD types.fieldType[@name='TextShingle']
                                               .analyzer
                                               .filter[@class='solr.ShingleFilterFactory',
                                                       @maxShingleSize='2',
                                                       @outputUnigrams='true'];

ALTER SEARCH INDEX SCHEMA ON demo.geo ADD fields.field[@name='name_shingle',@type='TextShingle',
                                                       @indexed='true',@stored='false'];

ALTER SEARCH INDEX SCHEMA ON demo.geo ADD copyField[@source='name',@dest='name_shingle'];

RELOAD SEARCH INDEX ON demo.geo;
