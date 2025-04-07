# List all commands
default:
    @just --list

# Generate Xcode project
gen:
    xcodegen generate 

# Open Xcode project
open:
    open HelloWorld.xcodeproj

# Build the app
build:
    xcodebuild -scheme HelloWorld -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16' build -derivedDataPath build

# Run app on simulator
sim:
    just build
    open -a Simulator
    @echo "Installing app from: build/Build/Products/Debug-iphonesimulator/HelloWorld.app"
    @ls -la build/Build/Products/Debug-iphonesimulator/ || true
    xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/HelloWorld.app
    xcrun simctl launch booted com.davidfitzgerald.HelloWorld
    sleep 2  # Give the app time to launch
    @echo "Testing URL scheme..."
    xcrun simctl openurl booted "habit://test" || echo "URL scheme test failed"

# Test notification
notify:
    echo '{"aps":{"alert":"Test notification","sound":"default"}}' > notification.json
    xcrun simctl push booted com.davidfitzgerald.HelloWorld notification.json
    rm notification.json