FROM openjdk:11

# Install Spark
ENV SPARK_VERSION=3.5.1
RUN apt-get update && apt-get install -y curl && \
    curl -O https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop3 /opt/spark && \
    ln -s /opt/spark/bin/spark-submit /usr/bin/spark-submit

# Set environment variables
ENV SPARK_HOME=/opt/spark
ENV PATH="$SPARK_HOME/bin:$PATH"

# Add project files
WORKDIR /app
COPY . .

# Package app using sbt
RUN curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/bin/sbt && \
    chmod +x /usr/bin/sbt && \
    sbt clean package

# Run the app
CMD ["spark-submit", "--class", "TaxiQuery", "target/scala-2.12/taxiquery_2.12-0.1.jar"]