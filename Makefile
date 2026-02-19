############################################
# DevSecOps Terraform Lab - Makefile
# Evidence + Security Scanning Automation
############################################

REPORTS_DIR=reports

############################################
# Step 1: Initialize Evidence Folder
############################################
init:
	@echo "Creating reports directory..."
	mkdir -p $(REPORTS_DIR)

############################################
# Step 2: Terraform Formatting
############################################
fmt:
	@echo "Running terraform fmt..."
	terraform fmt -recursive

############################################
# Step 3: Terraform Validation
############################################
validate:
	@echo "Running terraform validate..."
	cd infra && terraform validate

############################################
# Step 4: Secret Scanning (Gitleaks)
############################################
gitleaks:
	@echo "Running gitleaks scan..."
	gitleaks detect \
	  --source . \
	  --report-path $(REPORTS_DIR)/gitleaks-report.json

############################################
# Step 5: IaC Security Scan (Checkov)
############################################
checkov:
	@echo "Running checkov scan..."
	checkov -d infra/ \
	  --output json \
	  --output-file-path $(REPORTS_DIR)/

############################################
# Step 6: Compliance Scan (Terrascan + Custom Policies)
############################################
terrascan:
	@echo "Running terrascan compliance scan..."
	terrascan scan \
	  -i terraform \
	  -d infra/ \
	  -p policies/terrascan/ \
	  -o json \
	  --output $(REPORTS_DIR)/terrascan-report.json

############################################
# Step 7: Misconfiguration Scan (Trivy)
############################################
trivy:
	@echo "Running trivy config scan..."
	trivy config infra/ \
	  --format json \
	  -o $(REPORTS_DIR)/trivy-report.json

############################################
# Full DevSecOps Evidence Pipeline
############################################
all: init fmt validate gitleaks checkov terrascan trivy
	@echo "======================================"
	@echo " DevSecOps Scan Completed Successfully "
	@echo " Reports available in: $(REPORTS_DIR)/ "
	@echo "======================================"

############################################
# Evidence Listing for Scrum/PO Review
############################################
evidence:
	@echo "Generated Evidence Reports:"
	ls -lh $(REPORTS_DIR)/

