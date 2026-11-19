#!/usr/bin/env bash
# Wraps a Fortran compiler invocation so that generated .mod files go into a
# private, per-invocation temporary directory instead of the current
# directory. This prevents different test files in the same test directory
# (many of which declare modules with the same name, e.g. "module m") from
# racing on the same .mod file when lit runs them concurrently (-j > 1).
#
# Usage: isolate_moddir.sh <compiler-path> <module-dir-flag> <compiler-args...>
# The real compiler's exit code is preserved exactly, so this composes
# correctly with lit's "not <cmd>" negation.

compiler="$1"
shift
modflag="$1"
shift

moddir=$(mktemp -d)

"$compiler" "$modflag" "$moddir" "$@"
status=$?

rm -rf "$moddir"
exit $status
