// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)tutorial04.pov
// Desciption: mechanics simulation tutorial scene 4
// Creation Date: $ 07 Oct 2002, 12:38:51 $
// Last modified: $ 12 Mar 2005, 13:25:36 $
// Author: chris_hormann@gmx.de
//
//
// -w320 -h240 +a0.3 -j +kff100

#version unofficial megapov 1.2;

#include "mechsim.inc"

global_settings {
	assumed_gamma 1.0

	mechsim {
		gravity <0, 0, -9.81>
		method 1

		time_step (1/30)/600
		step_count 600
		
		#if (frame_number=1)
			topology {
				mass { <0, 0, 2.4>, <0, 0, 0>, 0.1 density 5000 fixed on  }
				mass { <1, 0, 2.4>, <0, 0, 0>, 0.1 density 5000 }
				mass { <2, 0, 2.4>, <0, 0, 0.6>, 0.15 density 5000 }
				connection { 0, 1 stiffness 50000 damping 2000 }
				connection { 1, 2 stiffness 50000 damping 2000 }
				save_file "tut04.dat"
			}
		#else
			topology {
				load_file "tut04.dat"
				save_file "tut04.dat"
			}
		#end
	}
}

// ----------------------------------------

camera {
  location  <-6.0, -16.0, 1.7>*0.6
  up z
  sky z
  look_at   <0.0, 0.0, 0.7>
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

MechSim_Show_All_Objects(-1, false, -1, "")

