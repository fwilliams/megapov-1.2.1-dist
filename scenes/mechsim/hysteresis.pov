// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)hysteresis.pov
// Description: demonstrates viscoelastic connections, force measurement and 2d simulation
// Features demonstrated: mechsim
// Creation Date: $ 15 Mar 2005, 18:53:05 $
// Last modified: $ 11 May 2005, 13:39:05 $
// Author: Christoph Hormann
//
// @@ This scene draws the hysteresis curves (stress-strain curves)
// @@ of a connection or a 2d grid under a periodic compression.
// @@ The single frequency harmonic movement causes an elliptical
// @@ hysteresis for both normal and viscoelastic connections but
// @@ the curve starts at the origin with viscoelastic material
// @@ which is not the case for normal connections.
//
// -w320 -h240 +a0.3 -j +kff80 DECLARE=Dimensions=2 DECLARE=VE=1 DECLARE=Fixed=1
//

#version unofficial megapov 1.2;

#include "mechsim.inc"
#include "shapes.inc"

// ----------------------------------

// parameters you can modify:

#ifndef (Dimensions)

#declare Dimensions=2;
#declare VE=on;
#declare Fixed=off;

#end

// Note:
//  this scene generates a text file to store the values of the previous
//  frames - make sure you delete this when changing the parameters above.
//

// ----------------------------------

#if (Dimensions=1)
	#declare Fixed=on;
#end

#declare Trans1 =
	transform {
		translate <-0.53, -0.26, 0.02>
	}

#declare fn_Attach=function { -1 + (y<0.01) + (y>0.99)*2 }
#declare Con_Array=array[2]
#declare Con_Array[0]=1;
#declare Con_Array[1]=1;

#declare Amplitude = 0.15;
#declare Frequency = 4;
#declare Seconds = 20;
#declare Resolution = 150;

#declare Stiffness=80000;
#declare Damping=1500;

global_settings {
	max_trace_level 10
	assumed_gamma 1

	mechsim {
		method 1

		fixed z

		attach <Fixed,1,1> {
			function {
				spline {
					linear_spline

					#local Cnt = 0;

					// Cnt = 0..Frequency*Seconds*Resolution
					// time = spline parameter = 0..Seconds
					// sin-Argument = 2*pi*time*Frequency
					//   --> Frequency*Seconds Periods in Seconds seconds time

					#while (Cnt<Frequency*Seconds*Resolution)
						Cnt/(Frequency*Resolution),
						//<0, Amplitude*Cnt/Resolution, 0>
						<0, Amplitude*sin(2*pi*Cnt/Resolution), 0>

						#local Cnt = Cnt+1;

					#end

				}
			}
		}

		attach <Fixed,1,1> {
			function {
				spline {
					linear_spline
					0.0, <0,0,0>
					Seconds, <0,0,0>
				}
			}
		}

		step_count 9000
		time_step (1/180)/9000

		#if (file_exists("hysteresis.dat") & (frame_number!=1))

			topology {
				load_file "hysteresis.dat"
				save_file "hysteresis.dat"
			}
			
		#else

			topology {

				group {

					// 1d - two masses with one connection
					#if (Dimensions=1)
						mass { <-0.2, -0.25, 0>, <0,0,0>, 0.012 density 12000 attach 0 }
						mass { <-0.2, 0.35, 0>, <0,0,0>, 0.012 density 12000 attach 1 }

						#if (VE)
							viscoelastic {
								0, 1  stiffness Stiffness
								element { 5000, 150000 }
								element { 190000, 750000 }
								element { 500000, 36000 }
							}
						#else
							connection { 0, 1  stiffness Stiffness*5 damping Damping*5 }
						#end

						// 2d - grid
					#else

						#if (VE)
							#declare VE_Elements=array[3][2]
							#declare VE_Elements[0][0]=5000;
							#declare VE_Elements[0][1]=150000;
							#declare VE_Elements[1][0]=190000;
							#declare VE_Elements[1][1]=50000;
							#declare VE_Elements[2][0]=500000;
							#declare VE_Elements[2][1]=26000;

							MechSim_Generate_Patch_VE(<0, 0, 0>, 0.012, 32000, Stiffness, VE_Elements, 1, false, <1/20, 1/20>, <11, 11>, Trans1, No_Fixed, fn_Attach, No_Force, Con_Array)
						#else
							MechSim_Generate_Patch(<0, 0, 0>, 0.012, 32000, Stiffness, Damping*0.3, false, <1/20, 1/20>, <11, 11>, Trans1, No_Fixed, fn_Attach, No_Force, Con_Array)
						#end

					#end

				}

				save_file "hysteresis.dat"
			}
			
		#end

	}
}

// ----------------------------------

MechSim_Show_All_Default()

// ----------------------------------

camera {
	orthographic
	location <0,0,10>
	look_at  <0,0,0>
	right -(image_width/image_height)*x
	up 1*y
}

light_source {
	<-3.2, 1.3, 4.4>*100000
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

box {
	<-1, -1, 0>, <1,1,-0.1>
	texture {
		T_Env
	}
}

// ----------------------------------

// this is for measuring the internal forces
#if (Dimensions=1)

	#declare Length=0.6;

	#if (VE)
		#declare Force=mechsim:viscoelastic(0):force;
	#else
		#declare Force=mechsim:connection(0):force;
	#end

#else

	#declare Length=0.5;

	#declare M_Array=array[31]

	#local XCnt=0;
	#local YCnt=41*5+1;
	#local Cnt=0;

	#while (Cnt<10)
		#declare M_Array[XCnt]=YCnt;
		#declare M_Array[XCnt+1]=YCnt+1;
		#declare M_Array[XCnt+2]=YCnt+2;
		#local Cnt=Cnt+1;
		#local XCnt=XCnt+3;
		#local YCnt=YCnt+4;
	#end

	#declare M_Array[30]=YCnt-1;

	#local Cnt=0;
	#declare VForce=<0,0,0>;

	#while (Cnt<31)
		#if (VE)
			//MechSim_Show_Con_VE(M_Array[Cnt])

			#local Dir=mechsim:mass(mechsim:viscoelastic(M_Array[Cnt]):index2):position-
			           mechsim:mass(mechsim:viscoelastic(M_Array[Cnt]):index1):position;

			#if (Dir.y<0)
				#local Dir=-Dir;
			#end

			#declare VForce=VForce+vnormalize(Dir)*mechsim:viscoelastic(M_Array[Cnt]):force;
		#else
			//MechSim_Show_Con(M_Array[Cnt])

			#local Dir=mechsim:mass(mechsim:connection(M_Array[Cnt]):index2):position-
			           mechsim:mass(mechsim:connection(M_Array[Cnt]):index1):position;

			#if (Dir.y<0)
				#local Dir=-Dir;
			#end

			#declare VForce=VForce+vnormalize(Dir)*mechsim:connection(M_Array[Cnt]):force;
		#end

		#local Cnt=Cnt+1;
	#end

	#declare Force=VForce.y;

#end

#local Dist = mechsim:mass(mechsim:mass_count-1):position.y-mechsim:mass(0):position.y;

// ----------------------------------

// writing the measured values to text file

#if (frame_number<=1)
	#fopen FILE "hysteresis.txt" write
#else
	#fopen FILE "hysteresis.txt" append
#end

#write (FILE, Dist-Length, ", ", Force,", \n")

#fclose FILE

// and drawing the hysteresis curve

#debug concat("Force: ",str(Force,3,3),"\n")
#debug concat("Distance: ",str(Dist,3,3),"\n")

union {
	cylinder {
		<-1,0,0>, <1,0,0>, 0.012
		texture { pigment { color rgb 0 } }
	}
	cylinder {
		<0,-1,0>, <0,1,0>, 0.012
		texture { pigment { color rgb 0 } }
	}
	text {
		ttf "crystal.ttf",
		"x=strain",
		0.1, 0
		scale 0.12
		translate <-0.9,1.1,0>
		texture { pigment { color rgb 0 } }
	}
	text {
		ttf "crystal.ttf",
		"y=stress",
		0.1, 0
		scale 0.12
		translate <-0.9,0.9,0>
		texture { pigment { color rgb 0 } }
	}

	#fopen FILE "hysteresis.txt" read

	#while (defined(FILE))
		#read (FILE, XPos, YPos)
		sphere {
			<XPos*5, YPos/120000, 0>*0.5, 0.02
			texture {
				pigment { color rgb z }
			}
		}
	#end

	#fclose FILE
	scale 0.3
	translate 0.36*x
	no_shadow
}

// ----------------------------------
