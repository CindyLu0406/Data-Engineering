# DSEFS programmatic access

This demo contains a complete example of a project with programmatic DSEFS
usage. The demo can be used as a starting point for building a standalone
application that leverages DSEFS. The demo contains a set of sample
applications that among others cover:
- basic usages like reading and writing
- connecting to secured DSEFS

All samples are writen in Scala and are enclosed in a single class with
`Demo` suffix in name.

## Interface

DSEFS provides implementation of Hadoop's `FileSystem` interface. All
samples use this implementation to access DSEFS. It is obtained via
Hadoop's `FileSystem.get` method.

There are many different ways to configure `FileSystem` implementations.
In the samples we simply provide `Configuration` object with necessary
entries. Refer to Hadoop docs on different ways of providing
configuration entries.

## Building

The demo is based on Gradle, here is a command that builds a jar file
containing all samples.

```
./gradlew jar copyDeps
```

- `jar` creates a jar archive with compiled sample classes
- `copyDeps` copies all needed dependencies to `build/libs` directory. It
can be referenced in classpath while executing the samples.

## Dependencies
Crucial dependencies are:
- `byos` (https://docs.datastax.com/en/dse/5.1/dse-dev/datastax_enterprise/spark/byosOverview.html) -
contains DSEFS classes, including DSEFS's implementation of Hadoop's
`Filesystem` implementation
- `hadoop-common` - contains Hadoop's interfaces and machinery to create
different `Filesystem` instances

## Executing

Sample application can be executed with the following command.

```
./run-dsefs-demo.sh <application name> <application arguments>
```

An example of `WriteDemo` and `DownloadDemo` execution.

```
# write given text to some_target_file localted on DSEFS
./run-dsefs-demo.sh WriteDemo some_target_file "some text I want to write to target file"

# download some_targe_file from DSEFS to local_file
./run-dsefs-demo.sh DownloadDemo some_target_file local_file
```

If there are no arguments specified, the usage is displayed.

```
$ ./run-dsefs-demo.sh DownloadDemo
Error: Missing argument <DSEFS path to source file>

Error: Missing argument <local target path>
Usage: download <DSEFS path to source file> <local target path>

  <DSEFS path to source file>

  <local target path>
```

#### Execution details
Under the covers `run-dsefs-demo.sh` invokes simple java command with
classpath built out of jars prepared in "Building" stage.

```
java -cp "build/libs/*:build/deps/*" <application class fully qualified name> <application arguments>
```

- `build/libs` contains jar with compiled sample classes
- `build/deps` contains dependencies, including `hadoop-common`

