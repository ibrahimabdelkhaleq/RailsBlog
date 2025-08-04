#!/bin/bash

# Setup script for SonarQube JBC Plugin Classpath
# This script ensures all required dependencies are properly placed

SONARQUBE_HOME=${SONARQUBE_HOME:-/opt/sonarqube}

echo "Setting up classpath for JBC plugin..."

# Create necessary directories
mkdir -p $SONARQUBE_HOME/extensions/lib
mkdir -p $SONARQUBE_HOME/extensions/plugins

# Download additional dependencies that might be needed
cd $SONARQUBE_HOME/extensions/lib

# Download Log4j2 dependencies
echo "Downloading Log4j2 dependencies..."
curl -L -o log4j-core-2.8.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.8.2/log4j-core-2.8.2.jar
curl -L -o log4j-api-2.8.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.8.2/log4j-api-2.8.2.jar
curl -L -o log4j-slf4j-impl-2.8.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-slf4j-impl/2.8.2/log4j-slf4j-impl-2.8.2.jar

# Download additional TAFJ dependencies that might be needed
echo "Downloading additional TAFJ dependencies..."
curl -L -o slf4j-api-1.7.25.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar
curl -L -o commons-logging-1.2.jar https://repo1.maven.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar

# Set proper permissions
chown -R sonarqube:sonarqube $SONARQUBE_HOME/extensions/

echo "Classpath setup complete!"