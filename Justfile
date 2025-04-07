default:
    @just --list

# List all devices
devices:
    flutter devices

# Build the app
build:
    cd test_app && dart run build_runner build

# Run Flutter app on iOS simulator
sim:
    open -a Simulator
    cd test_app && flutter run -d "D82BA525-5C30-4333-9D2B-CC1A026624FE"

# Run Flutter app on physical iPhone
ios:
    cd test_app && flutter run -d "00008110-001939640110401E"

# Run Flutter app on Chrome
web:
    cd test_app && flutter run -d chrome

# Run tests
test:
    cd test_app && flutter test

# Clean project
clean:
    cd test_app/ios && pod deintegrate && pod install && cd .. && flutter clean && flutter pub get
    # cd test_app/ios && rm -rf Pods Podfile.lock && pod install && cd .. && flutter clean && flutter pub get
