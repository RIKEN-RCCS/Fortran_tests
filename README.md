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
├─ 06_maximumRank/     # Test program directory
│  ├─ 06_maximumRank_001.f90   # _NNN: normal test cases
│  ├─ 06_maximumRank_c001.f90  # _cNNN: negative/error test cases
│  ├─ 06_maximumRank_c002.f90
│  └─ 06_maximumRank_c003.f90
└─ lit.cfg.py          # lit configuration file
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

## Configuration
Edit `lit.cfg.py` to match your local environment.

Example:

```python
llvm_root = "/usr/lib/llvm-21"
config.substitutions.append(('%gfortran', '/usr/bin/gfortran'))
```

Update the paths for `flang` and `gfortran` as needed.

---

## Running Tests
Run the following command in the test root directory:

```sh
llvm-lit .
```

You can also run specific directories or files:

```sh
llvm-lit 06_maximumRank/
llvm-lit 06_maximumRank/06_maximumRank_001.f90
```

---

## Example Output
```
-- Testing: 1 tests, 1 workers --
PASS: Fortran2008-Tests :: 06_maximumRank/06_maximumRank_001.f90

Testing Time: 0.05s
Passed: 1
```

---

## Notes
- `_NNN`: normal (positive) test cases
- `_cNNN`: negative test cases (e.g., compilation errors)
- Each test defines its execution via `RUN:` directives

