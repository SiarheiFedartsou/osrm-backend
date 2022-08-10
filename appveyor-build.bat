@ECHO OFF
SETLOCAL
SET EL=0

ECHO NUMBER_OF_PROCESSORS^: %NUMBER_OF_PROCESSORS%

SET PATH=C:\Program Files (x86)\MSBuild\15.0\Bin;%PATH%
CALL "C:\Program Files\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
CALL "C:\Program Files\Microsoft Visual Studio\Installer\vswhere.exe" -latest -prerelease -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe
ECHO cl.exe version
cl
ECHO msbuild version
msbuild /version

mkdir build
cd build
cmake -DENABLE_CONAN=ON  -G "Visual Studio 16 2019" ..
@REM msbuild OSRM.sln /p:Configuration=Release /p:Platform=x64 /t:rebuild /p:BuildInParallel=true /m:%NUMBER_OF_PROCESSORS% /toolsversion:Current /p:PlatformToolset=v142 /clp:Verbosity=normal /nologo /flp1:logfile=build_errors.txt;errorsonly /flp2:logfile=build_warnings.txt;warningsonly
    

@REM @ECHO OFF
@REM SETLOCAL
@REM SET EL=0

@REM ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %~f0 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

@REM SET PROJECT_DIR=%CD%
@REM ECHO PROJECT_DIR^: %PROJECT_DIR%
@REM ECHO NUMBER_OF_PROCESSORS^: %NUMBER_OF_PROCESSORS%


@REM :: Check CMake version
@REM SET CMAKE_VERSION=3.16.3
@REM SET PATH=%PROJECT_DIR%\cmake-%CMAKE_VERSION%-win32-x86\bin;%PATH%
@REM ECHO cmake^: && cmake --version
@REM IF %ERRORLEVEL% NEQ 0 ECHO CMAKE not found && GOTO CMAKE_NOT_OK

@REM cmake --version | findstr /C:%CMAKE_VERSION% && GOTO CMAKE_OK

@REM :CMAKE_NOT_OK
@REM ECHO CMAKE NOT OK - downloading new CMake %CMAKE_VERSION%
@REM powershell Invoke-WebRequest https://cmake.org/files/v3.16/cmake-%CMAKE_VERSION%-win32-x86.zip -OutFile $env:PROJECT_DIR\cm.zip
@REM IF %ERRORLEVEL% NEQ 0 GOTO ERROR
@REM IF NOT EXIST cmake-%CMAKE_VERSION%-win32-x86 7z -y x cm.zip | %windir%\system32\FIND "ing archive"
@REM IF %ERRORLEVEL% NEQ 0 GOTO ERROR

@REM :CMAKE_OK
@REM ECHO CMAKE_OK
@REM cmake --version

@REM ECHO activating VS command prompt ...
@REM SET PATH=C:\Program Files (x86)\MSBuild\15.0\Bin;%PATH%
@REM CALL "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"

@REM ECHO platform^: %platform%

@REM ECHO cl.exe version
@REM cl
@REM ECHO msbuild version
@REM msbuild /version

@REM :: HARDCODE "x64" as it is uppercase on AppVeyor and download from S3 is case sensitive
@REM SET DEPSPKG=osrm-deps-win-x64-14.2-2019.01.7z

@REM :: local development
@REM ECHO.
@REM ECHO LOCAL_DEV^: %LOCAL_DEV%
@REM IF NOT DEFINED LOCAL_DEV SET LOCAL_DEV=0
@REM IF DEFINED LOCAL_DEV IF %LOCAL_DEV% EQU 1 IF EXIST %DEPSPKG% ECHO skipping deps download && GOTO SKIPDL

@REM IF EXIST %DEPSPKG% DEL %DEPSPKG%
@REM IF %ERRORLEVEL% NEQ 0 GOTO ERROR

@REM ECHO downloading %DEPSPKG%
@REM powershell Invoke-WebRequest http://project-osrm.wolt.com/windows-build-deps/$env:DEPSPKG -OutFile $env:PROJECT_DIR\$env:DEPSPKG
@REM IF %ERRORLEVEL% NEQ 0 GOTO ERROR

@REM :SKIPDL

@REM IF EXIST osrm-deps ECHO deleting osrm-deps... && RD /S /Q osrm-deps
@REM IF %ERRORLEVEL% NEQ 0 GOTO ERROR
@REM IF EXIST build ECHO deleting build dir... && RD /S /Q build
@REM IF %ERRORLEVEL% NEQ 0 GOTO ERROR

@REM 7z -y x %DEPSPKG% | %windir%\system32\FIND "ing archive"
@REM IF %ERRORLEVEL% NEQ 0 GOTO ERROR

@REM ::tree osrm-deps

@REM MKDIR build
@REM IF %ERRORLEVEL% NEQ 0 GOTO ERROR
@REM cd build
@REM IF %ERRORLEVEL% NEQ 0 GOTO ERROR

@REM SET OSRMDEPSDIR=%PROJECT_DIR%/osrm-deps
@REM set PREFIX=%OSRMDEPSDIR%/libs
@REM set BOOST_ROOT=%OSRMDEPSDIR%
@REM set BOOST_LIBRARYDIR=%BOOST_ROOT%/lib
@REM set TBB_INSTALL_DIR=%OSRMDEPSDIR%
@REM REM set TBB_ARCH_PLATFORM=intel64/vc17

@REM ECHO OSRMDEPSDIR       ^: %OSRMDEPSDIR%
@REM ECHO PREFIX            ^: %PREFIX%
@REM ECHO BOOST_ROOT        ^: %BOOST_ROOT%
@REM ECHO BOOST_LIBRARYDIR  ^: %BOOST_LIBRARYDIR%
@REM ECHO TBB_INSTALL_DIR   ^: %TBB_INSTALL_DIR%
@REM REM ECHO TBB_ARCH_PLATFORM ^: %TBB_ARCH_PLATFORM%


@REM ECHO calling cmake ....
@REM cmake .. ^
@REM -G "Visual Studio 16 2019" ^
@REM -DBOOST_ROOT=%BOOST_ROOT% ^
@REM -DBOOST_LIBRARYDIR=%BOOST_LIBRARYDIR% ^
@REM -DBoost_ADDITIONAL_VERSIONS=1.73.0 ^
@REM -DBoost_USE_MULTITHREADED=ON ^
@REM -DBoost_USE_STATIC_LIBS=ON ^
@REM -DEXPAT_INCLUDE_DIR=%OSRMDEPSDIR% ^
@REM -DEXPAT_LIBRARY=%OSRMDEPSDIR%/lib/libexpat.lib ^
@REM -DBZIP2_INCLUDE_DIR=%OSRMDEPSDIR% ^
@REM -DBZIP2_LIBRARIES=%OSRMDEPSDIR%/lib/libbz2.lib ^
@REM -DLUA_INCLUDE_DIR=%OSRMDEPSDIR% ^
@REM -DLUA_LIBRARIES=%OSRMDEPSDIR%/lib/lua5.3.5.lib ^
@REM -DZLIB_INCLUDE_DIR=%OSRMDEPSDIR% ^
@REM -DZLIB_LIBRARY=%OSRMDEPSDIR%/lib/libz.lib ^
@REM -DCMAKE_BUILD_TYPE=%CONFIGURATION% ^
@REM -DCMAKE_INSTALL_PREFIX=%PREFIX%
@REM IF %ERRORLEVEL% NEQ 0 GOTO ERROR

@REM ECHO building ...
@REM msbuild OSRM.sln ^
@REM /p:Configuration=%Configuration% ^
@REM /p:Platform=x64 ^
@REM /t:rebuild ^
@REM /p:BuildInParallel=true ^
@REM /m:%NUMBER_OF_PROCESSORS% ^
@REM /toolsversion:Current ^
@REM /p:PlatformToolset=v142 ^
@REM /clp:Verbosity=normal ^
@REM /nologo ^
@REM /flp1:logfile=build_errors.txt;errorsonly ^
@REM /flp2:logfile=build_warnings.txt;warningsonly
@REM IF %ERRORLEVEL% EQU 1 GOTO ERROR

@REM CD %PROJECT_DIR%\build
@REM IF %ERRORLEVEL% EQU 1 GOTO ERROR

@REM SET PATH=%PROJECT_DIR%\osrm-deps\lib;%PATH%

@REM ECHO running extractor-tests.exe ...
@REM unit_tests\%Configuration%\extractor-tests.exe
@REM IF %ERRORLEVEL% EQU 1 GOTO ERROR

@REM ECHO running contractor-tests.exe ...
@REM unit_tests\%Configuration%\contractor-tests.exe
@REM IF %ERRORLEVEL% EQU 1 GOTO ERROR

@REM ECHO running engine-tests.exe ...
@REM unit_tests\%Configuration%\engine-tests.exe
@REM IF %ERRORLEVEL% EQU 1 GOTO ERROR

@REM ECHO running util-tests.exe ...
@REM unit_tests\%Configuration%\util-tests.exe
@REM IF %ERRORLEVEL% EQU 1 GOTO ERROR

@REM ECHO running server-tests.exe ...
@REM unit_tests\%Configuration%\server-tests.exe
@REM IF %ERRORLEVEL% EQU 1 GOTO ERROR

@REM ECHO running partitioner-tests.exe ...
@REM unit_tests\%Configuration%\partitioner-tests.exe
@REM IF %ERRORLEVEL% EQU 1 GOTO ERROR

@REM ECHO running customizer-tests.exe ...
@REM unit_tests\%Configuration%\customizer-tests.exe
@REM IF %ERRORLEVEL% EQU 1 GOTO ERROR

@REM ECHO running library-tests.exe ...
@REM SET test_region=monaco
@REM SET test_region_ch=ch\monaco
@REM SET test_region_corech=corech\monaco
@REM SET test_region_mld=mld\monaco
@REM SET test_osm=%test_region%.osm.pbf
@REM IF NOT EXIST %test_osm% powershell Invoke-WebRequest http://project-osrm.wolt.com/testing/monaco.osm.pbf -OutFile %test_osm%
@REM ECHO running %Configuration%\osrm-extract.exe -p ../profiles/car.lua %test_osm%
@REM %Configuration%\osrm-extract.exe
@REM %Configuration%\osrm-extract.exe -p ../profiles/car.lua %test_osm%
@REM MKDIR ch
@REM XCOPY %test_region%.osrm.* ch\
@REM XCOPY %test_region%.osrm ch\
@REM MKDIR corech
@REM XCOPY %test_region%.osrm.* corech\
@REM XCOPY %test_region%.osrm corech\
@REM MKDIR mld
@REM XCOPY %test_region%.osrm.* mld\
@REM XCOPY %test_region%.osrm mld\
@REM %Configuration%\osrm-contract.exe %test_region_ch%.osrm
@REM %Configuration%\osrm-contract.exe --core 0.8 %test_region_corech%.osrm
@REM %Configuration%\osrm-partition.exe %test_region_mld%.osrm
@REM %Configuration%\osrm-customize.exe %test_region_mld%.osrm
@REM XCOPY /Y ch\*.* ..\test\data\ch\
@REM XCOPY /Y corech\*.* ..\test\data\corech\
@REM XCOPY /Y mld\*.* ..\test\data\mld\
@REM unit_tests\%Configuration%\library-tests.exe

@REM :ERROR
@REM ECHO ~~~~~~~~~~~~~~~~~~~~~~ ERROR %~f0 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@REM ECHO ERRORLEVEL^: %ERRORLEVEL%
@REM SET EL=%ERRORLEVEL%

@REM :DONE
@REM ECHO ~~~~~~~~~~~~~~~~~~~~~~ DONE %~f0 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

@REM EXIT /b %EL%
