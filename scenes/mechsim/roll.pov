// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)roll.pov
// Description: sliding/rolling simulation
// Features demonstrated: mechsim
// Creation Date: $ 11 May 2005, 19:39:51 $
// Last modified: $ 20 May 2005, 11:31:15 $
// Author: Christoph Hormann
// Requirements: IsoCSG library: http://www.tu-bs.de/~y0013390/pov/ic/
//
// @@ This scene shows how changing material peoperties
// @@ can influence the interaction of simulation objects
// @@ with environments
//
// -w320 -h240 +a0.3 -j +kff75

#version unofficial megapov 1.2;

#include "mechsim.inc"
#include "iso_csg.inc"

// ----------------------------------------

// surface function
#declare fn_hf=
	function {
		z-0.6+x*0.54+sin(30*x)*0.01
	}

// environment function
#declare fn_Env=
	IC_Merge2(
		IC_Intersection2(
			function { fn_hf(x,y,z) },
			IC_Box(<-2,-2,0.1>, <2,2,2>)
		),
		IC_Plane(z, 0)
	)

// ----------------------------------------

#declare Stiffness1=4600;
#declare Damping1=2000;

#declare Stiffness2=2600;
#declare Damping2=500;

#declare Trans1 =
  transform {
		rotate 28*y
    translate <-1.7, 0.5, 1.6>
  }

#declare Trans2 =
  transform {
		Trans1
		translate -1.6*y
  }

// ----------------------------------------

#declare MSim_Tex_Mesh=texture { MSim_Tex_C }

global_settings {
	max_trace_level 10
	assumed_gamma 1

	mechsim {
		gravity <0, 0, -9.81>
		method 1

		environment {
			function { fn_Env(x, y, z) }
			stiffness 32000
			damping 2500
			friction 0.29
		}

		collision { 0 }

		#if (file_exists("roll.dat") & (frame_number!=1))
			step_count 600
			time_step (1/30)/600

			topology {
				load_file "roll.dat"
				save_file "roll.dat"
			}
		#else
			step_count 0

			topology {

				#declare VE_Elements1=array[3][2]
				#declare VE_Elements1[0][0]=Stiffness1*0.4;
				#declare VE_Elements1[0][1]=Damping1*120;
				#declare VE_Elements1[1][0]=Stiffness1*1.4;
				#declare VE_Elements1[1][1]=Damping1*6;
				#declare VE_Elements1[2][0]=Stiffness1*24;
				#declare VE_Elements1[2][1]=Damping1*0.8;

				MechSim_Generate_Grid_Std_VE(<0, 0, 0>, 0.04, 22000, Stiffness1, VE_Elements1, 1, true, <0.12, 0.12, 0.12>, <5, 5, 5>, Trans1, 3)

				//#declare MStart2=mechsim:face_count;
				//#debug concat("MStart2=", str(MStart2,0,0), "\n")

				#declare VE_Elements2=array[3][2]
				#declare VE_Elements2[0][0]=Stiffness2*0.4;
				#declare VE_Elements2[0][1]=Damping2*120;
				#declare VE_Elements2[1][0]=Stiffness2*1.4;
				#declare VE_Elements2[1][1]=Damping2*6;
				#declare VE_Elements2[2][0]=Stiffness2*24;
				#declare VE_Elements2[2][1]=Damping2*0.8;

				MechSim_Generate_Grid_Std_VE(<0, 0, 0>, 0.04, 22000, Stiffness2, VE_Elements1, 2, true, <0.12, 0.12, 0.12>, <5, 5, 5>, Trans2, 3)

				save_file "roll.dat"
			}
		#end
	}
}

// ----------------------------------------

//MechSim_Show_All_Default()
MechSim_Show_Grid(0, 5,5,5, true, false, 0, "")
MechSim_Show_Grid(192, 5,5,5, true, false, 0, "")

// ----------------------------------------

camera {
	location    <12, -7, 6>
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <0, -0.3, 0.8>
	angle       26
}

light_source {
	<3.2, -1.3, 4.4>*100000
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
		pigment {
			checker
			color rgb 0.8
			color rgb 0
			scale 0.5
		}
		finish {
			ambient 0.05
			diffuse 0.6
			reflection 0.7
		}
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
	contained_by { box { <-2,-2,0.1>, <2,2,1.7> } }
	texture {
		pigment {
			color rgb <0.45, 0.45, 0.55>
		}
		finish { ambient 0.05 diffuse 0.6 }
	}
}