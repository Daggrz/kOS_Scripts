// Minmus Lander
// Sean Gordon

function main {
        perform_ascent()
        perform_circularization().
        transfer_to(Minmus).
        perform_powered_descent().
        gather_science().
        perform_ascent().
        perform_circularization().
        transfer_to(Kerbin).
        perform_unpowered_descent().
}

function perform_ascent {
  //TODO 
}

function perform_circularization {
  wait until eta:apoapsis < 20.
  lock steering to prograde.
  lock throttle to 1.
  wait until obt:eccentricity < 0.1.
  lock throttle to 0.
}

function transfer_to {
  parameter body.
  //TODO
}
function perform_powered_descent {

}

function gather_science {
  //TODO 
}

function perform_circularization {
  //TODO 
}

function perform_unpowered_descent {
  //TODO 
}

main().
