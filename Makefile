.PHONY: build test format lint

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
	-rm -rf .build
	-rm -rf Tests/.build
