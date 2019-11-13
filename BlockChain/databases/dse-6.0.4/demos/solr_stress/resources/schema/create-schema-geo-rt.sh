#!/bin/bash

echo "Creating search index on demo.geort with create_table_geo_rt.cql and create_index_demo_geort.cql..."

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
"$DIR"/execute-cql.sh -t "$DIR"/create_table_geo_rt.cql $*
"$DIR"/execute-cql.sh -t "$DIR"/create_index_demo_geort.cql $*

echo "Search index on demo.geort created."
