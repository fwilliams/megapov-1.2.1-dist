// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)rotate.pov
// Description: mechanics simulation sample scene
// Features demonstrated: mechsim
// Creation Date: $ 14 Dec 2002, 16:55:14 $
// Last modified: $ 30 Apr 2005, 12:04:34 $
// Author: Christoph Hormann
//
// @@ This scene demonstrates use of the
// @@ MechSim_Generate_Line_Std() macro and
// @@ the attach function
//
// -w320 -h240 +a0.3 -j +kff90


#version unofficial megapov 1.2;

#include "mechsim.inc"

#local Radius=1;
#local Seconds=3;   // 90 frames each 1/30 second

// ----------------------------------------

global_settings {
	assumed_gamma 1.0
	max_trace_level 15

	mechsim {
		gravity <0, 0, -9.81>
		method 1

		#local Angle=0;

		#while (Angle<360)

			attach {
				function {
					spline {
						linear_spline

						#local Cnt=0;

						#while (Cnt<1200)

							(Cnt/360)*4,   // 4 seconds per circle
							<Radius*sin(radians(Angle+Cnt)), Radius*cos(radians(Angle+Cnt)), 2.1>

							#local Cnt=Cnt+10;
						#end
					}
				}
			}

			#local Angle=Angle+40;
		#end

		#if (file_exists("rotate.dat") & (frame_number!=1))
			step_count 500
			time_step (1/30)/500

			topology {
				load_file "rotate.dat"
				save_file "rotate.dat"
			}
		#else
			step_count 0

			topology {

				#local Angle=0;
				#local Cnt=0;

				#while (Angle<360)

					#local Trans=transform { translate <Radius*sin(radians(Angle)), Radius*cos(radians(Angle)) 2> }

					mass{ <Radius*sin(radians(Angle)), Radius*cos(radians(Angle)) 2.1> , 0, 0.08 density 3000 attach Cnt }
					#local Idx=mechsim:mass_count;

					MechSim_Generate_Line_Std(<0,0,0>, 0.05, 8000, 25000, 0, 0.15, 10, -z, Trans)

					connection { Idx-1, Idx stiffness 25000 damping 0 }

					#local Idx=mechsim:mass_count;
					mass{ <Radius*sin(radians(Angle)), Radius*cos(radians(Angle)) 2-10*0.15> , 0, 0.09 density 3000 }
					connection { Idx, Idx-1 stiffness 25000 damping 0 }

					#local Angle=Angle+40;
					#local Cnt=Cnt+1;
				#end

				save_file "rotate.dat"
			}
		#end
	}
}

// ----------------------------------------

MechSim_Show_All_Default()

// ----------------------------------------

camera {
	location  <-6.0, -16.0, 7.0>*0.6
	direction y
	up        z
	sky       z
	right     (4/3)*x
	look_at   <0.0, 0.0, 0.9>
	angle     30
}

light_source {
	<2000, -3000, 2700>
	color rgb <1.7, 1.5, 1.2>
}

sky_sphere {
	pigment {
		bozo
		color_map {
			[0.0 rgb <0.4,0.1,0.3>]
			[0.2 rgb <0.1,0.2,0.6>]
		}
		scale 0.2
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

	union {
		cylinder { < 0,0,2.1>, <0,0,2.3>, Radius*1.1 }
		cylinder { -z, <0,0,2.2>, 0.12 }
		sphere { 2.3*z, 0.25 }

		texture {
			spiral2 6
			texture_map {
				[0.45 pigment { color rgb 0.35 } finish { ambient 0.05 diffuse 0.6 } ]
				[0.55 pigment { color rgb 1.5 } finish { ambient 0.05 diffuse 0.6 }]
			}
			rotate -((clock*Seconds)/4)*360*z  // 4 seconds per circle
		}
	}

	texture { T_Env }
}
