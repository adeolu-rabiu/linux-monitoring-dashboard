#!/bin/bash

# Define monitoring services
SERVICES=("grafana-server" "prometheus" "node-exporter" "alertmanager")

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

# ✅ Function to start a service
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

# ✅ Function to stop a service
stop_service() {
    local service=$1
    echo "🛠 Checking $service service..."

    if systemctl is-active --quiet "$service"; then
        echo "🛠 Stopping $service..."
        sudo systemctl stop "$service"
        sleep 2  # Wait for service to stop

        # Check status after attempting to stop
        if systemctl is-active --quiet "$service"; then
            echo "❌ ERROR: $service failed to stop!"
        else
            echo "✅ $service stopped successfully."
        fi
    else
        echo "✅ $service is already stopped."
    fi
}

# ✅ Function to start all or specific services
start_services() {
    echo "1) Start All Services"
    echo "2) Start a Specific Service"
    read -p "Choose an option (1/2): " start_choice

    if [[ "$start_choice" == "1" ]]; then
        # Free up required ports before starting services
        check_port 3000  # Grafana
        check_port 9090  # Prometheus
        check_port 9100  # Node Exporter
        check_port 9093  # Alertmanager

        for service in "${SERVICES[@]}"; do
            start_service "$service"
        done
        echo "🚀 All services started successfully."
    elif [[ "$start_choice" == "2" ]]; then
        echo "Available services:"
        for i in "${!SERVICES[@]}"; do
            echo "$((i + 1))) ${SERVICES[$i]}"
        done
        read -p "Enter the number of the service you want to start: " service_number

        if [[ "$service_number" -ge 1 && "$service_number" -le ${#SERVICES[@]} ]]; then
            start_service "${SERVICES[$((service_number - 1))]}"
        else
            echo "❌ Invalid selection."
        fi
    else
        echo "❌ Invalid choice."
    fi
}

# ✅ Function to stop all or specific services
stop_services() {
    echo "1) Stop All Services"
    echo "2) Stop a Specific Service"
    read -p "Choose an option (1/2): " stop_choice

    if [[ "$stop_choice" == "1" ]]; then
        for service in "${SERVICES[@]}"; do
            stop_service "$service"
        done
        echo "🛑 All services stopped successfully."
    elif [[ "$stop_choice" == "2" ]]; then
        echo "Available services:"
        for i in "${!SERVICES[@]}"; do
            echo "$((i + 1))) ${SERVICES[$i]}"
        done
        read -p "Enter the number of the service you want to stop: " service_number

        if [[ "$service_number" -ge 1 && "$service_number" -le ${#SERVICES[@]} ]]; then
            stop_service "${SERVICES[$((service_number - 1))]}"
        else
            echo "❌ Invalid selection."
        fi
    else
        echo "❌ Invalid choice."
    fi
}

# ✅ Main menu
echo "🔹 Monitoring Stack Management"
echo "1) Start Services"
echo "2) Stop Services"
read -p "Choose an option (1/2): " action_choice

if [[ "$action_choice" == "1" ]]; then
    start_services
elif [[ "$action_choice" == "2" ]]; then
    stop_services
else
    echo "❌ Invalid selection. Exiting."
    exit 1
fi

# ✅ Display final status of all services
echo "🔍 Final service statuses:"
for service in "${SERVICES[@]}"; do
    systemctl status "$service" --no-pager --lines=5
done

echo "✅ Script execution completed."

