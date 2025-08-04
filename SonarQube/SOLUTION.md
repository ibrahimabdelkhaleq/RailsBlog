# JBC Plugin Log4j2 Dependency Issue - Solution

## 🔍 **Problem Analysis**

The JBC plugin is failing to start because it requires Log4j2 dependencies that are not available in its classpath. The error shows:

```
java.lang.NoClassDefFoundError: org/apache/logging/log4j/status/StatusLogger
```

This happens because:
1. The JBC plugin bundles its own dependencies in `META-INF/lib/`
2. Log4j2 dependencies are missing from the plugin's bundled libraries
3. SonarQube's plugin classloader can't find the required Log4j2 classes

## 🛠️ **Solution Options**

### **Option 1: Fix the Plugin JAR (Recommended)**

Use the `fix-jbc-plugin.sh` script to add missing dependencies to the plugin:

```bash
# Make the script executable
chmod +x fix-jbc-plugin.sh

# Run the fix script
./fix-jbc-plugin.sh

# Rebuild the Docker container
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

This approach:
- Extracts the plugin JAR
- Adds Log4j2 dependencies to `META-INF/lib/`
- Repackages the plugin with all required dependencies
- Ensures dependencies are available to the plugin's classloader

### **Option 2: Enhanced Docker Setup**

The current Dockerfile includes:
- Log4j2 dependencies in both `/lib` and `/extensions/lib`
- Custom Log4j2 configuration (`log4j2.xml`)
- System properties to disable StatusLogger
- Extended classpath configuration

## 📋 **Current Configuration**

### **Dependencies Added:**
- `log4j-core-2.8.2.jar`
- `log4j-api-2.8.2.jar`
- `log4j-slf4j-impl-2.8.2.jar`
- `slf4j-api-1.7.25.jar`
- `commons-logging-1.2.jar`

### **System Properties:**
- `-Dlog4j2.statusLogger.enabled=false`
- `-Dlog4j2.disable.jmx=true`
- `-Dlog4j2.configurationFile=/opt/sonarqube/conf/log4j2.xml`
- `-Djava.ext.dirs=/opt/sonarqube/lib`
- `-Dtemn.tafj.runtime.enable.jbc.meter=false`

### **Log4j2 Configuration:**
- StatusLogger completely disabled
- TAFJ logging set to WARN level
- Minimal configuration to prevent conflicts

## 🚀 **Quick Start**

1. **Try the current setup first:**
   ```bash
   cd SonarQube
   docker-compose down
   docker-compose build --no-cache
   docker-compose up -d
   ```

2. **If still failing, fix the plugin:**
   ```bash
   chmod +x fix-jbc-plugin.sh
   ./fix-jbc-plugin.sh
   docker-compose down
   docker-compose build --no-cache
   docker-compose up -d
   ```

3. **Monitor logs:**
   ```bash
   docker-compose logs -f sonarqube
   ```

## 🔧 **Troubleshooting**

### **If the plugin fix doesn't work:**
1. Check if the plugin JAR was properly updated
2. Verify dependencies are in `META-INF/lib/`
3. Try rebuilding without cache

### **If Docker setup doesn't work:**
1. Check if Log4j2 JARs are properly downloaded
2. Verify system properties are set correctly
3. Check the Log4j2 configuration file

### **Alternative approach:**
- Use a different SonarQube version
- Try a different JBC plugin version
- Contact Temenos support for plugin compatibility

## 📊 **Expected Success Indicators**

When working correctly, you should see:
- No `NoClassDefFoundError` for Log4j2 classes
- JBC plugin loads successfully
- Rule repository "jbc-rules" created
- SonarQube starts without errors