@REM @ECHO OFF
SETLOCAL
SET EL=0

ECHO NUMBER_OF_PROCESSORS^: %NUMBER_OF_PROCESSORS%

SET PROJECT_DIR=%CD%
SET CONFIGURATION=Release

SET PATH=C:\Program Files (x86)\MSBuild\15.0\Bin;%PATH%
CALL "C:\Program Files\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
CALL "C:\Program Files\Microsoft Visual Studio\Installer\vswhere.exe" -latest -prerelease -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe
ECHO cl.exe version
cl
ECHO msbuild version
msbuild /version

mkdir build
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
cd build
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
cmake -DENABLE_CONAN=ON -DCMAKE_BUILD_TYPE=%CONFIGURATION% -DBUILD_TOOLS=ON -G "Visual Studio 16 2019" ..
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

msbuild OSRM.sln ^
/p:Configuration=%CONFIGURATION% ^
/p:Platform=x64 ^
/t:rebuild ^
/p:BuildInParallel=true ^
/m:%NUMBER_OF_PROCESSORS% ^
/toolsversion:Current ^
/p:PlatformToolset=v142 ^
/clp:Verbosity=normal ^
/nologo

IF %ERRORLEVEL% NEQ 0 GOTO ERROR


CD %PROJECT_DIR%\build
IF %ERRORLEVEL% EQU 1 GOTO ERROR

ECHO running extractor-tests.exe ...
unit_tests\%CONFIGURATION%\extractor-tests.exe
IF %ERRORLEVEL% EQU 1 GOTO ERROR

ECHO running contractor-tests.exe ...
unit_tests\%CONFIGURATION%\contractor-tests.exe
IF %ERRORLEVEL% EQU 1 GOTO ERROR

ECHO running engine-tests.exe ...
unit_tests\%CONFIGURATION%\engine-tests.exe
IF %ERRORLEVEL% EQU 1 GOTO ERROR

ECHO running util-tests.exe ...
unit_tests\%CONFIGURATION%\util-tests.exe
IF %ERRORLEVEL% EQU 1 GOTO ERROR

ECHO running server-tests.exe ...
unit_tests\%CONFIGURATION%\server-tests.exe
IF %ERRORLEVEL% EQU 1 GOTO ERROR

ECHO running partitioner-tests.exe ...
unit_tests\%CONFIGURATION%\partitioner-tests.exe
IF %ERRORLEVEL% EQU 1 GOTO ERROR

ECHO running customizer-tests.exe ...
unit_tests\%CONFIGURATION%\customizer-tests.exe
IF %ERRORLEVEL% EQU 1 GOTO ERROR
echo Exit Code is %errorlevel%
ECHO running library-tests.exe ...
SET test_region=monaco
SET test_region_ch=%PROJECT_DIR%\test\data\ch\monaco
SET test_region_corech=%PROJECT_DIR%\test\data\corech\monaco
SET test_region_mld=%PROJECT_DIR%\test\data\mld\monaco
SET test_osm=%PROJECT_DIR%\test\data\%test_region%.osm.pbf
ECHO running %CONFIGURATION%\osrm-extract.exe -p ../profiles/car.lua %test_osm%
cmd /c "exit /b 0"
%CONFIGURATION%\osrm-extract.exe -p ../profiles/car.lua %test_osm%
echo Exit Code is %errorlevel%
@REM IF %ERRORLEVEL% NEQ 0 GOTO ERROR
dir Release
Release\osrm-extract.exe --version
@rem dir /s /b

MKDIR ch
XCOPY %test_region%.osrm.* ch\
XCOPY %test_region%.osrm ch\
MKDIR corech
XCOPY %test_region%.osrm.* corech\
XCOPY %test_region%.osrm corech\
MKDIR mld
XCOPY %test_region%.osrm.* mld\
XCOPY %test_region%.osrm mld\
%CONFIGURATION%\osrm-contract.exe %test_region_ch%.osrm
%CONFIGURATION%\osrm-contract.exe --core 0.8 %test_region_corech%.osrm
%CONFIGURATION%\osrm-partition.exe %test_region_mld%.osrm
%CONFIGURATION%\osrm-customize.exe %test_region_mld%.osrm
XCOPY /Y ch\*.* ..\test\data\ch\
XCOPY /Y corech\*.* ..\test\data\corech\
XCOPY /Y mld\*.* ..\test\data\mld\
unit_tests\%CONFIGURATION%\library-tests.exe
IF %ERRORLEVEL% EQU 1 GOTO ERROR



:ERROR
ECHO ~~~~~~~~~~~~~~~~~~~~~~ ERROR %~f0 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO ERRORLEVEL^: %ERRORLEVEL%
SET EL=%ERRORLEVEL%

:DONE
ECHO ~~~~~~~~~~~~~~~~~~~~~~ DONE %~f0 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

EXIT /b %EL%
