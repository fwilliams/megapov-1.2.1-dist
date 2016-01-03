// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)dispwarp.pov
// Description: Demo scene for the displace warp
// Features demonstrated: Displacement warp
// Creation Date: $ 26 Sep 2000, 15:58:20 $
// Last modified: $ 15 Jun 2004, 00:38:53 $
// Author: René Smellenbergh
//
// @@ The displace warp distorts a pattern by moving each point by the value of the color vector of the
// @@ displacing pigment at that point. The displacing pigment isn't used for colors, but for vectors.
// @@ The rgb values are used for xyz values for translating each point of the pattern being warped.
//
// -w320 -h240 +a0.3

#version unofficial megapov 1.1;

camera {
	location <0.0, 0.0, -5>
	up y*image_height right x*image_width
	look_at <0.0, 0.0, 0.0>
	angle 40
}

light_source { <1500, 3000, -8000> rgb 1.0 }
light_source { <0, 0, -5> rgb 0.5 shadowless } //fill light

//********* Left box with a hexagon pattern, displaced by a spiral pattern *********
box {
	<-0.5, -0.5, -0.5>, <0.5, 0.5, 0.5>
	texture {
		pigment {
			hexagon
			rgb <0.090196, 0.400000, 0.764706>,
			rgb <0.972549, 0.254902, 0.200000>,
			rgb <0.956863, 0.870588, 0.533333>
			scale 0.1
			ramp_wave
			warp {
				displace {
					spiral2 3
					color_map { [ 0.0 rgb 0 ] [ 1.0 rgb 1 ] }
					scale 2
					turbulence <0.2, 0.0, 0.0>
				}
			}
			translate x*-0.3
		}
	}
	rotate <-20, -35, 0>
	translate <-0.8, 0, -0.5>
}

//********* Right box with a hexagon pattern, displaced by a spiral pattern *********
// same as left box, but with a different wave_type
box {
	<-0.5, -0.5, -0.5>, <0.5, 0.5, 0.5>
	texture {
		pigment {
			hexagon 
			rgb <0.090196, 0.400000, 0.764706>,
			rgb <0.972549, 0.254902, 0.200000>,
			rgb <0.956863, 0.870588, 0.533333>
			scale 0.1
			poly_wave 0.001
			warp {
				displace {
					spiral2 3
					color_map { [ 0.0 rgb 0 ] [ 1.0 rgb 1 ] }
					scale 2
					turbulence <0.2, 0.0, 0.0>
				}
			}
			translate x*-0.3
		}
	}
	rotate <-20, 35, 0>
	translate <0.8, 0, -0.5>
}

//************** Bottom with a gradient x pattern displaced by bumps and agate patterns *********
disc  {
	0, <0.0, 1, 0>, 10
	texture {
		pigment {
			gradient x
			color_map {
				[ 0.000 rgb <0.951934, 0.887221, 0.690501>*1.2 ]
				[ 1.000 rgb <0.403525, 0.287846, 0.091951>*2 ]
			}
			frequency 5
			scallop_wave
			warp {
				displace {
					bumps
					color_map { [ 0.0 rgb 0] [ 1.0 rgb 0.5 ] }
					cubic_wave
				}
			}
			warp {
				displace {
					agate
					color_map { [ 0.0 rgb 0.0] [ 0.8 rgb 0.7 ] [ 1.0 rgb 0.3 ]}
					scale 0.05
					poly_wave 0.05
				}
			}
		}
	}
	rotate x*-5
	translate <0, -0.5, 0>
}

//***************** Sky, using a displace_map to further change the gradient pattern *******
sky_sphere {
	pigment {
		gradient y
		color_map {
			[ 0.0 rgb <0.626993, 0.792508, 0.862654> ]
			[ 1 rgb <0.006622, 0.368414, 0.696941> ]
		}
		scale 0.1
		warp { turbulence 0.3}
		warp {
			displace {
				onion
				color_map { [ 0.0 rgb 0] [ 1.0 rgb 0.8 ] }
				poly_wave 0.01
			}
		}
	}
}

