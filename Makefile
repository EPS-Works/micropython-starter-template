# Set the directory where your Python files are located
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

# The default target
all: $(MPY_FILES)

# Rule to compile .py to .mpy using mpy-cross
$(BUILD_DIR)/%.mpy: $(LIB_DIR)/%.py
	@mkdir -p $(dir $@)
	@echo "Compiling $< to $@..."
	$(MPY_CROSS) -o $@ $<

# Clean target to remove all .mpy files from the build directory
clean:
	@echo "Cleaning up .mpy files in $(BUILD_DIR)..."
	@rm -rf $(BUILD_DIR)

.PHONY: all clean debug
