DROP SEARCH INDEX ON demo.solr WITH OPTIONS { deleteResources : false, deleteDataDir : true };

TRUNCATE demo.solr;

RELOAD SEARCH INDEX ON demo.solr;
