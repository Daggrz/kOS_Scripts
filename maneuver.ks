// Maneuver Library
// Sean Gordon
// Library of functions for maneuver.

set burnoutCheck to "reset".
FUNCTION MNV_BURNOUT {
  PARAMETER autoStage.

  if burnoutCheck = "reset" {
    set burnoutCheck to MAXTHRUST.
    return FALSE.
  }

  IF burnoutCheck - MAXTHRUST > 10 {
    if sutoStage {
      set currentThrottle to THROTTLE.
      lock THROTTLE to 0.
      wait 1. STAGE. wait 1.
      lock THROTTLE to currentThrottle.
    }
    set burnoutCheck to "reset".
    return TRUE.
  }

  return FALSE.
}

//Time to complete a maneuver
FUNCTION MNV_TIME {
  PARAMETER dV.

  LIST ENGINES in en.

  local f is en[0]:MAXTHRUST * 1000.
  local m is SHIP:MASS * 1000.
  local e is CONSTANT():E.
  local p is en[0]:ISP.
  local g is 9.82.

  return g * m * p (1 - e^(-dV/(g*p))) / f.
}

// Delta V requirements for Hohmann Transfer
FUNCTION MNV_HOHMANN_DV {
  PARAMETER desireAltitude.

  set u to SHIP:OBT:BODY:MU.
  set r1 to SHIP:OBT:SEMIMAJORAXIS.
  set r2 to desiredAltitude + SHIP:BODY:OBT:RADIUS.

  // v2
  set v1 to SQRT(u / r1) * (SQRT((2 * r2) / (r1 + r2)) - 1).

  // v2
  set v2 to SQRT(u / r2) * (1 - SQRT((2 * r1) / (r1 + r2))).

  return LIST(v1 , v2).
}

// Execute the next node
FUNCTION MNV_EXEC_NODE {
  PARAMETER autoWarp.  
  local n is NEXTNODE.
  local v is n:BURNVECTOR.

  local startTime it TIME:SECONDS + n:ETA - MNV_TIME(v:MAG)/2.
  lock STEERING to n:BURNVECTOR.

  if autoWarp { WARPTO(startTime - 30). }

  wait until TIME:SECONDS >= startTime.
  lock THROTTLE to MIN(MNV_TIME(n:BURNVECTOR:MAG), 1).
  wait until VDOT(n:BURNVECTOR, v) < 0.
  lock THROTTLE to 0.
  UNlock STEERING.  
}
