default:
    @just --list

# Run Flutter app on iOS simulator
sim:
    cd test_app && flutter run -d "D82BA525-5C30-4333-9D2B-CC1A026624FE"

# Run Flutter app on physical iPhone
ios:
    cd test_app && flutter run -d "00008110-001939640110401E"

# Run Flutter app on Chrome
web:
    cd test_app && flutter run -d chrome

clean-ios:
    cd test_app/ios && rm -rf Pods Podfile.lock && pod install && cd .. && flutter clean && flutter pub get
