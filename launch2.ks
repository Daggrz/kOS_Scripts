// Launch Testing Script
// Sean Gordon

print "toggle rcs to launch".
wait until rcs.

lock throttle to 1.
loch steering to heading (90,90).
stage.

wait 5.

// Force a constant twr
lock g to body:mu / ((ship:altitude + body:radius)^2).
lock maxtwr tp ship:maxthrust / (g * ship:mass).
lock throttle to min(1.3 / maxtwr, 1).

// Linearly decrease pitch based on desired alititude
lock pitch to 90 - ((alt:radar / 100000)^0.5 * 90).
lock steering to heading(90 , pitch).

until 0 {wait 1.}
