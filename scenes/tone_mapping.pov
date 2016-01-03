// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)tone_mapping.pov
// Description: Demonstrates the tone mapping feature
// Features demonstrated: tone mapping
// Creation Date: $ 27 Feb 2005, 12:05:22 $
// Last modified: $ 14 Mar 2005, 20:59:01 $
// Author: Christoph Hormann <chris_hormann@gmx.de>
//
// Render instructions:
// --------------------
//
// To render the different tone mapping settings use something like:
//
// -w320 -h240 +a0.3 -j +kff7
//
// you can try different aa settings to see the effect on antialiasing

#version unofficial megapov 1.2;


#include "tone_mapping.inc"

global_settings {
	max_trace_level 10
	assumed_gamma 1

	radiosity {
		pretrace_start 0.08
		pretrace_end 0.01
		count 320

		nearest_count 5
		error_bound 0.5
		recursion_limit 1

		low_error_factor .5
		gray_threshold 0.0
		minimum_reuse 0.015
		brightness 1.0
		media on
	}
	
	#declare Exposure=1.6;
	#declare Exposure_Gain=1.0;
		
	#switch (frame_number)

		#case (0) #warning "Use '+kff7 to render all versions of this scene"
		#case (1)                       // no (linear) mapping				
			tone_mapping {
				function { x }
			}
		#break
		#case (2)                       // clipping			
			tone_mapping {
				function { min(1, x) }
			}
			// predefined macro in tone_mapping.inc:
			//Clip_Colors()
		#break
		#case (3)                       // exponential exposure	
			tone_mapping {
				function { Exposure_Gain - exp( -Exposure * x ) * Exposure_Gain }
			}
			// predefined macro in tone_mapping.inc:
			//Film_Exposure(Exposure, Exposure_Gain)
		#break
		#case (4)                       // exponential exposure with inversion
			tone_mapping {
				function { Exposure_Gain - exp( -Exposure * x ) * Exposure_Gain }
				inverse function { - ln(1 -min(0.9999, x/Exposure_Gain)) / Exposure }
			}
			// predefined macro in tone_mapping.inc:
			//Film_Exposure_Invert(Exposure, Exposure_Gain)
		#break
		#case (5)                       // exponential exposure with numerical inversion
			tone_mapping {
				function { Exposure_Gain - exp( -Exposure * x ) * Exposure_Gain }
				inverse 1000
			}
		#break
		#case (6)                       // inversion	
			tone_mapping {
				function { 1 - min(1, x) }
			}
		#break
		#case (7)                       // brightness/contrast adjustment
			Brightness_Contrast(-0.3, 0.8)
		#break
	#end

}

camera {
	location    <-0.95, 0.5, 0.4>
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <0, 0, -0.1>
	angle       76
}

light_source {
	<3, 5.1, 2>*100000
	color rgb <2.0, 1.5, 1.0>*10
}

light_source {
	-0.3*z
	color rgb <0.3, 0.5, 1.2>*10
	fade_power 2
	fade_distance 0.5
}

sky_sphere {
	pigment {
		color rgb <0.6,0.7,1.0>*2
	}
}

#declare Tex_Env=
			texture {
				pigment { color rgb <1.0, 0.95, 0.85> }
				finish { ambient 0.0 diffuse 0.65 }
			}

#declare Tex_Obj=
			texture {
				pigment { color rgb <0.4, 0.5, 1.0> }
				finish { ambient 0.0 diffuse 0.6 }
			}

#declare Window_Size=0.3;

difference {
  box { -1.2, 1.2 }
	box { -1.0, 1.0 }
	box { <-2, -Window_Size, -Window_Size>, <2, Window_Size, Window_Size> }
	box { <-Window_Size, -2, -Window_Size>, <Window_Size, 2, Window_Size> }
	box { <-Window_Size, -Window_Size, -2>, <Window_Size, Window_Size, 2> }
	texture { Tex_Env }
	hollow on
}

difference {
	sphere { 0, 0.45 }
	sphere { 0, 0.4 }
	cylinder { -z, z, 0.1 }
	cylinder { -x, x, 0.1 }
	cylinder { -y, y, 0.1 }
	
	cylinder { -1, 1, 0.1 }
	cylinder { <-1, -1, 1>, <1, 1, -1>, 0.075 }
	cylinder { <-1, 1, -1>, <1, -1, 1>, 0.075 }
	cylinder { <1, -1, -1>, <-1, 1, 1>, 0.075 }
	
	cylinder { < 1,  1, 0>, <-1, -1, 0>, 0.05 }
	cylinder { < 1, -1, 0>, <-1,  1, 0>, 0.05 }
	cylinder { <-1,  1, 0>, < 1, -1, 0>, 0.05 }
	
	cylinder { < 1, 0,  1>, <-1, 0, -1>, 0.05 }
	cylinder { < 1, 0, -1>, <-1, 0,  1>, 0.05 }
	cylinder { <-1, 0,  1>, < 1, 0, -1>, 0.05 }
	
	cylinder { <0,  1,  1>, <0, -1, -1>, 0.05 }
	cylinder { <0,  1, -1>, <0, -1,  1>, 0.05 }
	cylinder { <0, -1,  1>, <0,  1, -1>, 0.05 }

	translate -0.3*z
	texture { Tex_Obj }
	hollow on
}


box { 
	-1.3, 1.3
	pigment { color rgbt <1,1,1,1> }
	interior {
		media {
			scattering { 5, 0.05 eccentricity 0.55 extinction 0.75 }
			method 3
			intervals 1
			samples 10
			aa_level 3
			aa_threshold 0.05   
		}
	}
	hollow on
}