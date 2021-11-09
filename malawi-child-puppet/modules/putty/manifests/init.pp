class putty {
    
	$putty_zip = 'putty.zip'
	
	$pih_putty_zip = "${pih_home_bin}\\${putty_zip}"
	
	file { $pih_putty_home:
		ensure  => directory,
		require => File[$pih_home],
	}
	
	file { $pih_putty_zip:
		ensure  => file,
		source	=> "puppet:///modules/putty/${putty_zip}",		
		require => File[$pih_putty_home],
	}
	
	windows::unzip { $pih_putty_zip:
		destination => $pih_putty_home,
		creates	=> "${pih_putty_home}\\plink.exe",
		require => File[$pih_putty_zip],
	} ->
	
	windows::path { "${pih_putty_home}": } 

}