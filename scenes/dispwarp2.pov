// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)dispwarp2.pov
// Description: Demo scene for the displace warp
// Features demonstrated: Displacement warp
// Creation Date: $ 5 Sep 2000, 16:00:21 $
// Last modified: $ 15 Jun 2004, 00:41:58 $
// Author: Chris Huff
// Update: René Smellenbergh
//
// -w320 -h240 +a0.3

#version unofficial megapov 1.1;

global_settings {
	assumed_gamma 1.0
}

camera {
	location <0, 0,-28>
	up y*image_height right x*image_width
	angle 25
	look_at <0, 0, 0>
}

//*******  Controls row 1  *************************************
#declare controlPgmt1 =
pigment {
	spherical  //waves
	poly_wave 2
	color_map {
		[0 color rgb 0]
		[1 color rgb 1]
	}
}
//*******  Controls row 2  *************************************
#declare controlPgmt2 =
pigment {
	crackle//bozo
	poly_wave 2
	color_map {
		[0 color rgb 0]
		[1 color rgb 1]
	}
}
//*******  Controls row 3  *************************************
#declare controlPgmt3 =
pigment {
	wrinkles  //granite
	poly_wave 2
	color_map {
		[0 color rgb 0]
		[1 color rgb 1]
	}
}
//*******  FIRST COLUMN: base = gradient y   ************************
box {
	<-2,-1.5, 0>, < 2, 1.5, 0.1>
	texture {
		pigment {
			gradient y frequency 10
			color_map {[0 rgb 0][1 rgb 1]}
			warp { displace {controlPgmt1} }
		}
		finish {ambient 1}
	}
	translate <-2*2, 1.5*2, 0>
}
box {
	<-2,-1.5, 0>, < 2, 1.5, 0.1>
	texture {
		pigment {
			gradient y frequency 10
			color_map {[0 rgb 0][1 rgb 1]}
			warp { displace {controlPgmt2} }
		}
		finish {ambient 1}
	}
	translate <-2*2, 0, 0>
}
box {
	<-2,-1.5, 0>, < 2, 1.5, 0.1>
	texture {
		pigment {
			gradient y frequency 10
			color_map {[0 rgb 0][1 rgb 1]}
			warp { displace {controlPgmt3} }
		}
		finish {ambient 1}
	}
	translate <-2*2, -1.5*2, 0>
}
//*******  	SECOND COLUMN: base = onion  *********************
box {
	<-2,-1.5, 0>, < 2, 1.5, 0.1>
	texture {
		pigment {
			onion frequency 5
			color_map {[0 rgb 0][1 rgb 1]}
			warp { displace {controlPgmt1} }
		}
		finish {ambient 1}
	}
	translate <0, 1.5*2, 0>
}
box {
	<-2,-1.5, 0>, < 2, 1.5, 0.1>
	texture {
		pigment {
			onion frequency 5
			color_map {[0 rgb 0][1 rgb 1]}
			warp { displace {controlPgmt2} }
		}
		finish {ambient 1}
	}
	translate <0, 0, 0>
}
box {
	<-2,-1.5, 0>, < 2, 1.5, 0.1>
	texture {
		pigment {
			onion frequency 5
			color_map {[0 rgb 0][1 rgb 1]}
			warp { displace {controlPgmt3} }
		}
		finish {ambient 1}
	}
	translate <0, -1.5*2, 0>
}
//*******  	THIRD COLUMN: base = crackle  *********************
box {
	<-2,-1.5, 0>, < 2, 1.5, 0.1>
	texture {
		pigment {
			crackle frequency 10
			color_map {[0 rgb 0][1 rgb 1]}
			warp { displace {controlPgmt1} }
		}
		finish {ambient 1}
	}
	translate <2*2, 1.5*2, 0>
}
box {
	<-2,-1.5, 0>, < 2, 1.5, 0.1>
	texture {
		pigment {
			crackle frequency 10
			color_map {[0 rgb 0][1 rgb 1]}
			warp { displace {controlPgmt2} }
		}
		finish {ambient 1}
	}
	translate <2*2, 0, 0>
}
box {
	<-2,-1.5, 0>, < 2, 1.5, 0.1>
	texture {
		pigment {
			crackle frequency 10
			color_map {[0 rgb 0][1 rgb 1]}
			warp { displace {controlPgmt3} }
		}
		finish {ambient 1}
	}
	translate <2*2, -1.5*2, 0>
}
