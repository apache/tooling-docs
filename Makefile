.PHONY: check check-light sync sync-all update-deps
.DEFAULT_GOAL := help

check: ## Run all pre-commit checks.
	git add -A
	uv run pre-commit run --all-files

check-light: ## Run the light set of pre-commit checks.
	git add -A
	uv run pre-commit run --all-files --config .pre-commit-light.yaml

sync: ## Sync non-development dependencies using uv.
	uv sync --no-dev

sync-all: ## Sync all dependencies (including development) using uv.
	uv sync --all-groups

update-deps: ## Update pre-commit hooks and dependency locks.
	pre-commit autoupdate || :
	uv lock --upgrade
	uv sync --all-groups
