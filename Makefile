# Project Setup Configuration
VENV = .venv
TYPINGS_DIR = typings
REQUIREMENTS = requirements.txt
KEEP = utoml.pyi

# Build Configuration
LIB_DIR = src
BUILD_DIR = build

# Try to detect mpy-cross using 'which'
MPY_CROSS = $(shell which mpy-cross)

# Fallback to a default location if not found
ifneq ($(MPY_CROSS),)
    $(info Found mpy-cross at $(MPY_CROSS))
else
    $(error mpy-cross not found! Please install mpy-cross or specify the path in the Makefile.)
endif

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


# Build
build: $(MPY_FILES)

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

.PHONY: setup install-deps install-stubs build clean clean-build clean-setup rebuild
