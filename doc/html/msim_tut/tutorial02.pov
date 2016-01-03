// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)tutorial02.pov
// Desciption: mechanics simulation tutorial scene 2
// Creation Date: $ 07 Oct 2002, 12:38:51 $
// Last modified: $ 23 Feb 2005, 21:30:46 $
// Author: chris_hormann@gmx.de
//
//
// -w320 -h240 +a0.3 -j +kff50

#version unofficial megapov 1.2;

#include "mechsim.inc"

global_settings {
	assumed_gamma 1.0

	mechsim {
		gravity <0, 0, -9.81>
		method 1

		environment {
			object plane {  z, 0 }
			damping 0.9
			friction 0.3
			method 2
		}

		step_count 300
		time_step 1/30/300
		
		#if (frame_number=1)
			topology {
				mass { <-2.8, -8.0, 0.9>, <2, 5, 0>, 0.1 density 5000 }
				save_file "tut02.dat"
			}
		#else
			topology {
				load_file "tut02.dat"
				save_file "tut02.dat"
			}
		#end
	}
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

MechSim_Show_All_Objects(-1, false, -1, "")

