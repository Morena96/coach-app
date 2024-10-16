#!/bin/bash

echo "Running tests and generating coverage..."
dart run test --coverage=coverage

echo "Formatting coverage..."
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib &&

echo "Generating HTML report..."
genhtml coverage/lcov.info -o coverage/html

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