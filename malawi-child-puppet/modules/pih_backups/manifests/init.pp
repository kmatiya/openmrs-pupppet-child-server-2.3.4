class pih_backups {
    
	require pih_mysql
	require openmrs
	
	
	$za_exe = '7za.exe'
	$za_exe_bin = "${pih_home_bin}\\${za_exe}"
	$mysql_backup_bat = 'mysqlbackup.bat'
	$mysql_backup_bat_bin = "${pih_home_bin}\\${mysql_backup_bat}"
	$schedule_mysql_backup_bat_bin = "${pih_home_bin}\\schedule_mysql_backup.bat"
	$pih_backups_home = "${pih_home}\\backups"

	$openmrs_db = hiera('openmrs_db')
	$openmrs_db_user = hiera('openmrs_db_user')
	$openmrs_db_password = hiera('openmrs_db_password')	
	
	$label_schedule_openmrs_backups = "Schedule OpenMRS backups"
	$schedule_openmrs_backups_lnk = "${openmrs_startup_menu}\\Schedule OpenMRS backups.lnk"
	$label_backup_openmrs_now = "Backup OpenMRS now"
	$backup_openmrs_now_lnk = "${openmrs_startup_menu}\\Backup OpenMRS now.lnk"
	
	file { $pih_backups_home:
		ensure  => directory,
		require => File[$pih_home],
	} ->
	
	file { $za_exe_bin:
		ensure  => file,
		source	=> "puppet:///modules/pih_backups/${za_exe}",		
		require => File[$pih_backups_home],
	} ->

	file { $mysql_backup_bat_bin:
		ensure  => present,
		provider => windows, 	
		content	=> template('pih_backups/mysqlbackup.bat.erb'),	
	} ->

	file { $schedule_mysql_backup_bat_bin:
		ensure  => present,
		provider => windows, 	
		content	=> template('pih_backups/schedule_mysql_backup.bat.erb'),	
	} ->		
	
	windows::shortcut { $backup_openmrs_now_lnk:
	  target      => $mysql_backup_bat_bin,
	  working_directory	=> "${pih_home_bin}", 
	  description => "${label_backup_openmrs_now}",
	} ->
	
	windows::shortcut { $schedule_openmrs_backups_lnk:
	  target      => $schedule_mysql_backup_bat_bin,
	  working_directory	=> "${pih_home_bin}", 
	  description => "${label_schedule_openmrs_backups}",
	} ->
	
	windows::path { "${pih_backups_home}": } 

}