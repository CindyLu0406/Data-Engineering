#A Demonstration Application for the Spark Jobserver

##Summary
This Demo comes with a Jar which is capable of doing four things:

* create: Create a table in C* and fill it with some data
* cache: Cache the table to a Jobserver NamedRDD
* uncache: Uncache a NamedRDD
* sum: Sum a row from a NamedRDD

These tasks can be accomplished by issuing commands via curl to the
Spark Jobserver after uploading the Application jar. This is an example of providing
shared access to an RDD for multiple users to do work on a Cassandra Table
without requiring constant access to a Cassandra cluster. 

##Starting the Jobserver
Starting the jobserver will launch an application via Spark Submit with all of
the requisite DSE classpath additions. This will incorporate any of the current
security settings.

    dse spark-jobserver start

The "spark-submit" process should now be observable running when `jps` is called.

    $ jps
    66907 Jps
    66590 SparkSubmit    //Spark Jobserver
    66026 DseModule      //DataStax Enterprise (Including C* and Spark Master)
    66036 DseSparkWorker //Spark Worker

##Building the Application Jar (Optional)
The demo should already be built into the DemoSparkJob.jar file. If you want
to rebuild it from the included source, change into the demos/spark-jobserver
directory and run:

    ./gradlew jar

##Submitting the Jar to the Jobserver
The Spark Jobserver requires jars to be uploaded and named before running any
job on them. This can be accomplished using any http compatible tool. For this
example we'll use curl to upload the jar.

    $ curl -H 'Content-Type: application/java-archive' --data-binary @DemoSparkJob.jar 127.0.0.1:8090/binaries/DemoSparkJob
    OK

Once the upload is complete we can view the UI for the Spark Jobserver and see
that the transfer completed successfully.

Check the UI at http://127.0.0.1:8090 and check the `Jars` tab

    |Name         |Deployment Time              |
    |-------------|-----------------------------|
    |DemoSparkJob |2015-07-27T16:23:39.545-07:00|

Or check via `curl`:

    $ curl 127.0.0.1:8090/jars
    {
      "DemoSparkJob": "2015-07-27T16:23:39.545-07:00"
    }

##Executing a job using a Stand Alone Context
Using a Stand Alone context will create a temporary context for the length of
the command. Once the command has finished the context will be cleaned up and
it's resources released. The following command will issue the `create` action
in a stand alone context. It will create the table "demo" and fill it with
some data.

To quickly create a keyspace for this demo use `cqlsh` to run the following

    CREATE KEYSPACE test WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'};
    
Change the keyspace statement to match your cluster layout if necessary.

The options for the `create` action are:

* keyspace: Specifies which keyspace to create the table in (keyspace must exist)
* table: The name of the table to create (table must not exist)
  
With the HTTP Request it is important that we specify the name of the Jar (appName)
and the classPath to the main class(classPath) we would like to execute. Make
a curl call like the following:

    $ curl -d "action = create, keyspace = test, table = demo" '127.0.0.1:8090/jobs?appName=DemoSparkJob&classPath=com.datastax.DemoSparkJob'
    {
      "status": "STARTED",
      "result": {
        "jobId": "58531754-dccb-4401-aac6-dd4c6a44cd31",
        "context": "482b389d-com.datastax.DemoSparkJob"
      }
    }

We can check that data was created in `cqlsh`

    SELECT * FROM test.demo limit 5;
     customer    | order    | amount
    -------------+----------+--------
     customer_59 | order_59 |     59
     customer_53 | order_53 |     53
     customer_44 | order_44 |     44
     customer_64 | order_64 |     64
     customer_51 | order_51 |     51

##Executing a job using a Shared Context
Using a shared context allows an application to share RDDs between executions
by keeping a consistently running Spark Context on the Spark Jobserver. RDDs are
used between call by using NamedRDDs (see the source code for this demo for an
example). This can be advantageous when multiple users would like to work with the
same data but have it only loaded once from Cassandra into Spark.

###Create the Shared Context
Curl (or any HTTP Client) can be used to ask the Spark Jobserver to create our
Spark Context. The sub-directory underneath `contexts` names the new context we are
creating. For full options on setting up a shared context visit the Spark 
Jobserver documentation.
    
    $ curl -d "" '127.0.01:8090/contexts/test-context'
    OK

We can verify that this context was created on the Spark Jobserver UI in the
`contexts` tab

    |Name        |
    |------------|
    |test-context|
    
or by using `curl`

    $ curl 127.0.0.1:8090/contexts
    ["test-context"]

###Making a NamedRDD using the Shared Context
Using the Demo jar we can cache the Cassandra table we previously made using the Stand
Alone Context. The `cache` action takes the following options:
  
* keyspace: The keyspace which has the table we want to use to make a NamedRDD
* table: The table we would like to make into a NamedRDD
* rdd: The new name to use for the created NamedRDD

Notice that we are passing the `context` as an additional parameter to the HTTP
request:

    $ curl -d "action = cache, keyspace = test, table = demo, rdd = demoRDD" \
    '127.0.0.1:8090/jobs?appName=DemoSparkJob&classPath=com.datastax.DemoSparkJob&context=test-context'
    {
      "status": "STARTED",
      "result": {
        "jobId": "d9b37cb6-8b04-45fd-ab4a-c36c42041ae6",
        "context": "test-context"
      }
    }

###Summing a column in a Named RDD
Now that a NamedRDD has been created we can issue commands to it without the RDD
being recreated between requests. We can observe the results using the `sum` action
which sums the "amount" column from the RDD's created from this application.

The `sum` action only takes one option:

* rdd: Name of the RDD to sum

In this action we are using the `sync` option in the HTTP Request to ask the jobserver
not to return the Request until the job has completed:

    $ time curl -d "action = sum, rdd = demoRDD" '127.0.0.1:8090/jobs?appName=DemoSparkJob&classPath=com.datastax.DemoSparkJob&context=test-context&sync=true'
    {
      "status": "OK",
      "result": "Summed amount field of demoRDD is 5050000.0"
    }
    0.00s user 0.00s system 0% cpu 1.122 total
    
    # Now The RDD has been cached so subsequent runs will be faster
    $ time curl -d "action = sum, rdd = demoRDD" '127.0.0.1:8090/jobs?appName=DemoSparkJob&classPath=com.datastax.DemoSparkJob&context=test-context&sync=true'
    {
      "status": "OK",
      "result": "Summed amount field of demoRDD is 5050000.0"
    }
    0.00s user 0.00s system 9% cpu 0.068 total
    
###Uncaching a NamedRDD

When we are done using a NamedRDD we can free up it's resources by removing
it from cache. The `uncache` action lets us do just that:

    $ curl -d "action = uncache, rdd = demoRDD" '127.0.0.1:8090/jobs?appName=DemoSparkJob&classPath=com.datastax.DemoSparkJob&context=test-context&sync=true'
    {
      "status": "OK",
      "result": "Now Cached: "
    }

##Using SparkSession

Jobserver API allows to use Spark Session instead of SparkContext. Refer
to `DemoSparkSessionJob.scala` to see minimal example. To test it we should
create context with SessionContextFactory with:

    $curl -d "" '127.0.0.1:8090/contexts/my_session?context-factory=spark.jobserver.context.SessionContextFactory&spark.cassandra.connection.host=localhost'
    {
      "status": "SUCCESS",
      "result": "Context initialized"
    }

Target context need to be specified when submitting demo SparkSession job:

    $ curl -d "" '127.0.0.1:8090/jobs?appName=DemoSparkJob&classPath=com.datastax.DemoSparkSessionJob&context=my_session'
    {
      "duration": "Job not done yet",
      "classPath": "com.datastax.DemoSparkSqlJob",
      "startTime": "2017-09-19T10:44:11.863+02:00",
      "context": "sql_context",
      "status": "STARTED",
      "jobId": "a1bcb67e-8da8-4b28-ae25-71e736239cb7"
    }
