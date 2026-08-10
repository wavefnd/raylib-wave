WAVEC ?= wavec
PKG_CONFIG ?= pkg-config
RAYLIB_PACKAGE ?= raylib
BUILD_DIR ?= target
EXAMPLE ?= example
WAVEC_FLAGS ?=

EXAMPLE_NAMES := example shapes text windows
EXAMPLE_SOURCES := $(addprefix examples/,$(addsuffix .wave,$(EXAMPLE_NAMES)))
EXAMPLE_BINS := $(addprefix $(BUILD_DIR)/,$(EXAMPLE_NAMES))
EXAMPLE_OBJECTS := $(addprefix $(BUILD_DIR)/,$(addsuffix .o,$(EXAMPLE_NAMES)))

RAYLIB_LIBRARY_FLAGS := $(patsubst -l%,--link=%,$(shell $(PKG_CONFIG) --libs-only-l $(RAYLIB_PACKAGE) 2>/dev/null))
RAYLIB_SEARCH_FLAGS := $(shell $(PKG_CONFIG) --libs-only-L $(RAYLIB_PACKAGE) 2>/dev/null)
RAYLIB_LINK_FLAGS ?= $(strip $(RAYLIB_SEARCH_FLAGS) $(RAYLIB_LIBRARY_FLAGS))

.PHONY: all examples build run check dry-run check-tools print-config clean help

all: examples

examples: check-tools $(EXAMPLE_BINS)

build: check-tools $(BUILD_DIR)/$(EXAMPLE)

run: build
	./$(BUILD_DIR)/$(EXAMPLE)

check: check-tools
	@set -eu; \
	for source in $(EXAMPLE_SOURCES); do \
		echo "Checking $$source"; \
		$(WAVEC) $(WAVEC_FLAGS) check "$$source"; \
	done

dry-run: check-tools | $(BUILD_DIR)
	$(WAVEC) $(WAVEC_FLAGS) $(RAYLIB_LINK_FLAGS) build examples/$(EXAMPLE).wave -o $(BUILD_DIR)/$(EXAMPLE) --dry-run

$(BUILD_DIR)/%: examples/%.wave raylib.wave | $(BUILD_DIR)
	$(WAVEC) $(WAVEC_FLAGS) $(RAYLIB_LINK_FLAGS) build $< -o $@

$(BUILD_DIR):
	mkdir -p $@

check-tools:
	@command -v "$(WAVEC)" >/dev/null 2>&1 || { echo "error: wavec was not found; set WAVEC=/path/to/wavec" >&2; exit 1; }
	@command -v "$(PKG_CONFIG)" >/dev/null 2>&1 || { echo "error: pkg-config was not found" >&2; exit 1; }
	@$(PKG_CONFIG) --exists $(RAYLIB_PACKAGE) || { echo "error: pkg-config package '$(RAYLIB_PACKAGE)' was not found; install the raylib development package" >&2; exit 1; }

print-config: check-tools
	@echo "WAVEC=$(WAVEC)"
	@echo "RAYLIB_PACKAGE=$(RAYLIB_PACKAGE)"
	@echo "RAYLIB_LINK_FLAGS=$(RAYLIB_LINK_FLAGS)"
	@echo "EXAMPLE=$(EXAMPLE)"

clean:
	$(RM) $(EXAMPLE_BINS) $(EXAMPLE_OBJECTS)
	@rmdir $(BUILD_DIR) 2>/dev/null || true

help:
	@echo "make                         Build every example"
	@echo "make build EXAMPLE=shapes    Build one example"
	@echo "make run EXAMPLE=shapes      Build and run one example"
	@echo "make check                   Check all Wave sources"
	@echo "make dry-run EXAMPLE=shapes  Print the wavec build plan"
	@echo "make print-config            Show detected linker flags"
	@echo "make clean                   Remove example binaries"
