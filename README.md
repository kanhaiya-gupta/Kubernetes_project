# Deploying an ETL Pipeline on Kubernetes

In this task, you will deploy an ETL (Extract, Transform, Load) pipeline on Kubernetes to calculate the total number of passengers who took a NYC yellow cab in groups of 2 or more. The pipeline will utilize Kubernetes Pods for each step—Extract, Transform, and Load—interacting with Persistent Volumes (PVs) and Persistent Volume Claims (PVCs) for data storage and transfer.

## Objective
The goal is to:
- Extract initial data as a CSV file using the "Extract Pod".
- Transform the yellow cab data into an SQLite database and filter relevant data using the "Transform Pod".
- Load the processed data, compute the total passenger count, and save the result as a CSV file using the "Load Pod".

## Prerequisites
Two directories have been prepared:
- `Docker/`: Contains files to build Docker images.
- `Manifests/`: Contains Kubernetes manifest files for deployment.

## Instructions

### Step 1: Inspect Docker Files
Inspect the files in the `Docker/` directory to understand the setup:
- **Dockerfiles**: Check `Docker/Dockerfile.extract`, `Docker/Dockerfile.transform`, and `Docker/Dockerfile.load` to see how the images are constructed.
- **SQL Files**: Examine any `.sql` files (e.g., `Docker/init.sql`) to understand database initialization or queries.
- **Commands**:
  - Use `cat Docker/Dockerfile.extract` to view the Extract Dockerfile (repeat for other files).
  - Use `more Docker/init.sql` for paginated viewing of SQL files.
  - Exit `cat` with `CTRL+D`.

### Step 2: Build and Upload Docker Images
Build and upload the Docker images to your Kubernetes cluster:
- Run the provided build script: `bash 01_build_and_upload_images.sh`.
- This script will:
  - Build three Docker images: `extract:v1`, `transform:v1`, and `load:v1`.
  - Upload them to your Kubernetes cluster for deployment.

### Next Steps
After completing these steps, the Docker images will be ready for deployment using the Kubernetes manifests in the `Manifests/` directory. Subsequent instructions will guide you through deploying the Pods, PVCs, and PVs to execute the ETL pipeline and compute the total number of passengers.

**Note**: Ensure you have access to the Kubernetes cluster and the necessary permissions to build and upload images.
