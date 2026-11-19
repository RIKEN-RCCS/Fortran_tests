# Fortran Test (F2008)

## Overview
This repository contains test cases for Fortran (mainly F2008 features),
executed and verified using LLVM's testing tool **lit**.

Each `.f90` file is compiled and executed according to the `RUN:` directives,
and the output is validated using `FileCheck`.

---

## Directory Structure (Example)
The following is just an example.  
You can freely modify the directory structure and naming as needed.

```
./fortran-tests        # Root directory for tests (arbitrary)
├── 06_maximumRank/    # Test program directory
│   ├── 06_maximumRank_001.f90   # _NNN: normal test cases
│   ├── 06_maximumRank_c001.f90  # _cNNN: negative/error test cases
│   ├── 06_maximumRank_c002.f90
│   └── 06_maximumRank_c003.f90
└── lit.cfg.py         # lit configuration file
```

---

## Prerequisites
Make sure the following tools are available in your environment:

- flang
- gfortran
- FileCheck
- lit

*Note:* Installing LLVM provides both `FileCheck` and `lit`.

---

## Environment Setup
Before running tests, set the LLVM environment variables:

```bash
export LLVM_HOME="/home/share/llvm21/builds"
export PATH=$LLVM_HOME/bin:$PATH
export LD_LIBRARY_PATH=$LLVM_HOME/lib:$LD_LIBRARY_PATH
```

Ensure that `flang`, `FileCheck`, and `lit` are accessible via `PATH`.

---

## Configuration
Edit `lit.cfg.py` to match your local environment.

Example:

```python
llvm_root = "/home/share/llvm21/builds"
config.substitutions.append(('%gfortran', '/usr/bin/gfortran'))
```

Update the paths for `flang` and `gfortran` as needed.

---

## Running Tests

### Recommended
Run all tests using the provided script:

```bash
./run_tests.sh
```

This script internally invokes `lit` and manages execution.

---

## Manual Execution (Optional)

You can also run tests manually using `llvm-lit`:

### Run all tests
```bash
llvm-lit .
```

### Run a specific directory
```bash
llvm-lit 06_maximumRank/
```

### Run a specific file
```bash
llvm-lit 06_maximumRank/06_maximumRank_001.f90
```

### Notes
- However, the primary execution method is `run_tests.sh`.

---
