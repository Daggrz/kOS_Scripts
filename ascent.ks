// Excecute Ascent Profile
// Sean Gordon

FUNCTION EXECUTE_ASCENT_STEP {
  PARAMETER direction.
  PARAMETER minAlt.
  PARAMETER newAngle.
  PARAMETER newThrust.

  set prevThrust to MAXTHRUST.

  UNTIL FALSE {
    if MAXTHRUST < (prevThrust - 10) {
      set currentThrottle to THROTTLE.
      lock THROTTLE  to 0.
      wait 1. stage. wait 1.
      lock THROTTLE to currentThrottle.
      set prevThrust to MAXTHRUST.
    }

    if ALTITUDE > minAlt {
      lock STEERING to HEADING(direction, newAngle).
      lock THROTTLE to newThrust.
      break.
    }

    wait 0.1.
  }
}

FUNCTION EXECUTE_ASCENT_PROFILE {
  PARAMETER direction.
  PARAMETER profile.

  set step to 0.
  UNTIL step >= profile:length - 1 {
    EXECUTE_ASCENT_STEP(
      direction,
      profile[step],
      profile[step+1],
      profile[step+2]
    ).
    set step to step + 3.
  }
}
