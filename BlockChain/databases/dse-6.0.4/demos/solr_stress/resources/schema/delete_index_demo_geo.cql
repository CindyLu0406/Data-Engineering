DROP SEARCH INDEX ON demo.geo WITH OPTIONS { deleteResources : false, deleteDataDir : true };

TRUNCATE demo.geo;

RELOAD SEARCH INDEX ON demo.geo;
