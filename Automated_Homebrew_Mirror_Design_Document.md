
# **System Design Document: Automated Homebrew Mirror for Air-Gapped Network**

## **1. Introduction**
### **1.1 Objective**
This document details the design and implementation of an automated system to mirror the Homebrew repository and store it in an AWS S3 bucket. The system will:
- Download the Homebrew repository weekly without manual intervention.
- Compress and split large files into manageable parts (3.5GB each).
- Compare hashes to identify changes in the repository.
- Freeze the state of the repository during download to avoid inconsistencies.

### **1.2 Scope**
The system is designed for environments where an air-gapped network requires a regularly updated mirror of the Homebrew repository. AWS services will be utilized for storage and automation.

## **2. System Components**
### **2.1 AWS Services**
- **Amazon EC2:** For downloading, processing, and splitting the repository files.
- **Amazon S3:** For storing the compressed and split files.
- **AWS Systems Manager (SSM):** For automating EC2 instance startup and execution of tasks.
- **Amazon CloudWatch:** For monitoring and scheduling.
- **Amazon SNS:** For notifications in case of errors or completion.

### **2.2 Tools**
- **Homebrew:** The package manager.
- **Python:** For scripting tasks like hash comparison, file manipulation, and S3 operations.
- **Bash:** For executing system commands.

## **3. Architecture Overview**
1. **Trigger:** A CloudWatch scheduled event triggers the process weekly.
2. **Execution:** The EC2 instance performs the following:
   - Locks the current state of Homebrew.
   - Downloads the latest repository updates.
   - Compares file hashes with the previous version stored in S3.
   - Compresses and splits the repository into 3.5GB parts.
   - Uploads the parts and updated hash file to S3.
3. **Notification:** SNS sends notifications regarding task completion or errors.

## **4. Workflow**
### **4.1 Initialization**
- Pre-configure an AMI with the required tools (Homebrew, Python, AWS CLI).
- Attach a sufficient EBS volume (500GB+) to the EC2 instance.

### **4.2 Weekly Execution**
1. **Start EC2 Instance:** Systems Manager triggers the EC2 instance.
2. **Freeze Repository State:** A Python script executes `brew freeze` to lock the repository state.
3. **Download Updates:** Run `brew update` to download the latest repository data.
4. **Compare Hashes:**
   - Compute the SHA-256 hash of the repository files.
   - Compare with the hash stored in S3 to identify changes.
5. **Compress and Split:**
   - Use `tar` for compression.
   - Split the archive into 3.5GB chunks using `split`.
6. **Upload to S3:**
   - Upload each part to a designated S3 bucket.
   - Update the hash file in S3.
7. **Stop EC2 Instance:** The instance is terminated to minimize costs.

### **4.3 Error Handling**
- Logs are stored in CloudWatch for debugging.
- SNS alerts are sent for failures or task completions.

## **5. File Structure**
- **S3 Bucket Layout:**
  - `/brew_repo/`: Contains compressed parts.
  - `/hash/`: Contains the latest hash file.

## **6. Technical Details**
### **6.1 EC2 Instance Configuration**
- Instance Type: m5.large
- Storage: EBS with 500GB capacity
- OS: Amazon Linux 2 or Ubuntu

### **6.2 Hash Calculation**
The Python script calculates SHA-256 hashes for integrity checks:
```python
import hashlib
import os

def calculate_hash(directory):
    hasher = hashlib.sha256()
    for root, _, files in os.walk(directory):
        for fname in files:
            with open(os.path.join(root, fname), 'rb') as f:
                while chunk := f.read(8192):
                    hasher.update(chunk)
    return hasher.hexdigest()
```

### **6.3 Compression and Splitting**
Commands used:
```bash
tar -czf /tmp/brew_repo.tar.gz /path/to/repo
split -b 3500M /tmp/brew_repo.tar.gz /tmp/brew_repo_part_
```

### **6.4 S3 Upload**
Python script for uploading:
```python
import boto3

s3 = boto3.client('s3')
bucket_name = "your-bucket-name"

def upload_to_s3(file_path, s3_path):
    s3.upload_file(file_path, bucket_name, s3_path)
```

## **7. Monitoring and Maintenance**
- **CloudWatch Logs:** Monitors EC2 instance activity.
- **SNS Notifications:** Alerts for errors and completions.
- **Periodic Review:** Verify system integrity and repository consistency.

## **8. Future Enhancements**
- Integrate with air-gapped network deployment processes.
- Optimize compression for faster processing.
- Support incremental updates to reduce bandwidth usage.
