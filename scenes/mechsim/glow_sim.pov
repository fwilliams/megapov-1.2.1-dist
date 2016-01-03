// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)glow_sim.pov
// Description: particle simulation with glows
// Features demonstrated: mechsim
// Creation Date: $ 17 Mar 2005, 19:39:51 $
// Last modified: $ 29 Apr 2005, 23:43:34 $
// Author: Christoph Hormann
// Requirements: IsoCSG library: http://www.tu-bs.de/~y0013390/pov/ic/
//
// @@ Demonstrates particle simulation combined with glows
// @@ as well as custom forces in mechsim that move the masses
// @@ on the ground towards the center
//
// -w320 -h240 +a0.3 -j +kff500

#version unofficial megapov 1.2;

#include "mechsim.inc"
#include "math.inc"
#include "transforms.inc"
#include "iso_csg.inc"

// environment function
#declare fn_Env=
	IC_Merge2(
		IC_Difference2(
			IC_Plane(z,0),
			IC_Cylinder(-z*2, z*0.5, 0.32)
		),
		IC_Sphere(0.75*z, 0.5)
	)

// emitter transform
#declare Em_Trans=
	transform {
		rotate 20*y
		rotate 3*z
		translate <-2, 0, 0.4>
		rotate -35*z
	}

#declare Particle_Radius=0.05;

// ----------------------------------

#macro Particle_Emit(Frame_Step, Rand, Radius, Density, Speed, Trans)

#local DTrans=transform { Trans normal }

#local Dir=vtransform(z, DTrans);
#local CPos=vtransform(<0,0,0>, Trans);

#if (mod(frame_number,Frame_Step)=0)
	#local Seed=seed(frame_number*10);
	#local Pos=CPos+vtransform(<0,0,-Radius>, DTrans);
	#local Vel=Dir*Speed+(<rand(Seed),rand(Seed),rand(Seed)>-0.5)*Rand;
	mass { Pos, Vel, Radius density Density force 0 }
#end

#end

// ----------------------------------

global_settings {
	max_trace_level 10
	assumed_gamma 1

	mechsim {
		gravity <0, 0, -9.81>
		method 1

		environment {
			function { fn_Env(x, y, z) }
			stiffness 45000
			damping 8500
			friction 0.0
		}

		force {
			Vector_Function(
				function { -(x/max(0.0001, pow(f_r(x,y,0), 0.5)))*(z<0.1)*2 },
				function { -(y/max(0.0001, pow(f_r(x,y,0), 0.5)))*(z<0.1)*2 },
				function { 0 }
			)
		}

		#if (file_exists("glow_sim.dat") & (frame_number!=1))
			step_count 600
			time_step (1/30)/600

			topology {
				load_file "glow_sim.dat"

				#if (frame_number<100)
					Particle_Emit(2, 0.8, Particle_Radius, 5000, 6, Em_Trans)
				#end

				save_file "glow_sim.dat"
			}
		#else
			step_count 0

			topology {
				Particle_Emit(2, 0.8, Particle_Radius, 5000, 6, Em_Trans)
				save_file "glow_sim.dat"
			}
		#end
	}

}

// ----------------------------------

#declare fn_Color=
	function {
		pigment {
			agate
			color_map {
				[0.0 color rgb <2.0, 1.5, 1.0>]
				[0.5 color rgb <2.0, 1.0, 1.0>]
				[1.0 color rgb <1.2, 1.0, 2.0>]
			}
		}
	}

#local Cnt=0;

#while (Cnt<mechsim:mass_count)

	#if (mechsim:mass(Cnt):position.z>-0.25)
		glow {
			type 0
			location mechsim:mass(Cnt):position
			size Particle_Radius*0.35
			radius 6
			fade_power 2
			color	fn_Color(Cnt*0.5, 0, 0)
		}
	#end

	#local Cnt=Cnt+1;
#end

// ----------------------------------

camera {
	location    <-8, -12, 6>
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <0, 0, 0.9>
	angle       26
}


// tube
difference {
	cylinder { 0, -z*2, Particle_Radius*3 }
	cylinder { z*0.1, -z*1.9, Particle_Radius*2.5 }
	texture {
		pigment { color rgb <0.2, 0.15, 0.7> }
		finish {
			ambient 0
			diffuse 0.6
			reflection {
				0.9
				metallic
			}
			conserve_energy
		}
	}
	transform {
		Em_Trans
	}
}

sphere {
	0.75*z, 0.5
	texture {
		pigment { color rgb 0.4 }
		finish {
			ambient 0
			diffuse 0.6
			reflection {
				0.9
				metallic
			}
			conserve_energy
		}
	}
}

difference {
	plane {	z, 0 }
	cylinder { -z*2, z*0.5, 0.32 }
	texture {
		pigment {
			checker
			color rgb <0.04, 0.05, 0.1>
			color rgb <0.9, 0.95, 1>
		}
		finish {
			ambient 0
			diffuse 0.85
			reflection {
				0.9
				metallic
			}
			conserve_energy
		}
	}
}
