#!/bin/bash

echo "🔹 Starting local monitoring stack..."

# ✅ Load environment variables from .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
    echo "✅ Environment variables loaded from .env"
else
    echo "⚠️ WARNING: .env file not found! Using default password."
    export GRAFANA_ADMIN_PASSWORD="admin"
fi

# ✅ Function to check if a port is free
check_port() {
    if lsof -i :$1 &>/dev/null; then
        echo "⚠️ Port $1 is already in use. Attempting to stop process..."
        sudo fuser -k $1/tcp
        sleep 2  # Allow time for the port to be freed
    else
        echo "✅ Port $1 is free."
    fi
}

# ✅ Check and free up required ports
check_port 3000  # Grafana
check_port 9090  # Prometheus
check_port 9100  # Node Exporter
check_port 9093  # Alertmanager

# ✅ Function to start a service and check its status
start_service() {
    local service=$1
    echo "🛠 Checking $service service..."

    if systemctl is-active --quiet "$service"; then
        echo "✅ $service is already running."
    else
        echo "🛠 Starting $service..."
        sudo systemctl start "$service"
        sleep 3  # Wait for service to start

        # Check status after attempting to start
        if systemctl is-active --quiet "$service"; then
            echo "✅ $service started successfully."
        else
            echo "❌ ERROR: $service failed to start!"
            systemctl status "$service" --no-pager --lines=10
        fi
    fi
}

# ✅ Start all monitoring services
start_service grafana-server
start_service prometheus
start_service node-exporter
start_service alertmanager

# ✅ Display final status of all services
echo "🔍 Final service statuses:"
systemctl status grafana-server --no-pager --lines=5
systemctl status prometheus --no-pager --lines=5
systemctl status node-exporter --no-pager --lines=5
systemctl status alertmanager --no-pager --lines=5

echo "🚀 All monitoring services are running successfully!"

