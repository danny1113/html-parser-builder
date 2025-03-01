.PHONY: build test format lint preview-docs

all: build

build: format lint
	swift build

test:
	cd Tests && swift test

format:
	swift format \
		--in-place --parallel --recursive \
		--configuration .swift-format \
		.

lint:
	swift format lint \
		--parallel --recursive \
		--configuration .swift-format \
		--no-color-diagnostics \
		.

clean:
	-rm -rf .build Tests/.build .docc-build


DOCC_PORT := 8080
SGFS_DIR = .build/docs
UNAME_OS := $(shell uname -s)
ifeq ($(UNAME_OS),Darwin)
    DOCC_BIN := xcrun docc
else
    DOCC_BIN := docc
endif

preview-docs:
	swift build \
		--target HTMLParserBuilder \
		-Xswiftc -emit-symbol-graph \
		-Xswiftc -emit-symbol-graph-dir \
		-Xswiftc $(SGFS_DIR)
	$(DOCC_BIN) preview \
		--port $(DOCC_PORT) \
		--additional-symbol-graph-dir $(SGFS_DIR)
