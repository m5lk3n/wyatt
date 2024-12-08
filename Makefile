## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## install: add all required dependencies
.PHONY: install
install:
	flutter pub add flutter_lints --dev
	flutter pub add flutter_launcher_icons --dev
	flutter pub add package_info_plus
	flutter pub add google_fonts
	flutter pub add url_launcher
	flutter pub add flutter_secure_storage
	flutter pub add http
	flutter pub add uuid
	flutter pub add shared_preferences
	flutter pub add flutter_riverpod
	flutter pub add go_router
	flutter pub add restart_app
	flutter pub add google_maps_flutter
	flutter pub add location
	flutter pub add geocoding
	flutter pub add google_map_dynamic_key
	flutter pub add flutter_datetime_picker_plus
	flutter pub add intl
	flutter pub add geofence_foreground_service
	flutter pub add permission_handler
	flutter pub add internet_connection_checker_plus

## clean: remove all dependencies and install them again
.PHONY: clean
clean:
	flutter pub get

## update: update all dependencies
.PHONY: update
update:
	flutter pub outdated

## upgrade: major upgrade dependencies
.PHONY: upgrade
upgrade:
	flutter pub upgrade --major-versions

# generate: generate code
#.PHONY: generate
#generate:
#	dart run build_runner build --delete-conflicting-outputs

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

## generate_lttl_dev: generate lttl.dev/wyatt
.PHONY: generate_lttl_dev
generate_lttl_dev:
	lttl.dev/generate.sh

.PHONY: needs-clean-build
needs-clean-build:
	rm -rf build

## android-debug: build the apk in debug mode
.PHONY: android-debug
android-debug: needs-clean-build
	flutter build apk --debug

## ios-debug: regenerate dependencies for iOS and build the application in debug mode
.PHONY: ios-debug
ios-debug: needs-clean-build
	cd ios && pod install
	flutter build ios --debug --dart-define=KEY_URL=http://192.168.1.115/note/wyatt#key --dart-define=KEY_WHAT_URL=https://wyatt.lttl.dev/what --dart-define=KEY_WHY_URL=https://wyatt.lttl.dev/why --dart-define=KEY_PERMISSIONS_URL=https://wyatt.lttl.dev/permissions

# ios-debug: regenerate dependencies for iOS and build the application in debug mode
#.PHONY: ios-release
#ios-debug: needs-clean-build
#	cd ios && pod install
#	flutter build ios --debug

# TODO: ios-release: regenerate dependencies for iOS and build the application in release mode
#.PHONY: ios-release
#ios-release: needs-clean-build
#	cd ios && pod install
#	flutter build ios --release --obfuscate?
