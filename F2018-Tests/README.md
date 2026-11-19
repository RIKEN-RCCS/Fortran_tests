# F2018-Tests: Fortran 2018 Language Feature Tests

This README describes the layout of the tests, the preparation, how to run the tests, and how to read the results.

## Contents

- [1. Layout](#layout)
- [2. Preparation](#preparation)
- [3. Running the tests](#running)
- [4. Reading the results](#results)

---

## <a id="layout" name="layout"></a>1. Layout

The test programs and the test runner script are in this repository (<https://github.com/RIKEN-RCCS/Fortran_tests>).

The layout of the repository is as follows.

```
<repository>/
├── README.md                 … guide to the repository
├── F2008-Tests/              … Fortran 2008 tests (see the README in that directory)
└── F2018-Tests/
    ├── README.md             … this file
    ├── lit.cfg.py            … lit configuration
    ├── run_tests.sh          … test runner script
    ├── isolate_moddir.sh     … script that wraps compiler invocations (chapter 3)
    └── <No>_<spec>/           … one directory per specification (No.)
        ├── *.f90             … test programs
        └── *.c               … C programs combined with Fortran in some tests
```

Tests are classified into the following four kinds by what they check, and told apart by file name.

| Kind | What it checks | File name |
|---|---|---|
| Normal | Code that the standard allows compiles and runs as expected | `<No>_<spec>_<serial>.f90` (e.g. `18_subnormalValues_001.f90`) |
| Compile-time negative | The compiler issues a diagnostic for code that the standard prohibits or constrains | `<No>_<spec>_c<serial>.f90` (e.g. `18_subnormalValues_c001.f90`) |
| Run-time negative | The processor detects a nonconformance (or a defect in the input given to the program) that is first known from values at run time and that the processor is not required to detect.<br>Includes input that a processor may accept as an extension | `<No>_<spec>_e<serial>.f90` (e.g. `18_subnormalValues_e001.f90`) |
| Termination | Where the standard specifies how execution ends (initiating error termination, the stop code of `stop` and `error stop`, and so on), the exit status and standard error are as expected | `<No>_<spec>_t<serial>.f90` (e.g. `18_subnormalValues_t001.f90`) |

Tests are placed in the directory of their specification (No.), `<No>_<spec>/`. `<spec>` is an English name that describes the specification (e.g. `subnormalValues` in `18_subnormalValues`).

lit treats only `.f90` files as tests. The C programs are compiled and linked by the RUN lines of the test programs.

## <a id="preparation" name="preparation"></a>2. Preparation

The following are needed to run the tests.

| Item | Purpose | How to get it |
|---|---|---|
| Test set | The test programs and the test runner script | Clone the branch `FORT-2026-f2018` of the GitHub repository ([chapter 1](#layout)) with git |
| lit | Runs the tests | Install with `pip install lit`, and make the `lit` command runnable from PATH (`run_tests.sh` calls `lit` by its command name). No LLVM build is needed |
| FileCheck | Checks program output and compiler diagnostics against the expected values | Build LLVM from source.<br>With `LLVM_INSTALL_UTILS=ON` in CMake, it is installed into `bin` of the install prefix |
| not | In compile-time negative tests, treats a compiler failure as success | Same as FileCheck |
| Target compilers | Compile and run the tests | Build flang from the LLVM source (the same LLVM as FileCheck is fine).<br>Build gfortran from the GCC source.<br>Install the NVIDIA HPC SDK for nvfortran |
| C compilers | Compile the C programs (`*.c`) | Use the one from the same vendor as each Fortran compiler (clang, gcc, nvc).<br>clang is in the same LLVM as flang, gcc in the same GCC as gfortran, and nvc in the NVIDIA HPC SDK |

The test set is on the branch `FORT-2026-f2018` of the GitHub repository.
Get this branch as follows. The directory you get corresponds to `<repository>` in [chapter 1](#layout).

```
git clone -b FORT-2026-f2018 https://github.com/RIKEN-RCCS/Fortran_tests.git
cd Fortran_tests/F2018-Tests
```

FileCheck and not are not included in lit.

Before running the tests, change the following variables in `lit.cfg.py` to the paths of the tools and compilers in your environment.

| Variable | Points to | When to change |
|---|---|---|
| `llvm_root` | The LLVM install prefix | Required (FileCheck and not are used from `bin` under it) |
| `gfortran`, `gcc`, `gfortran_lib_dir` | The gfortran and gcc executables, and the `lib64` of the same GCC | When you run with gfortran |
| `nvfortran`, `nvc` | The nvfortran and nvc executables | When you run with nvfortran |

The lines to change in `lit.cfg.py` are as follows (change the `<…>` parts to match the environment where you run the tests).

```
# LLVM installation
llvm_root = "<LLVM install prefix>"
…
# GNU Fortran installation
gfortran = "<path to the gfortran executable>"
…
gfortran_lib_dir = "<path to lib64 of the GCC>"

# NVIDIA HPC SDK installation
nvfortran = "<path to the nvfortran executable>"
…
gcc = "<path to the gcc executable>"
nvc = "<path to the nvc executable>"
```

## <a id="running" name="running"></a>3. Running the tests

Run `run_tests.sh` in the `F2018-Tests` directory.
It runs lit for the three compilers (flang, gfortran, nvfortran) in this order.
With `-c <compiler>`, it runs lit for the given compiler only.

| Command | Target |
|---|---|
| `./run_tests.sh` | All tests under `F2018-Tests` |
| `./run_tests.sh <directory>` | Tests in the given No. directory |
| `./run_tests.sh <file>` | The given single test |
| `./run_tests.sh -c <compiler> [<directory>\|<file>]` | The given target (all tests if omitted), with the given compiler only |

`<compiler>` is `flang`, `gfortran` or `nvfortran`.
To run several compilers, give `-c` more than once (for example, `-c flang -c gfortran`).
If some compiler is not available, select the available ones with `-c`.

A FAIL under one compiler does not stop the runs for the remaining compilers.
The exit status is 0 if no compiler had a FAIL, and 1 if any compiler had a FAIL.

lit can also be run directly.

```
lit -j$(nproc) --param compiler=<flang|gfortran|nvfortran> <target>
```

`--param compiler=` is required.
Each test program has one RUN line per compiler (`%if flang %{ … %}` and so on), and only the lines for the selected compiler are run.
The C programs are compiled with the C compiler from the same vendor as the selected Fortran compiler.

To run the tests with some of them left out, run lit directly and give the directory name or the file name of the tests to leave out to `--filter-out`.

```
lit -j$(nproc) --param compiler=<flang|gfortran|nvfortran> --filter-out <directory name> <target>
```

Compiler invocations go through `isolate_moddir.sh`. It sends `.mod` output to a separate temporary directory for each invocation. Even if several tests in the same directory declare modules with the same name, they do not race on the same `.mod` file when run in parallel.
The compiler's exit status is returned unchanged.

## <a id="results" name="results"></a>4. Reading the results

### Conditions for PASS and FAIL

The condition for PASS is defined for each test by the RUN lines at the top of the test program and the CHECK lines that hold the expected values.
lit reports PASS when all commands of the RUN line succeed, and FAIL when any of them fails.

| Kind | Condition for PASS | Examples of FAIL |
|---|---|---|
| Normal | Compiling, linking and running all succeed, and the program output matches the expected values in the CHECK lines in order | Compile error, abnormal termination at run time, output different from the expected values |
| Compile-time negative | The compiler ends with a failure (`%not` in the RUN line), the expected diagnostic appears on the expected line, and no other error appears | Compilation succeeds without an error, an error appears on a different line |
| Run-time negative | When the error is caught (by `iostat=` and so on), a `_detected=T` line showing the detection is printed and the program ends with exit status 0.<br>When there is no specifier to catch the error, the control lines printed before the violating statement match the expected values and the program ends with a nonzero exit status (including abnormal termination by a signal).<br>When there is no specifier to catch the error, stopping with an error at compile time also counts as detection | When the error is caught (by `iostat=` and so on), the test stops with an error at compile time or at run time (catching the error does not stop the run).<br>The control lines differ from the expected values (the program stopped for another reason before the violating statement).<br>When the violation is not detected (a `_detected=F` line), lit reports the test as FAIL. This only means that the processor did not detect the violation, which the standard does not require |
| Termination | The output before the stop appears, the output after the stop does not appear, and the items of standard error and exit status that the standard requires match the expected values.<br>The items that the standard recommends are also checked, but a mismatch does not make the test a FAIL.<br>A mismatch in a recommended item is shown by a line starting with `recommended_differs:` when lit is run with `-a` | The output before the stop does not appear, the output after the stop appears, a required item differs from the expected value |

For example, the RUN and CHECK lines of a normal test look like this (excerpt from `28_comparisons_005.f90`).

```
! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
…
! CHECK: nan_supported=T
! CHECK-NEXT: eq  invalid=F
! CHECK-NEXT: ne  invalid=F
! CHECK-NEXT: ge  invalid=T
```

This RUN line compiles the test with flang (`%flang %s -o %t`), runs it (`%t`), and checks its output against the CHECK lines with FileCheck.
If any of compiling, running or checking fails, the test is a FAIL.
In compile-time negative tests, the expected diagnostic is written in the CHECK lines together with the line number where the violation is written.
Parts that the standard leaves to the processor (whether a zero comes before the decimal point, the form of the exponent, and so on) are matched by regular expressions in the CHECK lines that allow every form.

### lit output

lit prints one line per test, with the verdict and the test name.
At the end of the run for each compiler, lit prints the list of failed tests and the PASS and FAIL counts.

As an example, here is the flang part of the output of `./run_tests.sh 28_comparisons`.

```
--- compiler=flang ---
-- Testing: 12 tests, 8 workers --
PASS: F2018-Tests :: 28_comparisons/28_comparisons_007.f90 (1 of 12)
PASS: F2018-Tests :: 28_comparisons/28_comparisons_001.f90 (2 of 12)
FAIL: F2018-Tests :: 28_comparisons/28_comparisons_005.f90 (3 of 12)
PASS: F2018-Tests :: 28_comparisons/28_comparisons_009.f90 (4 of 12)
PASS: F2018-Tests :: 28_comparisons/28_comparisons_004.f90 (5 of 12)
PASS: F2018-Tests :: 28_comparisons/28_comparisons_002.f90 (6 of 12)
PASS: F2018-Tests :: 28_comparisons/28_comparisons_003.f90 (7 of 12)
PASS: F2018-Tests :: 28_comparisons/28_comparisons_010.f90 (8 of 12)
PASS: F2018-Tests :: 28_comparisons/28_comparisons_c001.f90 (9 of 12)
PASS: F2018-Tests :: 28_comparisons/28_comparisons_c002.f90 (10 of 12)
PASS: F2018-Tests :: 28_comparisons/28_comparisons_008.f90 (11 of 12)
PASS: F2018-Tests :: 28_comparisons/28_comparisons_006.f90 (12 of 12)
********************
Failed Tests (1):
  F2018-Tests :: 28_comparisons/28_comparisons_005.f90


Testing Time: 0.53s

Total Discovered Tests: 12
  Passed: 11 (91.67%)
  Failed:  1 (8.33%)
```

| Output | Meaning |
|---|---|
| `--- compiler=flang ---` | What follows is the result for flang (printed by `run_tests.sh`) |
| Lines starting with `PASS:` or `FAIL:` | The verdict of one test. After `F2018-Tests ::` is the test file; the number in parentheses is the order in which it finished |
| After `Failed Tests (1):` | The list of failed tests |
| From `Total Discovered Tests:` on | The number of tests run, and the PASS and FAIL counts |

Tests run in parallel, so the order of the `PASS:` and `FAIL:` lines changes from run to run.

To see the cause of a FAIL (a compiler diagnostic, or a difference between the output and the expected value), run that test again with `lit -v`.
As an example, here is part of the output when the FAIL above is run again. `<repository>` stands for the location of the repository, and `…` marks omitted text.

```
$ lit -v --param compiler=flang 28_comparisons/28_comparisons_005.f90
FAIL: F2018-Tests :: 28_comparisons/28_comparisons_005.f90 (1 of 1)
******************** TEST 'F2018-Tests :: 28_comparisons/28_comparisons_005.f90' FAILED ********************
Exit Code: 1
…
# executed command: <repository>/F2018-Tests/isolate_moddir.sh <llvm_root>/bin/flang -module-dir <repository>/F2018-Tests/28_comparisons/28_comparisons_005.f90 -o …
# executed command: <repository>/F2018-Tests/28_comparisons/Output/28_comparisons_005.f90.tmp
# executed command: FileCheck <repository>/F2018-Tests/28_comparisons/28_comparisons_005.f90
# .---command stderr------------
# | <repository>/F2018-Tests/28_comparisons/28_comparisons_005.f90:62:15: error: CHECK-NEXT: expected string not found in input
# | ! CHECK-NEXT: ge invalid=T
# |               ^
# | <stdin>:3:13: note: scanning from here
# | ne invalid=F
# |             ^
# | <stdin>:4:1: note: possible intended match here
# | ge invalid=F
# | ^
# …
# | Input was:
# | <<<<<<
# |            1: nan_supported=T 
# |            2: eq invalid=F 
# |            3: ne invalid=F 
# | next:62'0                {   search range start (exclusive)
# | next:62'1                    error: no match found in search range
# |            4: ge invalid=F 
# | next:62'2     ?              possible intended match
# |            5: gt invalid=F 
# |            6: le invalid=F 
# |            7: lt invalid=F 
# | next:62'3                  } search range end (exclusive)
# | >>>>>>
# `-----------------------------
# error: command failed with exit status: 1
```

The `# executed command:` lines are the commands that were run (compile, run, and check with FileCheck), and the `command stderr` box holds their output.
In this example, FileCheck shows that the expected value is `ge invalid=T` (line 62 of the test) but the actual output is `ge invalid=F`.
After `Input was:` are all the lines printed by the test program.
When compilation fails, the compiler diagnostics appear in the `command stderr` box.
