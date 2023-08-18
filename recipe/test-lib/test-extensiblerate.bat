echo on

rem Get the current working directory
set "BASEDIR=%cd%"
set "PYTHONPATH=%PYTHONPATH%;%BASEDIR%\test-lib"
set "CANTERA_DATA=%BASEDIR%\test-lib"

copy /y "%CONDA_PREFIX%\share\cantera\samples\cxx\demo" "cxx_demo"
copy "%BASEDIR%\test-lib\extensible-rate.cpp" "cxx_demo\demo.cpp"

rem Test ExtensibleRate with CMake
echo ***** Testing ExtensibleRate with CMake *****
cd /d "%BASEDIR%\cxx_demo"
echo ===
type CMakeLists.txt
echo ===
mkdir build
cd build
cmake ..
cmake --build . --config Release
Release\demo.exe
if errorlevel 1 exit 1
echo SUCCESS!

rem Test ExtensibleRate with SCons
echo ***** Testing ExtensibleRate with SCons *****
cd /d "%BASEDIR%\cxx_demo"
echo ===
type SConstruct
echo ===
scons
demo.exe
if errorlevel 1 exit 1
echo SUCCESS
