// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)camera_motion.pov
// Description: Using the camera_view to simulate camera motion in a single pass.
// Features demonstrated: camera_view
// Creation Date: $ 01 Aug 2004, 19:58:00 $
// Last modified: $ 01 Aug 2004, 19:58:00 $
// Author: René Smellenbergh
//
// -w320 -h240 +a0.3

#version unofficial megapov 1.1;

global_settings {
	assumed_gamma 1
}

#declare Margin = 0.05;

//**********   ROTATE   *************************************************
light_group {
	light_source {
		<0, 1, 8>
		rgb 2
	}
	text {
		ttf "crystal.ttf",
		"ROTATE"
		0.01, <0.0, 0.0, 0.0>
		v_align_center
		material {
			texture {
				pigment {
					rgb <1.0, 0.374578, 0.086427>	//orange
				}
			}
		}
		rotate y*-180
		translate <-0.15, 0, 0.5>
	}
}

box {
	<0, 0, 0>, <1.4, 1.4, 0.01>
	material {
		texture {
			pigment {
				average
				pigment_map {
					#local C= 0;
					#local Step = 0.01;
					#while (C<1)
					[(0.05+Step)
					 camera_view {
							perspective 
							location <0, 0, 13>
							up y right x	//set ratio to the size of the image panel
							angle 30
							look_at <0, 0, 0>
							rotate z*200*C	//rotate the camera in steps
						}
					]
					#set C=C+ Step;
					#end
					[4 camera_view {	//this extra entry to get a bright copie of the text object
							perspective 
							location <0, 0, 13>
							up y right x	//set ratio to the size of the image panel
							angle 30
							look_at <0, 0, 0>
						}
					]
				}
			}
		}
		scale <1.4, 1.4, 1>	//scale the view area to the size of the panel
	}
	translate <-0.5+Margin, -0.25+ Margin, 0>
}

//**********   ZOOM  ************************************************
light_group {
	light_source {
		<-30, 10, 0.5>
		rgb 1
	}
	box {
		<-0.5, -0.5, 0>, <0.5, 0.5, 0.01>
		scale <15, 20, 1>
		material {
			texture{
				pigment {
					crackle
					color_map {
						[ 0.00 rgb <0.067842, 0.821973, 1.000000>*1.5 ]
						[ 0.15 rgb <0.067842, 0.821973, 1.000000>*1.0 ]
						[ 0.15 rgb <0.416144, 0.891402, 0.512657>*0.8 ]
						[ 1.00 rgb <0.236713, 0.574655, 0.287602>*0.6 ]
					}
					scale <0.2, 0.2, 1>
				}
			}
		}
	translate <-20, 0, 15>
	}
	text {
		ttf "crystal.ttf",
		"ZOOM"
		0.1, <0.0, 0.0, 0.0>
		h_align_center
		v_align_center
		material {
			texture{
				pigment {
					rgb <1.0, 0.0, 0.0>	//red
				}
			}
		}
		translate <-20, 0, 14.8>
	}
}

box {
	<0, 0, 0>, <1.4, 2.4, 0.01>
	material {
		texture{
			pigment {
				average
				pigment_map {
					#local C= 0;
					#local Step = 0.03;
					#while (C<=1)
					[Step camera_view {
							perspective 
							location <-20, 0, 3>
							up y*2.4 right x*1.4	//set ratio to the size of the image panel
							angle 33-(8*C)	//change the camera angle in steps to zoom in
							look_at <-20, 0, 10>
						}
					]
					#set C=C+ Step;
					#end
				}
			}
		}
		scale <1.4, 2.4, 1>	//scale the view area to the size of the panel
	}
	translate <-2+ Margin, -1.25+ Margin, 0>
}
//**********   MOVE    *****************************************************
light_group {
	light_source {
		<-70, 5 0.5>
		rgb 5
	}
	sphere {
		<0.0, 0.0, 0.0>, 1
		material {
			texture{
				pigment {
					rgb <1.000000, 0.966720, 0.565087>	//yellow
				}
			}
		}
		translate <50, 0, 15>
	}
}

box {
	<0, 0, 0>, <2.4, 0.9, 0.01>
	material {
		texture{
			pigment {
				average
				pigment_map {
//				[0.5 camera_view {
//						perspective 
//						location <46.5, 0, 2>
//						up y*0.9 right z*2.4	//set ratio to the size of the image panel
//						angle 40
//						look_at < 46.5, 0, 15>
//					}
//				]
				#local C= 0;
				#local Step = 0.015;
				#while (C<=1)	//create several views with the camera
					[0.5+Step camera_view {
							perspective 
							location <46.5+(7*C), 0, 2>	//move the camera location in steps along the x-axis
							up y*0.9 right z*2.4	//set ratio to the size of the image panel
							angle 40
							look_at <46.5+(7*C), 0, 15>	//move the camera look_at in steps along the x-axis
						}
					]
					#set C=C+ Step;
				#end
				}
			}
		}
		scale <2.4, 0.9, 1>	//scale the view area to the size of the panel
	}
	translate <-0.5+ Margin, -1.25+ Margin, 0>
}

//**********   MULTI-EXPOSURE   **************************************
#macro random(Myseed,R_min,R_max)
	(rand(seed(Myseed))*(R_max-R_min) + R_min)
#end

light_group {
	light_source {
		<-10, 50, 0.5>
		rgb 5
	}
	sphere {
		<0.0, 0.0, 0.0>, 2
		material {
			texture {
				pigment {	//create a sphere with transparent center and bright rim
					wood
					color_map {
						[ 0.0 rgbt <0.0, 0.0, 0.0, 1.0> ]
						[ 0.3 rgbt <0.0, 0.0, 0.0, 1.0> ]
						[ 1.0 rgb <1.0, 1.0, 1.0>*5]
					}
					poly_wave 3
					scale <2.1, 2.1, 1>
				}
			}
		}
		translate <0, 30, 15>
	}
}

box {
	<0, 0, 0>, <0.9, 1.4, 0.01>
	material {
		texture  {
			pigment {
				average
				pigment_map {
					#local I = 0;
					#while (I <10)
					[0.5 camera_view {
							perspective 
							location <random(5280*I, -2, 2), random(32850*I, 35, 25), 1>	//randomize x and y location of camera
							up y*1.4 right x*0.9	//set ratio to the size of the image panel
							angle 40
							look_at <random(5280*I, -2, 2), random(32850*I, 35, 25), 15>	//randomize x and y look_at of camera
						}
					]
					#set I = I +1;
					#end
				}
			}
		}
		scale <0.9, 1.4, 1>	//scale the view area to the size of the panel
	}
	translate <1+Margin, -0.25+ Margin, 0>
}

//**********   DIVIDER   *************************************************
//create a dividing screen to block out the camera_view scenes
plane {
	<0.0, 0.0, -1>, -0.03
	material {
		texture {
			pigment {
				rgb <1, 1, 1>	//white
			}
		}
		interior_texture {	//make the backside of the dividing screen black as a background for the camera_view scenes
			pigment { rgb 0 }
		}
	}
	hollow
}

//**********   LIGHT SOURCE   *******************************************
light_source {
	<-100, 100, -100>
	rgb <1.0, 1.0, 1.0>*2
}

//**********   CAMERA   *************************************************
camera {
	orthographic 
	location <0, 0, -1>
	up y*3 right x*4
	look_at <0, 0, 0>
}

//eof
