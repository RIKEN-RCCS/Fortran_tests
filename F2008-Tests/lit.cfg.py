# lit.cfg.py

import os
import lit.formats

# Name shown by llvm-lit
config.name = "F2008-Tests"

# Use RUN lines
config.test_format = lit.formats.ShTest(execute_external=True)

# Fortran files treated as tests
config.suffixes = ['.f90']

# Root directory
config.test_source_root = os.path.dirname(__file__)

# Ignore directories
config.excludes = ['Inputs', 'CMakeLists.txt']

# Make diagnostics reproducible
config.environment['LC_ALL'] = 'C'

# Allow full access (777 for dirs/executables, 666 for files)
os.umask(0o000)

#######################

# LLVM installation
llvm_root = "/usr/lib/llvm-21"
llvm_bin_dir = os.path.join(llvm_root, "bin")

# tools
flang = os.path.join(llvm_bin_dir, "flang")
filecheck = os.path.join(llvm_bin_dir, "FileCheck")
not_tool = os.path.join(llvm_bin_dir, "not")

# substitutions
config.substitutions.append(('%flang', flang))
config.substitutions.append(('%FileCheck', filecheck))
config.substitutions.append(('%not', not_tool))
config.substitutions.append(('%gfortran', '/usr/bin/gfortran'))

# PATH
config.environment['PATH'] = (
    llvm_bin_dir + os.pathsep + config.environment.get('PATH', '')
)

