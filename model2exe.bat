@setlocal enabledelayedexpansion

@set target=%1

@set GCC=
@set platform=32

@if exist "%SystemDrive%\Rtools\mingw_%platform%\bin\gcc.exe" (
  @set "GCC=%SystemDrive%\Rtools\mingw_%platform%\bin\gcc.exe"
)

@if "%GCC%" == "" (
  @echo.
  @echo Failed to find compiler in Rtools
  @exit /b 1
)

@echo.
@echo using GCC: %GCC%

@set "MOD=.\mod\mod.exe"

@if not exist "%MOD%" (

  @echo.
  @echo Building mod...
  
  "%GCC%" -o %MOD% .\mod\*.c

  @if %ERRORLEVEL% neq 0 (
    @pause
    @exit /b 1
  )

  @echo ...done

)

@if "%target%" NEQ "" (

  @for %%i in ("%target%") do @(
    @set targetName=%%~ni
  )

  "%MOD%" %target% ".\out\!targetName!.c"

  @if not exist ".\out\!targetName!.c" (
    @exit /b 1
  )

  "%GCC%" -O3 -I.. -I.\sim -o ".\out\!targetName!.exe" ".\out\!targetName!.c" .\sim\*.c -lm

  @if not exist ".\out\!targetName!.exe" (
    @exit /b 1
  )

  @echo Created .\out\!targetName!.exe

  @exit /b 0
)

@for /f %%M in (".\target\*.model") do @(

  @echo.
  @echo Building sim for %%~nM...

  "%MOD%" %%M ".\out\%%~nM.c"

  @if not exist ".\out\%%~nM.c" (
    @echo.
    @echo Failed to generate .c file for %%~nM
    @exit /b 1
  )

  @echo ...compiling...

  "%GCC%" -O3 -I.. -I.\sim -o ".\out\%%~nM.exe" ".\out\%%~nM.c" .\sim\*.c -lm

  @if not exist ".\out\%%~nM.exe" (
    @echo.
    @echo Failed to compile/link .c file for %%~nM
    @exit /b 1
  )

  @echo ...done...created %%~nM.exe

)
