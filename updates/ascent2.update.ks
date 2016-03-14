// Ascent Update Script 
// Sean Gordon
// Launch script using ascent.ks library
require("ascent.ks" ,0).

notify ("launch script initiated" ,5).
wait 5.
local n is 10.
until n < 0 {
  notify("Launching in " + n ,1).
  set n to n - 1.
  wait 1. 
}

set ascentProfile to list(
//MinAlt     Angle    Thrust"
  100,       88,      1,
  250,       86,      1,
  500,       84,      1,
  750,       82,      1,
  1000,      80,      1,
  1250,      78,      1,
  2000,      76,      1,
  2500,      74,      1,
  2750,      72,      1,
  3000,      70,      1,
  3500,      68,      1,
  4000,      64,      1,
  4500,      62,      1,
  5000,      60,      1, 
  6000,      58,      1,
  7000,      56,      1,
  8000,      54,      1,
  9000,      52,      1,
  10000,     50,      1,
  12000,     45,      1, 
).
