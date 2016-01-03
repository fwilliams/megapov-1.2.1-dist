// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)blocks.pov
// Description: mechanics simulation sample scene
// Features demonstrated: mechsim
// Creation Date: $ 14 Oct 2002, 16:55:14 $
// Last modified: $ 29 Apr 2005, 12:44:37 $
// Author: Christoph Hormann
//
// @@ Demonstrating groups and mass-face-collisions.
//
// -w320 -h240 +a0.3 -j +kff70

#version unofficial megapov 1.2;

#include "mechsim.inc"

#declare fn_Env = function { z }

#declare Trans1 =
	transform {
		translate -1.5*<0.7, 0.7, 0>
		rotate -40*z
		translate 1.8*x
		translate 0.5*z
	}

#declare Trans2 =
	transform {
		translate -1.5*<0.7, 0.7, 0>
		rotate 25*z
		translate -2.1*x
		translate 0.5*z
	}

#declare Trans3 =
	transform {
		translate -<4*0.55, 0.55, 0>
		translate 2.9*z
	}



global_settings {
	max_trace_level 10
	assumed_gamma 1

	mechsim {
		gravity <0, 0, -9.81>
		method 2
		bounding 3

		environment {
			function { fn_Env(x, y, z) }
			stiffness 240000
			damping 35000
			friction 0.2, 1.001
		}

		collision {
			2, 2
			stiffness 180000
			damping 30000 //5000
			friction 0.2, 1.001
		}

		#if (file_exists("blocks.dat") & (frame_number!=1))
			step_count 300 //500
			time_step (1/30)/300 //500

			topology {
				load_file "blocks.dat"
				save_file "blocks.dat"
			}
    #else
			step_count 0
			topology {

				#declare Stiff=24000;
				#declare Damp=3000;
				//#declare Stiff=52000;
				//#declare Damp=2500;

				group {
					MechSim_Generate_Grid_Std(<0, 0, 0>, 0.1, 22000, Stiff, Damp, true, <0.7, 0.7, 0.7>, <4, 4, 4>, Trans1, 3)
				}
				group {
					MechSim_Generate_Grid_Std(<0, 0, 0>, 0.1, 22000, Stiff, Damp, true, <0.7, 0.7, 0.7>, <4, 4, 4>, Trans2, 3)
				}
				group {
					MechSim_Generate_Grid_Std(<0, 0, 0>, 0.1, 22000, Stiff, Damp, true, <0.55, 0.55, 0.55>, <9, 3, 3>, Trans3, 3)
				}
				save_file "blocks.dat"
			}
		#end
	}
}

//MechSim_Show_All_Objects(-1, true, false, "")
MechSim_Show_Grid(0, 4,4,4, true, false, 0, "")
MechSim_Show_Grid(108, 4,4,4, true, false, 0, "")
MechSim_Show_Grid(216, 9, 3, 3, true, false, 0, "")

camera {
	location    <8, -10, 5>*1.4
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <0, 0, 1>
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

plane {
	z, 0
	texture {
		pigment { color rgb 1 }
		finish { ambient 0.05 diffuse 0.45 }
	}
}
