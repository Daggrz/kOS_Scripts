// Boot Script
// Sean Gordon
// Generalized boot script for all probes.

set SHIP:CONTROL:PILOTMAINTHROTTLE to 0.

//Display a message
function NOTIFY {
  PARAMETER message.
  PARAMETER dT.
  HUDTEXT("kOS: " + message, dT, 2, 50, GREEN, FALSE).
}

// Detect wether a file exists on a specific volume
function HAS_FILE {
  PARAMETER name.
  PARAMETER vol.

  SWITCH to vol.
  LIST FILES in allFiles.
  for file in allFiles {
    if file:NAME = name{
      switch to 1.
      RETURN TRUE.
    }
  }

  SWITCH to 1.
  RETURN FALSE.
}

// First-pass at artificial delay.
function DELAY {
  set dTime to ADDONS:RT:DELAY(SHIP) * 3.
  set accTime to 0.

  UNTIL accTime >= dTime {
    set start to TIME:SECONDS.
    WAIT UNTIL (TIME:SECONDS - start) > (dTime - accTime) or not ADDONS:RT:HASCONNECTION(SHIP).
    set accTime to accTime + TIME:SECONDS - start.
  }
}

// Get a file from KSC
function DOWNLOAD {
  PARAMETER name.

  DELAY().
  if HAS_FILE(name, 1) {
    DELETE name.
  }
  if HAS_FILE(name, 0) {
    COPY name FROM 0.
  }
}

// Push a file to KSC
function UPLOAD {
  PARAMETER name.

  DELAY().
  if HAS_FILE(name, 0) {
    SWITCH to 0. DELETE name. SWITCH to 1.
  }
  if HAS_FILE(name, 1) {
    COPY name to 0.
  }
}

// Run libray, downloading it from KSC if necessary
function REQUIRE {
  PARAMETER name.

  if not HAS_FILE(name, 1) { DELAY(). DOWNLOAD(name). }
  RENAME name to "tmp.exec.ks".
  run tmp.exec.ks.
  RENAME "tmp.exec.ks" to name.
}

// The Boot Process
set updateScript to SHIP:NAME + ".update.ks".

// If we have a connection, see if there are new instructions.
// If so, download and run them.
if ADDONS:RT:HASCONNECTION(SHIP) {
  if HAS_FILE(updateScript, 0) {
    DOWNLOAD(updateScript).
    SWITCH to 0. DELETE updateScript. SWITCH to 1.
    if HAS_FILE("update.ks", 1) {
      DELETE update.ks.
    }
    RENAME updateScript to "update.ks".
    run update.ks.
    DELETE update.ks.
  }
}

// If a startup.ks file exists on the disk, run that.
if HAS_FILE("startup.ks", 1) {
  run startup.ks.
}

WAIT UNTIL ADDONS:RT:HASCONNECTION(SHIP).
WAIT 10.
REBOOT.
