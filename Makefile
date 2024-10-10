## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## install: add all required dependencies
.PHONY: install
install:
	flutter pub add google_fonts
	flutter pub add flutter_linkify
	flutter pub add url_launcher
	flutter pub add flutter_secure_storage

## update: update all dependencies
.PHONY: update
update:
	flutter pub outdated

## upgrade: major upgrade dependencies
.PHONY: upgrade
upgrade:
	flutter pub upgrade --major-versions

## test: test the application
.PHONY: test
test:
	flutter test

## run: start the application
.PHONY: run
run:
	flutter run

## icons: regenerate application launcher icons (from assets/icon/icon.png)
.PHONY: icons
icons:
	dart run flutter_launcher_icons