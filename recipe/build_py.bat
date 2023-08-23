echo ****************************
echo PYTHON %PYTHON% BUILD STARTED
echo ****************************

echo on

SET "ESC_PYTHON=%PYTHON:\=/%"
ECHO python_cmd="%ESC_PYTHON%" >> cantera.conf

:: Set the number of CPUs to use in building
SET /A CPU_USE=%CPU_COUNT% / 2
IF %CPU_USE% EQU 0 SET CPU_USE=1

CALL scons build -j%CPU_USE% python_package=y
IF %ERRORLEVEL% NEQ 0 EXIT 1

"%PYTHON%" -m pip install --no-deps --no-index --find-links=build\python\dist\ cantera
IF %ERRORLEVEL% NEQ 0 EXIT 1

:: Plugin library for loading Cantera Python extensions from C++
copy "%SRC_DIR%\build\lib\cantera_python*.dll" "%PREFIX%\Library\bin\"

:: Conda environment handles library path, so no need to co-install cantera_shared.dll
del /f "%PREFIX%\Lib\site-packages\cantera\cantera_shared.dll"

echo ****************************
echo PYTHON %PYTHON% BUILD COMPLETED SUCCESSFULLY
echo ****************************
