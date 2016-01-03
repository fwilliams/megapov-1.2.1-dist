// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)bar.pov
// Description: mechanics simulation sample scene
// Features demonstrated: mechsim
// Creation Date: $ 14 Aug 2002, 16:55:14 $
// Last modified: $ 30 Apr 2005, 11:57:35 $
// Author: Christoph Hormann
// Requirements: IsoCSG library: http://www.tu-bs.de/~y0013390/pov/ic/
//
// @@ This scene demonstrates the use of moving environments.
//
// -w320 -h240 +a0.3 -j +kff70

#version unofficial megapov 1.2;

#include "mechsim.inc"
#include "iso_csg.inc"

// ----------------------------------------

#declare Start_Move=0.5;
#declare End_Move=1.2;
//#declare Start_Move=0.2;
//#declare End_Move=0.71;

#if (clock_on)
	#if (frame_number*(1/30) < Start_Move)
		#declare Clock=0;
	#else
		#if (frame_number*(1/30) > End_Move)
			#declare Clock=1;
		#else
			#declare Clock=(frame_number*(1/30)-Start_Move)/(End_Move-Start_Move);
		#end
	#end
#else
	#declare Clock=0;
#end

#declare fn_Move=
	IC_Round_Box ( <-3, -1.2, -1>, <-5,  1.2, 3.2>, 0.2 )

#declare fn_NonMove=
	IC_Merge3 (
		IC_Plane(z, 0),
		IC_Round_Box ( <0, -1.2, -1>, <-5, -2.2, 1.8>, 0.2 ),
		IC_Round_Box ( <0,  1.2, -1>, <-5,  2.2, 1.8>, 0.2 )
	)

#declare fn_Env=
	function(x, y, z, tim) {
		min(
			fn_Move(x-(
				(tim>Start_Move)*(tim<End_Move)*(tim-Start_Move)/(End_Move-Start_Move) +
				(tim>End_Move) )*3, y, z),
			fn_NonMove(x, y, z)
		)
	}

#declare Trans1 =
	transform {
		translate 2.5*z
		translate -7*0.45*y
		translate -1.6*x
	}

// ----------------------------------------

global_settings {
	max_trace_level 10
	assumed_gamma 1

	mechsim {
		gravity <0, 0, -9.81>

		environment {
			function(x, y, z, tim) { fn_Env(x, y, z, tim) }
			stiffness 280000
			damping 50000
			friction 0.1
		}

		collision { off }

		#if (file_exists("bar.dat") & (frame_number!=1))
			step_count 300
			time_step (1/30)/300
			start_time frame_number*(1/30)

			topology {
				load_file "bar.dat"
				save_file "bar.dat"
			}
		#else
			step_count 0
			topology {
				MechSim_Generate_Grid_Std(<0, 0, 0>, 0.05, 16000, 24000, 4000, true, <0.45, 0.45, 0.45>, <3, 15, 3>, Trans1, 3)
				save_file "bar.dat"
			}
		#end
	}
}

// ----------------------------------------

MechSim_Show_All_Default()

// ----------------------------------------

#include "shapes.inc"

camera {
	location    <10, -9, 5.5>
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <-1, 0, 1.3>
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

	Round_Box ( <0, -1.2, -1>, <-5, -2.2, 1.8>, 0.2, false )
	Round_Box ( <0,  1.2, -1>, <-5,  2.2, 1.8>, 0.2, false )

	object {
		Round_Box ( <-3, -1.2, -1>, <-5,  1.2, 3.2>, 0.2, false )
		translate Clock*3*x
	}
	texture {
		pigment { color rgb 1 }
		finish { ambient 0.05 diffuse 0.45 }
	}
}
