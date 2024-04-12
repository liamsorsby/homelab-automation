tf-lint:
	terraform -chdir=./terraform fmt
tf-plan: tf-lint
	terraform -chdir=./terraform plan -out plan.out -var-file=./environments/test/variables.tfvars
tf-apply: tf-lint tf-plan
	terraform -chdir=./terraform apply "plan.out"
tf-destroy: tf-lint
	terraform -chdir=./terraform destroy -var-file=./environments/test/variables.tfvars -auto-approve

install-deps: ansible-install-deps

ansible-install-deps:
	ansible-galaxy install -r ./ansible/k8s/requirements.yaml
	ansible-galaxy install -r ./ansible/dns/requirements.yaml
