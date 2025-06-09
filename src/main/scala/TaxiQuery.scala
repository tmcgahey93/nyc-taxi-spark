import org.apache.spark.sql.SparkSession

object TaxiQuery {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder()
      .appName("NYC Taxi Trip Analysis")
      .master("local[*]")
      .getOrCreate()

    val df = spark.read.parquet("data/yellow_tripdata_2024-12.parquet")
    df.createOrReplaceTempView("taxi")

    val result = spark.sql("""
      SELECT passenger_count, COUNT(*) as trip_count
      FROM taxi
      WHERE passenger_count > 0
      GROUP BY passenger_count
      ORDER BY trip_count DESC
    """)

    result.show()

    spark.stop()
  }
}