# SonarQube with JBC Plugin

This setup provides SonarQube 7.8 with the JBC (Java Business Component) plugin properly configured to resolve dependency issues.

## Prerequisites

- Docker
- Docker Compose

## Quick Start

1. **Build and start the container:**
   ```bash
   docker-compose up -d
   ```

2. **Check the logs to ensure startup:**
   ```bash
   docker-compose logs -f sonarqube
   ```

3. **Access SonarQube:**
   - URL: http://localhost:9000
   - Default credentials: admin/admin

## What's Fixed

The original error was caused by missing Log4j2 dependencies. This setup:

1. **Adds missing Log4j2 JARs:** Downloads and includes `log4j-core-2.17.1.jar` and `log4j-api-2.17.1.jar`
2. **Proper plugin installation:** Correctly copies the JBC plugin to the extensions directory
3. **Permission handling:** Sets proper ownership for the sonarqube user
4. **Health monitoring:** Includes health checks to monitor the service

## Troubleshooting

### If SonarQube fails to start:

1. **Check logs:**
   ```bash
   docker-compose logs sonarqube
   ```

2. **Restart the container:**
   ```bash
   docker-compose restart sonarqube
   ```

3. **Rebuild if needed:**
   ```bash
   docker-compose down
   docker-compose build --no-cache
   docker-compose up -d
   ```

### Common Issues:

- **Memory issues:** The compose file sets reasonable memory limits. If you need more, adjust the `SONAR_*_JAVAOPTS` environment variables
- **Plugin compatibility:** This setup uses SonarQube 7.8. If you need a different version, update the base image in the Dockerfile

## Stopping the Service

```bash
docker-compose down
```

To remove all data:
```bash
docker-compose down -v
``` 