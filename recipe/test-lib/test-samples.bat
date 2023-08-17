echo on

rem Get the current working directory
set "BASEDIR=%cd%"

rem Copy the demo directory to a new directory called cxx_demo
copy /y "%CONDA_PREFIX%\share\cantera\samples\cxx\demo" "cxx_demo"

rem Test clib example with CMake
echo -e "\n***** Testing clib example with CMake *****\n"
cd "%CONDA_PREFIX%\share\cantera\samples\clib"
echo "==="
type CMakeLists.txt
echo "==="
mkdir build
cd build
cmake ..
cmake --build . --config Release
demo.exe
if errorlevel 1 exit 1
echo "SUCCESS!"

rem Test clib example with SCons
echo -e "\n***** Testing clib example with SCons *****\n"
cd "%CONDA_PREFIX%\share\cantera\samples\clib"
echo "==="
type SConstruct
echo "==="
scons
demo.exe
if errorlevel 1 exit 1
echo "SUCCESS!"

rem Test kinetics1 example with CMake
echo -e "\n***** Testing kinetics1 example with CMake *****\n"
cd "%CONDA_PREFIX%\share\cantera\samples\cxx\kinetics1"
echo "==="
type CMakeLists.txt
echo "==="
mkdir build
cd build
cmake ..
cmake --build . --config Release
kinetics1.exe
if errorlevel 1 exit 1
echo "SUCCESS!"

rem Test kinetics1 example with SCons
echo -e "\n***** Testing kinetics1 example with SCons *****\n"
cd "%CONDA_PREFIX%\share\cantera\samples\cxx\kinetics1"
echo "==="
type SConstruct
echo "==="
scons
kinetics1.exe
if errorlevel 1 exit 1
echo "SUCCESS!"

rem Test openmp_ignition example with CMake
echo -e "\n***** Testing openmp_ignition example with CMake *****\n"
cd "%CONDA_PREFIX%\share\cantera\samples\cxx\openmp_ignition"
echo "==="
type CMakeLists.txt
echo "==="
mkdir build
cd build
cmake ..
cmake --build . --config Release
openmp_ignition.exe
if errorlevel 1 exit 1
echo "SUCCESS!"

rem Test openmp_ignition example with SCons
echo -e "\n***** Testing openmp_ignition example with SCons *****\n"
cd "%CONDA_PREFIX%\share\cantera\samples\cxx\openmp_ignition"
echo "==="
type SConstruct
echo "==="
scons
openmp_ignition.exe
if errorlevel 1 exit 1
echo "SUCCESS!"

rem Prepare ExtensibleRate test
cd "%BASEDIR%"
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

echo ****************************
echo ALL SAMPLES RAN SUCCESSFULLY
echo ****************************
