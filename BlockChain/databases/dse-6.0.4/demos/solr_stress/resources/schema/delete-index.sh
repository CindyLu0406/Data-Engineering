#!/bin/bash

FORCE=0
SCRIPT="delete-index.sh"
CQL_SCRIPT="delete_index_demo_solr.cql"
SEARCH_INDEX="demo.solr"

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

usage() {
   echo
   echo "Usage: ./$SCRIPT [-h <HOST>] [-u <USERNAME>] [-p <PASSWORD>] [--ssl enable ssl] [-f force delete]"
   echo
}

ARGS=""
while true
do
    if [ ! $1 ]; then break; fi
        case $1 in
            -s)
                SCRIPT=$2
                shift
                ;;
            -c)
                CQL_SCRIPT=$2
                shift
                ;;
            -i)
                SEARCH_INDEX=$2
                shift
                ;;
            -f)
                FORCE=1
                ;;
            *)
                ARGS="$ARGS $1"
                ;;
        esac
        shift
done

if [ "$FORCE" = "0" ]; then
    while true; do
        usage
        read -p "Do you wish to delete all data from the search index on $SEARCH_INDEX [y/n]? " yn
        case $yn in
          [Yy]* ) break;;
          [Nn]* ) exit;;
          * ) echo "Please answer y or n.";;
      esac
   done
fi

echo "Deleting all data from the search index on $SEARCH_INDEX with $CQL_SCRIPT..."

"$DIR"/execute-cql.sh -t "$DIR/"$CQL_SCRIPT $ARGS

echo "All data on $SEARCH_INDEX deleted."
