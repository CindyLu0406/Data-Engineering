#!/bin/bash

HOST=`hostname -f`

while true
do
    if [ ! $1 ]; then break; fi
        case $1 in
            -h)
                HOST=$2
                shift
                ;;
            -p)
                CQLSH_PASSWORD=$2
                shift
                ;;
            -u)
                CQLSH_USERNAME=$2
                shift
                ;;
            --ssl)
                SSL_ENABLED=1
                ;;
        esac
        shift
done

cd `dirname $0`

if [ -x ../../bin/cqlsh ]; then
  CQLSH_BIN=../../bin/cqlsh
elif [ -x /usr/bin/cqlsh ]; then
  CQLSH_BIN=/usr/bin/cqlsh
else
  CQLSH_BIN=cqlsh
fi

CQLSH_OPTIONS="$HOST"

if [ ! -z $SSL_ENABLED ]; then
    CQLSH_OPTIONS="$CQLSH_OPTIONS --ssl"
fi

if [ ! -z $CQLSH_USERNAME ]; then
    CQLSH_OPTIONS="$CQLSH_OPTIONS -u $CQLSH_USERNAME"
fi

if [ ! -z $CQLSH_PASSWORD ]; then
    CQLSH_OPTIONS="$CQLSH_OPTIONS -p $CQLSH_PASSWORD"
fi

echo "Creating search index wiki.solr..."
"$CQLSH_BIN" $CQLSH_OPTIONS <create_search_index.cql
echo "Search index created..."
