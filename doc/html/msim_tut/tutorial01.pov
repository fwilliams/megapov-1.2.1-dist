// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)tutorial01.pov
// Desciption: mechanics simulation tutorial scene 1
// Creation Date: $ 07 Oct 2002, 12:38:51 $
// Last modified: $ 23 Feb 2005, 21:02:26 $
// Author: chris_hormann@gmx.de
//
//
// -w320 -h240 +a0.3

#version 3.5;

global_settings {
  assumed_gamma 1.0
}

// ----------------------------------------

camera {
  location  <-6.0, -16.0, 1.6>*0.6
  up z
  sky z
  look_at   <0.0, 0.0, 0.2>
  angle 30
}

light_source {
  <2000, -3000, 2700>
  color rgb <1.7, 1.5, 1.2>
}

sky_sphere {
  pigment {
    gradient z
    color_map {
      [0.0 rgb <0.6,0.7,1.0>]
      [0.2 rgb <0.2,0.3,0.9>]
    }
  }
}

// ----------------------------------------

#declare T_Env=
  texture {
    pigment { color rgb 1.5 }
    finish { ambient 0.05 diffuse 0.6 }
  }


plane {
  z, 0
  texture { T_Env }
}

// ----------------------------------------

