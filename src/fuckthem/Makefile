# Name of the output executable
APP_NAME = fuckthem.exe

# Source files
GO_FILES = fuckthem.go

# Compiler flags
# -s -w: Omit symbol table and debug information
# -H=windowsgui: Hide the console window on execution
LDFLAGS = -s -w -H=windowsgui

# Environment variables for cross-compilation targeting 64-bit Windows
BUILD_ENV = GOOS=windows GOARCH=amd64

.PHONY: all build run clean fmt deps

# Default target
all: build

# Compilation rule
build: deps fmt
	@echo "Building $(APP_NAME)..."
	$(BUILD_ENV) go build -ldflags="$(LDFLAGS)" -o $(APP_NAME) $(GO_FILES)
	@echo "Build completed!"

# Rule to run the binary directly (works via WSL/interoperability from a Linux terminal)
run: build
	@echo "Running $(APP_NAME)..."
	./$(APP_NAME)

# Rule to clean up generated files
clean:
	@echo "Cleaning binaries..."
	rm -f $(APP_NAME)
	@echo "Cleanup completed!"

# Rule to format source code
fmt:
	@echo "Formatting source code..."
	go fmt ./...

# Rule to ensure dependencies are updated
deps:
	@echo "Resolving dependencies..."
	go mod tidy
