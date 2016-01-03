// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)listed.pov
// Description: 'listed' pattern demonstration
// Features demonstrated: listed pattern
// Creation Date: $ 27 Sep 2000, 16:10:45 $
// Last modified: $ 14 Jun 2004, 22:37:56 $
// Author: René Smellenbergh
//
// @@ Listed picks the color, pigment, normal or texture at the specified location in the map. 
// @@ Using loops, textures can be taken from the map in different ways. The second and last rows 
// @@ are randomly picked from their map, the first and third in a linear way.
//
// -w320 -h240 +a0.3

#version unofficial MegaPov 1.1;

global_settings {
	assumed_gamma 1.0
}

camera {
	location <0.0, 0.0, -18>
	up y*image_height right x*image_width
	angle 40
	look_at <0.0, 0.0, 0.0>
}

light_source { <2000, 3000, -6000>  rgb 1.2 }

background { rgb <0.2, 0, 0> }

#declare PListA =
	color_map {
		[ 0.0 rgb <0.834806, 0.746777, 0.605188> ]
		[ 0.12 rgb <0.719982, 0.583948, 0.239994> ]
		[ 0.23 rgb <0.797894, 0.577569, 0.342077> ]
		[ 0.5 rgb <0.555993, 0.373999, 0.244007> ]
		[ 0.7 rgb <0.613184, 0.374868, 0.226795> ]
		[ 1.0 rgb <0.523568, 0.272648, 0.156405> ]
	}
#declare NListA =
	normal_map {
		[ 0.0 agate bump_size 0.8 scale 0.3 ]
		[ 0.5 granite 0.6 scale 0.5 ]
		[ 1.0 crackle ]
	}

box {
	<-5.5, -0.3, -0.5>, <5.5, 0.3, 0.5>
	texture {
		pigment {
			gradient x
			color_map { PListA }
		}
		normal {
			gradient x
			normal_map { NListA }
		}
		scale <11, 1, 1>
		translate x*-5.5
	}
	translate <0, 2, 0>
}
			
#local C = 0;
#local Copies = 12;

#while ( C < Copies)
	sphere {
		<0.0, 0.0, 0.0>, 0.5
		texture {
			pigment {
				listed (C/(Copies -1))
				color_map { PListA }
//					[ 0.0 rgb <0.834806, 0.746777, 0.605188> ]
//					[ 0.12 rgb <0.719982, 0.583948, 0.239994> ]
//					[ 0.23 rgb <0.797894, 0.577569, 0.342077> ]
//					[ 0.5 rgb <0.555993, 0.373999, 0.244007> ]
//					[ 0.7 rgb <0.613184, 0.374868, 0.226795> ]
//					[ 1.0 rgb <0.523568, 0.272648, 0.156405> ]
//				}
			}
			normal {
				listed (C/(Copies -1))
				normal_map { NListA }
//					[ 0.0 agate bump_size 0.8 scale 0.3 ]
//					[ 0.5 granite 0.6 scale 0.5 ]
//					[ 1.0 crackle ]
//				}
			}
			finish { phong 1.0  phong_size 500 }
		}
		translate x * (-5.5 + (C * (5.5 - (-5.5))/(Copies -1)))
		translate y * 3
	} //object
	#set C = C +1;
#end  //while (C < Copies)
	
#local C = 0;
#local Copies = 12;
#while ( C < Copies)
	sphere {
		<0.0, 0.0, 0.0>, 0.5
		texture {
			pigment {
				listed rand(seed(C))
				color_map { PListA }
//					[ 0.0 rgb <0.834806, 0.746777, 0.605188> ]
//					[ 0.12 rgb <0.719982, 0.583948, 0.239994> ]
//					[ 0.23 rgb <0.797894, 0.577569, 0.342077> ]
//					[ 0.5 rgb <0.555993, 0.373999, 0.244007> ]
//					[ 0.7 rgb <0.613184, 0.374868, 0.226795> ]
//					[ 1.0 rgb <0.523568, 0.272648, 0.156405> ]
//				}
			}
			normal {
				listed rand(seed(C))
				normal_map { NListA }
//					[ 0.0 agate bump_size 0.8 scale 0.3 ]
//					[ 0.5 granite 0.6 scale 0.5 ]
//					[ 1.0 crackle ]
//				}
			}
			finish { phong 1.0  phong_size 500 }
		}
		translate x * (-5.5 + (C * (5.5 - (-5.5))/(Copies -1)))
		translate y *1
	} //object
	#set C = C +1;
#end  //while (C < Copies)

#declare PListB =
	color_map {
		[ 0.0 rgb <0.976608, 0.951720, 0.763378> ]
		[ 0.12 rgb <0.946807, 0.810803, 0.773190> ]
		[ 0.23 rgb <0.955001, 0.751980, 0.744976> ]
		[ 0.5 rgb <0.909804, 0.650187, 0.810315> ]
		[ 0.7 rgb <0.700710, 0.682887, 0.897093> ]
		[ 0.8 rgb <0.618387, 0.811933, 0.901595> ]
		[ 1.0 rgb <0.591974, 0.928008, 0.731991> ]
	}

#declare NListB =
	normal_map {
		[ 0.0 agate bump_size 0.8 scale 0.3 ]
		[ 0.1 quilted 0.5 scale 0.3 ]
		[ 0.2 leopard 0.3 scale 0.1 ]
		[ 0.3 bozo 0.6 scale 0.1 ]
		[ 0.4 granite 0.6 scale 0.5 ]
		[ 0.5 marble 0.8 scale 0.2 turbulence 0.2 ]
		[ 0.6 granite 0.6 scale 0.5 ]
		[ 0.7 dents 0.6 scale 0.5 ]
		[ 0.8 wrinkles 0.6 scale 0.25 ]
		[ 0.9 ripples 1.2 scale 0.2 ]
		[ 1.0 crackle scale 0.5]
	}

box {
	<-5.5, -0.3, -0.5>, <5.5, 0.3, 0.5>
	texture {
		pigment {
			gradient x
			color_map { PListB }
		}
		normal {
			gradient x
			normal_map { NListB }
		}
		scale <11, 1, 1>
		translate x*-5.5
	}
	translate <0, -2, 0>
}

#local C = 0;
#local Copies = 12;
#while ( C < Copies)
	sphere {
		<0.0, 0.0, 0.0>, 0.5
		texture {
			pigment {
				listed (C/(Copies -1))
				color_map { PListB }
//					[ 0.0 rgb <0.976608, 0.951720, 0.763378> ]
//					[ 0.12 rgb <0.946807, 0.810803, 0.773190> ]
//					[ 0.23 rgb <0.955001, 0.751980, 0.744976> ]
//					[ 0.5 rgb <0.909804, 0.650187, 0.810315> ]
//					[ 0.7 rgb <0.700710, 0.682887, 0.897093> ]
//					[ 0.8 rgb <0.618387, 0.811933, 0.901595> ]
//					[ 1.0 rgb <0.591974, 0.928008, 0.731991> ]
//				}
			}
			normal {
				listed (C/(Copies -1))
				normal_map { NListB }
//					[ 0.0 agate bump_size 0.8 scale 0.3 ]
//					[ 0.1 quilted 0.5 scale 0.3 ]
//					[ 0.2 leopard 0.3 scale 0.1 ]
//					[ 0.3 bozo 0.6 scale 0.1 ]
//					[ 0.4 granite 0.6 scale 0.5 ]
//					[ 0.5 marble 0.8 scale 0.2 turbulence 0.2 ]
//					[ 0.6 granite 0.6 scale 0.5 ]
//					[ 0.7 dents 0.6 scale 0.5 ]
//					[ 0.8 wrinkles 0.6 scale 0.25 ]
//					[ 0.9 ripples 1.2 scale 0.2 ]
//					[ 1.0 crackle scale 0.5]
//				}
			}
			finish { phong 1.0  phong_size 500 }
		}
		translate x * (-5.5 + (C * (5.5 - (-5.5))/(Copies -1)))
		translate y *-1
	} //object
	#set C = C +1;
#end  //while (C < Copies)

#local C = 0;
#local Copies = 12;
#while ( C < Copies)
	sphere {
		<0.0, 0.0, 0.0>, 0.5
		texture {
			pigment {
				listed rand(seed(C))
				color_map { PListB }
//					[ 0.0 rgb <0.976608, 0.951720, 0.763378> ]
//					[ 0.12 rgb <0.946807, 0.810803, 0.773190> ]
//					[ 0.23 rgb <0.955001, 0.751980, 0.744976> ]
//					[ 0.5 rgb <0.909804, 0.650187, 0.810315> ]
//					[ 0.7 rgb <0.700710, 0.682887, 0.897093> ]
//					[ 0.8 rgb <0.618387, 0.811933, 0.901595> ]
//					[ 1.0 rgb <0.591974, 0.928008, 0.731991> ]
//				}
			}
			normal {
				listed rand(seed(C))
				normal_map { NListB }
//					[ 0.0 agate bump_size 0.8 scale 0.3 ]
//					[ 0.1 quilted 0.5 scale 0.3 ]
//					[ 0.2 leopard 0.3 scale 0.1 ]
//					[ 0.3 bozo 0.6 scale 0.1 ]
//					[ 0.4 granite 0.6 scale 0.5 ]
//					[ 0.5 marble 0.8 scale 0.2 turbulence 0.2 ]
//					[ 0.6 granite 0.6 scale 0.5 ]
//					[ 0.7 dents 0.6 scale 0.5 ]
//					[ 0.8 wrinkles 0.6 scale 0.25 ]
//					[ 0.9 ripples 1.2 scale 0.2 ]
//					[ 1.0 crackle scale 0.5]
//				}
			}
			finish { phong 1.0  phong_size 500 }
		}
		translate x * (-5.5 + (C * (5.5 - (-5.5))/(Copies -1)))
		translate y *-3
	} //object
	#set C = C +1;
#end  //while (C < Copies)


