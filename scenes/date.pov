// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)date.pov
// Description: Demo scene for the 'date' function
// Features demonstrated: Time and date functions
// Creation Date: $ 14 Dec 2002, 15:56:20 $
// Last modified: $ 15 Jun 2004, 10:35:21 $
// Author: Yvo Smellenbergh
//
// @@ The time and date function allow to retrieve time and date from the computer system and to use it as strings in your scene.
//
// -w320 -h240 +a0.3
	
#version unofficial MegaPov 1.1;

global_settings {
	assumed_gamma 1.0
}

camera {
	location <0.0, 0.0, -15>
	up y*image_height right x*image_width
	angle 60
	look_at <0.0, 0.0, 0.0>
}

light_source { <100, 1000, -5000> 	rgb 1.2 }

#declare Top=2;	
#declare Down= 0.9;
#declare Day=date("%A")
#declare Month=date("%B")
#declare Daynr=date("%d")
#declare Monthnr=date("%m")
#declare Year=date("%Y")

#declare Font="crystal.ttf"

text {
	ttf Font,
	concat("Time / date functions")
	0.1, <0.0, 0.0, 0.0>
	h_align_center
	texture {
		pigment {
			rgb <0.595438, 0.434028, 0.764752>
		}
	}
	translate y*(Top+(Down*1.5))
}

text {
	ttf Font,
	concat("This text was rendered on:")
	0.1, <0.0, 0.0, 0.0>
	h_align_center
	texture {
		pigment {
			rgb <0.369986, 0.514031, 0.910002>
		}
	}
	translate y*Top
}

text {
	ttf Font,
	concat(Month," ",Daynr," ",Year)
	0.1, <0.0, 0.0, 0.0>
	h_align_center
	texture {
		pigment {
			rgb <0.369986, 0.514031, 0.910002>
		}
	}
	translate y*(Top-Down*2)
}

text {
	ttf Font,
	concat("it was a ",Day)
	0.1, <0.0, 0.0, 0.0>
	h_align_center
	texture {
		pigment {
			rgb <0.369986, 0.514031, 0.910002>
		}
	}
	translate y*(Top-Down*3)
}



text {
	ttf Font,
	concat("at: ",date("%H:%M:%S")," (24h)")
	0.1, <0.0, 0.0, 0.0>
	h_align_center
	texture {
		pigment {
			rgb <0.369986, 0.514031, 0.910002>
		}
	}
	translate y*(Top-(Down*4))
}

text { 
	ttf Font,
	concat("or : ",date("%I:%M:%S %p"))
	0.1, <0.0, 0.0, 0.0>
	h_align_center
	texture {
		pigment {
			rgb <0.369986, 0.514031, 0.910002>
		}
	}
	translate y*(Top-(Down*5))
}


text {
	ttf Font,
	concat("timezone: ",date("%z"))
	0.1, <0.0, 0.0, 0.0>
	h_align_center
	texture {
		pigment {
			rgb <0.369986, 0.514031, 0.910002>
		}
	}
	translate y*(Top-(Down*6))
}

