ssh-keygen -t rsa -f ~/.ssh/gc_rsa -C yourname


gcloud compute --project "REMOVED OUR PROJECT ID" instances create "$INSTANCE_NAME" \
    --zone "europe-west1-c" \
    --machine-type "f1-micro" \
    --network "cloudnet" \
    --subnet "$SERVER_SUBNET" \
    --no-address \
    --private-network-ip="$SERVER_IP" \
    --maintenance-policy "MIGRATE" \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --service-account "default" \
    --tags "$TAGS" \
    --image-family "debian-8" \
    --boot-disk-size "10" \
    --boot-disk-type "pd-ssd" \
    --boot-disk-device-name "bootdisk-$INSTANCE_NAME" \



gcloud compute instances create instance-1 


gcloud compute instances create career
  --zone us-east1-c
  --machine-type f1-micro
  --image ubuntu-16-04
  --network default




gcloud compute --project "REMOVED OUR PROJECT ID" instances create "$INSTANCE_NAME" \
    --zone "europe-west1-c" \
    --machine-type "f1-micro" \
    --network "cloudnet" \
    --subnet "$SERVER_SUBNET" \
    --no-address \
    --private-network-ip="$SERVER_IP" \
    --maintenance-policy "MIGRATE" \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --service-account "default" \
    --tags "$TAGS" \
    --image-family "debian-8" \
    --boot-disk-size "10" \
    --boot-disk-type "pd-ssd" \
    --boot-disk-device-name "bootdisk-$INSTANCE_NAME" \








step1: preparations

install google cloud sdk
Install 

gcloud init

Step2: create cluster

gcloud dataproc clusters create spark-jason \
--initialization-actions gs://dataproc-initialization-actions/datalab/datalab.sh \
--master-boot-disk-size=50 \
--master-machine-type=n1-standard-2 \
--worker-boot-disk-size=50 \
--worker-machine-type=n1-standard-2 \
--zone=us-central1-b \
--scopes cloud-platform   
gs://dataproc-initialization-actions/datalab/datalab.sh \


gcloud dataproc clusters create NAME 
[--async] 
[--bucket=BUCKET] 
[--image-version=VERSION]
[--initialization-action-timeout=TIMEOUT; default="10m"]
[--initialization-actions=CLOUD_STORAGE_URI,[CLOUD_STORAGE_URI,…]] 
[--labels=[KEY=VALUE,…]]
[--master-boot-disk-size=MASTER_BOOT_DISK_SIZE]
[--master-machine-type=MASTER_MACHINE_TYPE] 
[--metadata=KEY=VALUE,[KEY=VALUE,…]]
[--num-master-local-ssds=NUM_MASTER_LOCAL_SSDS]
[--num-preemptible-workers=NUM_PREEMPTIBLE_WORKERS]
[--num-worker-local-ssds=NUM_WORKER_LOCAL_SSDS] 
[--num-workers=NUM_WORKERS]
[--preemptible-worker-boot-disk-size=PREEMPTIBLE_WORKER_BOOT_DISK_SIZE]
[--properties=[PREFIX:PROPERTY=VALUE,…]] 
[--region=REGION] 
[--scopes=SCOPE,[SCOPE,…]]
[--service-account=SERVICE_ACCOUNT] 
[--tags=TAG,[TAG,…]]
[--worker-boot-disk-size=WORKER_BOOT_DISK_SIZE]
[--worker-machine-type=WORKER_MACHINE_TYPE] 
[--zone=ZONE, -z ZONE] 
[--network=NETWORK    | --subnet=SUBNET] 
[GCLOUD_WIDE_FLAG …]





step3: create ssh connection

gcloud compute ssh --zone=us-central1-b spark-jason-m -- \
  -D 1080 -N -n

Notice: here the master-host-name means your cluster name +m as 

gcloud compute ssh --zone=master-host-zone master-host-name -- \
  -D 1080 -N -n

Or!!! not use socks proxy just use local host
Type the following instead
the following command lets you access localhost:8088

gcloud compute ssh spark-jason-m -- -D 8088 -N -n


gcloud compute ssh cluster-name-m -- -D 8088 -N -n



Step4: connect through socks proxy 
Google Chrome executable path \
  --proxy-server="socks5://localhost:1080" \
  --host-resolver-rules="MAP * 0.0.0.0 , EXCLUDE localhost" \
  --user-data-dir=/tmp/spark-jason-m


Google Chrome executable path \
  --proxy-server="socks5://localhost:1080" \
  --host-resolver-rules="MAP * 0.0.0.0 , EXCLUDE localhost" \
  --user-data-dir=/tmp/master-host-name


或者用云平台上的shell
Replace the first port argument with the Cloud Shell port you will use (8080 - 8084)

gcloud compute ssh --zone us-central1-b spark-jason-m -- \
  -N -L port:spark-jason-m:8080

gcloud compute ssh --zone master-host-zone master-host-name -- \
  -N -L port:master-host-name:8080


问题：
1： ERROR: (gcloud.compute.ssh) [/usr/bin/ssh] exited with return code [255].

去云平台的computer enginee 的metadata里面把ssh key给删除，再重新跑之前的代码
2: reset ssh
rm ~/.ssh/google_compute_engine*
