/*
 * Copyright DataStax, Inc.
 *
 * Please see the included license file for details.
 */

package com.datastax

import _root_.spark.jobserver.SparkSessionJob
import _root_.spark.jobserver.api.JobEnvironment
import _root_.spark.jobserver.api.ValidationProblem
import com.typesafe.config.Config
import org.apache.spark.sql.SparkSession
import org.scalactic._

case class DemoDatasetElement(n: Int, value: String)

object DemoSparkSessionJob extends SparkSessionJob {

  type JobOutput = Array[DemoDatasetElement] // job result type
  type JobData = Config // type of validation result (result is passed to runJob)

  override def runJob(sparkSession: SparkSession, runtime: JobEnvironment, config: JobData):
    JobOutput = {
    import sparkSession.implicits._
    sparkSession.createDataset(1 to 10)
        .map(i => DemoDatasetElement(i, i.toString))
        .collect()
  }

  override def validate(sparkSession: SparkSession, runtime: JobEnvironment, config: JobData):
    JobData Or Every[ValidationProblem] = {
    Good(config)
  }

}
