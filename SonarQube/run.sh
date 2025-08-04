#!/bin/bash

# SonarQube with JBC Plugin Runner
# This script builds and runs the SonarQube container with the JBC plugin

set -e

echo "🚀 Starting SonarQube with JBC Plugin..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose is not installed. Please install it and try again."
    exit 1
fi

# Stop any existing containers
echo "🛑 Stopping any existing containers..."
docker-compose down 2>/dev/null || true

# Build the image
echo "🔨 Building SonarQube image..."
docker-compose build --no-cache

# Start the container
echo "▶️  Starting SonarQube container..."
docker-compose up -d

# Wait for SonarQube to start
echo "⏳ Waiting for SonarQube to start (this may take a few minutes)..."
sleep 10

# Check if container is running
if docker-compose ps | grep -q "Up"; then
    echo "✅ SonarQube is starting up!"
    echo ""
    echo "📊 You can monitor the logs with:"
    echo "   docker-compose logs -f sonarqube"
    echo ""
    echo "🌐 Access SonarQube at: http://localhost:9000"
    echo "   Default credentials: admin/admin"
    echo ""
    echo "🛑 To stop the service, run: docker-compose down"
else
    echo "❌ Failed to start SonarQube. Check the logs:"
    docker-compose logs sonarqube
    exit 1
fi 