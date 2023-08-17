echo on

rem Get the current working directory
set "BASEDIR=%cd%"

copy /y "%CONDA_PREFIX%\share\cantera\samples\cxx\demo" "cxx_demo"
copy "%BASEDIR%\test-lib\extensible-rate.cpp" "cxx_demo\demo.cpp"

rem Test ExtensibleRate with CMake
echo -e "\n***** Testing ExtensibleRate with CMake *****\n"
cd "%BASEDIR%\cxx_demo"
echo "==="
type CMakeLists.txt
echo "==="
mkdir build
cd build
cmake ..
cmake --build . --config Release
copy "%BASEDIR%\test-lib\user_ext.py" .
copy "%BASEDIR%\test-lib\extensible-reactions.yaml" .
demo.exe
if errorlevel 1 exit 1
echo "SUCCESS!"

rem Test ExtensibleRate with SCons
echo -e "\n***** Testing ExtensibleRate with SCons *****\n"
cd "%BASEDIR%\cxx_demo"
echo "==="
type SConstruct
echo "==="
scons
if errorlevel 1 exit 1
echo "SUCCESS!"
