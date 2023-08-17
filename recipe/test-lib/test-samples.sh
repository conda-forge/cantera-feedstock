#!/bin/bash

die () {
    echo >&2 "$@"
    exit 1
}

# Pretend we're on a modern macOS
unset MACOSX_DEPLOYMENT_TARGET
unset MACOSX_SDK_VERSION

BASEDIR=`pwd`
cp -a ${CONDA_PREFIX}/share/cantera/samples/cxx/demo cxx_demo

echo -e '\n***** Testing clib example with CMake *****\n'
cd ${CONDA_PREFIX}/share/cantera/samples/clib
echo "==="
cat CMakeLists.txt
echo "==="
mkdir build
cd build
cmake ..
cmake --build .
./demo || die "clib-cmake failed"

echo -e '\n***** Testing clib example with SCons *****\n'
cd ${CONDA_PREFIX}/share/cantera/samples/clib
echo "==="
cat SConstruct
echo "==="
scons
./demo || die "clib-scons failed"

echo -e '\n***** Testing kinetics1 example with CMake *****\n'
cd ${CONDA_PREFIX}/share/cantera/samples/cxx/kinetics1
echo "==="
cat CMakeLists.txt
echo "==="
mkdir build
cd build
cmake ..
cmake --build .
./kinetics1 || die "kinetics1-cmake failed"

echo -e '\n***** Testing kinetics1 example with SCons *****\n'
cd ${CONDA_PREFIX}/share/cantera/samples/cxx/kinetics1
echo "==="
cat SConstruct
echo "==="
scons
./kinetics1 || die "kinetics1-scons failed"

echo -e '\n***** Testing rankine example with pkg-config *****\n'
cd ${CONDA_PREFIX}/share/cantera/samples/cxx/rankine
echo "==="
echo $(pkg-config --cflags cantera --libs)
echo "==="
${CXX} rankine.cpp -o rankine $(pkg-config --cflags cantera --libs)
./rankine || die "rankine-pkgconfig failed"

echo -e '\n***** Testing openmp_ignition example with CMake *****\n'
cd ${CONDA_PREFIX}/share/cantera/samples/cxx/openmp_ignition
echo "==="
cat CMakeLists.txt
echo "==="
mkdir build
cd build
cmake ..
cmake --build .
./openmp_ignition || die "openmp_ignition-cmake failed"

echo -e '\n***** Testing openmp_ignition example with SCons *****\n'
cd ${CONDA_PREFIX}/share/cantera/samples/cxx/openmp_ignition
echo "==="
cat SConstruct
echo "==="
scons
./openmp_ignition || die "openmp_ignition-scons failed"

# Prepare ExtensibleRate test
cd ${BASEDIR}
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
