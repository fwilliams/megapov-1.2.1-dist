// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)test_motion.pov
// Description: motion blur example
// Features demonstrated: motion_blur
// Creation Date: $ 14 Jun 2004, 16:29:12 $
// Last modified: $ 14 Jun 2004, 22:37:06 $
// Author: Yvo Smellenbergh
//
// -w320 -h240 +a0.3

#version unofficial MegaPov 1.1;

camera {
  location  <0.0, 0.5, -5.0>
  direction 1.5*z
  right     4/3*x
  look_at   <0.0, 0.0,  0.0>
}

light_source {
  0*x // light's position (translated below)
  color red 1.0  green 1.0  blue 1.0  // light's color
  translate <-30, 30, -30>
}

global_settings {
  assumed_gamma 1.0
	ambient_light rgb <0.5, 0.5, 0.5>
	charset utf8

	motion_blur 15,0.5016
}

box {
	<-0.5, -0.5, -0.5>, <0.5, 0.5, 0.5>
	material {
		texture{
			pigment {
				brick 
				rgb <0.8, 0.8, 0.8>,
				rgb <1.0, 0.0, 0.0>
				brick_size <8.0, 3.0, 4.5>
				mortar 0.5
				turbulence <0.05, 0.05, 0.0>
			}
			finish { ambient 1.0 }
		}
		scale <0.002, 0.002, 1.0>
	}
	scale <10, 10, 1>
	translate <1000, 0.0, 0.0>
}

background {
	rgb <0.093294, 0.543038, 0.615915>
}

motion_blur{
  type 1
  union{
    sphere { 0.0, 1}
    box{-1,1 scale .5 translate 1*y}
    texture {pigment {radial frequency 8} finish{specular 1}}
  }
  scale .6
  //translate x*clock
  translate y*clock
  translate x*-1.2
}

motion_blur{
  type 0
  union{
    sphere { 0.0, 1}
    box{-1,1 scale .5 translate 1*y}
    texture {pigment {radial frequency 8} finish{specular 1}}
  }
  scale .6

  scale 1+clock
}

motion_blur{
  type 1
  union{
    sphere { 0.0, 1}
    box{-1,1 scale .5 translate 1*y}
    texture {pigment {radial frequency 8} finish{specular 1}}
  }
  scale .6
  //translate x*clock
  translate -y*clock
  translate x*1.2
}
