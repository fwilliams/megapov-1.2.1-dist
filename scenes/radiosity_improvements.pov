// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)radiosity_improvements.pov
// Desciption: demonstration of radiosity improvements
// Features demonstrated: radiosity improvements
// Creation Date: $ 13 Feb 2005, 21:29:46 $
// Last modified: $ 20 May 2005, 15:46:04 $
// Author: Christoph Hormann
//
// @@ Demonstrates some of the radiosity improvements in MegaPOV.
// @@ Variant 1 is without any of the patches.
// @@ Variant 2 uses the new adaptive pretrace 1.
// @@ Variant 3 uses the new adaptive pretrace 2.
// @@ Variant 4 uses the adaptive error_bound.
// @@ Variant 5 shows sample point visualization.
// @@ Variant 6 shows low count visualization.
//
//
// -w640 -h480 +a0.0 +am1 +r3 -j +kff6
//

#version unofficial megapov 1.2;

// ----------------------------------------

// Variant 1: standard radiosity
// Variant 2: adaptive pretrace 1
// Variant 3: adaptive pretrace 2
// Variant 4: adaptive error_bound
// Variant 5: sample point visualization
// Variant 6: low count visualization

#if (!clock_on)
	#debug "This scene should be rendered as an animation with 6 frames\n"
	#debug "to render all variants of the radiosity demonstration.\n"
#end

#ifndef (Variant)
	#declare Variant=frame_number;
#end

// ----------------------------------------

#declare PRETRACE_END=2/image_width;
#declare REC=1;
#declare ASO=1;
#declare COUNT=150;
#declare ERROR_BOUND=0.15;
#declare EB_ADAPTIVE=1.5;
#declare EB_MAX=20;
#declare SHOW_SAMPLE_RADIUS=0.01;

// ----------------------------------------

global_settings {
	assumed_gamma 1
	max_trace_level 20

	radiosity {
		pretrace_start 1
		pretrace_end PRETRACE_END

		#if (Variant=2)
			adaptive 1
		#end
		#if (Variant=3)
			adaptive 2
		#end
		// necessary because radiosity settings do not get reset after every frame
		#if (Variant>3)
			adaptive 0
		#end

		#if (Variant=4)
			error_bound { ERROR_BOUND adaptive EB_ADAPTIVE, EB_MAX }
		#else
			error_bound ERROR_BOUND
		#end

		count COUNT
		recursion_limit REC

		#if (ASO>0)
			always_sample off
		#end

		#if (Variant=5)
			show_samples SHOW_SAMPLE_RADIUS, color rgb <200,-200,-200>
		#end
		#if (Variant=6)
			// necessary (see above)
			show_samples 0
			show_low_count color rgb <0,0,4>, color rgb <4,0,4>
		#end
	}
}

camera {
	location    <0.0, -2.5, 0.8>
	direction   y
	sky         z
	up          z
	right       1.3333333*x
	look_at     <0.0, 0.0, 0.65>
	angle       60
}

// ----------------------------------------

#declare Light_Pos=<-2.2, -1.0, 2.5>;

light_source {
	Light_Pos
	color rgb <2.0, 1.5, 1.0>*2
}

// ----------------------------------------

#local Length=2.8;
#local Width=0.9;
#local Height=2.1;

box {
	<-abs(Light_Pos.x)-0.9, -Length-0.2, -0.1>, <abs(Light_Pos.x)+0.9, Length+0.2, abs(Light_Pos.z)+0.15>
	texture{
		pigment { color rgb 1 }
		finish  { ambient 0.0 diffuse 1 }
	}
}

#include "shapes.inc"

union {
	difference {
		box { <Width+0.1, -Length-0.1, -0.1>, <Width, Length+0.1, Height+0.1> }
		box { <Width-0.1, -0.6, -0.1>, <Width+0.2, 0.6, Height-0.9> }
		texture {
			pigment { color rgb <0.9, 0.36, 0.3> }
			finish  { ambient 0.0 diffuse 1 }
		}
	}
	box { <-1.5, -Length-0.1, -0.5>, <Width+2, Length+0.1, 0.0> }
	box {
		<-1.5, -Length-0.1, Height>, <Width+2.1, Length+0.1, Height+0.1>
	}

	union {
		box { <-1.5, -Length-0.1, -0.5>, <Width+0.1, -Length, Height+0.1> }
		box { <-1.5,  Length+0.1, -0.5>, <Width+0.1,  Length, Height+0.1> }
		texture {
			pigment { color rgb 0.6 }
			finish  { ambient 0.0 diffuse 1 }
		}
	}

	difference {
		box { <-Width, -Length-0.1, -0.1>, <-Width-0.1, Length+0.1, Height+0.1> }
		box { <-Width+0.1, -Length+2.2, Height-0.5>, <-Width-0.2, Length-0.4, 0.6> }
		box { <-Width+0.1, -0.6, -0.1>, <-Width-0.2, 0.0, 0.2> }
	}

	box {
		<-Width-0.2, 0.2, -0.5>, <-Width+0.2, 0.4, Height+0.1>
		texture {
			pigment { color rgb <0.9, 0.36, 0.3> }
			finish  { ambient 0.0 diffuse 1 }
		}
	}

	object {
		Round_Cylinder_Union ( <0,0, -0.5>, <0,0, Height-1.2>, 0.3, 0.05 )
		texture {
			pigment { color rgb <0.3, 0.9, 0.36> }
			finish  { ambient 0.0 diffuse 0.7 }
		}
		translate <-Width+0.45, 1.8, 0>
	}

	texture {
		pigment { color rgb <0.3, 0.36, 0.9> }
		finish  { ambient 0.0 diffuse 1 }
	}
}

