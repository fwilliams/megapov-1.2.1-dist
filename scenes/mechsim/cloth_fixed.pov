// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)cloth_fixed.pov
// Description: a cloth held at the corners
// Features demonstrated: mechsim
// Creation Date: $ 10 Mar 2005, 18:53:05 $
// Last modified: $ 11 May 2005, 13:41:11 $
// Author: Christoph Hormann
//
// @@ Demonstrates cloth simulation with the Mechsim patch
//
// -w320 -h240 +a0.3 -j +kff120

#version unofficial megapov 1.2;

#include "mechsim.inc"
#include "shapes.inc"

#declare Trans1 =
  transform {
    translate <-1, -1, 0>
    translate 1.79*z
		scale <1.04, 1.04, 1>
  }
					
#declare fn_Fixed=
	function { 
		((x<0.03) & (y<0.03)) | 
		((x>0.97) & (y>0.97)) | 
		((x<0.03) & (y>0.97)) | 
		((x>0.97) & (y<0.03)) 
	}

#declare Con_Array=array[3]
#declare Con_Array[0]=1;
#declare Con_Array[1]=1;
#declare Con_Array[2]=0.5;

// ----------------------------------

global_settings {
  max_trace_level 10
  assumed_gamma 1

  mechsim {
    gravity -9.81*z
    method 1
		bounding 1

		collision {
      2, 0, 0
      stiffness 32000
      damping 2500
      friction 0.1
    }

		step_count 2000
		time_step (1/30)/2000

		#if (file_exists("cloth_fixed.dat") & (frame_number!=1))

      topology {
				load_file "cloth_fixed.dat"
				save_file "cloth_fixed.dat"
      }

    #else

      topology {

				group {
					MechSim_Generate_Patch(<0, 0, 0>, 0.02, 320, 160, 8, true, <1, 1>/15, <31, 31>, Trans1, fn_Fixed, No_Attach, No_Force, Con_Array)
				}

				group {
					mass { <0, 0, 2.7>, <0.1,0,0>, 0.32 density 12000 }
				}

				save_file "cloth_fixed.dat"
      }

    #end

  }
}

// ----------------------------------

#declare Obj1=MechSim_Show_Patch(0, 31, 31, true, true, -1, "")

object {
	Obj1
	uv_mapping
	pigment {
		checker
		color rgb <0.05, 0.05, 0.1>
		color rgb <0.5, 0.7, 1.0>

		scale 0.05
	}
	finish {
		ambient 0.04
		diffuse 0.3
		specular 0.35
		reflection { 0.3 }
	}
}

MechSim_Show_Objects(mechsim:mass_count-1, mechsim:connection_count, mechsim:face_count, -1, -1, -1, -1, false, -1, "")

// ----------------------------------

camera {
  location    <9, -7, 7.8>
  direction   y
  sky         z
  up          z
  right       (4/3)*x
  look_at     <-0.8, 0.5, 0.6>
  angle       28
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
		Wire_Box(<1.2, 1.2, 0>, <1, 1, 1.8>, 0.03, true )
		Wire_Box(<-1.2, 1.2, 0>, <-1, 1, 1.8>, 0.03, true )
		Wire_Box(<1.2, -1.2, 0>, <1, -1, 1.8>, 0.03, true )
		Wire_Box(<-1.2, -1.2, 0>, <-1, -1, 1.8>, 0.03, true )
		texture {
			pigment {
				color rgb <1, 0.5, 0.1>
			}
			finish{
				diffuse 0.3
				ambient 0.0
				specular 0.6

				reflection {
					0.8
					metallic
				}

				conserve_energy
			}
		}
	}
  texture { T_Env }
}

// ----------------------------------
