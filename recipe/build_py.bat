echo ****************************
echo PYTHON %PYTHON% BUILD STARTED
echo ****************************

COPY cantera.conf cantera.conf.bak
DEL /F cantera.conf
FINDSTR /V "python_package" cantera.conf.bak > cantera.conf
DEL /F cantera.conf.bak

ECHO python_package='full' >> cantera.conf
SET "ESC_PYTHON=%PYTHON:\=/%"
ECHO python_cmd="%ESC_PYTHON%" >> cantera.conf

:: Set the number of CPUs to use in building
SET /A CPU_USE=%CPU_COUNT% / 2
IF %CPU_USE% EQU 0 SET CPU_USE=1

CALL scons build -j%CPU_USE%
IF ERRORLEVEL 1 EXIT 1

echo ****************************
echo PYTHON %PYTHON% BUILD COMPLETED SUCCESSFULLY
echo ****************************

cd interfaces/cython
"%PYTHON%" setup.py build --build-lib=../../build/python install
IF ERRORLEVEL 1 EXIT 1

:: Plugin library for loading Cantera Python extensions from C++
copy "%SRC_DIR%\build\lib\cantera_python*.dll" "%PREFIX%\Library\bin\"

:: Conda environment handles library path, so no need to co-install cantera.dll
del /f "%PREFIX%\Lib\site-packages\cantera\cantera.dll"
