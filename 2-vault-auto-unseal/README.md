# Task 2
## Setup Vault using aut-unseal capability

- The setup fetches cluster credentials from GKE cluster created in first task.
- GCP KMS is used for auto-unseal capabilities.
- GCS is used as HA storage for vault.
- HELM is used for vault deployment.
- Vault is HA enabled with one active and 2 standby nodes.

### Prerequisites
Note: Below pre-requisites can be automated using Terraform as well.

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

### Execution
- In Jenkins
    - Setup a new pipeline job named "2-vault-auto-unseal" with pipeline script as SCM from https://github.com/japneet-sahni/terraform-vault.git and jenkinsfile as 2-vault-auto-unseal/terraform-2.jenkinsfile
    - You are all set, just click on "Build Now"

### Vault Deployment
Vault is deployed using HELM. All the required configurations are stored in vault-values.yml
```bash 
helm upgrade --install vault hashicorp/vault -f vault-values.yml
```

### Output
```bash
kubectl exec vault-0 -- vault status
Key                      Value
---                      -----
Recovery Seal Type       gcpckms
Initialized              false
Sealed                   true
Total Recovery Shares    0
Threshold                0
Unseal Progress          0/0
Unseal Nonce             n/a
Version                  1.7.3
Storage Type             gcs
HA Enabled               true
command terminated with exit code 2
```

### Next Steps from CLI
```bash
#Initialize the vault. The vault will be automatically be unsealed using gcpckms
kubectl exec vault-0 -- vault operator init -format=json > recover_keys.json
Key                      Value
---                      -----
Recovery Seal Type       shamir
Initialized              true
Sealed                   false
Total Recovery Shares    5
Threshold                3
Version                  1.7.3
Storage Type             gcs
Cluster Name             vault-cluster-67cd6926
Cluster ID               --
HA Enabled               true
HA Cluster               https://vault-1.vault-internal:8201
HA Mode                  active
Active Since             2021-07-23T22:06:34.586380937Z

kubectl exec vault-0 -- vault status
kubectl exec vault-1 -- vault status
kubectl exec vault-2 -- vault status
```