# Project Setup Configuration
VENV = .venv
TYPINGS_DIR = typings
REQUIREMENTS = requirements.txt
KEEP = utoml.pyi

# Build Configuration
LIB_DIR = src
BUILD_DIR = build

# Define mpy-cross path - will be available after installing dependencies
MPY_CROSS_CHECK = $(shell if [ -f "$(VENV)/bin/mpy-cross" ]; then echo "$(VENV)/bin/mpy-cross"; else which mpy-cross 2>/dev/null; fi)
MPY_CROSS = $(if $(MPY_CROSS_CHECK),$(MPY_CROSS_CHECK),$(VENV)/bin/mpy-cross)

# Find all .py files in LIB_DIR and its subdirectories
PY_FILES = $(shell find $(LIB_DIR) -type f -name "*.py")

# Define target for all .mpy files in the build directory
MPY_FILES = $(patsubst $(LIB_DIR)/%.py,$(BUILD_DIR)/%.mpy,$(PY_FILES))


# TARGETS -----------------------------------------------------------------

# Setup & Dependency Installation
setup: install-deps install-stubs

install-deps:
	source $(VENV)/bin/activate && pip install -r $(REQUIREMENTS)

install-stubs:
	source $(VENV)/bin/activate && pip install -U micropython-stm32-stubs --no-user --target $(TYPINGS_DIR)
	source $(VENV)/bin/activate && pip install git+https://github.com/eps-works/sdk-stubs.git  --target $(TYPINGS_DIR)


# Build
build: check-mpy-cross $(MPY_FILES)

check-mpy-cross:
	@if [ ! -f "$(MPY_CROSS)" ]; then \
		echo "Error: mpy-cross not found at $(MPY_CROSS)"; \
		echo "Please run 'make setup' first to install dependencies."; \
		exit 1; \
	fi

$(BUILD_DIR)/%.mpy: $(LIB_DIR)/%.py
	@mkdir -p $(dir $@)
	@echo "Compiling $< to $@"
	$(MPY_CROSS) -o $@ $<


# Clean
clean-setup:
	@echo "Cleaning $(TYPINGS_DIR)..."
	@rm -rf $(TYPINGS_DIR)/*

clean-build:
	@echo "Cleaning up build directory..."
	@rm -rf $(BUILD_DIR)

clean: clean-setup clean-build

# Optional: rebuild everything
rebuild: clean-build build

.PHONY: setup install-deps install-stubs build check-mpy-cross clean clean-build clean-setup rebuild
