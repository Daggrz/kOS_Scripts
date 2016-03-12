// General Execute Node Script
// Sean Gordon

run maneuver.ks.

notify("Maneuver autopilot initiated", 3).
wait 3.
notify("RCS: Execute Maneuver. Brakes: Done", 5).

set done to false.
on BRAKES { set done to true. }

set rcsState to RCS.
until done {
	if RCS <> rcsState {
		notify("Executing maneuver...").
		MNV_EXEC_NODE(true).
		notify("Done").
	}
	wait 0.1.
}

notify("Manuver Completed" , 5).
