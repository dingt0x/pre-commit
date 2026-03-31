.PHONY: help
help:
	@echo "help"

.PHONY: install
install:
	@cp ./devops/fmt_sh.sh .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit

