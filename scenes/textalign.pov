// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)textalign.pov
// Description: demonstration of text alignment feature
// Features demonstrated:  Text alignments, noise_pigment
// Creation Date: $ 14 Dec 2002, 16:33:20 $
// Last modified: $ 14 Jun 2004, 22:40:33 $
// Author: René Smellenbergh
//
// @@ The added keywords allow to algn text relative to the origin. 
// @@ Horizontally left, center and right can be used. Vertically top, 
// @@ center and bottom are allowed.
//
// -w320 -h240 +a0.3

#version unofficial megapov 1.1;

global_settings { assumed_gamma 1.0 }

camera {
	location <0, 0, -11>
	up y*image_height right x*image_width
	look_at <0, 0, 0>
	angle 54
	rotate x*10
}

#declare Decimal =
union {
	text { ttf "crystal.ttf", "right",  1, <0.0, 0.0, 0.0>  h_align_right  translate x*-0.1 }
	text { ttf "crystal.ttf", ",",  0.5 <0.0, 0.0, 0.0>  h_align_center }
	text { ttf "crystal.ttf", "left",  0.5, <0.0, 0.0, 0.0>  h_align_left  translate x*0.1 }
	text { ttf "crystal.ttf", "0",  0.5, <0.0, 0.0, 0.0>  h_align_right  translate <-0.1, -1, 0> }
	text { ttf "crystal.ttf", ",",  0.5, <0.0, 0.0, 0.0>  h_align_center  translate <0, -1, 0> }
	text { ttf "crystal.ttf", "001",  0.5, <0.0, 0.0, 0.0>  h_align_left  translate <0.1, -1, 0> }
	text { ttf "crystal.ttf", "215",  0.5, <0.0, 0.0, 0.0>  h_align_right  translate <-0.1, -2, 0> }
	text { ttf "crystal.ttf", ",",  0.5, <0.0, 0.0, 0.0>  h_align_center  translate <0, -2, 0> }
	text { ttf "crystal.ttf", "5",  0.5, <0.0, 0.0, 0.0>  h_align_left  translate <0.1, -2, 0> }
	text { ttf "crystal.ttf", "10000",  0.5, <0.0, 0.0, 0.0>  h_align_right  translate <-0.1, -3, 0> }
	text { ttf "crystal.ttf", ",",  0.5, <0.0, 0.0, 0.0>  h_align_center  translate <0, -3, 0> }
	text { ttf "crystal.ttf", "312",  0.5, <0.0, 0.0, 0.0>  h_align_left  translate <0.1, -3, 0> }
}

#declare Outpig = 
pigment {
	average 
	pigment_map {
		[ 0.3  noise_pigment { 1, rgb 0.4, rgb 2 }]
		[ 0.7  rgb <0.731441, 1.000000, 0.098833>]
	}
}
box {
	min_extent(Decimal)-0.1, max_extent(Decimal)+0.1
	texture {
		pigment {
			object {
				Decimal translate z*-0.2
				pigment { Outpig }
//				pigment {rgb <0.731441, 1.000000, 0.098833>},
				pigment {rgb <0.407843, 0.278584, 1.000000>/2}
			}
		}
		finish { ambient 0 }
	}
	rotate y*20
	translate <3, 0, 1>
}

#declare Centered=
	text {
		ttf "crystal.ttf", "Centered",
		3, <0.0, 0.4, 0.0>
		h_align_center  v_align_center
		translate <0.1, -2, 0> 
	}
box {
	min_extent(Centered)-0.1, max_extent(Centered)+0.1
	texture {
		pigment {
			object {
				Centered translate z*-0.2
				rgb <0.731441, 1.000000, 0.098833>,
				rgb 0.0
			}
		}
		finish { ambient 0.1 }
	}
	rotate y*-25
	translate <-2, -min_extent(Centered).y, 3>
}
union {
	text {
		ttf "crystal.ttf", 	"Top"
		0.5, <0.0, 0.0, 0.0>
		h_align_center  v_align_top
		pigment {
			rgb <0.336889, 1.000000, 0.676387>
		}
		translate <0, 2.8, 0>
	}
	box {
		<-1, 2.8, -0.05>, <1, 2.85, 0.6>
		pigment { rgb 0.8 } 
	}
	rotate y*20
	translate <2.5, 0.3, -0.3>
}
union {
	text {
		ttf "crystal.ttf", 	"Bottom"
		0.3, <0.0, 0.0, 0.0>
		h_align_center  v_align_bottom
		pigment {
			rgb <0.336889, 1.000000, 0.676387>
		}
	}
	box {
		<-1.9, -0.05, -0.1>, <1.9, 0, 0.5>
		pigment { rgb 0.8 } 
	}
	rotate y*-45
	translate <-1.3, -0.3, -3.2>
}
light_source {
	<0.0, 500, -1000>
	rgb <1.000000, 1.000000, 1.000000>
}
light_source {
	<500, 0, 10>
	rgb 0.3
	shadowless
}
light_source {
	<-500, 0, 10>
	rgb 0.1
	shadowless
}
