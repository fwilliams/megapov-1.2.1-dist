// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)pat_aoi.pov
// Description: demo scene for aoi pattern
// Features demonstrated: aoi pattern
// Creation Date: $ 13 Jun 2004, 14:28:44 $
// Last modified: $ 14 Jun 2004, 22:36:36 $
// Author: Christoph Hormann <chris_hormann@gmx.de>
//
// -w320 -h240 +a0.3 +kff2

#version unofficial megapov 1.1;

// ----------------------------------------

// Variant 1: no point (camera)
// Variant 2: point

#if (!clock_on)
	#debug "This scene should be rendered as an animation with 2 frames\n"
	#debug "to render all variants of the pattern demonstration.\n"
#end
	
#declare Variant=frame_number;

// ----------------------------------------

global_settings {
  max_trace_level 10
  assumed_gamma 1
	
	radiosity {
		pretrace_start 0.08
		pretrace_end 0.01
		count 120

		nearest_count 5
		error_bound 0.6
		recursion_limit 1

		low_error_factor .5
		gray_threshold 0.0
		minimum_reuse 0.015
		brightness 1

		adc_bailout 0.01/2
	}	
}

camera {
  location    <1.5, -5, 2.9>
  direction   y
  sky         z
  up          z
  right       (4/3)*x
  look_at     <0, 0, 0.55>
  angle       60
}

light_source {
  <3, -1, 2>*100000
  color rgb <2.0, 1.5, 1.0>*1.8
}

// ----------------------------------------

#declare Shape=
	union {
		plane {
			z, 0
		}
		sphere { 0, 1 scale <0.2, 0.2, 1> }
		
		#local Az=0;
		
		#while (Az<360)
			
			#local El=-20;
			
			#while (El<90)
				
				union {
					cylinder { 0, x*1.7, 0.15 }
					sphere { x*1.7, 0.15 }
					rotate -El*y
					rotate Az*z
					translate 0.5*z
				}
				#local El=El+25;
			#end
			
			torus { 1.7, 0.1 rotate Az*z translate 0.5*z }
			
			#local Az=Az+30;
		#end
	}


#declare Tex_Obj=
	texture {
		pigment {
			aoi
			#switch (Variant)
				#case (2)
					<3, 1, 3>
					color_map {
						[0 color rgb <1.0,0.8,0.5>]
						[0.8 color rgb <0.15,0.25,0.9>]
					}
				#break
			#else
      color_map {
        [0 color rgb <1.0,0.8,0.5>]
        [0.5 color rgb <0.15,0.25,0.9>]
      }				
			#end
    }
    finish {
      ambient 0
      diffuse 0.7
			specular 0.16
    }
  }

object {
  Shape
  texture { Tex_Obj }
}




