// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)parametric.pov
// Description: parametric object uv-mapping demonstration scene
// Features demonstrated: parametric object uv-mapping
// Creation Date: $ 14 Jun 2004, 16:21:30 $
// Last modified: $ 14 Jun 2004, 22:40:08 $
// Author: Wlodzimierz ABX Skiba
//
// @@ Parametric object already operates on uv coordinates but for 
// @@ some reason this space is not available for mapping textures on 
// @@ it. Here is comparision what uv_mapping gives for simple twisted tape.
// @@ NOTE: this feature is now included in POV-Ray 3.6
//
// -w320 -h240 +a0.3

#version 3.6;

#declare minor=3;
#declare major=9;
#declare rotor=5;
#declare Corner=(major*<1,1,0>)+minor;

parametric{
  function{sin(2*u)*(cos(rotor*u)*v+major)}
  function{cos(2*u)*(cos(rotor*u)*v+major)}
  function{sin(rotor*u)*v}
  <0,-minor><pi,minor>
  contained_by{box{-Corner Corner}}
  precompute 18,x,y,z
  uv_mapping
  pigment{checker rgb 0 rgb 1}
  translate 3*z*major
}

light_source{-9-9*z 1}
background{1}
camera{up y right x}
