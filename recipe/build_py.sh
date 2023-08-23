echo "******************************"
echo "PYTHON ${PY_VER} BUILD STARTED"
echo "******************************"

# Remove old Python build files, if they're present
if [ -d "build/python" ]; then
    rm -r build/python
    rm -r build/temp-py
    rm $PREFIX/bin/ck2cti || true
    rm $PREFIX/bin/ck2yaml || true
    rm $PREFIX/bin/ctml_writer || true
    rm $PREFIX/bin/cti2yaml || true
    rm $PREFIX/bin/ctml2yaml || true
fi

${BUILD_PREFIX}/bin/python `which scons` build python_package='y' python_cmd="${PYTHON}" -j${CPU_COUNT}

$PYTHON -m pip install --no-deps build/python

# Plugin library for loading Cantera Python extensions from C++
mkdir -p $PREFIX/lib

PY_VERSION=`$PYTHON -c "from sys import version_info as vi; print(f'{vi.major}.{vi.minor}')"`

if [[ "$target_platform" != osx-64 || "$PY_VERSION" != "3.10" ]]; then
    # TEMPORARY WORKAROUND: Do not include the shim library for Python 3.10 on Intel Mac
    # due to upstream issues; see https://github.com/conda-forge/cantera-feedstock/pull/28
    cp $SRC_DIR/build/lib/libcantera_python* $PREFIX/lib/
fi

if [[ "$target_platform" == osx-* ]]; then
   VERSION=$(echo $PKG_VERSION | cut -da -f1 | cut -db -f1 | cut -dr -f1)
   file_to_fix=$(find $SP_DIR -name "_cantera*.so" | head -n 1)
   ${OTOOL:-otool} -L $file_to_fix
   ${INSTALL_NAME_TOOL:-install_name_tool} -change build/lib/libcantera.${VERSION}.dylib "@rpath/libcantera.${VERSION}.dylib" $file_to_fix
fi

echo "********************************"
echo "PYTHON ${PY_VER} BUILD COMPLETED"
echo "********************************"
