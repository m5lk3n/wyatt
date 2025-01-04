## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## install: add all required dependencies
.PHONY: install
install:
	flutter clean
	flutter pub add flutter_lints --dev
	flutter pub add flutter_launcher_icons --dev
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
	flutter pub add workmanager
	flutter pub add shared_preferences
	flutter pub add flutter_local_notifications
	flutter pub add geolocator
	flutter pub add timezone
	flutter pub add logging
	flutter pub add path_provider

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

## run: execute the application (in release mode but with debug URLs)
.PHONY: run
run:
	flutter run --release --dart-define=KEY_URL=http://192.168.1.115/note/wyatt --dart-define=KEY_WHAT_URL=http://192.168.1.115/note/wyatt --dart-define=KEY_WHY_URL=http://192.168.1.115/note/wyatt --dart-define=KEY_PERMISSIONS_URL=http://192.168.1.115/note/wyatt

## icons: regenerate application launcher icons (from assets/icon/icon.png)
.PHONY: icons
icons:
	dart run flutter_launcher_icons
# https://github.com/fluttercommunity/flutter_launcher_icons/issues/578#issuecomment-2366797554:
	rm -rf android/app/src/main/res/mipmap-anydpi-v26

## generate-lttl_dev: generate lttl.dev/wyatt
.PHONY: generate-lttl_dev
generate-lttl_dev:
	lttl.dev/generate.sh

## build-android-debug: build the apk in debug mode
.PHONY: build-android-debug
build-android-debug:
	flutter clean
	flutter build apk --debug --dart-define=KEY_URL=http://192.168.1.115/note/wyatt --dart-define=KEY_WHAT_URL=http://192.168.1.115/note/wyatt --dart-define=KEY_WHY_URL=http://192.168.1.115/note/wyatt --dart-define=KEY_PERMISSIONS_URL=http://192.168.1.115/note/wyatt

## all-android: start from scratch, install all dependencies, build the apk in release mode, and install on device
.PHONY: all-android
all-android: clean update upgrade
	flutter build apk --release # --obfuscate --split-debug-info=build/app/outputs/flutter-apk/app-armeabi-v7a-release-obfuscation ?
	flutter install

## build-ios-debug: regenerate dependencies for iOS and build the application in debug mode
.PHONY: build-ios-debug
build-ios-debug:
	flutter clean
	cd ios && pod install
	flutter build ios --debug --dart-define=KEY_URL=http://192.168.1.115/note/wyatt --dart-define=KEY_WHAT_URL=http://192.168.1.115/note/wyatt --dart-define=KEY_WHY_URL=http://192.168.1.115/note/wyatt --dart-define=KEY_PERMISSIONS_URL=http://192.168.1.115/note/wyatt

# TODO: build-ios-release: regenerate dependencies for iOS and build the application in release mode
#.PHONY: build-ios-release
#build-ios-release:
#	flutter clean
#	cd ios && pod install
#	flutter build ios --release --obfuscate?
