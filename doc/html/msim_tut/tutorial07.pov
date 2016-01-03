// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)tutorial07.pov
// Desciption: mechanics simulation tutorial scene 7
// Creation Date: $ 07 Oct 2002, 12:38:51 $
// Last modified: $ 27 Feb 2005, 20:57:19 $
// Author: chris_hormann@gmx.de
// Requirements: IsoCSG library: http://www.tu-bs.de/~y0013390/pov/ic/
//
//
// -w320 -h240 +a0.3 -j +kff70

#version unofficial megapov 1.2;

#include "mechsim.inc"
#include "iso_csg.inc"

#declare fn_Env=
IC_Merge3(
  IC_Plane(z, 0),
  IC_Cylinder(-z, z*1.5, 0.3),
  IC_Sphere(z*1.5, 0.6)
)

#declare Trans1 =
  transform {
    translate -35*<0.07, 0.07, 0>*0.5
    translate 2.2*z
  }

global_settings {
	assumed_gamma 1.0

	mechsim {
		gravity -4.5*z
		method 4

		environment {
			function { fn_Env(x, y, z) }
			stiffness 60000
			method 1
		}
		
		step_count 800
		time_step (1/30)/4000
		
		#if (frame_number=1)
			topology {
				MechSim_Generate_Patch_Std(<0, 0, 0>, 0.03, 8000, 10000, 0, true, <0.07, 0.07>, <35, 35>, Trans1, 2)
				save_file "tut07.dat"
			}
		#else
			topology {
				load_file "tut07.dat"
				save_file "tut07.dat"
			}
		#end
	}
}

// ----------------------------------------

camera {
  location  <-6.0, -16.0, 7.0>*0.6
  up z
  sky z
  look_at   <0.0, 0.0, 1.0>
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

  cylinder { -z, z*1.5, 0.3 }
  sphere { z*1.5, 0.6 }

  texture { T_Env }
}

// ----------------------------------------

MechSim_Show_All_Objects(-1, true, -1, "")

