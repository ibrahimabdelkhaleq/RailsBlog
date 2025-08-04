#!/bin/bash

# Custom entrypoint for SonarQube with JBC Plugin
# This ensures proper classpath setup before starting SonarQube

set -e

echo "🔧 Setting up SonarQube with JBC Plugin..."

# Set up classpath if not already done
if [ ! -f "$SONARQUBE_HOME/extensions/lib/log4j-core-2.8.2.jar" ]; then
    echo "📦 Setting up dependencies..."
    $SONARQUBE_HOME/setup-classpath.sh
fi

# Set additional system properties for JBC plugin
export SONAR_WEB_JAVAOPTS="$SONAR_WEB_JAVAOPTS -Dlog4j2.statusLogger.enabled=false -Dlog4j2.disable.jmx=true"
export SONAR_CE_JAVAOPTS="$SONAR_CE_JAVAOPTS -Dlog4j2.statusLogger.enabled=false -Dlog4j2.disable.jmx=true"

# Ensure proper permissions
chown -R sonarqube:sonarqube $SONARQUBE_HOME/extensions/

echo "✅ Setup complete, starting SonarQube..."

# Call the original entrypoint
exec /opt/sonarqube/bin/run.sh "$@"