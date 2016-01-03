// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)noisepig.pov
// Description: noise pigment demonstration scene
// Features demonstrated: Pigment 'noise_pigment'
// Creation Date: $ 26 Sep 2000, 16:18:02 $
// Last modified: $ 14 Jun 2004, 22:37:16 $
// Author: Chris Huff
//
// @@ This pigment isn't really a pattern. It is intended to add some noise to the image.
//
// -w320 -h240 +a0.3

#version unofficial megapov 1.1;

global_settings { assumed_gamma 1.0 }

camera {
	location <0, 3.5,-8>
	up y*image_height right x*image_width
	look_at <0, 3.5, 0>
	angle 54
}

light_source {<-20, 150, -100 > rgb 1}

box {
	<-4, 1.5, 0>, <-2, 5, 0>
	texture {
		pigment { noise_pigment {0, rgb -1, rgb 1} }
		finish { ambient 1 }
	}
	translate y*2
}

box {
	<-4,-5, 0>, <-2, 1.5, 0>
	texture {
		pigment { noise_pigment {0, rgb 0, rgb < 0.5, 0.5, 1>} }
		finish { ambient 1 }
	}
	translate y*2
}

box {
	<-1.95, 1.5, 0>, <-0.05, 5, 0>
	texture {
		pigment { noise_pigment {1, rgb 0, rgb 1} }
		finish { ambient 1 }
	}
	translate y*2
}

box {
	<-1.95,-5, 0>, <-0.05, 1.5, 0>
	texture {
		pigment { noise_pigment {1, rgb 0, rgb < 0.5, 1, 0.5>} }
		finish { ambient 1 }
	}
	translate y*2
}

box {
	< 0, 1.5, 0>, < 2, 5, 0>
	texture {
		pigment { noise_pigment {2, rgb 0, rgb 1} }
		finish { ambient 1 }
	}
	translate y*2
}

box {
	< 0,-5, 0>, < 2, 1.5, 0>
	texture {
		pigment { noise_pigment {2, rgb 0, rgb < 1, 0.5, 0.5>} }
		finish { ambient 1 }
	}
	translate y*2
}

box {
	< 2.05, 1.5, 0>, < 4, 5, 0>
	texture {
		pigment { noise_pigment {3, rgb 0, rgb 1} }
		finish { ambient 1 }
	}
	translate y*2
}

box {
	< 2.05,-5, 0>, < 4, 1.5, 0>
	texture {
		pigment { noise_pigment {3, rgb 0, rgb < 1, 0.5, 1>} }
		finish { ambient 1 }
	}
	translate y*2
}


