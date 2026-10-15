@echo off
echo ========================================================
echo NEXORA - Resetting MySQL root password to 'root'
echo ========================================================
net stop MySQL80
echo ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'; > "%TEMP%\mysql_init.sql"
echo FLUSH PRIVILEGES; >> "%TEMP%\mysql_init.sql"
start "" "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe" --defaults-file="C:\ProgramData\MySQL\MySQL Server 8.0\my.ini" --init-file="%TEMP%\mysql_init.sql" --console
timeout /t 6 /nobreak > nul
taskkill /F /IM mysqld.exe > nul 2>&1
timeout /t 2 /nobreak > nul
net start MySQL80
del "%TEMP%\mysql_init.sql" > nul 2>&1
echo ========================================================
echo SUCCESS! Your MySQL root password is now: root
echo ========================================================
pause
