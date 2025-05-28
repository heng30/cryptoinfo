#!/bin/sh

debug:
	RUST_LOG=info cargo run

build-debug:
	cargo build

build-release:
	cargo build --release

build-release-nixos:
	nix-shell --run "cargo build --release"

clean:
	cargo clean
