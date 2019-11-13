#!/bin/bash

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
"$DIR"/delete-index.sh -s delete-index-geo.sh -c delete_index_demo_geo.cql -i demo.geo $@
