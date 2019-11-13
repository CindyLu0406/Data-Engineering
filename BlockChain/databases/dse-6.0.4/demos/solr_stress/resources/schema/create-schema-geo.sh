#!/bin/bash

echo "Creating search index on demo.geo with create_table_geo.cql and create_index_demo_geo.cql..."

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
"$DIR"/execute-cql.sh -t "$DIR"/create_table_geo.cql $*
"$DIR"/execute-cql.sh -t "$DIR"/create_index_demo_geo.cql $*

echo "Search index on demo.geo created."
