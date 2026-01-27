#!/bin/bash

# Setup: Create dummy files for both scenarios
echo '{"status": "OBJECT_OK", "data": "1"}' > valid_object.json
echo '[{"status": "ARRAY_OK", "data": "2"}]' > valid_array.json

# Test 1: Standard Object
RESULT_OBJ=$(jq -r '(if type=="array" then .[0] else . end).status' valid_object.json)

if [ "$RESULT_OBJ" == "OBJECT_OK" ]; then
  echo "✔ Test 1 (Object): PASSED"
else
  echo "✘ Test 1 (Object): FAILED (Got: $RESULT_OBJ)"
  exit 1
fi

# Test 2: Wrapped Array
RESULT_ARR=$(jq -r '(if type=="array" then .[0] else . end).status' valid_array.json)

if [ "$RESULT_ARR" == "ARRAY_OK" ]; then
  echo "✔ Test 2 (Array):  PASSED"
else
  echo "✘ Test 2 (Array):  FAILED (Got: $RESULT_ARR)"
  exit 1
fi

# Cleanup
rm valid_object.json valid_array.json