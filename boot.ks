// Revised Boot Script
// Sean Gordon

function notify {
  PARAMETER message.
  PARAMETER dT.
  HUDTEXT("kOS: " + message, dT, 2, 50, GREEN, FALSE).
}

function has_file {
        parameter n.
        list files in fs.
        for f in fs if f:name = n return 1.
        return 0.
}
{
	function assign_core_tagname {
		local n is "".
		until n:length = 14 {
			set n to n + (random() + ""):remove(0,2).
			if n:length > 14 set n to n:substring(0,14).	
		} 
		set core:part:tag to n.
		switch to 0.
		log "" to core:part:tag + ".update.ks".
		switch to 1.
	}

	function command_name {
		if core:part:tag = ""  assign_core_tagname(). 
		return core:part:tag + ".update.ks".	
	}

	function has_new_command {
		switch to 0.
		local result is has_file(command_name()).
		switch to 1.
		return result.
	}
	
	function fetch_and_run_new_cmd {
		copy command_name() from 0.
		log "" to tmp.exec.ks. delete tmp.exec.ks.
		rename command_name() to "tmp.exec.ks".
		run tmp.exec.ks.
	}

	// Bootup process
	if core:part:tag = ""  assign_core_tagname().	
	set ship:control:pilotmainthrottle to 0.
	if has_new_command() fetch_and_run_new_cmd().
	else if has_file("startup.ks") run startup.ks.
}
