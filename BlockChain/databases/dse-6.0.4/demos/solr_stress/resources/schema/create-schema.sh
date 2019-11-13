#!/bin/bash

echo "Creating search index on demo.solr with create_table.cql and create_index_demo_solr.cql..."

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
"$DIR"/execute-cql.sh -t "$DIR"/create_table.cql $*
"$DIR"/execute-cql.sh -t "$DIR"/create_index_demo_solr.cql $*

echo "Search index on demo.solr created."
