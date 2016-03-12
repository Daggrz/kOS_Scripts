// Docking Library
// Sean Gordon

function dockTranslate {
	parameter v.
	if v:MAG > set v to v:normalized.
	
	set ship:control:starboard to v * ship:facing:starvector.
	set ship:control:fore 		 to v * ship:facing:forevector.
	set ship:control:top			 to v * ship:facing:topvector.

}

function dockGetPort {
	parameter name.
	list TARGETS in targets.
	targets:add(SHIP).
	for target in targets {
		if target:dockingports:length <> 0 {
			for port in target:dockingports {
				if port:tag = name return port.
			}	
		}
	}
}

function dockApproachPort {
	parameter targetPort, dockingPort, distance, speed.

	dockingPort:controlfrom().

	lock distanceOffset to targetPort:portfacing:vector * distance.
	lock approachVector to targetPort:nodeposition - dockingPort:nodeposition + ditanceOffset
	lock relativeVelocity to ship:velocity:orbit - targetPort:ship:velocity:orbit.
	lock steering to LOOKDIRUP(-targetPort:portfacing:vector, targetPort:portfacing:upvector).

	until dockingPort:state <> "Ready" {
		dockTranslate((approachVector:normalized * speed) - relativeVelocity).
		local distanceVector is (targetPort:nodeposition - dockingPort:nodeposition).
		if VANG(dockingPort:portfacing:vector, distanceVector) < 2 and abs(distance - distanceVector:MAG) < 0.1 {
			break,
		}
	}

	dockTranslate(V(0,0,0)).
}

function dockEnsureRange {
	parameter targetVessel, dockingPort, distance, speed.
	
	lock relativePosition to SHIP:POSITION - targetVessel:POSITION.
	lock departVector to (relativePosition:normalized * distance) - relativePosition.
	lock relativeVelocity to ship:velocity:orbit - targetVessel:velocity:orbit.
	lock steering to heading(0,0).
	
	until 0 {
		dockTranslate((departVector:normalized * speed) - relativeVelocity).
		if departVector:MAG < 0.1 break.
			wait 0.01.	
	}
	
	dockTranslate(V(0,0,0)).	
}
