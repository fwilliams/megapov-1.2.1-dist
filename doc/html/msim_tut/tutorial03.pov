// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)tutorial03.pov
// Desciption: mechanics simulation tutorial scene 3
// Creation Date: $ 07 Oct 2002, 12:38:51 $
// Last modified: $ 24 Feb 2005, 19:18:41 $
// Author: chris_hormann@gmx.de
// Requirements: IsoCSG library: http://www.tu-bs.de/~y0013390/pov/ic/
//
//
// -w320 -h240 +a0.3 -j +kff150

#version unofficial megapov 1.2;

#include "mechsim.inc"
#include "iso_csg.inc"

#declare fn_Env=
IC_Merge5(
  IC_Plane(z, 0),
  IC_Box(< 1.7,-1.7,-1.0>, < 1.5,1.7,0.5>),
  IC_Box(<-1.7,-1.7,-1.0>, <-1.5,1.7,0.5>),
  IC_Box(<-1.7, 1.7,-1.0>, <1.7, 1.5,0.5>),
  IC_Box(<-1.7,-1.7,-1.0>, <1.7,-1.5,0.5>)
)

global_settings {
	assumed_gamma 1.0

	mechsim {
		gravity <0, 0, -9.81>
		method 1

		environment {
			function { fn_Env(x, y, z) }
			stiffness 60000
			damping 12000
			friction 0.1, 1.001
			method 1
		}

		collision {
			1, 0, 0
			stiffness 60000
			damping 4000
		}

		step_count 1500
		time_step (1/30)/1500
		
		#if (frame_number=1)
			topology {
				mass { < 1.3,-1.55,0.8>, <-0.2, 5, 0>, 0.18 density 5000 }
				save_file "tut03.dat"
			}
		#else
			topology {
				load_file "tut03.dat"

				#if (mod(frame_number, 6)=5)
					mass { < 1.3,-1.55,0.8>, <-0.2, 5, 0>, 0.18 density 5000 }
				#end

				save_file "tut03.dat"
			}
		#end
	}
}

// ----------------------------------------

camera {
  location  <-6.0, -16.0, 7.0>*0.6
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


union {
  plane { z, 0 }

  box { < 1.7,-1.7,-1.0>, < 1.5,1.7,0.5> }
  box { <-1.7,-1.7,-1.0>, <-1.5,1.7,0.5> }
  box { <-1.7, 1.7,-1.0>, <1.7, 1.5,0.5> }
  box { <-1.7,-1.7,-1.0>, <1.7,-1.5,0.5> }

  cylinder { < 1.3,-1.5,0.8>, < 1.3,-2.5,0.8>, 0.2 }
  sphere { < 1.3,-2.5,0.8>, 0.2 }
  cylinder { < 1.3,-2.5,0.8>, < 1.3,-2.5,-0.8>, 0.2 }

  texture { T_Env }
}

// ----------------------------------------

MechSim_Show_All_Objects(-1, false, -1, "")

