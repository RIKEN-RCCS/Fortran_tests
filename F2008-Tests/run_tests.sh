#!/bin/bash

###############################################################################
# Fortran Test Runner (F2008)
#
# Usage:
#   ./run_tests.sh               # Run all tests
#   ./run_tests.sh <dir>         # Run specific directory
#   ./run_tests.sh <file>        # Run specific file
#
# Description:
#   Runs tests using llvm-lit.
#
# For setup instructions (LLVM, PATH, etc.),
# see ../README.md.
#
###############################################################################

set -e

echo "Running Fortran F2008 tests..."

# Target selection
if [ $# -eq 0 ]; then
    TARGET="."
else
    TARGET="$1"
fi

echo "Target: $TARGET"

llvm-lit -j1 "$TARGET"

echo "All tests completed."
