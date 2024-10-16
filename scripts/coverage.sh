#!/bin/bash

echo "Running tests and generating coverage..."
flutter test --coverage

echo "Excluding generated files from coverage..."
lcov --remove coverage/lcov.info '*/generated/*' '*/l10n/*' '*.g.dart' '*.freezed.dart' '*.mocks.dart' -o coverage/lcov_cleaned.info

echo "Generating HTML report..."
genhtml coverage/lcov_cleaned.info -o coverage/html

echo "Opening coverage report in default browser..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    open coverage/html/index.html
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open coverage/html/index.html
elif [[ "$OSTYPE" == "msys" ]]; then
    start coverage/html/index.html
else
    echo "Unsupported OS. Please open coverage/html/index.html manually."
fi

echo "Coverage report generation complete!"