FROM sonarqube:7.8-community

# Install curl for downloading dependencies
RUN apk add --no-cache curl

# Create plugins directory if it doesn't exist
RUN mkdir -p $SONARQUBE_HOME/extensions/plugins

# Copy the JBC plugin and Log4j2 configuration
COPY JbcSonarPlugin-21.12.0.jar $SONARQUBE_HOME/extensions/plugins/
COPY log4j2.xml $SONARQUBE_HOME/conf/

# Add missing Log4j2 dependencies - comprehensive set
RUN curl -L -o $SONARQUBE_HOME/lib/log4j-core-2.8.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.8.2/log4j-core-2.8.2.jar && \
    curl -L -o $SONARQUBE_HOME/lib/log4j-api-2.8.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.8.2/log4j-api-2.8.2.jar && \
    curl -L -o $SONARQUBE_HOME/lib/log4j-slf4j-impl-2.8.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-slf4j-impl/2.8.2/log4j-slf4j-impl-2.8.2.jar && \
    curl -L -o $SONARQUBE_HOME/lib/slf4j-api-1.7.25.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar && \
    curl -L -o $SONARQUBE_HOME/lib/commons-logging-1.2.jar https://repo1.maven.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar

# Also add to extensions/lib for plugin classloading
RUN mkdir -p $SONARQUBE_HOME/extensions/lib && \
    cp $SONARQUBE_HOME/lib/log4j-core-2.8.2.jar $SONARQUBE_HOME/extensions/lib/ && \
    cp $SONARQUBE_HOME/lib/log4j-api-2.8.2.jar $SONARQUBE_HOME/extensions/lib/ && \
    cp $SONARQUBE_HOME/lib/log4j-slf4j-impl-2.8.2.jar $SONARQUBE_HOME/extensions/lib/ && \
    cp $SONARQUBE_HOME/lib/slf4j-api-1.7.25.jar $SONARQUBE_HOME/extensions/lib/ && \
    cp $SONARQUBE_HOME/lib/commons-logging-1.2.jar $SONARQUBE_HOME/extensions/lib/

# Set proper permissions
RUN chown -R sonarqube:sonarqube $SONARQUBE_HOME/extensions/ && \
    chown -R sonarqube:sonarqube $SONARQUBE_HOME/lib/

# Set JBC runtime property to disable metering and Log4j2 properties
# Also add the lib directory to the classpath
ENV SONAR_WEB_JAVAOPTS="-Dtemn.tafj.runtime.enable.jbc.meter=false -Dlog4j2.statusLogger.enabled=false -Dlog4j2.disable.jmx=true -Dlog4j2.configurationFile=/opt/sonarqube/conf/log4j2.xml -Djava.ext.dirs=/opt/sonarqube/lib -Xmx512m -Xms128m"
ENV SONAR_CE_JAVAOPTS="-Dtemn.tafj.runtime.enable.jbc.meter=false -Dlog4j2.statusLogger.enabled=false -Dlog4j2.disable.jmx=true -Dlog4j2.configurationFile=/opt/sonarqube/conf/log4j2.xml -Djava.ext.dirs=/opt/sonarqube/lib -Xmx512m -Xms128m"

# Expose SonarQube port
EXPOSE 9000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:9000/api/system/status || exit 1