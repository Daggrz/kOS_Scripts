// Rendezvous Library
// Sean Gordon
// Library of functions for maneuver.

FUNCTION RDV_STEER {
  PARAMETER vector.

  LOCK STEERING to vector.
  WAIT UNTIL VANG(SHIP:FACING:FOREVECTOR, vector) < 2.
}

FUNCTION RDV_APPROACH {
  PARAMETER craft, speed.

  LOCK relativeVelocity to craft:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT.
  RDV_STEER(craft:POSITION). LOCK STEERING to craft:POSITION.

  LOCK maxAccel to SHIP:MAXTHRUST / SHIP:MASS.
  LOCK THROTTLE to MIN(1, ABS(speed - relativeVelocity:MAG) / maxAccel).

  WAIT UNTIL relativeVelocity:MAG > speed - 0.1.
  LOCK THROTTLE to 0.
  LOCK STEERING to relativeVelocity.
}

FUNCTION RDV_CANCEL {
  PARAMETER craft.

  LOCK relativeVelocity to craft:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT.
  RDV_STEER(relativeVelocity). LOCK STEERING to relativeVelocity.

  LOCK maxAccel to SHIP:MAXTHRUST / SHIP:MASS.
  LOCK THOTTLE TO MIN(1, relativeVelocity:MAG / maxAccel).

  WAIT UNTIL relativeVelocity:MAG < 0.1.
  LOCK THROTTLE to 0.
}

FUNCTION RDV_AWAIT_NEAREST {
  PARAMETER craft, minDistance.

  UNTIL 0 {
    set lastDistance to craft:DISTANCE.
    WAIT 0.5.
    if craft:DISTANCE > lastDistance or craft:DISTANCE < minDistance { BREAK. }
  }
}
