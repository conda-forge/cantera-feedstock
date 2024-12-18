@ECHO off

echo ****************************
echo BUILD STARTED
echo ****************************

:: Have to use CALL to prevent the script from exiting after calling SCons
CALL scons clean
IF %ERRORLEVEL% NEQ 0 EXIT 1

DEL /F cantera.conf

COPY "%RECIPE_DIR%\cantera_base.conf" cantera.conf
ECHO msvc_version='14.3' >> cantera.conf

:: Set the number of CPUs to use in building
SET /A CPU_USE=%CPU_COUNT% / 2
IF %CPU_USE% EQU 0 SET CPU_USE=1

SET "ESC_PREFIX=%PREFIX:\=/%"
ECHO prefix="%ESC_PREFIX%" >> cantera.conf

CALL scons build -j%CPU_USE% renamed_shared_libraries=y
IF %ERRORLEVEL% NEQ 0 EXIT 1

echo ****************************
echo BUILD COMPLETED SUCCESSFULLY
echo ****************************
