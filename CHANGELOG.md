# 📝 Changelog

## **[v1.1.0]** - 2025-03-11  
### **🔹 Added**
- **Environment Variable Handling:**  
  - The script now loads environment variables from `.env` if available.  
  - If `.env` is missing, a default Grafana password is set (`admin`).  

- **Port Conflict Resolution:**  
  - The script checks if required ports (`3000`, `9090`, `9100`, `9093`) are already in use.  
  - If a port is occupied, it attempts to stop the existing process before restarting services.  

- **Verbose Logging & Debugging:**  
  - Each service is checked before starting.  
  - If a service fails to start, its **last 10 log entries** are printed for troubleshooting.  
  - A final summary of all service statuses is displayed after execution.  

### **�� Fixed**
- **Grafana Service Startup Issue:**  
  - Previously, Grafana wasn't starting due to missing environment variables.  
  - Now explicitly starts `grafana-server` via `systemctl`.  

- **Unresponsive Services Not Restarting:**  
  - The script now ensures `prometheus`, `node-exporter`, and `alertmanager` are started even if they are partially running.  

### **🚀 How to Update Your Local Setup**
1. **Pull the latest changes from GitHub:**  
   ```bash
   git pull origin master

