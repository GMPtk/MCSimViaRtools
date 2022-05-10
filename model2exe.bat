@setlocal enabledelayedexpansion

@set rootdir=%~dp0
@set target=%~1

@set GCC=
@set GSL_VER=
@set platform=32

@if exist "%SystemDrive%\rtools42\x86_64-w64-mingw%platform%.static.posix\bin\gcc.exe" (
  @set "PATH=%PATH%;%SystemDrive%\rtools42\x86_64-w64-mingw%platform%.static.posix\bin"
  @set "GCC=gcc.exe"
  @set "GSL_VER=2.7"
  goto use_gcc
)

@if exist "%SystemDrive%\rtools40\mingw%platform%\bin\gcc.exe" (
  @set "GCC=%SystemDrive%\rtools40\mingw%platform%\bin\gcc.exe"
  @set "GSL_VER=2.6"
  goto use_gcc
)

@if exist "%SystemDrive%\Rtools\mingw_%platform%\bin\gcc.exe" (
  @set "GCC=%SystemDrive%\Rtools\mingw_%platform%\bin\gcc.exe"
  @set "GSL_VER=2.6"
  goto use_gcc
)

@echo.
@echo Failed to find compiler in Rtools
@exit /b 1

:use_gcc

@set "MOD=%rootdir%mod\mod.exe"

@if not exist "%MOD%" (

  @echo.
  @echo Building mod...
  
  "%GCC%" -o %MOD% %rootdir%mod\getopt.c %rootdir%mod\lex.c %rootdir%mod\lexerr.c %rootdir%mod\lexfn.c %rootdir%mod\mod.c %rootdir%mod\modd.c %rootdir%mod\modi.c %rootdir%mod\modiSBML.c %rootdir%mod\modiSBML2.c %rootdir%mod\modo.c %rootdir%mod\strutil.c

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

  "%GCC%" -O3 -I%rootdir%sim -I%rootdir%sim\gsl-%GSL_VER% -o "!targetDir!!targetName!.exe" "!targetDir!!targetName!.c" %rootdir%sim\delays.c %rootdir%sim\getopt.c %rootdir%sim\lex.c %rootdir%sim\lexerr.c %rootdir%sim\lexfn.c %rootdir%sim\list.c %rootdir%sim\lsodes1.c %rootdir%sim\lsodes2.c %rootdir%sim\matutil.c %rootdir%sim\matutilo.c %rootdir%sim\mh.c %rootdir%sim\modelu.c %rootdir%sim\optdsign.c %rootdir%sim\random.c %rootdir%sim\sim.c %rootdir%sim\simi.c %rootdir%sim\siminit.c %rootdir%sim\simmonte.c %rootdir%sim\simo.c %rootdir%sim\strutil.c %rootdir%sim\yourcode.c -lm -L%rootdir%sim\gsl-%GSL_VER%\.libs -lgsl

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

  @set "target_c=%rootdir%out\%%~nM.c"
  @set "target_exe=%rootdir%out\%%~nM.exe"

  @if exist "!target_c!" (
    @del "!target_c!"
  )

  "%MOD%" "%rootdir%target\%%~nM.model" "!target_c!"

  @if not exist "!target_c!" (
    @echo.
    @echo Failed to generate .c file for %%~nM
    @exit /b 1
  )

  @echo ...compiling...

  @if exist "!target_exe!" (
    @del "!target_exe!"
  )

  "%GCC%" -O3 -I%rootdir%sim -I%rootdir%sim\gsl-%GSL_VER% -o "!target_exe!" "!target_c!" %rootdir%sim\delays.c %rootdir%sim\getopt.c %rootdir%sim\lex.c %rootdir%sim\lexerr.c %rootdir%sim\lexfn.c %rootdir%sim\list.c %rootdir%sim\lsodes1.c %rootdir%sim\lsodes2.c %rootdir%sim\matutil.c %rootdir%sim\matutilo.c %rootdir%sim\mh.c %rootdir%sim\modelu.c %rootdir%sim\optdsign.c %rootdir%sim\random.c %rootdir%sim\sim.c %rootdir%sim\simi.c %rootdir%sim\siminit.c %rootdir%sim\simmonte.c %rootdir%sim\simo.c %rootdir%sim\strutil.c %rootdir%sim\yourcode.c -lm -L%rootdir%sim\gsl-%GSL_VER%\.libs -lgsl

  @if not exist "!target_exe!" (
    @echo.
    @echo Failed to compile/link .c file for %%~nM
    @exit /b 1
  )

  @echo.
  @echo ...done...created %%~nM.exe

)
