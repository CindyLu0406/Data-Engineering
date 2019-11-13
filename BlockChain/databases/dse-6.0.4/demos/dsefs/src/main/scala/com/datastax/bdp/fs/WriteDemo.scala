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
  * Creates the given file in DSEFS. Writes the given text in the file.
  */
object WriteDemo {

  case class Config(
      dsefsTargetPath: String = "",
      text: String = "sample text"
  )

  def main(args: Array[String]) {
    val parser = new OptionParser[Config]("write") {
      arg[String]("<DSEFS target path>")
          .required()
          .action((path, config) => config.copy(dsefsTargetPath = path))
      arg[String]("<some text in quotes>")
          .required()
          .action((path, config) => config.copy(text = path))
    }
    parser.parse(args, Config()).foreach(config => write(config))
  }

  private def write(config: Config): Unit = {
    val configuration = new Configuration()
    configuration.set("fs.dsefs.impl", "com.datastax.bdp.fs.hadoop.DseFileSystem")

    val dsefs = FileSystem.get(new URI("dsefs://localhost:5598/"), configuration)
    val outputStream = dsefs.create(new Path(config.dsefsTargetPath))
    outputStream.write(config.text.getBytes(StandardCharsets.UTF_8))
    outputStream.close()
  }
}


