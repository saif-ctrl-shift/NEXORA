@echo off
setlocal
echo ========================================================
echo Starting NEXORA College Event Management System
echo M.H. Saboo Siddik College of Engineering, Mumbai
echo ========================================================

set "JAVA_HOME=C:\Program Files\JetBrains\PyCharm 2026.1.4\jbr"
set "CATALINA_HOME=%~dp0tools\apache-tomcat-10.1.34"

echo JAVA_HOME: %JAVA_HOME%
echo CATALINA_HOME: %CATALINA_HOME%
echo URL: http://localhost:8080/
echo ========================================================

cd /d "%CATALINA_HOME%\bin"
call catalina.bat run
