.PHONY: help
help:
	@echo "help"

.PHONY: install
install:
	@cp ./devops/pre_commit_hook.sh .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit

