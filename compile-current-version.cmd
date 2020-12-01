rem @echo off
set compiler=C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe
set bin=C:\Program Files\AutoHotkey\Compiler\Unicode 64-bit.bin
set majorminorversion=1.2
set versionbuild=42
if not exist "%cd%\current" md "%cd%\current"
call "%compiler%" /in Timing-Labels-Assistant.ahk /out current\Timing-Labels-Assistant.exe /icon Timing-Labels-Assistant.ico /bin "%bin%"
call jade -o current/ jade/Timing-Labels-Assistant_readme.jade
cd current
call :setversion
call :dozip
cd ..
pause
goto :eof

:setversion
if exist Timing-Labels-Assistant_v%majorminorversion%.%versionbuild%.zip  set /A versionbuild=%versionbuild%+1
if exist Timing-Labels-Assistant_v%majorminorversion%.%versionbuild%.zip  goto :setversion
goto :eof


:dozip
call "C:\Program Files\7-Zip\7z.exe" a  -tzip Timing-Labels-Assistant_v%majorminorversion%.%versionbuild%.zip Timing-Labels-Assistant.exe *.html
goto :eof