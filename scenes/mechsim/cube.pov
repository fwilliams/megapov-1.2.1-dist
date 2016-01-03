// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)cube.pov
// Description: mechanics simulation sample scene
// Features demonstrated: mechsim
// Creation Date: $ 14 Aug 2002, 16:55:14 $
// Last modified: $ 30 Apr 2005, 12:01:00 $
// Author: Christoph Hormann
//
// @@ Simple cube topology
//
// -w320 -h240 +a0.3 -j +kff40

#version unofficial megapov 1.2;

#include "mechsim.inc"

// ----------------------------------------

#declare fn_Env = function { min(z, x+2) }

#declare Trans1 =
	transform {
		rotate 40*z
		rotate 19*y
		rotate -30*z
		translate 1.3*z
	}

// ----------------------------------------

global_settings {
	max_trace_level 10
	assumed_gamma 1

	mechsim {
		gravity <0, 0, -9.81>
		method 2

		environment {
			function { fn_Env(x, y, z) }
			stiffness 240000
			damping 50000
		}

		collision { off }

		#if (file_exists("cube.dat") & (frame_number!=1))
			step_count 250
			time_step (1/30)/250

			topology {
				load_file "cube.dat"
				save_file "cube.dat"
			}
		#else
			step_count 0
			topology {
				MechSim_Generate_Grid_Std(<0, 0, 0>, 0.1, 25000, 12000, 3500, false, <0.7, 0.7, 0.7>, <4, 4, 4>, Trans1, 4)
				save_file "cube.dat"
			}
		#end
	}
}

// ----------------------------------------

MechSim_Show_All_Default()

// ----------------------------------------

camera {
	location    <8, -8, 5>
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <0, 2, 1>
	angle       30
}

light_source {
	<3.2, -0.3, 1.8>*100000
	color rgb <1.6, 1.5, 1.0>
}

sky_sphere {
	pigment {
		gradient z
		color_map {
			[0.00 rgb <0.8,0.9,1.0>]
			[0.10 rgb <0.6,0.7,1.0>]
			[0.25 rgb <0.2,0.3,0.8>]
		}
	}
}

box {
	<-3, -3, -10>, <-2, 4, 1.8>
	texture {
		pigment { color rgb 1 }
		finish { ambient 0.05 diffuse 0.45 }
	}
}

plane {
	z, 0
	texture {
		pigment { color rgb 1 }
		finish { ambient 0.05 diffuse 0.45 }
	}
}
