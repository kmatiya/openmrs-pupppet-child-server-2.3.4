class pih_java {
    
	require pih_folders
	
	$jdk_zip = "${jdk_zip}"
	$pih_java_zip = "${pih_home_bin}\\${jdk_zip}"
	
	file { $pih_java_home:
		ensure  => directory,
		require => File[$pih_home],
	}
	
	file { $pih_java_zip:
		ensure  => file,
		source	=> "puppet:///modules/pih_java/${jdk_zip}",		
		require => File[$pih_java_home],
	}
	
	windows::unzip { $pih_java_zip:
		destination => $pih_java_home,
		creates	=> "${pih_java_home}\\bin",
		require => File[$pih_java_home],
	} ->
	
	windows::environment { 'JAVA_HOME': 
		value	=>	$pih_java_home,
		notify	=> Class['windows::refresh_environment'],
	} -> 
	
	windows::path { "${pih_java_home}\\bin": } 

}