// Launch Update Script
// Sean Gordon

copy launch.ks from 0.

notify("Begining launch sequence.", 1).

set n to 10.
until n < 0 {
  notify("Launching in " + n + " seconds.", 1).
  wait 1.
  set n to n - 1.
}

run launch.ks(
    75000,  // Target Apoapsis
    75000,  // Target Periapsis
    90,     // Target Heading
    FALSE,  // Fairings
    FALSE,  // Extra Delta V in Launch Stage
    FALSE   // Half Stage
).

delete launch.ks.
