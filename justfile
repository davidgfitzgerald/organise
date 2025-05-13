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
