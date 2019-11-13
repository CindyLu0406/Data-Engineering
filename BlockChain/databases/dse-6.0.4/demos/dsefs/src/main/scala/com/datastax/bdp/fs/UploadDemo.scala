/*
 * Copyright DataStax, Inc.
 *
 * Please see the included license file for details.
 */

package com.datastax.bdp.fs

import java.net.URI

import org.apache.hadoop.conf.Configuration
import org.apache.hadoop.fs.{FileSystem, Path}
import scopt.OptionParser

/**
  * Uploads the given file from local filesystem to DSEFS.
  */
object UploadDemo {

  case class Config(
      localSourcePath: String = "",
      dsefsTargetPath: String = ""
  )

  def main(args: Array[String]) {
    val parser = new OptionParser[Config]("upload") {
      arg[String]("<local path to source file>")
          .required()
          .action((path, config) => config.copy(localSourcePath = path))
      arg[String]("<DSEFS target path>")
          .required()
          .action((path, config) => config.copy(dsefsTargetPath = path))
    }
    parser.parse(args, Config()).foreach(config => upload(config))
  }

  private def upload(config: Config): Unit = {
    val configuration = new Configuration()
    configuration.set("fs.dsefs.impl", "com.datastax.bdp.fs.hadoop.DseFileSystem")

    val dsefs = FileSystem.get(new URI("dsefs://localhost:5598/"), configuration)
    dsefs.copyFromLocalFile(new Path(config.localSourcePath), new Path(config.dsefsTargetPath))
  }
}


