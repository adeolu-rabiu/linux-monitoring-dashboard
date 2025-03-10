# Monitoring & Alerting System

## Overview

This project is a **Monitoring & Alerting System** built using **Prometheus, Alertmanager, Grafana, and Node Exporter** to monitor both **on-premise and cloud infrastructure**. It collects system metrics, evaluates them based on predefined alert rules, and sends notifications via **Slack** when an issue arises or is resolved.

The system is designed to be **containerized using Docker Compose**, allowing for easy deployment and scaling across different environments, including **local VMs and AWS instances**.

---

## Tech Stack

- **Prometheus** (Metric Collection & Storage)
- **Node Exporter** (System Metrics Collection)
- **Alertmanager** (Alert Processing & Notification Routing)
- **Grafana** (Visualization & Dashboarding)
- **Slack Webhooks** (Alert Notifications)
- **Docker & Docker Compose** (Containerized Deployment)
- **AWS EC2** (Cloud Deployment)

---

## Features & Capabilities

✅ **Monitors On-Premise & Cloud Infrastructure** – Tracks CPU, memory, disk, network usage, and system failures.
✅ **Real-Time Alerting** – Detects anomalies based on alert rules and sends notifications to Slack.
✅ **Automated Fault Resolution Alerts** – Notifies when an issue is detected and again when resolved.
✅ **Visualization with Grafana** – View key system metrics in real-time dashboards.
✅ **Containerized Deployment** – Uses **Docker Compose** for easy deployment.
✅ **Scalable & Extensible** – Can be expanded to monitor additional services and cloud resources.

---

## Monitoring & Alerting Process Flow



### Steps:

1. **Data Collection from VM** – Node Exporter collects system metrics.
2. **Prometheus Scrapes Metrics** – Prometheus fetches data from Node Exporter.
3. **Grafana Visualizes Data** – Metrics are displayed on dashboards.
4. **Prometheus Evaluates Alert Rules** – Checks predefined conditions.
5. **Alertmanager Processes Alerts** – Sends alerts when conditions are met.
6. **Slack Notifications Triggered** – Alerts are pushed to Slack channels.
7. **Issue Resolution & Monitoring Continuation** – Once an issue is resolved, Slack is notified, and monitoring continues.

---

## Project Structure

```
monitoring/
├── alertmanager/
│   └── alertmanager.yml
├── alertmanager.service
├── docker-compose.yml
├── grafana/
│   ├── grafana.ini
│   ├── ldap.toml
│   └── provisioning/
│       ├── dashboards/
│       ├── datasources/
│       ├── alerting/
│       ├── access-control/
│       ├── plugins/
├── grafana-server.service
├── node-exporter.service
├── prometheus/
│   ├── prometheus.yml
│   ├── alert.rules.yml
├── prometheus.service
└── provisioning/
```

---

## Deployment Guide

### 1️⃣ Clone the Repository

```sh
git clone https://github.com/YOUR_GITHUB_USERNAME/monitoring.git
cd monitoring
```

### 2️⃣ Update Environment Variables

Edit **docker-compose.yml** to set environment variables for Grafana and Alertmanager:

```yaml
environment:
  - GF_SECURITY_ADMIN_PASSWORD=yourpassword
```

### 3️⃣ Run Docker Containers

```sh
docker-compose up -d
```

### 4️⃣ Access Monitoring Tools

- **Prometheus**: `http://localhost:9090`
- **Grafana**: `http://localhost:3000` (Default login: `admin / yourpassword`)
- **Alertmanager**: `http://localhost:9093`

### 5️⃣ Check Alerts in Slack

Ensure the Slack webhook is correctly configured in `alertmanager.yml`. Alerts will be sent to the configured channel when an issue arises or is resolved.

---

## Testing & Validation

### Run a Local Sandbox

Before deploying to **AWS**, test the setup locally using Docker Compose:

```sh
docker-compose up -d
```

Check Prometheus, Grafana, and Alertmanager UIs to verify that:
✅ Metrics are collected correctly
✅ Alerts are firing as expected
✅ Slack notifications are being sent

### Test Alert Triggering

Manually trigger an alert by stopping the **Node Exporter** service:

```sh
sudo systemctl stop node-exporter
```

Wait a few minutes, and check **Prometheus Alerts Page**: `http://localhost:9090/alerts`.

To restore the service:

```sh
sudo systemctl start node-exporter
```

You should receive a **resolution notification** in Slack.

---

## Deploying to AWS

### Steps to Deploy on an AWS EC2 Instance:

1. **Launch an EC2 instance** (Ubuntu/Debian recommended).
2. **Install Docker & Docker Compose**:
   ```sh
   sudo apt update && sudo apt install docker.io -y
   sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```
3. **Clone the GitHub repository**:
   ```sh
   git clone https://github.com/YOUR_GITHUB_USERNAME/monitoring.git
   cd monitoring
   ```
4. **Start the Monitoring Stack**:
   ```sh
   docker-compose up -d
   ```
5. **Access Monitoring Dashboards**:
   - Prometheus: `http://YOUR_EC2_PUBLIC_IP:9090`
   - Grafana: `http://YOUR_EC2_PUBLIC_IP:3000`
   - Alertmanager: `http://YOUR_EC2_PUBLIC_IP:9093`

---

## Contributing

🚀 If you'd like to contribute, fork this repo and submit a pull request!

---

## Author

Developed by **Adeolu Rabiu (https://www.linkedin.com/in/adeolurabiu/)**

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


