// Excecute Ascent Profile
// Sean Gordon

function execute_ascent_step {
  parameter direction.
  parameter minAlt.
  parameter newAngle.
  parameter newThrust.

  set prevThrust to MAXTHRUST.

  until false {
    if MAXTHRUST < (prevThrust - 10) {
      set currentThrottle to THROTTLE.
      lock THROTTLE  to 0.
      wait 1. stage. wait 1.
      lock THROTTLE to currentThrottle.
      set prevThrust to MAXTHRUST.
    }

    if ALTITUDE > minAlt {
      lock steering to heading(direction, newAngle).
      lock throttle to newThrust.
      break.
    }

    wait 0.1.
  }
}

function execute_ascent_profile {
  parameter direction.
  parameter profile.

  set step to 0.
  until step >= profile:length - 1 {
    execute_ascent_step(
      direction,
      profile[step],
      profile[step+1],
      profile[step+2]
    ).
    set step to step + 3.
  }
}
