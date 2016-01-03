// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)tutorial06.pov
// Desciption: mechanics simulation tutorial scene 6
// Creation Date: $ 07 Oct 2002, 12:38:51 $
// Last modified: $ 12 Mar 2005, 14:07:06 $
// Author: chris_hormann@gmx.de
// Requirements: IsoCSG library: http://www.tu-bs.de/~y0013390/pov/ic/
//
//
// -w320 -h240 +a0.3 -j +kff50

#version unofficial megapov 1.2;

#include "mechsim.inc"
#include "iso_csg.inc"

#declare fn_Env=
IC_Merge2(
  IC_Plane(z, 0),
  IC_Box(<-1.5, -0.6, -1.0>, <1.5, 0.6, 0.5>)
)

global_settings {
	assumed_gamma 1.0

	mechsim {
		gravity <0, 0, -9.81>
		method 3

		environment {
			function { fn_Env(x, y, z) }
			stiffness 110000
			damping 10000
			friction 0.1, 1.001
			method 1
		}

		time 1/30
		accuracy 1e-8, 1e-7
		
		#if (frame_number=1)
			topology {
				MechSim_Generate_Block(
					<0, 0, 0>, 0.07, 1500, 14000, 1600, true, 
					<-0.5, -2.75, 1.0>, <0.5, 2.75, 2.0>, <3, 12, 3>, No_Trans, 3
				)
				save_file "tut06.dat"
			}
		#else
			topology {
				load_file "tut06.dat"
				save_file "tut06.dat"
			}
		#end
	}
}

// ----------------------------------------

camera {
  location  <-6.0, -16.0, 3.0>*0.5
  up z
  sky z
  look_at   <0.0, 0.0, 0.4>
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

  box { <-1.5, -0.6, -1.0>, <1.5, 0.6, 0.5> }

  texture { T_Env }
}

// ----------------------------------------

MechSim_Show_All_Objects(-1, true, -1, "")

