#!/bin/bash

# Script to fix JBC plugin by adding missing Log4j2 dependencies
# This extracts the plugin, adds dependencies to META-INF/lib, and repackages it

set -e

echo "🔧 Fixing JBC plugin with missing Log4j2 dependencies..."

# Create working directory
WORK_DIR=$(pwd)
PLUGIN_DIR="$WORK_DIR/JbcSonarPlugin-21.12.0"
FIXED_PLUGIN="JbcSonarPlugin-21.12.0-fixed.jar"

# Check if plugin directory exists
if [ ! -d "$PLUGIN_DIR" ]; then
    echo "❌ Plugin directory not found: $PLUGIN_DIR"
    exit 1
fi

# Create META-INF/lib directory if it doesn't exist
mkdir -p "$PLUGIN_DIR/META-INF/lib"

# Download missing Log4j2 dependencies
echo "📦 Downloading Log4j2 dependencies..."
cd "$PLUGIN_DIR/META-INF/lib"

# Download Log4j2 dependencies
curl -L -o log4j-core-2.8.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.8.2/log4j-core-2.8.2.jar
curl -L -o log4j-api-2.8.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.8.2/log4j-api-2.8.2.jar
curl -L -o log4j-slf4j-impl-2.8.2.jar https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-slf4j-impl/2.8.2/log4j-slf4j-impl-2.8.2.jar

# Download additional dependencies that might be needed
curl -L -o slf4j-api-1.7.25.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar
curl -L -o commons-logging-1.2.jar https://repo1.maven.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar

echo "✅ Downloaded dependencies to META-INF/lib"

# Go back to working directory
cd "$WORK_DIR"

# Create the fixed JAR file
echo "📦 Creating fixed plugin JAR..."
jar -cf "$FIXED_PLUGIN" -C "$PLUGIN_DIR" .

echo "✅ Fixed plugin created: $FIXED_PLUGIN"

# Replace the original plugin
echo "🔄 Replacing original plugin..."
mv "$FIXED_PLUGIN" "JbcSonarPlugin-21.12.0.jar"

echo "✅ Plugin fixed successfully!"
echo "📋 Summary of changes:"
echo "   - Added log4j-core-2.8.2.jar"
echo "   - Added log4j-api-2.8.2.jar"
echo "   - Added log4j-slf4j-impl-2.8.2.jar"
echo "   - Added slf4j-api-1.7.25.jar"
echo "   - Added commons-logging-1.2.jar"
echo ""
echo "🚀 You can now rebuild and restart your Docker container:"
echo "   docker-compose down"
echo "   docker-compose build --no-cache"
echo "   docker-compose up -d"