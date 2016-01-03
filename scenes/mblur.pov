// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)mblur.pov
// Description: motion blur demo
// Features demonstrated: motion blur
// Creation Date: $ 22 Mar 2005, 18:01:42 $
// Last modified: $ 20 Aug 2005, 09:07:50 $
// Author: Christoph Hormann <chris_hormann@gmx.de>
//
// @@ This scene demostrates the use of the motion blur
// @@ feature to emphasize motion in a still scene.
//
// -w320 -h240 +a0.3

#version unofficial megapov 1.2;

#include "glass.inc"
#include "shapes.inc"

global_settings {
	tone_mapping { function { min(1, x) } }
	assumed_gamma 1
	max_trace_level 9
	motion_blur 20, 0.1
}

camera {
  location    <5.8, 11, 3.2>
  direction   z
  sky         z
  up          z
  right       1.33333*x
  look_at     <0,0,-0.5>
  angle       36
  translate <-1.2, -5, 0>
}

#local Light_Pos=<-15, 12, 15>;

light_source {
  Light_Pos
  color rgb <1.3, 1.2, 1.1>
  area_light 2*x 2*y 6, 6 adaptive 2 jitter circular orient
}

sky_sphere {
  pigment {
    pigment_pattern {
      spherical
      poly_wave 6
      color_map { [0 rgb 0][1 rgb 1] }
      scale 3
      translate vnormalize(Light_Pos)
    }
    pigment_map {
      [0 gradient y
        color_map {
          [0.00 rgb <1.248, 1.080, 1.200>]
          [0.10 rgb <0.936, 0.840, 1.200>]
          [0.25 rgb <0.312, 0.360, 0.960>]
        }
      ]
      [0.9 color rgb <64, 48, 32>]
    }
  }
}


motion_blur {
	sphere {
		z*0.5, 0.5
		translate clock*2.5*x
		rotate -60*z
		material {
			texture {
				pigment { color rgbt 1 }
				finish { 
					ambient 0
					diffuse 0
					reflection {
						0, 1
						fresnel on
					}
					conserve_energy
				}
			}
			interior {
				I_Glass_Exp(0.15)
				fade_color <0.8, 0.65, 0>
			}
		}
	}
}

plane {
  z, 0
  texture {
    pigment {
      color rgb <0.2, 0.3, 0.8>
    }
    finish {
      diffuse 0.45
      ambient 0.05
    }
  }
}

#declare T_Metal=
	texture {
		pigment { color rgb 0.5 }
		finish {
			diffuse 0.2
			specular 0.05
			roughness 0.01
			ambient 0
				reflection {
					0.9
					metallic
				}
			conserve_energy
		}
		normal { bozo 0.06 scale 0.6 }
	}


union {
	#local Cnt=0;
	#while (Cnt<16)
		merge {
			difference {
				Round_Box_Merge(<-0.1, -0.6, 0>, <0.1, 0.6, 2.4>, 0.03)
				cylinder {
					<-0.11, 0, 0.6>, <0.11, 0, 0.6>, 0.4
				}
				cylinder {
					<-0.11, 0, 1.8>, <0.11, 0, 1.8>, 0.4
				}
			}
			torus {
				0.4, 0.1
				rotate 90*z
				translate 0.6*z
			}
			torus {
				0.4, 0.1
				rotate 90*z
				translate 1.8*z
			}
			translate Cnt*0.55*x
			rotate -Cnt*1.5*z
		}
		#local Cnt=Cnt+1;
	#end
	texture {
		T_Metal
	}
	scale 0.7
	translate 1.3*x
	rotate -60*z
}
