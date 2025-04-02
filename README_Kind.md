# ETL Pipeline with Kind on Windows

## Overview
This project sets up an ETL (Extract, Transform, Load) pipeline using Docker images and a local Kubernetes cluster managed by `kind`. The pipeline consists of three Docker images (`extract:v1`, `transform:v1`, `load:v1`) built from respective Dockerfiles and loaded into a `kind` cluster named `test-cluster`. The process is automated with a shell script, `build_and_upload_images.sh`, designed to work on Windows with a Unix-like environment (e.g., WSL or Git Bash).

## Prerequisites
- **Windows OS**: Tested on Windows 10/11.
- **Docker Desktop**: Installed and running.
  - Verify: `docker --version`
- **Kind**: Kubernetes IN Docker tool.
  - Install: See [Installation](#installation).
- **kubectl** (optional): For cluster interaction.
  - Install: [Kubernetes Docs](https://kubernetes.io/docs/tasks/tools/)
- **Unix-like Environment**: WSL (Ubuntu) or Git Bash for running `.sh` scripts.
- **Project Files**:
  - `Dockerfile.extract`
  - `Dockerfile.transform`
  - `Dockerfile.load`
  - `yellow_tripdata_2024-01.partial.csv`
  - `transform.sql`
  - `load.sql`
  - `build_and_upload_images.sh`

## Project Structure
```
C:\Users\kanha\Machine Learning\Kubernetes\
├── Docker/
│   ├── Dockerfile.extract
│   ├── Dockerfile.transform
│   ├── Dockerfile.load
│   ├── yellow_tripdata_2024-01.partial.csv
│   ├── transform.sql
│   └── load.sql
└── build_and_upload_images.sh
```

### Docker Images
1. **`extract:v1`**:
   - Base: `alpine`
   - Copies: `yellow_tripdata_2024-01.partial.csv` to `/yellow_tripdata_2024-01.partial.csv`
   - Purpose: Extracts data from the CSV file.
2. **`transform:v1`**:
   - Base: `alpine`
   - Installs: `sqlite`
   - Copies: `transform.sql` to `/transform.sql`
   - Purpose: Transforms data using SQLite.
3. **`load:v1`**:
   - Base: `alpine`
   - Installs: `sqlite`
   - Copies: `load.sql` to `/load.sql`
   - Purpose: Loads transformed data.

## Installation

### Docker Desktop
- Download and install from [docker.com](https://www.docker.com/products/docker-desktop/).
- Start Docker Desktop and ensure it’s running.

### Kind (Windows)
```powershell
curl.exe -Lo kind.exe https://kind.sigs.k8s.io/dl/v0.20.0/kind-windows-amd64
Move-Item .\kind.exe C:\Windows\System32\
```
- Verify: `kind version`

### WSL (Recommended for Script Execution)
1. Install WSL:
   ```powershell
   wsl --install
   ```
2. Install Ubuntu from the Microsoft Store, then launch it to set up.
3. Install Kind in WSL:
   ```bash
   curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
   chmod +x ./kind
   sudo mv ./kind /usr/local/bin/
   ```

### Git Bash (Alternative)
- Install Git for Windows from [git-scm.com](https://git-scm.com/).
- Use Git Bash for Unix-like commands.

## Setup
1. **Navigate to Project Directory**:
   - WSL:
     ```bash
     cd /mnt/c/Users/kanha/Machine\ Learning/Kubernetes
     ```
   - Git Bash:
     ```bash
     cd /c/Users/kanha/Machine\ Learning/Kubernetes
     ```
   - PowerShell:
     ```powershell
     cd "C:\Users\kanha\Machine Learning\Kubernetes"
     ```

2. **Make Script Executable** (WSL/Git Bash):
   ```bash
   chmod +x build_and_upload_images.sh
   ```

## Usage

### Run the Script
- **WSL/Git Bash**:
  ```bash
  ./build_and_upload_images.sh
  ```
- **PowerShell** (with Git Bash installed):
  ```powershell
  bash .\build_and_upload_images.sh
  ```

### What the Script Does
```bash
#!/bin/bash
cd Docker
docker build -t extract:v1 -f Dockerfile.extract .
docker build -t transform:v1 -f Dockerfile.transform .
docker build -t load:v1 -f Dockerfile.load .
kind load docker-image extract:v1 --name test-cluster
kind load docker-image transform:v1 --name test-cluster
kind load docker-image load:v1 --name test-cluster
```
1. Builds three Docker images from their respective Dockerfiles.
2. Loads the images into a `kind` cluster named `test-cluster`.

### If Cluster Doesn’t Exist
If you see `ERROR: no nodes found for cluster "test-cluster"`, create the cluster first:
```bash
kind create cluster --name test-cluster
```
Then re-run the script.

## Verification
- **Check Images**:
  ```bash
  docker images
  ```
- **Check Cluster**:
  ```bash
  kind get clusters
  kubectl get nodes --context kind-test-cluster
  ```
- **Test a Pod**:
  ```bash
  kubectl run test-pod --image=extract:v1 --restart=Never
  kubectl get pods
  ```

## Cleanup
Delete the cluster when done:
```bash
kind delete cluster --name test-cluster
```

## Troubleshooting
- **"chmod not recognized"**: Use WSL or Git Bash, not PowerShell directly.
- **"no nodes found"**: Create the cluster with `kind create cluster --name test-cluster`.
- **Docker Errors**: Ensure Docker Desktop is running and you have permissions.

## Notes
- This setup assumes the Dockerfiles and script are run in a Unix-like environment on Windows (WSL/Git Bash).
- For native PowerShell, convert the script to `.ps1` (see [PowerShell Alternative](#powershell-alternative)).

## PowerShell Alternative
```powershell
# build_and_upload_images.ps1
Set-Location -Path "Docker"
docker build -t extract:v1 -f Dockerfile.extract .
docker build -t transform:v1 -f Dockerfile.transform .
docker build -t load:v1 -f Dockerfile.load .
kind load docker-image extract:v1 --name test-cluster
kind load docker-image transform:v1 --name test-cluster
kind load docker-image load:v1 --name test-cluster
```
Run: `.\build_and_upload_images.ps1`