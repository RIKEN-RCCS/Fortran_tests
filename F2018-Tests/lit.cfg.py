# lit.cfg.py

import os
import lit.formats

# Name shown by llvm-lit
config.name = "F2018-Tests"

# Use RUN lines. lit 23 rejects execute_external=True, so run them in
# lit's internal shell.
config.test_format = lit.formats.ShTest(execute_external=False)

# Fortran files treated as tests
config.suffixes = ['.f90']

# Root directory
config.test_source_root = os.path.dirname(__file__)

# Home directories
config.environment['HOME'] = os.environ.get('HOME', '/tmp')

# Ignore directories
config.excludes = ['Inputs', 'CMakeLists.txt']

# Make diagnostics reproducible
config.environment['LC_ALL'] = 'C'

# Allow full access (777 for dirs/executables, 666 for files)
os.umask(0o000)

#######################

# LLVM installation
llvm_root = "/home/share/llvm23.1.2"
llvm_bin_dir = os.path.join(llvm_root, "bin")

# tools
flang = os.path.join(llvm_bin_dir, "flang")
filecheck = os.path.join(llvm_bin_dir, "FileCheck")
not_tool = os.path.join(llvm_bin_dir, "not")

# GNU Fortran installation
gfortran = "/home/share/gcc16.2/bin/gfortran"
# Run-time library (libgfortran) of the same GCC, used by the test programs
gfortran_lib_dir = "/home/share/gcc16.2/lib64"

# NVIDIA HPC SDK installation
nvfortran = "/opt/nvidia/hpc_sdk/Linux_x86_64/26.5/compilers/bin/nvfortran"

# Matching C compilers, for the C companions of the Fortran/C interop tests
# (No.4 onwards). Each vendor's C compiler ships its own
# <ISO_Fortran_binding.h>, so the companions #include it with no -I.
clang = os.path.join(llvm_bin_dir, "clang")
gcc = "/home/share/gcc16.2/bin/gcc"
nvc = "/opt/nvidia/hpc_sdk/Linux_x86_64/26.5/compilers/bin/nvc"

# Wrap compiler invocations so each one writes its .mod files to a private,
# per-invocation temp directory instead of the current directory. Several
# test directories have multiple .f90 files that declare modules with the
# same name (e.g. "module m"); without this, running lit with -j > 1 lets
# those invocations race on the same .mod file. See isolate_moddir.sh.
isolate = os.path.join(config.test_source_root, "isolate_moddir.sh")

# substitutions
config.substitutions.append(('%flang', f'{isolate} {flang} -module-dir'))
config.substitutions.append(('%FileCheck', filecheck))
config.substitutions.append(('%not', not_tool))
config.substitutions.append(('%gfortran', f'{isolate} {gfortran} -J'))
config.substitutions.append(('%nvfortran', f'{isolate} {nvfortran} -module'))

# PATH
config.environment['PATH'] = (
    llvm_bin_dir + os.pathsep + config.environment.get('PATH', '')
)

# Select which compiler's RUN lines (`%if <compiler> %{ ... %}`) are active
# for this invocation. Required so that `.f90` files can list one RUN line
# per compiler and have only the requested one actually execute.
known_compilers = {'flang', 'gfortran', 'nvfortran'}
compiler = lit_config.params.get('compiler')
if compiler not in known_compilers:
    lit_config.fatal(
        f"--param compiler=<name> is required, with <name> one of "
        f"{sorted(known_compilers)} (got: {compiler!r})"
    )
config.available_features.add(compiler)

# %cc = the C compiler matching the selected Fortran compiler. The Fortran/C
# interop tests (No.4 onwards) compile a C companion with
#   %cc %S/<name>.c -c -o %t.c.o
# and link it with the Fortran driver. No .mod files are produced, so this is
# a bare path (no isolate_moddir.sh wrapper).
config.substitutions.append(
    ('%cc', {'flang': clang, 'gfortran': gcc, 'nvfortran': nvc}[compiler]))

# Put gfortran_lib_dir first in LD_LIBRARY_PATH, so that the gfortran test
# programs load the libgfortran of that GCC instead of an older one in the OS.
config.environment['LD_LIBRARY_PATH'] = os.pathsep.join(
    p for p in (gfortran_lib_dir, config.environment.get('LD_LIBRARY_PATH'))
    if p)
