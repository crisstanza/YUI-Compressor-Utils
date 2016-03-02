@echo off

set VERSION=1.0.0

set NAME=YUI Compressor Utils

set MAIN_PACKAGE=yuicompressorutils.main
set MAIN_CLASS=MainYUICompressorUtils

set CP=.
set CP=%CP%;classes

cls

if "%1"=="" (
	echo.
	echo %NAME% - %VERSION%
	echo ============================
	echo.
	echo   Error!
	echo   Usage: .\YUI-Compressor-Utils.bat [commands...]
	echo.
	echo   Available commands:
	echo          .\YUI-Compressor-Utils.bat [clean ^| runIt]
	echo.
	echo   ps: commands starting with uppercase letter are OS specific.
	echo.
	echo.
	GOTO end
) else (
	GOTO %1
)

:runIt
	set YUI_COMPRESSOR_JAR=yuicompressor-2.4.8.jar
	set SRC_DEPLOY=src.deploy
	if exist %SRC_DEPLOY% (
		set NAMES=files.txt
		forfiles /s /m *.css /c "cmd /c echo @relpath" | find /v "src.deploy" > %NAMES%
		forfiles /s /m *.js /c "cmd /c echo @relpath" | find /v "src.deploy" >> %NAMES%
		for /F "tokens=*" %%A in (%NAMES%) do (
			set line=%%A
			set DESTINY=%SRC_DEPLOY%\%line:~1,-1%
			echo =^> File: %DESTINY%
			echo.
			java -cp %CP% -jar lib\%YUI_COMPRESSOR_JAR% -v -o %DESTINY% %%A
		)
		del %NAMES%
	) else (
		echo.
		echo Error!
		echo Directory src.deploy not found!
		echo.
	)
	GOTO end

:clean
	if exist bin rmdir /s/q bin
	if exist classes rmdir /s/q classes
	GOTO end

:end
	echo.
	pause
