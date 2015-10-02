rem @echo off
set compiler=C:\programs\autohotkey32\Ahk2Exe112202\ahk2exe.exe
set bin=C:\programs\autohotkey32\Ahk2Exe112202\Unicode 32-bit.bin
set versionbuild=28
if not exist "%cd%\current" md "%cd%\current"
call "%compiler%" /in Timing-Labels-Assistant.ahk /out current\Timing-Labels-Assistant.exe /icon Timing-Labels-Assistant.ico /bin "%bin%"
call jade -o current/ jade/Timing-Labels-Assistant_readme.jade
cd current
call :dozip
cd ..
pause
goto :eof

:dozip
if exist Timing-Labels-Assistant_v1.2.%versionbuild%.zip  set /A versionbuild=%versionbuild%+1
if exist Timing-Labels-Assistant_v1.2.%versionbuild%.zip  goto :dozip
call "C:\Program Files\7-Zip\7z.exe" a  -tzip Timing-Labels-Assistant_v1.2.%versionbuild%.zip *.exe *.html
goto :eof