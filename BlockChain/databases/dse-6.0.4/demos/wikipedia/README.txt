DataStax Enterprise Search
==========================

This package contains integration between Apache Cassandra and Apache Solr.
Much like DataStax Enterprise Analytics you can partition your workloads
to support free-text search on data in your Cassandra Column Families.

You can also simply use it as a scalable Solr replacement.
DSE Search is built with Solr 4.x and features near real-time search.

== Mapping Cassandra and Solr Concepts ==

 ---------------------------
|  Cassandra    | Solr      |
 ---------------------------
| Column Family | Core      |
| Row Key       | UniqueKey |
| Column        | Field     |
| Node          | Shard     |
 ---------------------------

== Getting Started ==

To use DSE Search you need a Solr schema.xml that defines the
relationship between data in a column family and a Solr core.

This involves identifying the columns you wish to index in Solr
and matching up their names with the corresponding Solr types.

Data is indexed locally in Solr but the original source of the raw data
remains stored in Cassandra.

You can write to the index either by writing directly to the Cassandra
Column Family or you can writing to the Solr Core via the Solr API.
If the column family does not exist one will be created for you.

You can search the index via Solr. Internally DSE Search will manage the routing
to other nodes in the cluster, so you can simply treat it like a single Solr instance.
Replication, failover and scaling will be seamlessly managed by Cassandra.

Other benefits of DSE Search include the ability to run Hadoop MapReduce on the data via DSE Analytics.
Also, since the data lives in Cassandra you can reindex all your data or change your schema without
manually re-indexing by hand.  Finally, you can update individual columns under a row in Cassandra
and know that it will be reflected in search.

== Running Wikipedia Demo ==

To begin with DataStax Enterprise Search, start the server with the following:
    ./bin/dse cassandra -s

The "-s" denotes search and will start the Solr container inside of DSE.

Enter the wikipedia demo directory:
    cd ./demos/wikipedia

Add the Cassandra table and search index:
    ./1-add-schema.sh [options]

    Options:
        --ssl       use SSL for Cassandra table creation over cqlsh
        -h HOST     hostname for cqlsh
        -u USERNAME username for plain text authentication
        -p PASSWORD password for plain text authentication

Next start indexing articles (~3500 articles):
    ./2-index.sh --wikifile wikipedia-sample.bz2

Finally, to see a sample Wikipedia search UI open your web browser to
	http://localhost:8983/demos/wikipedia/

You can also inspect the index with the regular Solr admin tool
    http://localhost:8983/solr/#/

== Integration with Cassandra APIs ==

DSE Search also has hooks into existing CQL and Thrift
APIs.  Assuming you have data indexed in Solr from a column family
you can include a solr_query predicate to CQL.

Example:

use wiki;
select title from solr where solr_query='title:natio* AND title:[2000 TO 2010]';

The value supports any Lucene syntax
http://lucene.apache.org/java/2_9_1/queryparsersyntax.html

== Integration with DSE Analytics (Hadoop) ===

DSE Enterprise supports partitioning your cluster by workload
http://docs.datastax.com/en/datastax_enterprise/latest/datastax_enterprise/deploy/deployWkLdSep.html

By using this approach its possible to make some of your DSE nodes handle
search while others handle Map Reduce, or just act as plain vanilla Cassandra nodes.

This means you can injest data from an external data source and have the data indexed
by Solr on some nodes while other nodes are used to run Map Reduce over the same data.
Cassandra handles the replication and isolation of resources.

== Advanced Information ==

If you want to increase the replication factor of your Solr index you must update the keyspace and repair the Cassandra nodes.

== Limitations ==

Currently the known issues are:

  - On shutdown Tomcat complains of leaked resources.
