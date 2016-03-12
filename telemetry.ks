// Telemetry Functions
// Sean Gordon

// Ships ∆V
FUNCTION TLM_DELTAV {
  LIST ENGINES in shipEngines.
  set dryMass to SHIP:MASS - ((SHIP:LIQUIDFUEL + SHIP:OXIDIZER) * 0.005).
  RETURN shipEngines[0]:ISP * 9.81 * LN(SHIP:MASS / dryMass).
}

// Time to impact
FUNCTION TLM_TTI {
  PARAMETER margin.

  LOCAL d is ALT:RADAR - margin.
  LOCAL v is -SHIP:VERTICALSPEED.
  LOCAL g is SHIP:BODY:MU / SHIP:BODY:RADIUS^2.

  RETURN (SQRT(v^2 + 2 * g * d) - v) / g.
}
