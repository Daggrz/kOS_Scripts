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
      LOCK THROTTLE  to 0.
      WAIT 1. STAGE. WAIT 1.
      LOCK THROTTLE to currentThrottle.
      set prevThrust to MAXTHRUST.
    }

    if ALTITUDE > minAlt {
      LOCK STEERING to HEADING(direction, newAngle).
      LOCK THROTTLE to newThrust.
      BREAK.
    }

    WAIT 0.1.
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
