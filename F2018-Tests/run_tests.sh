#!/bin/bash

###############################################################################
# Fortran Test Runner (F2018)
#
# Usage:
#   ./run_tests.sh                        # Run all tests, all compilers
#   ./run_tests.sh <dir>                  # Run specific directory, all compilers
#   ./run_tests.sh <file>                 # Run specific file, all compilers
#   ./run_tests.sh -c <compiler> [<dir>|<file>]
#                                         # Run with the given compiler only
#
#   <compiler> is flang, gfortran or nvfortran. -c may be given more than
#   once (e.g. -c flang -c gfortran) to run several compilers.
#
# Description:
#   Runs tests using llvm-lit, once per compiler (flang, gfortran, nvfortran).
#   lit.cfg.py requires --param compiler=<name> to select which RUN lines
#   (%if <compiler> %{ ... %}) are active, so this script loops over the
#   selected compilers (all three when -c is not given). .mod output is
#   isolated per invocation (isolate_moddir.sh), so -j (parallel) is safe
#   here.
#   A FAIL under one compiler does not stop the others. The exit status is
#   non-zero if any compiler had a FAIL.
#
# For setup instructions (LLVM, PATH, etc.),
# see README.md.
#
###############################################################################

set -e

usage() {
    echo "Usage: $0 [-c flang|gfortran|nvfortran]... [<dir>|<file>]" >&2
    exit 2
}

# Compiler selection
compilers=()
while getopts "c:h" opt; do
    case "$opt" in
        c)
            case "$OPTARG" in
                flang|gfortran|nvfortran) compilers+=("$OPTARG") ;;
                *) echo "Unknown compiler: $OPTARG" >&2; usage ;;
            esac
            ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

if [ ${#compilers[@]} -eq 0 ]; then
    compilers=(flang gfortran nvfortran)
fi

if [ $# -gt 1 ]; then
    usage
fi

echo "Running Fortran F2018 tests..."

# Target selection
if [ $# -eq 0 ]; then
    TARGET="."
else
    TARGET="$1"
fi

echo "Target: $TARGET"

status=0
for compiler in "${compilers[@]}"; do
    echo "--- compiler=$compiler ---"
    lit -j "$(nproc)" --param compiler=$compiler "$TARGET" || status=1
done

echo "All tests completed."
exit $status
