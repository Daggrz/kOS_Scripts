// Launch Script
// Sean Gordon

parameter targetApoapsis.
parameter targetPeriapsis.
parameter targetHeading.
parameter fairings.
parameter extraDV.
parameter halfstage.

set targetRoll to R(0,0,180).
set sw to true.
set runmode to 2. // Insurance incase the script starts in the air.

if SHIP:ALTITUDE < 100 {
  set runmode to 1.
}

until runmode = 0 {
  if runmode = 1 {
    lock STEERING to HEADING(90,90) + R(0,0,270).
    set TVAL to 1.
    notify("Engine Ignition", 2).
    wait 2.
    stage.
    notify("Liftoff of the " + SHIP:NAME + ".", 4).
    set runmode to 2.
  } else if runmode = 2 {
    if SHIP:ALTITUDE > 250 {
      lock STEERING to HEADING(90,90) + targetRoll.
      if SHIP:ALTITUDE > 1000 {
        set runmode to  3.
      }
    }
  } else if runmode = 3 {
    set targetPitch to MAX(5, 90 * (1 - ALT:RADAR/50000)).
    lock STEERING to HEADING(targetHeading,targetPitch) + targetRoll.
    if SHIP:APOAPSIS > targetApoapsis * 0.9 {
      set TVAL to 0.33.
      RCS ON.
      if SHIP:APOAPSIS > targetApoapsis {
        set runmode to 4.
      }
    }
  } else if runmode = 4 {
    lock STEERING to PROGRADE.
    set TVAL to 0.
    if (SHIP:ALTITUDE > 70000) and (ETA:APOAPSIS > 90) and (VERTICALSPEED > 0)     {
      if WARP = 0 {
        wait 1.
        set WARP to 3.
      }
    } else if SHIP:APOAPSIS < 60 {
      set WARP to 0.
      lock STEERING to PROGRADE.
      set runmode to 5.
    }
  } else if runmode = 5 {
    if ETA:APOAPSIS < 15 and sw or VERTICALSPEED < 0 {
      set TVAL to 1.
      set sw to false.
    } else if ETA:APOAPSIS > 20 and not sw {
      set TVAL to 0.33.
    } else if ETA:APOAPSIS > 30 and not sw {
      set TVAL to 0.
      set sw to true.
    }
    if (SHIP:PERIAPSIS > targetPeriapsis) or (SHIP:PERIAPSIS > targetApoapsis * 0.98) or (SHIP:APOAPSIS > targetApoapsis * 1.25) {
      set TVAL to 0.
      set runmode to 10.
    }
  } else if runmode = 6 {
    set THROTTLE to 0.
    stage.
    wait 1.
    stage.
    set runmode to 5.
  } else if runmode = 10 {
    panels on.
    lights on.
    SAS ON.
    unlock STEERING.
    notify("Launch Sequence Completed", 5).
    set runmode to 0.
  }

  set engFO to 0.
  set engIG to 0.
  list engines in enginelist.
  for eng in enginelist {
    if eng:flameout {
      set engFO to engFO + 1.
    }
    if eng:ignition {
      set engIG to engIG + 1.
    }
  }
  if engIG > engFO AND engFO > 0 {
    stage.
  } else if engIG = engFO {
    stage.
    wait 2.
    stage.
  }

  if fairings {
    if SHIP:ALTITUDE > 35000 {
      stage.
      set fairings to false.
    }
  }

  if extraDV {
    if SHIP:PERIAPSIS > 35000 {
      set runmode to 6.
      set extraDV to false.
    }
  }

  if halfStage {
    if SHIP:ALTITUDE > 10000 {
      stage.
      set halfStage to false.
    } 
  }
  notify("Runmode: " + runmode , 1).
  set finalTVAL to TVAL.
  lock THROTTLE to finalTVAL.
}
