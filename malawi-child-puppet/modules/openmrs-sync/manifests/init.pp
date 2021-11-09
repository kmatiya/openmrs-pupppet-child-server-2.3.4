class openmrs-sync {
    
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
	
	$openmrs_create_db_sql = "${pih_openmrs_db}dropAndCreateDb.sql"
	$delete_sync_tables_sql = "${pih_openmrs_db}deleteSyncTables.sql"
	$get_db_from_parent_bat = "${pih_openmrs_db}getDbFromParent.bat"
	$check_For_Unsynced_Records_bat = "${pih_openmrs_db}checkForUnsyncedRecords.bat"
	$remove_changeloglock_bat = "${pih_openmrs_db}remove_changeloglock.bat"
	$remove_unsynced_changes_bat = "${pih_openmrs_db}remove_unsynced_changes.bat"
	$prepare_child_server_bat = "${pih_openmrs_db}prepare_child_server.bat"
	$register_Child_With_Parent_bat = "${pih_openmrs_db}registerChildWithParent.bat"
	
	$stop_OpenMRS_bat = "${pih_openmrs_home}stopOpenMRS.bat"
	$start_OpenMRS_bat = "${pih_openmrs_home}startOpenMRS.bat"
	$refresh_ic3_app_bat = "${pih_openmrs_home}refreshIC3App.bat"
	$label_refresh_ic3 = hiera('label_refresh_ic3_screening_app')
    $refresh_ic3_lnk = "${openmrs_startup_menu}\\Refresh IC3 App.lnk"
	$ic3_app_artifact= hiera('ic3_app_artifact')
	$artifacts_url= hiera('artifacts_url')
	$artifacts_modules_url= hiera('artifacts_modules_url')
	
	$download_db= hiera('download_db')
	
	$refresh_openmrs_app_bat = "${pih_openmrs_db}refreshOpenMRSApp.bat"
    $label_refresh_openmrs_app = hiera('label_refresh_openmrs_app')
    $refresh_openmrs_app_lnk = "${openmrs_startup_menu}\\Refresh OpenMRS App.lnk"
	
	$download_modules_from_test_server_bat = "${pih_openmrs_home}getOmrsModulesFromTestServer.bat"
	$label_download_modules_from_test_server = hiera('label_download_modules_from_test')
    $download_modules_from_test_lnk = "${openmrs_startup_menu}\\Download OpenMRS Modules from test server.lnk"
  
	$label_shutdown_openmrs = hiera('label_shutdown_openmrs')
	$shutdown_openmrs_lnk = "${openmrs_startup_menu}\\Shutdown OpenMRS.lnk"
	$label_start_openmrs = hiera('label_start_openmrs')
	$start_openmrs_lnk = "${openmrs_startup_menu}\\Start OpenMRS.lnk"
	$check_for_unsynced_records_lnk = "${openmrs_startup_menu}\\Check for Unsynced records.lnk"
	$label_check_for_unsynced_records = hiera('label_check_for_unsynced_records')
	$label_prepare_child_server = hiera('label_prepare_child_server')
	$prepare_child_server_lnk = "${openmrs_startup_menu}\\Prepare Child Server.lnk"
	
	$label_remove_changelock = hiera('label_remove_changelock')
	$remove_changeloglock_lnk = "${openmrs_startup_menu}\\Remove Changelock.lnk"
	$label_unsynced_changes = hiera('label_unsynced_changes')
	$remove_unsynced_changes_lnk = "${openmrs_startup_menu}\\Remove Unsynced Changes.lnk"
	
	$label_register_child_with_parent = hiera('label_register_child_with_parent')
	$register_child_with_parent_lnk = "${openmrs_startup_menu}\\Register Child with Parent.lnk"
	
	$update_child_server_settings_sql = "${pih_openmrs_db}updateChildServerSettings.sql"
	$update_parent_server_settings_sql = "${pih_openmrs_db}updateParentServerSettings.sql"
	
	$mysql_root_user = hiera('mysql_root_user')
	$mysql_root_password = hiera('mysql_root_password')
	$openmrs_db = hiera('openmrs_db')
	$openmrs_db_user = hiera('openmrs_db_user')
	$openmrs_db_password = hiera('openmrs_db_password')	
	
	$parent_mysql_db_password = hiera('parent_mysql_db_password')
	$ssh_parent_address = hiera('ssh_parent_address')
	$ssh_user = hiera('ssh_user')
	$ssh_port = hiera('ssh_port')
	$ssh_key = "${pih_putty_home}\\id_rsa"
	$plink_exe = "${pih_putty_home}\\PLINK.EXE"
	$pscp_exe = "${pih_putty_home}\\PSCP.EXE"
	$gzip_exe = "${pih_gzip_home}\\bin\\gzip"
	
	$pih_openmrs_modules_zip = "${pih_home_bin}\\openmrs-modules.zip"
	$pih_openmrs_war = "${pih_tomcat_home}\\webapps\\openmrs.war"
	$pih_openmrs_workflow = "${pih_tomcat_home}\\webapps\\workflow\\"
	$pih_openmrs_runtime_properties = "${pih_openmrs_home}openmrs-runtime.properties"
	
	$child_name = $hostname
	$sync_admin_email = hiera('sync_admin_email')
	$sync_parent_name = hiera('sync_parent_name')
	$sync_parent_address = hiera('sync_parent_address')
	$sync_parent_uuid = hiera('sync_parent_uuid')
	$sync_parent_user_name = hiera('sync_parent_user_name')
	$sync_parent_user_password = hiera('sync_parent_user_password')
	
	$server_uuid_text_file = "${pih_openmrs_db}${child_name}-serveruuid.txt"
	$output_server_uuid = regsubst($server_uuid_text_file, '[\\]', '/', G)
	$uploaded_child_server_uuid = "/tmp/${child_name}-serveruuid.txt"
	
	$puppet_install_home = hiera('puppet_install_home')
	$label_reset_openmrs = "Reset OpenMRS"
	$reset_openmrs_lnk = "${openmrs_startup_menu}\\Reset OpenMRS.lnk"
	$install_bat = "${puppet_install_home}\\install.bat"
	
	notify{"The value of uploaded_child_server_uuid is ${uploaded_child_server_uuid}": }
	
	file { $pih_openmrs_home:
		ensure  => directory,
		require => File[$pih_home],
	} ->
	
	file { $pih_openmrs_db:
		ensure  => directory,
	} ->

	file { $pih_openmrs_modules:
		ensure  => directory,
	} ->
	
	file { $openmrs_create_db_sql: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs-sync/dropAndCreateDb.sql.erb'),	
	} ->
	
	file { $delete_sync_tables_sql: 
		ensure  => present,
		provider => windows, 	
		source	=> "puppet:///modules/openmrs-sync/deleteSyncTables.sql",
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

	file { $refresh_ic3_app_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs-sync/refresh_ic3_app.bat.erb'),	
	} -> 

	windows::shortcut { $refresh_ic3_lnk:
	  target      => $refresh_ic3_app_bat,
	  working_directory	=> "${pih_openmrs_home}", 
	  description => "${label_start_openmrs}",
	} ->			
	
	file { $download_modules_from_test_server_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs-sync/getOmrsModulesFromTestServer.bat.erb'),	
	} -> 

	windows::shortcut { $download_modules_from_test_lnk:
	  target      => $download_modules_from_test_server_bat,
	  working_directory	=> "${pih_openmrs_home}", 
	  description => "${label_download_modules_from_test_server}",
	} ->	
	
	windows::shortcut { $reset_openmrs_lnk:
	  target      => $install_bat,
	  working_directory	=> "${puppet_install_home}", 
	  description => "${label_reset_openmrs}",
	} ->
	
	file { $update_child_server_settings_sql: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs-sync/updateChildServerSettings.sql.erb'),	
	} ->
	
	file { $update_parent_server_settings_sql: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs-sync/updateParentServerSettings.sql.erb'),		
	} ->
	
	file { $get_db_from_parent_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs-sync/getDbFromParent.bat.erb'),	
	} ->
	
	file { $refresh_openmrs_app_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs-sync/refreshOpenMRSApp.bat.erb'),	
	} ->

    windows::shortcut { $refresh_openmrs_app_lnk:
	  target      => $refresh_openmrs_app_bat,
	  working_directory	=> "${pih_openmrs_db}", 
	  description => "${label_refresh_openmrs_app}",
	} ->
	
	file { $prepare_child_server_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs-sync/prepare_child_server.bat.erb'),	
	} ->

	windows::shortcut { $prepare_child_server_lnk:
	  target      => $prepare_child_server_bat,
	  working_directory	=> "${pih_openmrs_db}", 
	  description => "${label_prepare_child_server}",
	} ->
	
	file { $check_For_Unsynced_Records_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs-sync/checkForUnsyncedRecords.bat.erb'),	
	} ->

	windows::shortcut { $check_for_unsynced_records_lnk:
	  target      => $check_For_Unsynced_Records_bat,
	  working_directory	=> "${pih_openmrs_db}", 
	  description => "${label_check_for_unsynced_records}",
	} ->
	
	file { $remove_changeloglock_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs-sync/remove_changeloglock.bat.erb'),	
	} ->

	windows::shortcut { $remove_changeloglock_lnk:
	  target      => $remove_changeloglock_bat,
	  working_directory	=> "${pih_openmrs_db}", 
	  description => "${label_remove_changelock}",
	} ->

	file { $remove_unsynced_changes_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs-sync/remove_unsynced_changes.bat.erb'),	
	} ->
	
	windows::shortcut { $remove_unsynced_changes_lnk:
	  target      => $remove_unsynced_changes_bat,
	  working_directory	=> "${pih_openmrs_db}", 
	  description => "${label_unsynced_changes}",
	} ->

	file { $register_Child_With_Parent_bat: 
		ensure  => present,
		provider => windows, 	
		content	=> template('openmrs-sync/registerChildWithParent.bat.erb'),	
	} ->	

	windows::shortcut { $register_child_with_parent_lnk:
	  target      => $register_Child_With_Parent_bat,
	  working_directory	=> "${pih_openmrs_db}", 
	  description => "${label_register_child_with_parent}",
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

	exec { 'execute_get_parent_db': 
		path		=> $::path,
		cwd			=> "${pih_openmrs_db}", 
		provider	=> windows, 
		timeout		=> 0, 
		command		=> "cmd.exe /c ${get_db_from_parent_bat}",
		logoutput	=> true,
		
	}

}