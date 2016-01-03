// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)projection.pov
// Description: projection pattern demonstration
// Features demonstrated: projection pattern
// Creation Date: $ 13 Jun 2004, 15:05:15 $
// Last modified: $ 13 Jul 2004, 22:37:12 $
// Author: Christoph Hormann <chris_hormann@gmx.de>
//
// -w320 -h240 +a0.3

#version unofficial megapov 1.1;

global_settings {
	max_trace_level 10
	assumed_gamma 1
}

camera {
	location    <4, 7.2, 6.6>
	direction   y
	sky         z
	up          z
	right       (4/3)*x
	look_at     <0, 0, 0>
	angle       42
}

light_source {
	<3, 2.5, 1.8>*100000
	color rgb <2.0, 1.5, 1.0>
}

sky_sphere {
	pigment {
		gradient z
		pigment_map {
			[0.0 rgb <0.75,0.85,1.0>]
			[0.1 
				granite
				color_map {
					[0.2 color rgb 1 ]
					[0.5 color rgb <0.45,0.65,1.0> ]
					[0.8 color rgb <0.3,0.45,1.0> ]
				}
				scale 2*<1,1,0.3>
			]
		}
	}
}

#include "functions.inc"

#declare fn_Shape=
	function {
		f_torus(x, z, y, 1.75, 0.1)
	}

#declare fn_Displace=
	function {
		pattern {
			bozo
			poly_wave 1.4
			warp {
				turbulence <0.25,0.25,0.7>
				omega 0.55
				octaves 7
			}
			translate -12
		}
	}

#declare Shape=
isosurface {
	function {
		fn_Shape(x, y, z)
		- fn_Displace(x, y, z)*1.5
	}

	max_gradient 7

	contained_by { box { <-2.6, -2.6, -1>, <2.6, 2.6, 1.3> } }
}

#declare Tex_Metal=
	texture {
		pigment { color rgb <1, 0.5, 0.1>*0.65 }
		finish {
			diffuse 0.2
			ambient 0
			reflection {
				0.9
				metallic
			}
			specular 0.7
			metallic
			roughness 0.03
			conserve_energy
		}
	}

#declare Tex_Corrosion=
	texture {
		pigment { color rgb <0.2,0.8,0.3> }
		finish {
			diffuse 0.25
			ambient 0
			reflection {
				0.3
				metallic
			}
			specular 0.2
			roughness 0.03
			conserve_energy
		}
	}

#declare Tex_Obj=
	texture {
		projection {
			Shape
			normal on
			blur 0.6, 10
		}
		texture_map {
			[0 Tex_Metal ]
			[1 Tex_Corrosion ]
		}
	}

object {
	Shape
	texture { Tex_Obj }
}

plane {
	z, -0.8
	texture {
		pigment {
			checker
			color rgb <0.04, 0.05, 0.1>
			color rgb <0.9, 0.95, 1>
		}
		finish {
			ambient 0
			diffuse 0.85
			specular 0.2
			
			metallic
			reflection {
				0.4
				metallic
			}
			conserve_energy	
		}
	}
}




