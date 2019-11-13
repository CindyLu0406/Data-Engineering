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
  * Creates directory in secured DSEFS. Authenticates with the given username and password.
  */
object BasicAuthenticationDemo {

  case class Config(
      dir: String = "",
      user: String = "",
      password: String = ""
  )

  def main(args: Array[String]) {
    val parser = new OptionParser[Config]("create directory") {
      arg[String]("<user>")
          .required()
          .action((user, config) => config.copy(user = user))
      arg[String]("<password>")
          .required()
          .action((password, config) => config.copy(password = password))
      arg[String]("<directory>")
          .required()
          .action((path, config) => config.copy(dir = path))
    }
    parser.parse(args, Config()).foreach(config => mkdirs(config))
  }

  private def mkdirs(config: Config): Unit = {
    val configuration = new Configuration()
    configuration.set("fs.dsefs.impl", "com.datastax.bdp.fs.hadoop.DseFileSystem")
    configuration.set("com.datastax.bdp.fs.client.authentication.basic.username", config.user)
    configuration.set("com.datastax.bdp.fs.client.authentication.basic.password", config.password)

    val dsefs = FileSystem.get(new URI("dsefs://localhost:5598/"), configuration)
    dsefs.mkdirs(new Path(config.dir))
  }
}


