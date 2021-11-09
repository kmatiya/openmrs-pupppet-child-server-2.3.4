class cwrsync {
    
	$cwrsync_zip = 'cwRsync.zip'
	
	$pih_cwrsync_zip = "${pih_home_bin}\\${cwrsync_zip}"
	
	file { $pih_cwrsync_home:
		ensure  => directory,
		require => File[$pih_home],
	} ->
	
	file { $pih_cwrsync_zip:
		ensure  => file,
		source	=> "puppet:///modules/cwrsync/${cwrsync_zip}",		
		require => File[$pih_cwrsync_home],
	} ->
	
	windows::unzip { $pih_cwrsync_zip:
		destination => $pih_cwrsync_home,
		creates	=> "${pih_putty_home}\\rsync.exe",
		require => File[$pih_cwrsync_zip],
	} ->

	windows::environment { 'HOME': 
		value	=>	$pih_cwrsync_home,
		require => File[$pih_cwrsync_home],
		target  => 'User',
		notify	=> Class['windows::refresh_environment'],
	}  -> 
	
	windows::path { "${pih_cwrsync_home}": } 

}