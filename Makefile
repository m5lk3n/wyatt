DEFAULT_DEV_URL = "http://192.168.1.115/note/wyatt"
DEV_URL ?= ${DEFAULT_DEV_URL} # can be overridden by ENV param 

## help: print this help message
.PHONY: help
help:
	@echo 'usage: make <target>'
	@echo
	@echo '  where <target> is one of the following:'
	@echo
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'
	@echo
	@echo "hint: use 'export DEV_URL=my.dev.url' to overwrite the default '${DEFAULT_DEV_URL}'"

## install: add all required dependencies
.PHONY: install
install:
	flutter clean
	flutter pub add flutter_lints --dev
	flutter pub add flutter_launcher_icons --dev
	flutter pub add version_bmp --dev
	flutter pub add package_info_plus
	flutter pub add google_fonts
	flutter pub add url_launcher
	flutter pub add flutter_secure_storage
	flutter pub add http
	flutter pub add uuid
	flutter pub add get_storage
	flutter pub add flutter_riverpod
	flutter pub add go_router
	flutter pub add restart_app
	flutter pub add google_maps_flutter
	flutter pub add location
	flutter pub add geocoding
	flutter pub add google_map_dynamic_key
	flutter pub add flutter_datetime_picker_plus
	flutter pub add intl
	flutter pub add permission_handler
	flutter pub add internet_connection_checker_plus
	flutter pub add haversine_distance
# TODO/FIXME (pending https://github.com/fluttercommunity/flutter_workmanager/issues/551): flutter pub add workmanager
	flutter pub add shared_preferences
	flutter pub add flutter_local_notifications
	flutter pub add geolocator
	flutter pub add timezone
	flutter pub add logging
	flutter pub add path_provider
	flutter pub add confirm_dialog

## clean: remove all dependencies and install them again
.PHONY: clean
clean:
	flutter clean
	flutter pub get

## update: update all dependencies
.PHONY: update
update:
	flutter pub outdated

## upgrade: major upgrade dependencies
.PHONY: upgrade
upgrade:
	flutter pub upgrade --major-versions

## test: test the application (spoiler: not)
.PHONY: test
test:
	flutter test

## run: execute the application (in release mode but with dev URL)
.PHONY: run
run:
	flutter run --release --dart-define=URL_KEY=${DEV_URL}

## icons: regenerate application launcher icons (from assets/icon/icon.png)
.PHONY: icons
icons:
	dart run flutter_launcher_icons
# https://github.com/fluttercommunity/flutter_launcher_icons/issues/578#issuecomment-2366797554:
	rm -rf android/app/src/main/res/mipmap-anydpi-v26

## bump: bump the version in pubspec
.PHONY: bump
bump:
	dart run version_bmp

## tag: git tag the current pubspec version
.PHONY: tag
tag:
	./tag.sh

## lttl_dev: generate lttl.dev/wyatt and deploy to wyatt.lttl.dev
.PHONY: lttl_dev
lttl_dev:
	lttl.dev/generate.sh
	lttl.dev/deploy.sh

## bump-tag-lttl_dev: see bump + tag + lttl_dev
.PHONY: bump-tag-lttl_dev
bump-tag-lttl_dev: bump tag lttl_dev

## build-android-debug: build the apk in debug mode
.PHONY: build-android-debug
build-android-debug: clean
	flutter build apk --debug --dart-define=URL_KEY=${DEV_URL}

## all-android: (re-)start from scratch, install all dependencies, build the apk in release mode, and install on device
.PHONY: all-android
all-android: clean update upgrade
	flutter build apk --release # --obfuscate --split-debug-info=build/app/outputs/flutter-apk/app-armeabi-v7a-release-obfuscation ?
	flutter install

## build-ios-debug: regenerate dependencies for iOS and build the application in debug mode
.PHONY: build-ios-debug
build-ios-debug: clean
	cd ios && pod install
	flutter build ios --debug --dart-define=URL_KEY=${DEV_URL}

# TODO: all-ios: regenerate dependencies for iOS and build the application in release mode
#.PHONY: all-ios
#all-ios-release: clean update upgrade
#	cd ios && pod install
#	flutter build ios --release --obfuscate?
#   flutter install
