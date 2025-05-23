# Detect OS and set DYLD_FALLBACK_LIBRARY_PATH if macOS
ifeq ($(shell uname),Darwin)
  export DYLD_FALLBACK_LIBRARY_PATH := /opt/homebrew/lib
endif

default:
	@echo "Call a specific subcommand:"
	@echo
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null\
	| awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}'\
	| sort\
	| egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo
	@exit 1

.state/check-uv:
	@# Check if the uv command is available, if not, prompt to install
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "uv is not installed."; \
		echo "Do you want to install uv https://docs.astral.sh/uv/ ? (y/n): "; \
		read answer; \
		if [ "$$answer" = "y" ]; then \
			echo "Installing uv..."; \
			curl -LsSf https://astral.sh/uv/install.sh | sh; \
			echo "uv installed successfully."; \
			echo "Please restart your terminal and then continue."; \
			exit 1; \
		else \
			echo "uv installation skipped. Exiting..."; \
			exit 1; \
		fi; \
	fi; \

	@# Mark the state so we don't rebuild this needlessly.
	mkdir -p .state
	touch .state/check-uv

.state/deps-install-with-uv: .state/check-uv uv.lock pyproject.toml mkdocs.yml 
	@# Synchronize the dependencies with the ones in the virtual environment
	uv sync

	@# Mark the state so we don't rebuild this needlessly.
	mkdir -p .state
	touch .state/deps-install-with-uv

serve: .state/deps-install-with-uv
	@# Start the server
	@echo "Starting the server..."
	@echo "You can access the site at http://localhost:8000"
	uv run mkdocs serve

build: .state/deps-install-with-uv
	@# Build the site
	@echo "Building the site..."
	uv run mkdocs build

requirements: .state/deps-install-with-uv
	@# Generate the requirements file
	@echo "Generating the requirements file..."
	uv export --format requirements.txt > requirements.txt

build-clean:
	@# Clear the build artifacts if exists.
	@echo "Cleaning the build artifacts..."
	rm -rf site

cache-clean:
	@# Clear all the stuff
	@echo "Cleaning all the cache..."
	rm -rf .state
	rm -rf .venv
	rm -rf .mypy_cache
	rm -rf .cache


.PHONY: serve build requirements build-clean cache-clean
