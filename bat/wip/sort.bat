@ECHO OFF
SETLOCAL EnableDelayedExpansion
	PUSHD
		:MAIN
			FOR %%A IN (*.*) DO (
				CALL :CLEAN "%%~nA"
				CALL :COUNT
			)
			FOR %%A IN (*.*) DO (
				CALL :CLEAN "%%~nA"
				CALL :SORT "%%~nA" "%%~xA"
			)
		GOTO :EOF

		:CLEAN
			REM Removes illegal characters
			SET "TITLE=COUNT_%~1"
			SET "TITLE=!TITLE: =_!"
			SET "TITLE=!TITLE:-=!"
			SET "TITLE=!TITLE:(=!"
			SET "TITLE=!TITLE:%%=!"
		GOTO :EOF & SET "TITLE=!TITLE:)=!"

		:COUNT
			REM Counts how many files share the same name
			IF !%TITLE%! LSS 1 ( SET /A "%TITLE%=0" )
			SET /A "%TITLE%+=1"
		GOTO :EOF

		:SORT
			REM Moves same name files to a same name folder
			IF !%TITLE%! GTR 1 (
				IF NOT EXIST "%~1" ( MD "%~1" )
				ECHO Moving "%~1%~2"
				MOVE "%~1%~2" "%~1"
				ECHO.
			)
		GOTO :EOF
	POPD
PAUSE