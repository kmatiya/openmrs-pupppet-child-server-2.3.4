cd %CD%
xcopy bin\java\* modules\pih_java\files\ /Y /I
xcopy bin\tomcat\* modules\pih_tomcat\files\ /Y /I
xcopy bin\mysql\* modules\pih_mysql\files\ /Y /I
xcopy bin\putty\* modules\putty\files\ /Y /I
xcopy bin\gzip\* modules\gzip\files\ /Y /I
xcopy bin\cwrsync\* modules\cwrsync\files\ /Y /I
xcopy bin\backups\7za.exe modules\pih_backups\files\ /Y /I
del /F /Q modules\openmrs\files\openmrs.sql.zip
del /F /Q modules\openmrs\files\openmrs.war 
del /F /Q modules\openmrs\files\modules\*
xcopy bin\openmrs\openmrs.sql.zip modules\openmrs\files\ /Y /I
xcopy bin\openmrs\openmrs.war modules\openmrs\files\ /Y /I
xcopy bin\openmrs\modules\*.omod modules\openmrs\files\modules\ /Y /I
puppet apply --verbose --logdest=console --hiera_config=./hiera.yaml --modulepath=./modules manifests\site.pp
