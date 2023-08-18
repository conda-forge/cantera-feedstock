#!/bin/bash

die () {
    echo >&2 "$@"
    exit 1
}

# Pretend we're on a modern macOS
unset MACOSX_DEPLOYMENT_TARGET
unset MACOSX_SDK_VERSION

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
