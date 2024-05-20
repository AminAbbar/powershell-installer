@echo off

:: just checking if the file is runing as administrator
>nul 2>&1 "%SYSTEMROOT%\System32\cacls.exe" "%SYSTEMROOT%\System32\config\system"


if "%errorlevel%" NEQ "0" (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)


PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0installer.ps1'"


pause