#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Run tests for the main app
echo "Running tests in the main app..."
flutter test

# Loop through each package and run its tests
for dir in packages/*/ ; do
  if [ -d "$dir/test" ]; then
    echo "Running tests in $dir..."
    (
      cd "$dir"  # Change directory to the package directory
      if [ -f "pubspec.yaml" ]; then
          # Run pub get to install dependencies
          dart pub get || flutter pub get

          # Check if it's a Dart or Flutter package and run the appropriate test command
          if grep -q "flutter" pubspec.yaml; then
            flutter test  # Run Flutter tests if it's a Flutter package
          else
            dart test  # Run Dart tests if it's a Dart package
          fi
      fi
    )
  fi
done