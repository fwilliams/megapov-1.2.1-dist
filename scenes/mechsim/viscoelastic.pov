// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)viscoelastic.pov
// Desciption: Use of viscoelastic connections
// Features demonstrated: mechsim
// Creation Date: $ 29 Apr 2005, 12:38:51 $
// Last modified: $ 30 Apr 2005, 12:06:11 $
// Author: Christoph Hormann
//
// @@ This scene demonstrates the use of viscoelastic connections
// @@ to simulate special material properties, in this case
// @@ relaxation of a bar fixed at both sides and bending under
// @@ its own weight.
//
// -w320 -h240 +a0.3 -j +kff90

#version unofficial megapov 1.2;

#include "mechsim.inc"
#include "shapes.inc"

#declare Length=1;
#declare Mass_Count=15;

#declare Transf1=
	transform {
		translate <-Length, -(Length/Mass_Count)*2, 1.5>
	}

// ----------------------------------------

// this is a wrapper macro for the MechSim_Generate_Grid_Fn_VE() macro
// from mechsim.inc that sets all the parameter functions to constant
// values except the 'Fixed' one
#macro MechSim_Generate_Grid_Fixed_VE(
	Velocity, Radius, Density, Stiffness, VE_Elements, VE_Accuracy,
	Faces, Cube_Scale, Grid_Size, Transf, Fn_Fixed, Connect_Arr)

	#local Fn_Density=function(x, y, z) {Density}
	#local Fn_Stiffness=function(x, y, z) {Stiffness}
	#local Fn_Damping=function(x, y, z) {0}
	#local Fn_Attach=function(x, y, z) {-1}
	#local Fn_Force=function(x, y, z) {-1}

	MechSim_Generate_Grid_Fn_VE(
		Velocity, Radius, Fn_Density, Fn_Stiffness, VE_Elements, VE_Accuracy, Faces, Cube_Scale, Grid_Size,
		Transf, Fn_Fixed, Fn_Attach, Fn_Force, Connect_Arr
	)

#end

// ----------------------------------------

global_settings {
	assumed_gamma 1.0

	mechsim {
		gravity <0, 0, -9.81>
		method 1

		step_count 1500
		time_step (1/30)/1500

		#if (file_exists("viscoelastic.dat") & (frame_number!=1))
			topology {
				load_file "viscoelastic.dat"
				save_file "viscoelastic.dat"
			}
		#else
			topology {

				// masses on right and left side are fixed
				#declare fn_Fixed=function(x, y, z) { (x<0.01)+(x>0.99) }

				// diagonal connections weighting
				#declare Connect_Arr=array[3]
				#declare Connect_Arr[0]=1;
				#declare Connect_Arr[1]=1;
				#declare Connect_Arr[2]=1;

				// connection parameters
				#declare Stiffness=4000;
				#declare Damping=4000;

				#declare VE_Elements=array[3][2]
				#declare VE_Elements[0][0]=Stiffness*2;
				#declare VE_Elements[0][1]=Damping*500;
				#declare VE_Elements[1][0]=Stiffness*15;
				#declare VE_Elements[1][1]=Damping*6;
				#declare VE_Elements[2][0]=Stiffness*100;
				#declare VE_Elements[2][1]=Damping*0.25;

				MechSim_Generate_Grid_Fixed_VE(
					<0, 0, 0>, 0.05, 15000, Stiffness, VE_Elements, 1,
					false, <Length/Mass_Count, Length/Mass_Count, Length/Mass_Count>*2, <Mass_Count+1, 3, 3>, Transf1
					fn_Fixed, Connect_Arr
				)
				save_file "viscoelastic.dat"
			}
		#end
	}
}

// ----------------------------------------

MechSim_Show_All_Default()

// ----------------------------------------

camera {
	location <3.5, -8.0, 2.0>
	up z
	sky z
	look_at  <0.0, 0.0, 1>
	right    (4/3)*x
	angle    25
}

light_source {
	<-1600, -3000, 2700>
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

fog {
	up z
	fog_type 2
	distance 40
	color rgb <1.0,0.9,0.8>
	fog_offset 0.5
	fog_alt 0.5
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
		Round_Box_Union( <-Length, -0.3, -1.0>, <-Length-0.1, 0.3, 1.9>, 0.04 )
		Round_Box_Union( < Length, -0.3, -1.0>, < Length+0.1, 0.3, 1.9>, 0.04 )
		texture {
			pigment {
				checker
				color rgb 0
				color rgb 1.5
				scale 0.16
			}
			finish { ambient 0.05 diffuse 0.8 }
		}
	}
	texture { T_Env }
}

