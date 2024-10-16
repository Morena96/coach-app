#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 feature_name"
  exit 1
fi

FEATURE_NAME=$1

mkdir -p lib/features/${FEATURE_NAME}/{infrastructure/{repositories,models},presentation/{pages,widgets,providers}}
touch lib/features/${FEATURE_NAME}/${FEATURE_NAME}.dart

echo "Feature structure for ${FEATURE_NAME} created."
