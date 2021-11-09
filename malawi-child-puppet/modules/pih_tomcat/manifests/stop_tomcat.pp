define pih_tomcat::stop_tomcat {
	exec { $title: 
		path		=> $::path,
		cwd			=> "${pih_tomcat_home}\\bin", 
		provider	=> windows, 
		command		=> "cmd.exe /c set JAVA_HOME=${pih_java_home}&&net stop Tomcat7",
		logoutput	=> true,
	}
	
}