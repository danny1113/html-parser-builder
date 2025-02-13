.PHONY: build test format

build:
	swift build

test:
	cd Tests && swift test

format:
	swift format \
		--in-place --parallel --recursive \
		--configuration .swift-format \
		.

clean:
	-rm -rf .build
	-rm -rf Tests/.build
