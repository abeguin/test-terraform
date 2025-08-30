# Terraform nix template

This flake provides a basic configuration to manage infrastructure with terraform.

## Structure

* terraform : contains the terraform code
* terraform/test : contains terraform tests for your infra
* .github : basic pull-request workflow

## Github Variables

You need to configure some Github repository variables to use this properly

* TF_STATE_KEY : usually $account-alias/apps/$repositoryname/terraform.tfstate
* TF_BUCKET : tfstate-pco-prod-eu-gva-operations
* TF_BUCKET_REGION : eu-west-1
* AWS_ROLE : arn:aws:iam::425434406702:role/PictetGithub-$context-$accountid-$trigram-$scope
* TF_AWS_ROLE_TO_ASSUME : arn:aws:iam::$accountid:role/PictetAppsBotRoleSFY

For more information about those variables :

* https://wiki.pictet.io/display/CLOUD/ADR+21+-+TF+State+S3+Policies+for+Bots+Roles
* https://stunning-adventure-2k47m3r.pages.github.io/docs/user-guide/aws/deploy-from-github-runners#example-use-the-roles-in-chain-to-deploy-on-aws

## Tasks

### git-root

```bash
export GIT_ROOT=$(git rev-parse --show-toplevel)
```

### tf-test

require: git-root

```bash 
cd $GIT_ROOT/terraform
terraform init --backend=false
terraform test
```

### tf-fmt-check

```bash
terraform fmt -recursive -check
```

### tf-fmt

```bash
terraform fmt -recursive
```

### tf-lint

```bash
tflint --init
tflint -f compact
```

### nix-fmt

```bash
nix fmt .
```

### nix-flake-check

```bash
nix flake check --all-systems
```

### cog-check

```bash
cog check --from-latest-tag
```

### cog-check-full

```bash
cog check
```

