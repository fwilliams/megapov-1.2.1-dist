// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)particle.pov
// Description: particle simulation
// Features demonstrated: mechsim
// Creation Date: $ 17 Mar 2005, 19:39:51 $
// Last modified: $ 30 Apr 2005, 12:03:48 $
// Author: Christoph Hormann
// Requirements: IsoCSG library: http://www.tu-bs.de/~y0013390/pov/ic/
//
// @@ This scene simulates the movement of a lot of
// @@ masses on a structured surface.  It demonstrates
// @@ environment collisions as well as mass-mass collisions.
//
// -w320 -h240 +a0.3 -j +kff250

#version unofficial megapov 1.2;

#include "mechsim.inc"
#include "iso_csg.inc"

// ----------------------------------------

// surface structure
#declare fn_noise=
	function {
		pattern {
			agate
			poly_wave 0.5
			scale 4
		}
	}

// surface function
#declare fn_hf=
	function {
		z-0.6+x*0.2-fn_noise(x,y,0)*0.3
	}

#declare Start_Point=<-1.7,0.32,1.4>;

// complete environment function
#declare fn_Env=
	IC_Merge3(
		IC_Plane(z,0),
		IC_Translate(
			IC_Difference2(
				IC_Cylinder( 0, -x*1.4, 0.2 ),
				IC_Cylinder( x*0.1, -x*1.3, 0.16 )
			),
			Start_Point
		),
		IC_Intersection2(
			function { fn_hf(x,y,z) },
			IC_Box(<-2,-2,0.1>, <2,2,1.3>)
		)
	)

// ----------------------------------------

global_settings {
	max_trace_level 10
	assumed_gamma 1

	mechsim {
		gravity <0, 0, -9.81>
		method 1

		environment {
			function { fn_Env(x, y, z) }
			stiffness 60000
			damping 9000
			friction 0.01, 1.001
		}

		collision {
			1
			stiffness 60000
			damping 4000
		}

		#if (file_exists("particles.dat") & (frame_number!=1))
			step_count 600
			time_step (1/30)/600

			topology {
				load_file "particles.dat"

				// every third frame: insert new masses
				#if (mod(frame_number,3)=0)
					#local Cnt=0;
					#local Seed=seed(frame_number*10);
					#local Pos=Start_Point-0.07*x+0.1*z;
					#local Vel=<1.4, 0, 0>+(<rand(Seed),rand(Seed),rand(Seed)>-0.5)*0.2;
					mass { Pos, Vel, 0.05 density 5000 }
					#local Pos=Start_Point-0.07*x-0.1*z;
					#local Vel=<1.4, 0, 0>+(<rand(Seed),rand(Seed),rand(Seed)>-0.5)*0.2;
					mass { Pos, Vel, 0.05 density 5000 }
					#local Pos=Start_Point-0.07*x+0.1*y;
					#local Vel=<1.4, 0, 0>+(<rand(Seed),rand(Seed),rand(Seed)>-0.5)*0.2;
					mass { Pos, Vel, 0.05 density 5000 }
					#local Pos=Start_Point-0.07*x-0.1*y;
					#local Vel=<1.4, 0, 0>+(<rand(Seed),rand(Seed),rand(Seed)>-0.5)*0.2;
					mass { Pos, Vel, 0.05 density 5000 }

				#end

				save_file "particles.dat"
			}
		#else
			step_count 0

			topology {
				mass { Start_Point-0.07*x, <1.4, 0, 0>, 0.05 density 5000 }
				save_file "particles.dat"
			}
		#end
	}
}

// ----------------------------------------

MechSim_Show_All_Default()

// ----------------------------------------

camera {
	location    <12, -8, 6>
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <0, 0, 0.8>
	angle       26
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

plane {
	z, 0
	texture { T_Env }
}

// ground
isosurface {
	function {
		fn_hf(x,y,z)
	}
	max_gradient 2.5
	contained_by { box { <-2,-2,0.1>, <2,2,1.3> } }
	texture {
		pigment { color rgb <0.8, 0.45, 0.15> }
		finish { ambient 0.05 diffuse 0.6 }
	}
}

// tube
difference {
	cylinder { 0, -x*1.4, 0.2 }
	cylinder { x*0.1, -x*1.3, 0.16 }
	texture {
		pigment { color rgb <0.2, 0.15, 0.7> }
		finish { ambient 0.05 diffuse 0.6 }
	}
	translate Start_Point
}
