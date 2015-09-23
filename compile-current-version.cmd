@echo off
set compiler=C:\programs\autohotkey32\Ahk2Exe112202\ahk2exe.exe
set bin=C:\programs\autohotkey32\Ahk2Exe112202\Unicode 32-bit.bin
if not exist "%cd%\current" md "%cd%\current"
call "%compiler%" /in Timing-Labels-Assistant.ahk /out current\Timing-Labels-Assistant.exe /icon Timing-Labels-Assistant.ico /bin "%bin%"
call jade -o current/ jade/Timing-Labels-Assistant_readme.jade
cd current
call "C:\Program Files\7-Zip\7z.exe" a  -tzip Timing-Labels-Assistant_v1.2.27.zip *.exe *.html
cd ..
pause