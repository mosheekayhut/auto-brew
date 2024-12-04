#!/bin/bash
set -e

# עדכון מערכת
sudo apt-get update && sudo apt-get upgrade -y

# התקנת כלים נדרשים
sudo apt-get install -y git wget curl tar

# משתני סביבה
BUCKET_NAME="homebrew-mirror-bucket"
AWS_REGION="us-east-1"
LOCAL_HOME_DIR="/opt/homebrew"
SYNC_DIR="/tmp/homebrew-sync"
LOG_FILE="/var/log/homebrew_sync.log"

# יצירת ספריות
mkdir -p ${LOCAL_HOME_DIR} ${SYNC_DIR}
echo "$(date): Starting Homebrew setup" >> ${LOG_FILE}

# סנכרון קבצים מה-S3
aws s3 sync s3://${BUCKET_NAME}/ ${SYNC_DIR} --region ${AWS_REGION}

# פירוק הארכיון
echo "$(date): Extracting Homebrew files" >> ${LOG_FILE}
tar -xzf ${SYNC_DIR}/brew-files.tar.gz -C ${LOCAL_HOME_DIR}

# עדכון Homebrew
echo "$(date): Updating Homebrew" >> ${LOG_FILE}
cd ${LOCAL_HOME_DIR}
bin/brew update

# שמירת ה-Hash החדש
echo "$(date): Saving updated Hash" >> ${LOG_FILE}
tar -czf ${SYNC_DIR}/brew-files.tar.gz -C ${LOCAL_HOME_DIR} .
aws s3 cp ${SYNC_DIR}/brew-files.tar.gz s3://${BUCKET_NAME}/ --region ${AWS_REGION}

echo "$(date): Homebrew setup complete" >> ${LOG_FILE}
