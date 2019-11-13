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
  * Downloads the given file from DSEFS to local filesystem.
  */
object DownloadDemo {

  case class Config(
      dsefsSourcePath: String = "",
      localTargetPath: String = ""
  )

  def main(args: Array[String]) {
    val parser = new OptionParser[Config]("download") {
      arg[String]("<DSEFS path to source file>")
          .required()
          .action((path, config) => config.copy(dsefsSourcePath = path))
      arg[String]("<local target path>")
          .required()
          .action((path, config) => config.copy(localTargetPath = path))
    }
    parser.parse(args, Config()).foreach(config => download(config))
  }

  private def download(config: Config): Unit = {
    val configuration = new Configuration()
    configuration.set("fs.dsefs.impl", "com.datastax.bdp.fs.hadoop.DseFileSystem")

    val dsefs = FileSystem.get(new URI("dsefs://localhost:5598/"), configuration)
    dsefs.copyToLocalFile(new Path(config.dsefsSourcePath), new Path(config.localTargetPath))
  }
}


