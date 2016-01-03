// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)pat_proj.pov
// Description: demo scene for projection pattern
// Features demonstrated: projection pattern
// Creation Date: $ 13 Jun 2004, 14:28:44 $
// Last modified: $ 14 Jun 2004, 22:37:19 $
// Author: Christoph Hormann <chris_hormann@gmx.de>
//
// -w320 -h240 +a0.3 +kff6

#version unofficial megapov 1.1;

// ----------------------------------------

// Variant 1: parallel
// Variant 2: point
// Variant 3: parallel with blur
// Variant 4: point with blur
// Variant 5: normal
// Variant 6: normal with blur

#if (!clock_on)
	#debug "This scene should be rendered as an animation with 6 frames\n"
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
	location    <1.5, -5, 2.8>
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <0, 0, 0.4>
	angle       60
}

light_source {
	<3, -1, 2>*100000
	color rgb <2.0, 1.5, 1.0>*1.8
}



sky_sphere {
	pigment {
		gradient z
		color_map {
			[0.0 rgb <0.7,0.8,1.0>]
			[0.3 rgb <0.0,0.1,0.8>]
		}
	}
}

// ----------------------------------------

#declare Shape=
	union {
		plane {
			z, 0
		}
		sphere { 0, 1 scale <0.2, 0.2, 1> translate 1.0*z }
		sphere { 0, 1 scale <0.5, 0.5, 1> }
		sphere { 0, 1 scale <1, 1, 0.2> translate 1.5*z }	
		cylinder { <-1.5,0,1.5>, <1.5,0,1.5>, 0.1 }
		cylinder { <0,-1.5,1.5>, <0,1.5,1.5>, 0.1 }
		cylinder { <0,-1.5,1.5>, <0,-2.5,-0.5>, 0.1 }
		cylinder { <0,1.5,1.5>, <0,2.5,-0.5>, 0.1 }
		cylinder { <-1.5,0,1.5>, <-2.5,0,-0.5>, 0.1 }
		cylinder { <1.5,0,1.5>, <2.5,0,-0.5>, 0.1 }
		torus { 1.5, 0.13 rotate 90*x translate 1.5*z }
		sphere { 0, 0.75 scale <0.5, 0.5, 1> translate 1.2*<1,1,0> }
		sphere { 0, 0.75 scale <0.5, 0.5, 1> translate 1.2*<-1,1,0>}
		sphere { 0, 0.75 scale <0.5, 0.5, 1> translate 1.2*<1,-1,0>}
		sphere { 0, 0.75 scale <0.5, 0.5, 1> translate 1.2*<-1,-1,0>}
	}


#declare Tex_Obj=
	texture {
		pigment {

			projection {
				Shape
				
				#switch (Variant)
					#case (1)
						parallel z
					#break
					#case (2)
						point <4, 1, 4>
					#break
					#case (3)
						parallel z
						blur 0.1, 10
					#break
					#case (4)
						point <4, 1, 4>
						blur 0.1, 10
					#break
					#case (5)
						normal on
					#break
					#case (6)
						normal on
						blur 0.1, 10
					#break
					#else
						parallel z
				#end
			}

			color_map {
				[0 color rgb <1.0,0.8,0.5>]
				[1 color rgb <0.15,0.25,0.9>]
			}
		}
		finish {
			ambient 0
			diffuse 0.65
			specular 0.16
		}
	}

object {
	Shape
	texture { Tex_Obj }
}




