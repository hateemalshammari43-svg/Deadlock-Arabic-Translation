@echo off
chcp 65001 > nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0تحديث_جيت_هاب.ps1"
echo.
echo اضغط على أي مفتاح للإغلاق...
pause > nul
