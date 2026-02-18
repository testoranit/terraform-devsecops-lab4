REPORTS_DIR=reports

init:
	mkdir -p $(REPORTS_DIR)

fmt:
	terraform fmt -recursive

validate:
	cd infra && terraform validate

gitleaks:
	gitleaks detect --source . --report-path $(REPORTS_DIR)/gitleaks-report.json

checkov:
	checkov -d infra/ -o json > $(REPORTS_DIR)/checkov-report.json

terrascan:
	terrascan scan -i terraform -d infra/ -p policies/terrascan/ \
	-o json > $(REPORTS_DIR)/terrascan-report.json

trivy:
	trivy config infra/ --format json \
	-o $(REPORTS_DIR)/trivy-report.json

all:
	make init
	make fmt
	make validate
	make gitleaks
	make checkov
	make terrascan
	make trivy

evidence:
	ls -lh reports/

