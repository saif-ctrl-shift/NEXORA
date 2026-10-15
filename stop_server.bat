@echo off
setlocal
echo Stopping NEXORA server...
set "JAVA_HOME=C:\Program Files\JetBrains\PyCharm 2026.1.4\jbr"
set "CATALINA_HOME=%~dp0tools\apache-tomcat-10.1.34"
cd /d "%CATALINA_HOME%\bin"
call catalina.bat stop
echo Server stopped.
