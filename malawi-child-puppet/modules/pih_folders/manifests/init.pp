class pih_folders {
	
	$label_reset_openmrs = "Reset OpenMRS"
	$reset_openmrs_lnk = "${openmrs_startup_menu}\\Reset OpenMRS.lnk"
	$install_bat = "${puppet_install_home}\\install.bat"
	$pih_icon = "${pih_home_bin}\\pih_favicon.ico"

	file { $pih_home:
		ensure  => directory,
	} -> 
	
	file { $pih_home_bin:
		ensure  => directory,
		purge   => true,
		force   => true,
		recurse => true,
	} -> 
	
	exec { 'stop_tomcat6': 
		path		=> $::path,
		cwd			=> "${pih_tomcat_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c net stop Tomcat6",
		onlyif		=> "cmd.exe /c sc query Tomcat6",
		unless		=> "cmd.exe /c sc query Tomcat6 | find \"STOPPED\"",
		logoutput	=> true, 
		returns		=> [0, 1, 2],
	} -> 

    exec { 'stop_tomcat7': 
		path		=> $::path,
		cwd			=> "${pih_tomcat_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c net stop Tomcat7",
		onlyif		=> "cmd.exe /c sc query Tomcat7",
		unless		=> "cmd.exe /c sc query Tomcat7 | find \"STOPPED\"",
		logoutput	=> true, 
		returns		=> [0, 1, 2],
	} -> 

    exec { 'uninstall_tomcat': 
		path		=> $::path,
		cwd			=> "${pih_tomcat_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c set JAVA_HOME=${pih_java_home}&&service.bat remove",
		onlyif		=> "cmd.exe /c dir ${pih_tomcat_home}\\bin",
		logoutput	=> true,
	} -> 

	exec { 'remove_pih_tomcat_folder': 
		path		=> $::path,
		provider	=> windows, 
		command		=> "cmd.exe /c rd /S /Q ${pih_tomcat_home}",
		onlyif		=> "cmd.exe /c dir ${pih_tomcat_home}",
		logoutput	=> true,
	} -> 

	exec { 'remove_pih_java_folder': 
		path		=> $::path,
		provider	=> windows, 
		command		=> "cmd.exe /c rd /S /Q ${pih_java_home}",
		onlyif		=> "cmd.exe /c dir ${pih_java_home}",
		logoutput	=> true,
	} -> 
	
	file { $pih_icon:
		ensure  => file,
		source	=> "puppet:///modules/pih_folders/PIH_favicon_50px.ico",		
		require => File[$pih_home_bin],
	} -> 
	
	exec { 'remove_openmrs_startup_menu': 
		path		=> $::path,
		provider	=> windows, 
		command		=> "cmd.exe /c rd /S /Q ${openmrs_startup_menu}",
		onlyif		=> "cmd.exe /c dir ${openmrs_startup_menu}",
		logoutput	=> true,
	} -> 
	
	file { $openmrs_startup_menu:
		ensure  => directory,
		purge   => true,
		force   => true,
		recurse => true,
	} 
	
}