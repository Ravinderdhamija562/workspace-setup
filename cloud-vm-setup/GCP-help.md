# GCP Help

## Launch GCP instance

```
gcloud compute instances create rk-bastion-server \
    --project=ns-cicd \
    --zone=us-west1-b \
    --machine-type=e2-standard-2 \
    --network-interface=stack-type=IPV4_ONLY,subnet=projects/ns-npe-shared-vpc/regions/us-west1/subnetworks/shared-vpc-ns-usw1,no-address \
    --metadata=ssh-keys=ravinderk:ssh-rsa\ \
AAAAB3NzaC1yc2EAAAADAQABAAABgQC9eTG08TOqalRQm0S\+NdZrnqI58CK4MrWM\+ozs8LJ3YA6V4s2owN5nJVanM47gBgY2ylmxdwseOFCN06E\+zCb0S2CmNAvsMOO8jkzolq7NgTui9NEJMeu4czmY9dZbySWHGK\+Yehtl75yz6s\+3\+Vrd0oxT07b\+V4BwK/Na0TjulyPJZqACdgCMqbs0qCkyHFV7LKvz7SOcz1IPVXPNWCMe4vL6sydXBNpi2TBkZ1r\+3zYMo7OjW2A8YsEmphlZRJVas48nbgMK8jcBW\+rilvqKL4/YxT\+2JA6CdkymI7U7xKYuJKYwR5AiWUmE9zmxNru/kdk53KdYklSUOFa6Hea72TjBxSv1G/Yy2tTbioQRAkIvtLgAgmltT21EUPSjFVJ6hz01Kunwj444tLo\+zEaOoNjIqkgRS\+dYDJTj2JXsZMB8ULOksp5VAsxBJpE5k19ZBwLFOxctKeKWHLnlJ1rQ6euq51ltyE/lneJwB8QzQXIOrIDYKsHzP7bQONsEac8=\ ravinderk@CT4WL2KYTX.local \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=609294243641-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --tags=allow-ssh \
    --create-disk=auto-delete=yes,boot=yes,device-name=rk-bastion-server,image=projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230829,mode=rw,size=50,type=projects/ns-cicd/zones/us-west1-b/diskTypes/pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any
```

## Gcloud

gcloud projects list
gcloud init # New configuration
gcloud config configurations list
gcloud config configurations activate dhamija560-project2-uscentral1-c
gcloud container clusters list
gcloud container clusters describe gke1 --region us-central1-c
gcloud container node-pools list --cluster gke1
gcloud container clusters get-credentials gke1 --region us-central1-c

### Get/Remove Role owner

gcloud auth activate-service-account --key-file spinnaker-gcs-account-rk-sa.json
gcloud projects add-iam-policy-binding ns-cicd --member=user:ravinderk@netskope.com --role=roles/owner

gcloud projects remove-iam-policy-binding ns-cicd --member=user:ravinderk@netskope.com --role=roles/owner # Remove owner

### Tunneling ssh,vnc with iap

#### Enable vnc from local machine to GCP VM

On GCP VM -
    sudo chmod -R 777 /tmp
    tightvncserver -geometry 1920x1080 (it should start x Desktop at :1)
On local system -
    gcloud compute start-iap-tunnel rk-bastion-server 5901 --local-host-port=localhost:5901 &
    Connect from local system using realvnc viewer with localhost:5901

#### Enable ssh from local machine to GCP VM

On local system - 
gcloud compute start-iap-tunnel rk-bastion-server 22 --zone=us-west1-b --local-host-port=localhost:2220 &
ssh ravinderk@localhost -p 2220


### Stop GCP VM

```bash
export VMNAMES="rk-bastion-server"
gcloud compute instances stop $VMNAMES
```

### Start GCP VM

```bash
#Make sure you are connected to vpn to ssh to instance
export VMNAMES="rk-bastion-server"
gcloud compute instances start $VMNAMES
```

## Delete GCP VM

```bash
gcloud compute instances list | grep -i rk-bas
export VMNAMES="rk-bastion-server rk-bastion-server2"
gcloud compute instances delete $VMNAMES
```