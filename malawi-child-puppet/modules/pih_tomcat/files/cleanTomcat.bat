@echo off

echo.
echo About to cleanup tomcat folder.
echo.


rem stop openmrs =============================================================
echo Stopping OpenMRS localhost
set PWD=%CD%
net stop Tomcat7
cd /d %PWD%

: fake messages to clear screen
echo.
echo Starting remote server preparation
echo Stopping OpenMRS localhost

rem cleanup ==================================================================
echo Cleaning up tomcat folders
del /F /Q ..\conf\Catalina\localhost\openmrs.xml
rd /S /Q ..\bin\activemq-data
del /F /Q /S ..\logs\*.*
@For /D %%I in (C:\openmrs\tomcat\temp\*) DO RD /s /q %%I
rd /S /Q ..\webapps\openmrs
rd /S /Q ..\work\Catalina
del /F /Q c:\pih\openmrs\openmrs.log

rem ready and done ===========================================================
echo.
echo Cleanup finished. You can now restart tomcat.
echo.

