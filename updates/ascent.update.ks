// Launch Update Script
// Sean Gordon

download("launch.ks").

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
    FALSE   // Extra ∆V in Launch Stage
).

delete launch.ks.
notify("Launch Complete", 5).
