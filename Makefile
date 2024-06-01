SHELL := /bin/bash
TRONADOR_AUTO_INIT := true

# List of targets the `readme` target should call before generating the readme
export README_DEPS ?= docs/targets.md docs/terraform.md

-include $(shell curl -sSL -o .tronador "https://cowk.io/acc"; echo .tronador)

## Lint terraform code
lint:
	$(SELF) terraform/install terraform/get-modules terraform/get-plugins terraform/lint terraform/validate
