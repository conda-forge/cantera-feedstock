#!/bin/bash
set -x
cd test-lib
echo CONDA_PREFIX=$CONDA_PREFIX
which python
PY_VERSION=`python -c "from sys import version_info as vi; print(f'{vi.major}.{vi.minor}')"`
python -c "import sys; print('interpreter sys.path:', sys.path)"
clang++ -I${CONDA_PREFIX}/include/python${PY_VERSION} -L${CONDA_PREFIX}/lib mwe.cpp -o mwe -lpython${PY_VERSION} -Wl,-rpath,${CONDA_PREFIX}/lib
./mwe
