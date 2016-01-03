// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)collide_fast.pov
// Description: collision of a mass with a block
// Features demonstrated: mechsim
// Creation Date: $ 23 Apr 2004, 19:39:51 $
// Last modified: $ 09 Aug 2005, 14:36:05 $
// Author: Christoph Hormann
// Requirements: IsoCSG library: http://www.tu-bs.de/~y0013390/pov/ic/
//
// @@ Demonstrates collisions and stress visualization
// @@ 60 frames per second slow motion
//
// -w320 -h240 +a0.3 -j +kff140

#version unofficial megapov 1.2;

#include "mechsim.inc"
#include "iso_csg.inc"

// ----------------------------------------

#declare fn_Env=
	IC_Merge3 (
		IC_Plane(z, 0),
		IC_Round_Box ( <0.5, -1.2, -1>, <-0.5, -2, 3.2>, 0.1 ),
		IC_Round_Box ( <0.5, 1.2, -1>, <-0.5,  2, 3.2>, 0.1 )
	)

#declare Trans1 =
	transform {
		translate -7.5*0.2*y
		translate 0.55*x
	}

// ----------------------------------------

global_settings {
	max_trace_level 10
	assumed_gamma 1

	mechsim {
		gravity -9.81*z
		method 3

		environment {
			function { fn_Env(x, y, z) }
			stiffness 180000
			damping 36000
			friction 0.15, 1.001
		}

		collision {
			2, 2
			stiffness 200000
			damping 36000
			friction 0.15, 1.001
		}

		time 1/60
		time_step 1e-4
		accuracy 1e-7, 1e-9

		#if (file_exists("collide_fast.dat") & (frame_number!=1))

			topology {
				load_file "collide_fast.dat"
				save_file "collide_fast.dat"
			}
			
		#else

			topology {

				group {
					MechSim_Generate_Grid_Std(<0, 0, 0>, 0.04, 10000, 20000, 2400, true, <0.2, 0.2, 0.2>, <3, 16, 16>, Trans1, 4)
				}
				group {
					mass { <4, 0, 1.7>, -24*x, 0.5 density 4000 }
				}

				save_file "collide_fast.dat"
			}

		#end

	}
}

// ----------------------------------------

MechSim_Show_Grid(0, 3, 16, 16, true, false, -100, "")

MechSim_Show_Objects(mechsim:mass_count-1, mechsim:connection_count, mechsim:face_count, -1, -1, -1, -1, false, -1, "")

// ----------------------------------------

#include "shapes.inc"
#include "glass.inc"

camera {
	location    <12, -10, 5.5>
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <-2.2, 0.5, 1.2>
	angle       36
}

light_source {
	<3.2, 1.3, 4.4>*100000
	color rgb <1.7, 1.5, 1.2>
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

#declare T_Env=
	texture {
		pigment { color rgb 1.5 }
		finish { ambient 0.05 diffuse 0.6 }
	}

union {
	plane { z, 0 }

	union {
		Round_Box ( <0.5, -1.2, -1>, <-0.5, -2, 3.2>, 0.1, true )
		Round_Box ( <0.5, 1.2, -1>, <-0.5,  2, 3.2>, 0.1, true )
		material {
			texture {
				pigment { color Col_Glass_Clear }
				finish { F_Glass6 }
			}
			interior {
				I_Glass_Exp(1.5)
				fade_color Col_Blue_01
			}
		}
	}
	texture { T_Env }
}
