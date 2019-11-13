DROP SEARCH INDEX ON demo.geort WITH OPTIONS { deleteResources : false, deleteDataDir : true };

TRUNCATE demo.geort;

RELOAD SEARCH INDEX ON demo.geort;
