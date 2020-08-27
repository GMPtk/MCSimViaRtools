@setlocal enabledelayedexpansion

@set rootdir=%~dp0
@set target=%~1

@set GCC=
@set platform=32

@if exist "%SystemDrive%\rtools40\mingw%platform%\bin\gcc.exe" (
  @set "GCC=%SystemDrive%\rtools40\mingw%platform%\bin\gcc.exe"
)

@if "%GCC%" == "" (
  @if exist "%SystemDrive%\Rtools\mingw_%platform%\bin\gcc.exe" (
    @set "GCC=%SystemDrive%\Rtools\mingw_%platform%\bin\gcc.exe"
  )
)

@if "%GCC%" == "" (
  @echo.
  @echo Failed to find compiler in Rtools
  @exit /b 1
)

@set "MOD=%rootdir%mod\mod.exe"

@if not exist "%MOD%" (

  @echo.
  @echo Building mod...
  
  "%GCC%" -o %MOD% %rootdir%mod\*.c

  @if %ERRORLEVEL% neq 0 (
    @pause
    @exit /b 1
  )

  @echo ...done

)

@if "%target%" NEQ "" (

  @for %%i in ("%target%") do @(
    @set targetName=%%~ni
    @set targetDir=%%~dpi
  )

  @if exist "!targetDir!!targetName!.c" (
    @del "!targetDir!!targetName!.c"
  )

  "%MOD%" "%target%" "!targetDir!!targetName!.c"

  @if not exist "!targetDir!!targetName!.c" (
    @exit /b 1
  )

  @if exist "!targetDir!!targetName!.exe" (
    @del "!targetDir!!targetName!.exe"
  )

  "%GCC%" -O3 -I%rootdir%sim -I%rootdir%sim\gsl-2.6 -o "!targetDir!!targetName!.exe" "!targetDir!!targetName!.c" %rootdir%sim\*.c -lm -L%rootdir%sim\gsl-2.6\.libs -lgsl

  @if not exist "!targetDir!!targetName!.exe" (
    @exit /b 1
  )

  @echo Created !targetDir!!targetName!.exe

  @exit /b 0
)

@if not exist "%rootdir%out" (
  mkdir "%rootdir%out"
)

@for /f %%M in ("%rootdir%target\*.model") do @(

  @echo.
  @echo Building sim for %%~nM...

  @if exist "%rootdir%out\%%~nM.c" (
    @del "%rootdir%out\%%~nM.c"
  )

  "%MOD%" %%M "%rootdir%out\%%~nM.c"

  @if not exist "%rootdir%out\%%~nM.c" (
    @echo.
    @echo Failed to generate .c file for %%~nM
    @exit /b 1
  )

  @echo ...compiling...

  @if exist "%rootdir%out\%%~nM.exe" (
    @del "%rootdir%out\%%~nM.exe"
  )

  "%GCC%" -O3 -I%rootdir%sim -I%rootdir%sim\gsl-2.6 -o "%rootdir%out\%%~nM.exe" "%rootdir%out\%%~nM.c" %rootdir%sim\*.c -lm -L%rootdir%sim\gsl-2.6\.libs -lgsl

  @if not exist "%rootdir%out\%%~nM.exe" (
    @echo.
    @echo Failed to compile/link .c file for %%~nM
    @exit /b 1
  )

  @echo.
  @echo ...done...created %%~nM.exe

)
