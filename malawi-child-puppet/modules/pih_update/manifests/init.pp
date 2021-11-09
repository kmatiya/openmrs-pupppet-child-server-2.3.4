class pih_update {
    
	require pih_java
	require pih_tomcat
	require pih_mysql
	require gzip 
	require putty 
	require cwrsync
	
	$pih_update_home = "${pih_home}\\update\\"
	$pih_update_home_openmrs= "${pih_update_home}openmrs"	
	$array_tmp= split($pih_update_home_openmrs, '[:\\]')
	$join_tmp = join($array_tmp,"/")
	notify{"join_tmp= ${join_tmp}": }
	$pih_update_home_openmrs_linux = "/cygdrive/${join_tmp}"
	notify{"pih_update_home_openmrs_linux= ${pih_update_home_openmrs_linux}": }
	$pih_openmrs_update_bat = "${pih_update_home}update-openmrs.bat"
	
	$ssh_parent_address = hiera('ssh_parent_address')
	$ssh_user = hiera('ssh_user')
	$ssh_port = hiera('ssh_port')
	$release_repository = hiera('release_repository')
	$ssh_key = "${pih_cwrsync_home}\\cwrsync"
	$pscp_exe = "${pih_putty_home}\\PSCP.EXE"
	
	$label_check_for_openmrs_updates = hiera('label_check_for_openmrs_updates')
	$check_for_openmrs_updates_lnk = "${openmrs_startup_menu}\\Check for OpenMRS updates.lnk"
	
	file { $pih_update_home:
		ensure  => directory,
	} -> 
	
	file { $pih_openmrs_update_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('pih_update/update-openmrs.bat.erb'),	
	} -> 
	
	windows::shortcut { $check_for_openmrs_updates_lnk:
	  target      => $pih_openmrs_update_bat,
	  working_directory	=> "${pih_update_home}", 
	  description => "${label_check_for_openmrs_updates}",
	} 
}