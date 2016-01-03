// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)torus_uv.pov
// Description: torus object uv-mapping demonstration scene
// Features demonstrated: torus object uv-mapping
// Creation Date: $ 14 Jun 2004, 16:21:30 $
// Last modified: $ 14 Jun 2004, 22:42:35 $
// Author: Wlodzimierz ABX Skiba
//
// @@ NOTE: this feature is now included in POV-Ray 3.6
//
// -w320 -h240 +a0.3

#version 3.6;

#declare minor=1/3;
#declare major=minor*3;

torus{
  major minor
  uv_mapping
  pigment{checker rgb 0 rgb 1 scale .1}
  rotate x*90
  rotate y*45
  translate 3*z*major
}

light_source{-9-9*z 1}
background{1}
camera{up y right x}