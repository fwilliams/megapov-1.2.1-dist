// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)area_light_refl.pov
// Desciption: demo scene for area light max_trace_level patch
// Features demonstrated: area light max_trace_level
// Creation Date: $ 13 Jun 2004, 14:28:44 $
// Last modified: $ 20 May 2005, 14:43:17 $
// Author: Christoph Hormann
//
// @@ This scene shows how the area light max_trace_level patch
// @@ can be used to speed up renders of scenes using area lights
// @@ and reflection.
//
// -w320 -h240 +a0.3 +kff2

#version unofficial megapov 1.2;

// ----------------------------------------

// Variant 1: normal
// Variant 2: no alrea light in reflection

#if (!clock_on)
	#debug "This scene should be rendered as an animation with 2 frames\n"
	#debug "to render all variants of the patch demonstration.\n"
#end
	
#declare Variant=frame_number;

// ----------------------------------------

global_settings {
	max_trace_level 10
	assumed_gamma 1
}

camera {
	location    <6, -12, 2.8>
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <0, 0, 0.4>
	angle       50
}

light_source {
	<5, 0.5, 2>*500
	color rgb <2.0, 1.5, 1.0>*1.8
  area_light 500*z 500*y  9,9 jitter adaptive 1 circular orient
	#if (Variant>1)
		max_trace_level 1
	#end
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


#declare Tex_Metal=
	texture {
		pigment { rgbt <0.2, 0.2, 0.3, 0.5> }
		finish {
			diffuse 0.22
			ambient 0
			reflection {
				0.4, 1.0
				fresnel on
				metallic on
			}
			conserve_energy
			specular 0.4
			roughness 0.03
		}
		normal {
			bozo 0.4
			scale 0.1
		}
	}

#declare Tex_Obj=
	texture {
		pigment {
			color rgb <1.0,0.8,0.5>
		}
		finish {
			ambient 0
			diffuse 0.65
			specular 0.16
		}
	}

#declare Tex_Obj2=
	texture {
		pigment {
			color rgb <1.0,0.8,0.5>
		}
		finish {
			ambient 0
			diffuse 0.3
		}
	}

plane {
	z, 0
	texture {
		Tex_Metal
	}
	interior { 
		ior 1.3 
		fade_color <0.2, 0.3, 0.35>
		fade_distance 3
		fade_power 1001
	}
}

plane {
	z, -6
	texture {
		Tex_Obj2
	}
}


box {
	<-1, -4, -6.1>, <-0.8, 4, 4>
	texture {
		Tex_Obj
	}
}

julia_fractal {
  <-0.13,0.41,-0.61,0.25>
  quaternion
  cube
  max_iteration 9
  precision 150	
	texture {
		Tex_Obj
	}
	scale 1.6

	rotate 90*z
	translate <2, 0, 2>
}
