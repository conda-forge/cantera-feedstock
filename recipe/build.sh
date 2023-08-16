set +x

echo "****************************"
echo "LIBRARY BUILD STARTED"
echo "****************************"

cp "${RECIPE_DIR}/cantera_base.conf" cantera.conf

echo "prefix = '${PREFIX}'" >> cantera.conf
echo "extra_inc_dirs = '${PREFIX}/include'" >> cantera.conf
echo "extra_lib_dirs = '${PREFIX}/lib'" >> cantera.conf

if [[ "${OSX_ARCH}" == "" ]]; then
    echo "CC = '${CC}'" >> cantera.conf
    echo "CXX = '${CXX}'" >> cantera.conf
    echo "cc_flags = '${CFLAGS}'" >> cantera.conf
else
    echo ${PREFIX}
    echo "CC = '${CLANG}'" >> cantera.conf
    echo "CXX = '${CLANGXX}'" >> cantera.conf
    echo "cc_flags = '${CFLAGS} -isysroot ${CONDA_BUILD_SYSROOT}'" >> cantera.conf
    echo "cxx_flags = '-std=c++17 -D_LIBCPP_DISABLE_AVAILABILITY'" >> cantera.conf
    echo "no_debug_linker_flags = '-isysroot ${CONDA_BUILD_SYSROOT}'" >> cantera.conf
fi

if [[ "$target_platform" == osx-* ]]; then
    # scons on osx uses major.minor while on linux it is major only
    export APPLELINK_COMPATIBILITY_VERSION="$(echo ${PKG_VERSION} | cut -d. -f1)"
    echo "APPLELINK_COMPATIBILITY_VERSION='${APPLELINK_COMPATIBILITY_VERSION}'" >> cantera.conf
fi

set -xe

${BUILD_PREFIX}/bin/python `which scons` build -j${CPU_COUNT}

set +xe

echo "****************************"
echo "BUILD COMPLETED SUCCESSFULLY"
echo "****************************"
