#!/bin/bash

die () {
    echo >&2 "$@"
    exit 1
}

# Pretend we're on a modern macOS
unset MACOSX_DEPLOYMENT_TARGET
unset MACOSX_SDK_VERSION

export DYLD_PRINT_LIBRARIES=1
export DYLD_PRINT_LIBRARIES_POST_LAUNCH=1
export DYLD_PRINT_RPATHS=1

BASEDIR=`pwd`
export CANTERA_DATA=${BASEDIR}/test-lib
export PYTHONPATH=${PYTHONPATH}:${BASEDIR}/test-lib

# Prepare ExtensibleRate test
cp -a ${CONDA_PREFIX}/share/cantera/samples/cxx/demo cxx_demo
cp ${BASEDIR}/test-lib/extensible-rate.cpp cxx_demo/demo.cpp

echo -e '\n***** Testing ExtensibleRate with CMake *****\n'
cd ${BASEDIR}/cxx_demo
echo "==="
cat CMakeLists.txt
echo "==="
mkdir build
cd build
cmake ..
cmake --build .
./demo || die "extensiblerate-cmake failed"

echo -e '\n***** Testing ExtensibleRate with SCons *****\n'
cd ${BASEDIR}/cxx_demo
echo "==="
cat SConstruct
echo "==="
scons
./demo || die "extensiblerate-scons failed"
