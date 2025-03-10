#!/bin/bash

echo "Fetching Grafana password from AWS SSM..."
export GRAFANA_ADMIN_PASSWORD=$(aws ssm get-parameter --name "grafana_admin_password" --with-decryption --query "Parameter.Value" --output text)

echo "Starting monitoring stack..."
docker-compose up -d

