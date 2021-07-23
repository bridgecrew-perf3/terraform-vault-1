# Task 2
## Setup Vault using aut-unseal capability

### Prerequisites

```bash
#Create GCS bucket for Vault Storage
export GCS_VAULT_BUCKET_NAME=$(GCP_PROJECT)-vault-data
gsutil mb --pap=enforced -b on gs://$GCS_VAULT_BUCKET_NAME

#Create keyring in GCP KMS
gcloud kms keyrings create vault-unseal-keyring \
    --location global \
    --project ${GCP_PROJECT}

#Create key in GCP KMS
gcloud kms keys create vault-unseal-key \
    --location global \
    --keyring vault-unseal-keyring \
    --purpose encryption \
    --project ${GCP_PROJECT}

#Give required permissions to vault unseal key
gcloud kms keys add-iam-policy-binding \
    vault-unseal-key \
    --location global \
    --keyring vault-unseal-keyring \
    --member serviceAccount:${VAULT_SA} \
    --role roles/cloudkms.cryptoKeyEncrypterDecrypter \
    --project ${GCP_PROJECT}
```

##Execution
- In Jenkins
    - Setup a new pipeline job named "2-vault-auto-unseal" with pipeline script as SCM from https://github.com/japneet-sahni/terraform-vault.git and jenkinsfile as 2-vault-auto-unseal/terraform-2.jenkinsfile
    - You are all set, just click on "Build Now"

##Output
```bash
kubectl exec vault-0 -- vault status
```

##Next Steps from CLI
```bash
#Initialize the 
kubectl exec vault-0 -- vault operator init -format=json > recover_keys.json

kubectl exec vault-0 -- vault status
kubectl exec vault-1 -- vault status
kubectl exec vault-2 -- vault status
```