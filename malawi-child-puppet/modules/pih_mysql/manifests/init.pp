class pih_mysql {
    
	require pih_java
	
	if $architecture == 'x64' { 
		$mysql_zip = 'mysql-5.6.16-winx64-min.zip'
	} else {
		$mysql_zip = 'mysql-5.6.16-win32-min.zip'
	}
	
	$pih_mysql_zip = "${pih_home_bin}\\${mysql_zip}"
	
	$pih_mysql_ini = "${pih_home}\\mysql\\my.ini"
	$pih_mysql_data = "${pih_home}\\mysql\\data\\"
	$pih_mysql_RootPassword = "${pih_home}\\mysql\\updateRootPassword.sql"
	$pih_mysql_init_password = "${pih_home}\\mysql\\mysql-init.ini"
	
	$mysql_root_password = hiera('mysql_root_password')
	
	file { $pih_mysql_home:
		ensure  => directory,
		require => File[$pih_home],
	} ->
	
	file { $pih_mysql_zip:
		ensure  => file,
		source	=> "puppet:///modules/pih_mysql/${mysql_zip}",		
		require => File[$pih_mysql_home],
	} ->
	
	windows::unzip { $pih_mysql_zip:
		destination => $pih_mysql_home,
		creates	=> "${pih_mysql_home}\\bin",
		require => File[$pih_mysql_home],
	} ->
	
	file { $pih_mysql_ini: 
		ensure  => present,
		provider => windows, 	
		content	=> template('pih_mysql/my.ini.erb'),	
	} ->
	
	windows::path { "${pih_mysql_home}\\bin": } -> 
	
	exec { 'stop_mysql': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c net stop mysql",
		onlyif		=> "cmd.exe /c sc query mysql",
		unless		=> "cmd.exe /c sc query mysql | find \"STOPPED\"",
		logoutput	=> true, 
		returns		=> [0, 1, 2],
	} -> 
	
	exec { 'remove_mysql': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c mysqld --remove",
		onlyif		=> "cmd.exe /c sc query mysql",
		logoutput	=> true,
	} -> 
	
	exec { 'install_mysql': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c mysqld --install",
		logoutput	=> true,
	} -> 
	
	exec { 'start_mysql': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c sc start mysql",
		logoutput	=> true,
	} ->

	file { $pih_mysql_init_password: 
		ensure  => present,
		provider => windows, 	
		content	=> template('pih_mysql/mysql-init.txt.erb'),	
	} ->
	
	exec { 'stop_mysql_server': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c net stop mysql",
		onlyif		=> "cmd.exe /c sc query mysql",
		unless		=> "cmd.exe /c sc query mysql | find \"STOPPED\"",
		logoutput	=> true, 
		returns		=> [0, 1, 2],
	} -> 
	
	exec { 'reset_mysql_root_password': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c start /b mysqld.exe --console --init-file=${pih_mysql_init_password}",
		logoutput	=> true,
		returns		=> [0, 1, 2],
	} ->
	
	exec { 'mysqladmin_stop': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c mysqladmin.exe -u root -p${mysql_root_password} shutdown&&ping -w 1000 -n 5 127.0.0.1",
		logoutput	=> true,
		returns		=> [0, 1, 2],
	} ->
	
	exec { 'start_mysql_server': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c sc start mysql",
		logoutput	=> true,
		returns		=> [0, 1, 2],
	} ->
	
	exec { 'remove_mysql_init_password': 
		path		=> $::path,
		cwd			=> "${pih_mysql_home}", 
		provider	=> windows, 
		timeout		=> 0, 
		command		=> "cmd.exe /c del /F /Q ${pih_mysql_init_password}",
		logoutput	=> true,
	}
	
}