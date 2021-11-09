cd %CD%
xcopy bin\java\* modules\pih_java\files\ /Y /I
xcopy bin\tomcat\* modules\pih_tomcat\files\ /Y /I
xcopy bin\mysql\* modules\pih_mysql\files\ /Y /I
xcopy bin\putty\* modules\putty\files\ /Y /I
puppet apply --verbose --logdest=console --hiera_config=./hiera.yaml --modulepath=./modules manifests\malawi-child-site.pp