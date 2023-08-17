#!/bin/bash

die () {
    echo >&2 "$@"
    exit 1
}

# Pretend we're on a modern macOS
unset MACOSX_DEPLOYMENT_TARGET
unset MACOSX_SDK_VERSION

BASEDIR=`pwd`

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
cp ${BASEDIR}/test-lib/user_ext.py .
cp ${BASEDIR}/test-lib/extensible-reactions.yaml .
./demo || die "extensiblerate-cmake failed"

echo -e '\n***** Testing ExtensibleRate with SCons *****\n'
cd ${BASEDIR}/cxx_demo
echo "==="
cat SConstruct
echo "==="
scons
cp ${BASEDIR}/test-lib/user_ext.py .
cp ${BASEDIR}/test-lib/extensible-reactions.yaml .
./demo || die "extensiblerate-scons failed"
