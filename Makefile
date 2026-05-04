.PHONY: all clean test build-go build-python build-rust build-js build-bun build-cpp help install-go install-rust install-cpp benchmark verify check-sums

# Default target
all: build-go build-python build-rust build-js build-cpp

help:
	@echo "find_dups - Multi-language Duplicate File Finder"
	@echo ""
	@echo "Targets:"
	@echo "  all          - Build all implementations"
	@echo "  build-go     - Build Go implementation"
	@echo "  build-python - No build needed (Python script)"
	@echo "  build-rust   - Build Rust implementation (release)"
	@echo "  build-js     - No build needed (Node.js script)"
	@echo "  build-bun    - No build needed (Bun script)"
	@echo "  build-cpp    - Build C++ implementation"
	@echo "  test         - Run all tests"
	@echo "  clean        - Remove build artifacts"
	@echo "  benchmark    - Run benchmarks on all implementations"
	@echo "  verify       - Verify all implementations produce identical results"
	@echo "  check-sums   - Generate checksums for all binaries"
	@echo "  install-go   - Install Go binary to /usr/local/bin"
	@echo "  install-rust - Install Rust binary to /usr/local/bin"
	@echo "  install-cpp  - Install C++ binary to /usr/local/bin"

# Go implementation
build-go:
	@echo "Building Go implementation..."
	cd find_dups_go && go build -o find_dups find_dups.go
	@echo "✓ Go binary: find_dups_go/find_dups"

install-go: build-go
	@echo "Installing Go binary..."
	cp find_dups_go/find_dups /usr/local/bin/find_dups_go
	@echo "✓ Installed to /usr/local/bin/find_dups_go"

# Python implementation (no build needed)
build-python:
	@echo "Python implementation is ready to use: find_dups_python/find_dups.py"

# Rust implementation
build-rust:
	@echo "Building Rust implementation..."
	cd find_dups_rust && cargo build --release
	@echo "✓ Rust binary: find_dups_rust/target/release/find_dups"

install-rust: build-rust
	@echo "Installing Rust binary..."
	cp find_dups_rust/target/release/find_dups /usr/local/bin/find_dups_rust
	@echo "✓ Installed to /usr/local/bin/find_dups_rust"

# JavaScript implementation (no build needed)
build-js:
	@echo "JavaScript implementation is ready to use: find_dups_js/find_dups.js"

# Bun implementation (no build needed)
build-bun:
	@echo "Bun implementation is ready to use: find_dups_bun/find_dups_bun.js"

# C++ implementation
build-cpp:
	@echo "Building C++ implementation..."
	@if [ "$$(uname)" = "Darwin" ]; then \
		cd find_dups_cp && \
		g++ -std=c++17 -O3 -pthread -I/usr/local/opt/openssl/include -L/usr/local/opt/openssl/lib \
		    find_dups.cpp -o find_dups_cpp -lcrypto; \
	else \
		cd find_dups_cp && \
		g++ -std=c++17 -O3 -pthread find_dups.cpp -o find_dups_cpp -lcrypto; \
	fi
	@echo "✓ C++ binary: find_dups_cp/find_dups_cpp"

install-cpp: build-cpp
	@echo "Installing C++ binary..."
	cp find_dups_cp/find_dups_cpp /usr/local/bin/find_dups_cpp
	@echo "✓ Installed to /usr/local/bin/find_dups_cpp"

# Testing
test: test-smoke test-integration

test-smoke:
	@echo "Running smoke tests..."
	@bash tests/run_smoke_tests.sh

test-integration:
	@echo "Running integration tests..."
	@bash tests/run_integration_tests.sh

# Benchmarking
benchmark:
	@echo "Running benchmarks..."
	@bash tests/benchmark.sh

# Verification
verify:
	@echo "Verifying all implementations produce identical results..."
	@bash tests/verify.sh

# Checksums
check-sums:
	@echo "Generating checksums for binaries..."
	@mkdir -p .checksums
	@if [ -f find_dups_go/find_dups ]; then \
		sha256sum find_dups_go/find_dups > .checksums/go.txt; \
		echo "✓ Go: $$(cat .checksums/go.txt)"; \
	fi
	@if [ -f find_dups_rust/target/release/find_dups ]; then \
		sha256sum find_dups_rust/target/release/find_dups > .checksums/rust.txt; \
		echo "✓ Rust: $$(cat .checksums/rust.txt)"; \
	fi
	@if [ -f find_dups_cp/find_dups_cpp ]; then \
		sha256sum find_dups_cp/find_dups_cpp > .checksums/cpp.txt; \
		echo "✓ C++: $$(cat .checksums/cpp.txt)"; \
	fi
	@echo "Checksums saved to .checksums/"

# Clean
clean:
	@echo "Cleaning build artifacts..."
	cd find_dups_rust && cargo clean || true
	rm -f find_dups_go/find_dups
	rm -f find_dups_cp/find_dups_cpp
	rm -rf .checksums
	rm -f test_data/test_*.txt
	@echo "✓ Clean complete"
