# Task 1
## Create GKE Cluster using Terraform

- GKE cluster is created using Terraform
- Service Account is used for Terraform execution instead of user application credentials.
- GCS is used as Terraform backend.
- Managed Node Pool is used instead of default pool with 1 worker node per zone.

### Prerequisites

```bash
#Configure using application user credentials
gcloud init

export GCP_PROJECT=<Project Name>
export VAULT_SA_NAME=terraform-vault-sa
export VAULT_SA=$VAULT_SA_NAME@$GCP_PROJECT.iam.gserviceaccount.com

#Create new GCP project
gcloud projects create $GCP_PROJECT

#Enable required GCP service APIs
gcloud services enable \
compute.googleapis.com \
container.googleapis.com \
cloudkms.googleapis.com \
--project ${GCP_PROJECT}

#Create Service account to be used for this demo
gcloud iam service-accounts $VAULT_SA_NAME \
    --display-name "Service account for Terraform and Vault" \
    --project ${GCP_PROJECT}

#Add required IAM roles (used owner but specific roles should only be used)
gcloud projects add-iam-policy-binding ${GCP_PROJECT} \
    --member=serviceAccount:$VAULT_SA --role=roles/owner

#Extract the authentication json file for this service account
gcloud iam service-accounts keys create serviceaccount-auth.json \
    --iam-account=$VAULT_SA

#Configure GCS bucket for storing terraform state file.
#To be used in Terraform backend
export GCS_TF_BUCKET_NAME=<Bucket Name>
gsutil mb --pap=enforced -b on gs://$GCS_TF_BUCKET_NAME

```

### Execution
- In Jenkins
    - Setup a new pipeline job named "1-gke-using-terraform" with pipeline script as SCM from https://github.com/japneet-sahni/terraform-vault.git and jenkinsfile as 1-gke-using-terraform/terraform-1.jenkinsfile
    - Create a new secret text credential in Jenkins using base64 encoded value of serviceaccount-auth.json
    - You are all set, just click on "Build Now"
    - Before *terraform apply*, the user is requested with input to further proceed or not.

### Terraform Outputs
- gke_cluster_name = "japneet-demo-cluster"
- region = "us-central1"
