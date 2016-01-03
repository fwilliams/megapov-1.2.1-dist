// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)tshirt.pov
// Description: mechanics simulation sample scene
// Features demonstrated: mechsim
// Creation Date: $ 14 Oct 2002, 16:55:14 $
// Last modified: $ 09 Aug 2005, 18:36:14 $
// Author: Christoph Hormann
//
// @@ This scene demonstrates the creation of more complicated
// @@ cloth shapes by combining rectangular patches with
// @@ connections.  Simulation is done with gradient descent
// @@ steps at the beginning and a following conventional
// @@ simulation.
//
// -w320 -h240 +a0.3 -j +kff15

#version unofficial megapov 1.2;

#include "mechsim.inc"

// ----------------------------------------

#declare Obj=
	blob {
		threshold 0.6

		cylinder { < 0.4, 0.0, -1.9>,  < 0.1, 0.0, 1.5>, 0.2, 1.0 }
		cylinder { <-0.4, 0.0, -1.9>,  <-0.1, 0.0, 1.5>, 0.2, 1.0 }

		cylinder { < 2.0, 0.0, -0.4>,  < 0.1, 0.0, 0.8>, 0.2, 1.0 }
		cylinder { <-2.0, 0.0, -0.4>,  <-0.1, 0.0, 0.8>, 0.2, 1.0 }

		rotate 90*z
	}


#declare Grid_Const=0.06;
#declare Body_Grid_CntX=25;
#declare Body_Grid_CntY=28;
#declare Arm_Grid_CntX=14;
#declare Arm_Grid_CntY=10;

#declare Trans1 =
	transform {
		rotate 90*y
		translate 0.8*z
		translate -(Body_Grid_CntX*0.5)*<Grid_Const, Grid_Const, 0>

		translate 0.6*x
	}

#declare Trans2 =
	transform {
		transform { Trans1 }
		translate -Arm_Grid_CntX*Grid_Const*y
		translate 0.2*y+0.15*z
		rotate 32*x
	}

#declare Trans3 =
	transform {
		transform { Trans1 }
		translate Body_Grid_CntX*Grid_Const*y
		translate -0.2*y+0.15*z
		rotate -32*x
	}


#declare Trans1a =
	transform {
		transform { Trans1 }
		translate 0.3*x
	}

#declare Trans2a =
	transform {
		transform { Trans2 }
		translate 0.3*x
	}

#declare Trans3a =
	transform {
		transform { Trans3 }
		translate 0.3*x
	}

// ----------------------------------------

global_settings {
	max_trace_level 10
	assumed_gamma 1

	mechsim {

		#if (file_exists("tshirt.dat") & (frame_number!=1))

			#if (frame_number<4)
				gravity -3.5*z
				method 4

				step_count 700
				time_step (1/30)/3000
      #else
				gravity <0, 0, -9.81>
				method 1

				step_count 1500
				time_step (1/30)/1500
			#end

			environment {
				object Obj
				stiffness 240000
				damping 9000
				friction 0.5, 1.001
				method 1
			}

			collision { off }

			topology {
				load_file "tshirt.dat"
				save_file "tshirt.dat"
			}
		#else
			step_count 0
			topology {

				#declare Stiff=13000;
				#declare Damp=1000;

				#declare Start_S1=mechsim:mass_count;
				MechSim_Generate_Patch_Std(<0, 0, 0>, 0.05, 4000, Stiff, Damp, true, <Grid_Const, Grid_Const>, <Body_Grid_CntY, Body_Grid_CntX>, Trans1, 2)
				
				#declare Start_A1A=mechsim:mass_count;
				MechSim_Generate_Patch_Std(<0, 0, 0>, 0.05, 4000, Stiff, Damp, true, <Grid_Const, Grid_Const>, <Arm_Grid_CntY, Arm_Grid_CntX>, Trans2, 2)

				#declare Start_A1B=mechsim:mass_count;
				MechSim_Generate_Patch_Std(<0, 0, 0>, 0.05, 4000, Stiff, Damp, true, <Grid_Const, Grid_Const>, <Arm_Grid_CntY, Arm_Grid_CntX>, Trans3, 2)

				#declare Start_S2=mechsim:mass_count;
				MechSim_Generate_Patch_Std(<0, 0, 0>, 0.05, 4000, Stiff, Damp, true, <Grid_Const, Grid_Const>, <Body_Grid_CntY, Body_Grid_CntX>, Trans1a, 2)

				#declare Start_A2A=mechsim:mass_count;
				MechSim_Generate_Patch_Std(<0, 0, 0>, 0.05, 4000, Stiff, Damp, true, <Grid_Const, Grid_Const>, <Arm_Grid_CntY, Arm_Grid_CntX>, Trans2a, 2)

				#declare Start_A2B=mechsim:mass_count;
				MechSim_Generate_Patch_Std(<0, 0, 0>, 0.05, 4000, Stiff, Damp, true, <Grid_Const, Grid_Const>, <Arm_Grid_CntY, Arm_Grid_CntX>, Trans3a, 2)

				#declare Start_Con=mechsim:connection_count;
				
				#declare Stiff=22000;
				#declare Damp=1000;
				#declare ZLen=0.03;

				// ------------------  body sides --------------------------------
				#local Cnt=Arm_Grid_CntY;
				#while (Cnt<Body_Grid_CntY)
					
					connection { Start_S1+Cnt, Start_S2+Cnt stiffness Stiff damping Damp length ZLen }
					connection { 
						Start_S1+((Body_Grid_CntX-1)*Body_Grid_CntY)+Cnt,
						Start_S2+((Body_Grid_CntX-1)*Body_Grid_CntY)+Cnt stiffness Stiff damping Damp length ZLen 
					}

					#local Cnt=Cnt+1;
				#end

				// ------------------  body top --------------------------------
				#local Cnt=0;
				#while (Cnt<7)

					connection { Start_S1+Cnt*Body_Grid_CntY, Start_S2+Cnt*Body_Grid_CntY stiffness Stiff damping Damp length ZLen }
					connection { 
						Start_S1+(Body_Grid_CntX*Body_Grid_CntY)-(Cnt+1)*Body_Grid_CntY,
						Start_S2+(Body_Grid_CntX*Body_Grid_CntY)-(Cnt+1)*Body_Grid_CntY stiffness Stiff damping Damp length ZLen 
					}

					#local Cnt=Cnt+1;
				#end

				// ------------------  arms --------------------------------
				#local Cnt=0;
				#while (Cnt<Arm_Grid_CntX)

					connection { Start_A1A+Cnt*Arm_Grid_CntY, Start_A2A+Cnt*Arm_Grid_CntY stiffness Stiff damping Damp length ZLen }
					connection { Start_A1B+Cnt*Arm_Grid_CntY, Start_A2B+Cnt*Arm_Grid_CntY stiffness Stiff damping Damp length ZLen }

					connection { 
						Start_A1A+Cnt*Arm_Grid_CntY+(Arm_Grid_CntY-1),
						Start_A2A+Cnt*Arm_Grid_CntY+(Arm_Grid_CntY-1) stiffness Stiff damping Damp length ZLen 
					}
					connection { 
						Start_A1B+Cnt*Arm_Grid_CntY+(Arm_Grid_CntY-1),
						Start_A2B+Cnt*Arm_Grid_CntY+(Arm_Grid_CntY-1) stiffness Stiff damping Damp length ZLen 
					}

					#local Cnt=Cnt+1;
				#end

				// ------------------  arms-body --------------------------------
				#local Cnt=0;
				#while (Cnt<Arm_Grid_CntY)

					connection { 
						Start_A1A+(Arm_Grid_CntY*(Arm_Grid_CntX-1))+Cnt,
						Start_S1+Cnt stiffness Stiff damping Damp length ZLen 
					}

					connection { 
						Start_A2A+(Arm_Grid_CntY*(Arm_Grid_CntX-1))+Cnt,
						Start_S2+Cnt stiffness Stiff damping Damp length ZLen 
					}

					connection { 
						Start_A1B+Cnt,
						Start_S1+((Body_Grid_CntX-1)*Body_Grid_CntY)+Cnt stiffness Stiff damping Damp length ZLen 
					}

					connection { 
						Start_A2B+Cnt,
						Start_S2+((Body_Grid_CntX-1)*Body_Grid_CntY)+Cnt stiffness Stiff damping Damp length ZLen 
					}

					#local Cnt=Cnt+1;
				#end

				connection { 
					Start_A2A+(Arm_Grid_CntY*Arm_Grid_CntX)-1,
					Start_S1+Arm_Grid_CntY-1 stiffness Stiff damping Damp length ZLen 
				}

				connection { 
					Start_A1A+(Arm_Grid_CntY*Arm_Grid_CntX)-1,
					Start_S2+Arm_Grid_CntY-1 stiffness Stiff damping Damp length ZLen 
				}

				connection { 
					Start_A1A+(Arm_Grid_CntY*(Arm_Grid_CntX-1)),
					Start_S2 stiffness Stiff damping Damp length ZLen 
				}

				connection { 
					Start_A2A+(Arm_Grid_CntY*(Arm_Grid_CntX-1)),
					Start_S1 stiffness Stiff damping Damp length ZLen 
				}


				connection { 
					Start_A1B+Arm_Grid_CntY-1,
					Start_S2+((Body_Grid_CntX-1)*Body_Grid_CntY)+Arm_Grid_CntY-1 stiffness Stiff damping Damp length ZLen 
				}

				connection { 
					Start_A2B+Arm_Grid_CntY-1,
					Start_S1+((Body_Grid_CntX-1)*Body_Grid_CntY)+Arm_Grid_CntY-1 stiffness Stiff damping Damp length ZLen 
				}

				connection { 
					Start_A1B,
					Start_S2+((Body_Grid_CntX-1)*Body_Grid_CntY) stiffness Stiff damping Damp length ZLen 
				}

				connection { 
					Start_A2B,
					Start_S1+((Body_Grid_CntX-1)*Body_Grid_CntY) stiffness Stiff damping Damp length ZLen 
				}

				save_file "tshirt.dat"
			}
		#end

	}
}

// ----------------------------------------

MechSim_Show_All_Default()

//#debug concat(str(Start_Con, 0, 0), "\n")
//#local Cnt=Start_Con;
#local Cnt=7246;

#while (Cnt<mechsim:connection_count)
	#local Dist = vlength(mechsim:mass(mechsim:connection(Cnt):index1):position-
	                      mechsim:mass(mechsim:connection(Cnt):index2):position);
	#if (Dist>0.0001)
		cylinder {
			mechsim:mass(mechsim:connection(Cnt):index1):position,
			mechsim:mass(mechsim:connection(Cnt):index2):position,

			mechsim:mass(mechsim:connection(Cnt):index1):radius*0.7

			texture { MSim_Tex_C }
		}
	#end

	#local Cnt=Cnt+1;
#end

// ----------------------------------------

camera {
	location    <11, -9, 4.5>
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <0, 0, 0>
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

object {
	Obj
	texture {
		pigment { color rgb <0.5, 0.45, 1.0>*0.8 }
		finish { ambient 0.05 diffuse 0.45 specular 0.2 }
	}
}


object {
	plane { z, -2 }

	texture {
		pigment { color rgb 1 }
		finish { ambient 0.05 diffuse 0.45 }
	}
}
