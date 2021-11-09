define pih_tomcat::start_tomcat {
	exec { $title: 
		path		=> $::path,
		cwd			=> "${pih_tomcat_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c set JAVA_HOME=${pih_java_home}&&net start Tomcat7",
		logoutput	=> true,
	}
	
}