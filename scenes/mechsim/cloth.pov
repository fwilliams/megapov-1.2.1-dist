// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)cloth.pov
// Description: mechanics simulation sample scene
// Features demonstrated: mechsim
// Creation Date: $ 14 Oct 2002, 16:55:14 $
// Last modified: $ 09 Aug 2005, 18:09:26 $
// Author: Christoph Hormann
// Requirements: IsoCSG library: http://www.tu-bs.de/~y0013390/pov/ic/
//
// @@ This scene demonstrates simulation of rectangular cloth patches.
//
// -w320 -h240 +a0.3 -j +kff30

#version unofficial megapov 1.2;

#include "mechsim.inc"
#include "iso_csg.inc"

#declare fn_Env=
	IC_Merge2 (
		IC_Merge3 (
			IC_Plane(z, 0),
			IC_Round_Box ( <2, -1.0, -1>, <-2, -1.5, 1.8>, 0.2 ),
			IC_Round_Box ( <2,  1.0, -1>, <-2,  1.5, 1.8>, 0.2 )
		),
		IC_Merge4 (
			IC_Cylinder ( <0, 0, 0>, <1.6, 0, 2.2>, 0.4 ),
			IC_Cylinder ( <0, 0, 0>, <-1.6, 0, 2.2>, 0.4 ),
			IC_Sphere ( <1.6, 0, 2.2>, 0.4 ),
			IC_Sphere ( <-1.6, 0, 2.2>, 0.4 )
		)
	)

#declare Trans1 =
	transform {
		translate -0.5*<79*0.07, 79*0.07, 0>
		//rotate 8*z
		rotate 40*z
		translate 2.65*z
	}

global_settings {
	max_trace_level 10
	assumed_gamma 1

	mechsim {
		gravity <0, 0, -9.81>

		environment {
			function { fn_Env(x, y, z) }
			stiffness 25000
			damping 0.8
			friction 0.2
			method 2
		}

		collision { off }

		#if (file_exists("cloth.dat") & (frame_number!=1))
			
			method 1
			step_count 500
			time_step (1/30)/500

			topology {
				load_file "cloth.dat"
				save_file "cloth.dat"
			}
		#else
			step_count 0
			topology {
				MechSim_Generate_Patch_Std(<0, 0, 0>, 0.05, 8000, 32000, 200, true, <0.14, 0.14>, <40, 40>, Trans1, 2)

				save_file "cloth.dat"
			}
		#end
	}
}

#declare Obj=MechSim_Show_Patch(0, 40, 40, true, true, -1, "")

object {
	Obj
	texture { MSim_Tex_Mesh }
}

#include "shapes.inc"

camera {
	location    <10, -8, 5.5>
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <0, 0, 1.3>
	angle       36
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

union {
	plane { z, 0 }

	Round_Box ( <2, -1.0, -1>, <-2, -1.5, 1.8>, 0.2, false )
	Round_Box ( <2,  1.0, -1>, <-2,  1.5, 1.8>, 0.2, false )

	cylinder { <0, 0, 0>, <1.6, 0, 2.2>, 0.4 }
	cylinder { <0, 0, 0>, <-1.6, 0, 2.2>, 0.4 }
	sphere { <1.6, 0, 2.2>, 0.4 }
	sphere { <-1.6, 0, 2.2>, 0.4 }

	texture {
		pigment { color rgb 1 }
		finish { ambient 0.05 diffuse 0.45 }
	}
}



