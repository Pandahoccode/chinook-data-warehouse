# Project Prerequisites & Setup Requirements

This document provides setup instructions for setting up the local development environment on Windows using **WSL 2**, **Docker**, **dbt**, and **Apache Airflow**.

---

## 🐧 1. Windows Subsystem for Linux (WSL 2) Setup

Airflow and Docker perform significantly better and are easier to manage when running inside a Linux environment on Windows.

### Step-by-Step Installation:
1. Open PowerShell as Administrator and execute:
   ```powershell
   wsl --install -d Ubuntu
   ```
2. Restart your computer when prompted.
3. Upon restart, a terminal window will open to complete the Ubuntu installation. Set your username and password.
4. Verify WSL 2 version is active:
   ```powershell
   wsl --list --verbose
   ```
   *(Ensure the version listed next to `Ubuntu` is `2`)*

---

## 🐳 2. Docker Desktop & WSL 2 Integration

Docker Desktop is required to host the multi-container Airflow environment.

### Installation:
1. Download and install **[Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)**.
2. During installation, make sure the option **"Use the WSL 2 based engine"** is checked.
3. Launch Docker Desktop and open **Settings** (gear icon) -> **Resources** -> **WSL Integration**.
4. Enable integration for your installed distribution (e.g. `Ubuntu`), then click **Apply & Restart**.

### Resource Requirements (Crucial for Airflow):
By default, WSL 2 can consume a lot of host memory. It is highly recommended to configure resource limits.
1. Create a file named `.wslconfig` in your Windows User Profile directory (e.g. `C:\Users\YourUsername\.wslconfig`).
2. Add the following config to allocate adequate resources for the Airflow worker/scheduler stack:
   ```ini
   [wsl2]
   memory=6GB      # Recommend at least 4-6GB
   processors=4    # Number of CPU cores to allocate
   ```
3. Restart WSL in PowerShell:
   ```powershell
   wsl --shutdown
   ```

---

## 🐍 3. dbt Environment Setup

For local model development, testing, and formatting, install dbt on your host or inside WSL.

### Step-by-Step Installation:
1. Install Python 3.10 or 3.11 (dbt-core works best with these versions).
2. Create and activate a Python virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Linux/WSL
   # OR
   venv\Scripts\activate     # On Windows Command Prompt
   ```
3. Install dbt and the PostgreSQL adapter:
   ```bash
   pip install dbt-postgres
   ```
4. Verify the installation:
   ```bash
   dbt --version
   ```

---

## ✈️ 4. Airflow Setup & Execution

The Airflow stack is pre-configured to run on Docker Compose.

### Initialization & Startup:
1. **Initialize the Airflow database**:
   Before starting the containers for the first time, run db migrations and set up initial workspace directories:
   ```bash
   docker-compose up airflow-init
   ```
2. **Start the Airflow Stack**:
   ```bash
   docker-compose up -d
   ```
3. **Verify running containers**:
   Ensure the following containers are up and healthy:
   *   `af-sche-chinook` (Scheduler)
   *   `af-api-chinook` (Webserver/API)
   *   `af-worker-chinook` (Worker)
   *   `postgres-chinook` (Postgres DB metadata & warehouse)
   *   `redis-chinook` (Celery Broker)

---

## 🐘 5. PostgreSQL Database Settings

The PostgreSQL service runs inside the docker container `postgres-chinook` and is used to store both the raw seeded datasets and the final target warehouse schema.

### Connection Parameters:
*   **Host (inside Docker Network)**: `postgres` (port `5432`)
*   **Host (from Windows/host machine)**: `localhost` (port `15432`)
*   **Database Name**: `chinook`
*   **Username**: `chinook`
*   **Password**: `chinook`

### Airflow Connection Configuration:
To allow Airflow operators to execute queries, ensure a connection is defined in Airflow with the following parameters:
*   **Connection ID**: `chinook_connection`
*   **Connection Type**: `Postgres`
*   **Host**: `postgres`
*   **Schema**: `chinook`
*   **Login**: `chinook`
*   **Password**: `chinook`
*   **Port**: `5432`
