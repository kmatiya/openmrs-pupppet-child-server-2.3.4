if $osfamily == 'windows' {
    File { source_permissions => ignore }
}

$jdk_zip = "jdk_8u222b10_x64.zip"
$pih_home = hiera('pih_home')
$puppet_install_home = hiera('puppet_install_home')
$pih_openmrs_home = "${pih_home}\\openmrs\\"
$windows_openmrs_user = hiera('windows_openmrs_user')
$pih_home_bin = "${pih_home}\\bin"
$pih_java_home = "${pih_home}\\java"
$pih_tomcat_home = "${pih_home}\\tomcat"
$pih_mysql_home = "${pih_home}\\mysql"
$pih_putty_home = "${pih_home}\\putty"
$pih_gzip_home = "${pih_home}\\gzip"
$tail_exe = "${pih_home_bin}\\tail.exe"
$wget_exe = "${pih_home_bin}\\wget.exe"
$subinacl_exe = "${pih_home_bin}\\subinacl.exe"
$win_startup_menu = hiera('win_startup_menu')
$openmrs_startup_menu = "${win_startup_menu}\\OpenMRS" 
$start_openmrs_lnk = "${openmrs_startup_menu}\\StartOpenMRS.lnk"

notify{"hostname= ${hostname}": }
notify{"openmrs_startup_menu= ${openmrs_startup_menu}": }
	
node default {
	include pih_folders
	include gzip
	include pih_java
	include pih_tomcat
	include pih_mysql
	include putty
	include openmrs-sync
}
