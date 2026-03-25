# Terraform DevSecOps Production Lab testing the code

## Scenario
Developer works on Jira ticket CLOUD-1023 and creates secure S3 infrastructure.

## Workflow
1. Create feature branch
2. Run DevSecOps checks locally using Makefile
3. Provide evidence to Product Owner
4. Raise PR → merge to dev
5. GitHub Actions triggers full DevSecOps pipeline

## Commands

### Install pre-commit hooks
```bash
pip install pre-commit
pre-commit install

