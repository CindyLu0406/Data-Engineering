/*
 * Copyright DataStax, Inc.
 *
 * Please see the included license file for details.
 */

package com.datastax.bdp.fs

import java.net.URI
import java.nio.charset.StandardCharsets

import org.apache.hadoop.conf.Configuration
import org.apache.hadoop.fs.{FileSystem, Path}
import scopt.OptionParser

/**
  * Reads and prints out content of the given file.
  */
object ReadDemo {

  case class Config(
      dsefsSourcePath: String = ""
  )

  def main(args: Array[String]) {
    val parser = new OptionParser[Config]("read") {
      arg[String]("<DSEFS source path>")
          .required()
          .action((path, config) => config.copy(dsefsSourcePath = path))
    }
    parser.parse(args, Config()).foreach(config => read(config))
  }

  private def read(config: Config): Unit = {
    val configuration = new Configuration()
    configuration.set("fs.dsefs.impl", "com.datastax.bdp.fs.hadoop.DseFileSystem")
    val dsefs = FileSystem.get(new URI("dsefs://localhost:5598/"), configuration)

    val bytes = new Array[Byte](1024)
    val inputStream = dsefs.open(new Path(config.dsefsSourcePath))
    var bytesRead = inputStream.read(bytes)
    while (bytesRead > 0) {
      // Do something with read bytes.
      print(new String(bytes, 0, bytesRead, StandardCharsets.UTF_8))
      bytesRead = inputStream.read(bytes)
    }
    inputStream.close()
  }
}


