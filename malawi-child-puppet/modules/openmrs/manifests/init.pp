class openmrs {
    
	require pih_folders
	require pih_java
	require pih_tomcat
	require pih_mysql
	require gzip 
	require putty 
	
	$mysql_exe = "${pih_mysql_home}\\bin\\mysql.exe"
	$pih_openmrs_home_linux = regsubst($pih_openmrs_home, '[\\]', '/', G) 
	$pih_openmrs_modules = "${pih_openmrs_home}\\modules\\"
	$pih_openmrs_db = "${pih_openmrs_home}db\\"
	$pih_openmrs_db_file = "${pih_openmrs_db}openmrs.sql"
	$pih_openmrs_db_bat = "${pih_openmrs_db}dropAndCreateDb.sql"
	$pih_openmrs_db_file_linux = regsubst($pih_openmrs_db_file, '[\\]', '/', G) 
	
	$stop_OpenMRS_bat = "${pih_openmrs_home}stopOpenMRS.bat"
	$start_OpenMRS_bat = "${pih_openmrs_home}startOpenMRS.bat"
	$label_shutdown_openmrs = hiera('label_shutdown_openmrs')
	$shutdown_openmrs_lnk = "${openmrs_startup_menu}\\Shutdown OpenMRS.lnk"
	$label_start_openmrs = hiera('label_start_openmrs')
	$start_openmrs_lnk = "${openmrs_startup_menu}\\Start OpenMRS.lnk"
	
	$pih_icon = $pih_folders::pih_icon
	$desktop_shortcut_url = hiera('desktop_shortcut_url')
	$windows_openmrs_user = hiera('windows_openmrs_user')
	$openmrs_desktop_url = "C:\\Users\\${windows_openmrs_user}\\Desktop\\${desktop_shortcut_url}"

	$openmrs_create_db_sql = "${pih_openmrs_db}dropAndCreateDb.sql"
	$dropAndCreateDb_bat = "${pih_openmrs_home}dropAndCreateDb.bat"
	
	$mysql_root_user = hiera('mysql_root_user')
	$mysql_root_password = hiera('mysql_root_password')
	$openmrs_db = hiera('openmrs_db')
	$openmrs_db_user = hiera('openmrs_db_user')
	$openmrs_db_password = hiera('openmrs_db_password')	
	$openmrs_scheduler_user = hiera('openmrs_scheduler_user')	
	$openmrs_scheduler_password = hiera('openmrs_scheduler_password')
	$openmrs_pih_config = hiera('openmrs_pih_config')
	$remote_zlidentifier_url = hiera('remote_zlidentifier_url')
	$remote_zlidentifier_username = hiera('remote_zlidentifier_username')
	$remote_zlidentifier_password = hiera('remote_zlidentifier_password')
	
	$gzip_exe = "${pih_gzip_home}\\bin\\gzip"
	
	$pih_openmrs_modules_zip = "${pih_home_bin}\\openmrs-modules.zip"
	$pih_openmrs_war = "${pih_tomcat_home}\\webapps\\openmrs.war"
	$openmrs_db_zip = "${pih_openmrs_db}openmrs.sql.zip"
	$pih_openmrs_runtime_properties = "${pih_openmrs_home}openmrs-runtime.properties"

	$update_openmrs_bat = "${pih_update_home}update-openmrs.bat"
	$pih_update_home = "${pih_home}\\update\\"
			
	file { $pih_openmrs_home:
		ensure  => directory,
		require => File[$pih_home],
	} ->
	
	file { $pih_openmrs_db:
		ensure  => directory,
		purge   => true,
		force   => true,
		recurse => true,
	} ->

	file { $pih_openmrs_modules:
		ensure  => directory,
		source	=> "puppet:///modules/openmrs/modules",		
		purge   => true,
		force   => true,
		recurse => true,
	} ->

	file { $openmrs_db_zip:
		ensure  => file,
		source	=> "puppet:///modules/openmrs/openmrs.sql.zip",		
		recurse => true,
		replace => true,
	} ->
	
	windows::unzip { $openmrs_db_zip:
		destination => $pih_openmrs_db,
		creates	=> "${pih_openmrs_db}\\openmrs.sql",
		require => File[$pih_openmrs_db],
	} ->
	
	file { $openmrs_create_db_sql: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/dropAndCreateDb.sql.erb'),	
	} ->
	
	file { $stop_OpenMRS_bat: 
		ensure  => present,
		provider => windows, 	
		source	=> "puppet:///modules/openmrs/stopOpenMRS.bat",
	} ->  

	windows::shortcut { $shutdown_openmrs_lnk:
	  target      => $stop_OpenMRS_bat,
	  working_directory	=> "${pih_openmrs_home}", 
	  description => "${label_shutdown_openmrs}",
	} ->	

	file { $start_OpenMRS_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/startOpenMRS.bat.erb'),	
	} -> 
	
	windows::shortcut { $start_openmrs_lnk:
	  target      => $start_OpenMRS_bat,
	  working_directory	=> "${pih_openmrs_home}", 
	  description => "${label_start_openmrs}",
	} ->		
					
	file { $pih_openmrs_war:
		ensure  => file,
		source	=> "puppet:///modules/openmrs/openmrs.war",		
	} -> 
	
	file { $pih_openmrs_runtime_properties: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/openmrs-runtime.properties.erb'),	
	} ->

	windows::environment { 'OPENMRS_RUNTIME_PROPERTIES_FILE': 
		value	=>	$pih_openmrs_runtime_properties,
		notify	=> Class['windows::refresh_environment'],
	} ->

	file { $dropAndCreateDb_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs/dropAndCreateDb.bat.erb'),	
	} ->

	exec { 'execute_dropAndCreateDb_bat': 
		path		=> $::path,
		cwd			=> "${pih_openmrs_db}", 
		provider	=> windows, 
		timeout		=> 0, 
		command		=> "cmd.exe /c ${dropAndCreateDb_bat}",
		logoutput	=> true,
	} -> 
	
	exec { 'remove_dropAndCreateDb_bat': 
		path		=> $::path,
		cwd			=> "${pih_openmrs_db}", 
		provider	=> windows, 
		timeout		=> 0, 
		command		=> "cmd.exe /c del /F /Q ${dropAndCreateDb_bat}",
		logoutput	=> true,
	} ->
	
	file { $openmrs_desktop_url: 
		ensure  => present,	
		content	=> template('openmrs/openmrs_desktop_shortcut.URL.erb'),	
	}

}