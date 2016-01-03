// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)chrono.pov
// Description: Writing parsing time to the image. Exit loop after a specified time.
// Features demonstrated: Timer
// Creation Date: $ 15 Dec 2002, 15:49:52 $
// Last modified: $ 14 Jun 2004, 22:39:07 $
// Author: René Smellenbergh
//
// -w320 -h240 +a0.3
	
#version unofficial megapov 1.1;

global_settings {
	assumed_gamma 1.0
}

//Get the clock and set the internal counter to zero.
//When reading again with the current_chrono keyword, you get the seconds between
//start_chrono and current_chrono

camera {
	location <0.0, 0.0, -10>
	up y*image_height right x*image_width
	angle 60
	look_at <0.0, 0.0, 0.0>
}

light_source { <1000, 1000, -10000> 	rgb 1.4 }
	
background { rgb <0.8, 0.8, 0.8> }

#local C = 0;
#local Copies = 24875;
#local ParseStart= start_chrono;	//start the chrono

#while ( C < Copies)
	sphere {
		<0.0, 0.0, 0.0>, 0.035
		translate y * (-0.4)
		rotate x * (0 + (C * (360*20)/(Copies -1)))
		translate x * (-4 + (C * (4 - (-4))/(Copies -1)))
		#local R = (1.000000 + (C * (0.978378 -(1.000000))/(Copies -1)));
		#local G = (0.000000 + (C * (1.000000 -(0.000000))/(Copies -1)));
		#local B = (0.000000 + (C * (0.350027 -(0.000000))/(Copies -1)));
		texture { pigment { 	rgb <R, G, B> } }
		translate y*1.6
	} //sphere
	#set C = C +1;
#end  //while (C < Copies)

//done, get the elapsed time
#local ParseEnd = current_chrono;	//reads the seconds elapsed since start_chrono

//*********** write time value to the scene *******************
text {		
	ttf "crystal.ttf",
	concat("Loop with ",str( Copies,1,0), " spheres")
	0.1, <-0.0, 0.0, 0.0>
	h_align_center  v_align_bottom
	texture { pigment { rgb <0.899992, 0.626368, 0.216022> } }
	scale <0.8,1,1>
	translate y*(1.6+0.435+0.2)
}

text {		
	ttf "crystal.ttf",
	concat("Parsing took ",str( ParseEnd,1,0), " seconds")
	0.1, <-0.0, 0.0, 0.0>
	h_align_center  v_align_top
	texture { pigment { rgb <0.899992, 0.626368, 0.216022> } }
	scale <0.8,1,1>
	translate y*(1.6-0.435-0.2)
}

//*********** start second loop ******************************
#local TimeOut = 6;
#local C2=0;
#local Copies = TimeOut*6000;
#local ResetChrono = start_chrono;	//reset the chrono
#while ( current_chrono < TimeOut)	//check if time limit has been reached
	sphere {
		<0.0, 0.0, 0.0>, 0.035
		translate y * (-0.4)
		rotate x * (0 + (C2 * (360*20)/(Copies -1)))
		translate x * (-4 + (C2 * (4 - (-4))/(Copies -1)))
		#local R = (1.000000 + (C2 * (0.978378 -(1.000000))/(Copies -1)));
		#local G = (0.000000 + (C2 * (1.000000 -(0.000000))/(Copies -1)));
		#local B = (0.000000 + (C2 * (0.350027 -(0.000000))/(Copies -1)));
		texture { pigment { 	rgb <R, G, B> } }
		translate y*-1.6
	} //sphere
	#set C2 = C2 + 1;
	#declare NrSph=C2;
#end  //while (C < Copies)

//*********** write values to the scene *******************
text {		
	ttf "crystal.ttf",
	concat("Parsing during ",str( TimeOut,1,0), " seconds")
	0.1, <-0.0, 0.0, 0.0>
	h_align_center  v_align_bottom
	texture { pigment { rgb <0.899992, 0.626368, 0.216022> } }
	scale <0.8,1,1>
	translate y*-(1.6-0.435-0.2)
}

text {		
	ttf "crystal.ttf",
	concat("placed ",str( NrSph,1,0)," spheres")
	0.1, <-0.0, 0.0, 0.0>
	h_align_center  v_align_top
	texture { pigment { rgb <0.899992, 0.626368, 0.216022> } }
	scale <0.8,1,1>
	translate y*-(1.6+0.435+0.2)
}


