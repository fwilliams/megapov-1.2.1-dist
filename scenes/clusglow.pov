// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)clusglow.pov
// Description: New atmospheric effect: glow. This scene uses no objects or light sources: only glows.
// Features demonstrated: glow, timer, set
// Creation Date: $ 14 Dec 2002, 15:54:05 $
// Last modified: $ 14 Jun 2004, 22:39:12 $
// Author: René Smellenbergh
//
// -w320 -h240 +a0.3

#version unofficial MegaPov 1.1;

#include "transforms.inc"
camera {
	location <0.0, 0.0, -40>
	up y*image_height right x*image_width
	angle 55
	look_at <0.0, 0.0, 0.0>
	rotate x*10
}

global_settings {
	assumed_gamma 1.0
}


//*************  Macro to fill a sphere with randomly placed glows  *******************
    /*This macro fills a sphere randomly with glows.
        The macro tries to place the requested number of glows, but if there are too many glows for the container's size,
        this might go on forever. Therefore we use the timer function to limit the parsing time.
    */
        
#declare Radius_Ratio = 1.8;
#macro FSWG (Cont_rad, Nr_glows, Glow_max_rad, Glow_min_rad, Intersect, Contain_all, Use_time_out,
				Max_time, Level, Glow_type, Glowpow, Size_fraction, Randcol, Transglow)
	#debug concat("\nFSWG Macro: running for max ",str(Max_time, 0, 0)," seconds\n")	//inform on set time limit
	#if (Cont_rad < 0)
		#local Cont_rad = abs(Cont_rad);
		#debug concat ("warning: \"Cont_rad\" cannot be negative! Converted to ", str(Cont_rad, 0, 9), "\n" )
	#end
	#if (Nr_glows < 1)
		#local Nr_glows = 1;
		#debug "warning: \"Nr_glows\" cannot be less than \"1\"! Converted to \"1\"\n"
	#else
		#local Nr_glows = int(Nr_glows);
	#end
	#if (Glow_min_rad < 0)
		#local Glow_min_rad = abs(Glow_min_rad);
		#debug concat("warning: \"Glow_min_rad\" cannot be negative ! Converted to ", str(Glow_min_rad, 0, 9), "\n")
	#end
	#if (Glow_min_rad = 0)
		#local Glow_min_rad = 1;
		#debug "warning: \"Glow_min_rad\" cannot be \"0\"! Converted to \"1\"\n"
	#end
	#if (Glow_max_rad < Glow_min_rad)
		#local Glow_max_rad = Glow_min_rad;
		#debug concat("warning: \"Glow_max_rad\" cannot be less than \"Glow_min_rad\" ! Converted to ", str(Glow_max_rad, 0, 9), "\n")
	#end
	#if (Intersect != yes & Intersect != no)
		#local Intersect = yes;
		#debug "warning: \"Intersect\" must be \"yes\" or \"no\". Converted to \"yes\"\n"
	#end
	#local Stopwatch = start_chrono;	//start the chrono
	#if (Contain_all != yes & Contain_all != no)
		#local Contain_all = yes;
		#debug "warning: \"Contain_all\" must be \"yes\" or \"no\". Converted to \"yes\"\n"
	#end
	#local Glow_center_array = array[Nr_glows]
	#local Glow_radius_array = array[Nr_glows]
	#local S1 = seed(1);
	#local Counter = 0;
	#local GlowCounter=0;
	#local DoExit=no;
	#while (Counter < Nr_glows & DoExit=no)
		#if ( Use_time_out)
			#if( current_chrono > Max_time )	//check if time limit was reached
				#local DoExit=yes;
			#end
		#end

	#local Provv_radius = rand(S1) * (Glow_max_rad - Glow_min_rad) + Glow_min_rad;
		#if (Contain_all = yes)
			#local Radius_offset = Provv_radius;
		#else
			#local Radius_offset = 0;
		#end
	#declare Provv_center = vnormalize(<rand(S1) - .5, rand(S1) - .5, rand(S1) - .5>) * Cont_rad * rand(S1);
		#if (Counter > 0 & Intersect = no)
			#local Compare = 0;
			#while (Compare < Counter)
				#local Sphere_is_good = true;
				#if (
					(vlength(Provv_center) > (Cont_rad-Provv_radius)) |
					( Provv_center.y > Level) |
					(vlength(Provv_center - Glow_center_array[Compare]) < (Provv_radius + Glow_radius_array[Compare]))
				)
					#local Sphere_is_good = false;
					#set Compare = Counter;
				#else
					#set Compare = Compare + 1;
				#end
			#end
			#if (Sphere_is_good = true)
				#local Time = current_chrono;	//check the time
				#local Glow_center_array[Counter] = Provv_center;
				#local Glow_radius_array[Counter] = Provv_radius;
				#set Counter = Counter + 1;
				#set GlowCounter=GlowCounter+1;
			#end
		#else
			#local Glow_center_array[Counter] = Provv_center;
			#local Glow_radius_array[Counter] = Provv_radius;
			#set Counter = Counter + 1;
			#set GlowCounter=GlowCounter+1;
		#end
	#end
	#debug concat("\ntotal glows parsed: ", str(Counter,0,0))
	#local Counter = 0;
		#while (Counter < GlowCounter )
			#local Seed1 = seed(50*Counter);
			#local Seed2 = seed(100*Counter);
			#local Seed3 = seed(3*Counter);
			glow {
				type Glow_type
				location Glow_center_array[Counter]
				size Glow_radius_array[Counter]*Size_fraction
				radius Glow_radius_array[Counter]*Radius_Ratio
				fade_power Glowpow
				#if (Randcol = 1)
					color rgb <rand(Seed1)*1.5, rand(Seed2)*1.5, rand(Seed3)*1.5>
				#else
					color rgb 1.5
				#end
				translate Transglow
			}
			#set Counter = Counter + 1;
		#end
	#debug "\nFSWG Macro: done"
#end

//******************* A cluster of white glows **********************
FSWG (8, 350, 0.65, 0.65, no, no, yes, 15, 8, 0, 1.8, 0.018, 0, x*-7.6)
	//FSWG (Cont_rad, Nr_glows, Glow_max_rad, Glow_min_rad, Intersect, Contain_all, Use_time_out,
	//			Max_time, Level, Glow_type, Glowpow, Size_fraction, Randcol, Transglow)

//************ A cluster of randomly colored glows *******************
	FSWG (8, 300, 1.2, 0.3, no, no, yes, 15, 8, 0, 1.7, 0.015, 1, <7.6, 0, 0>)
	//FSWG (Cont_rad, Nr_glows, Glow_max_rad, Glow_min_rad, Intersect, Contain_all, Use_time_out,
	//			Max_time, Level, Glow_type, Glowpow, Size_fraction, Randcol, Transglow)

//**************** Create an ellips of glows ************************
#local C = 0;
#local Copies =600;
	#debug "\nstart parsing glowing ellips"
	#while ( C < Copies)
		glow {
			type 0
			location vtransform( <0,0,0>, transform { translate x*10 rotate z*(C*((360-(360/Copies)))/(Copies -1)) scale <1.8, 1.1, 1> translate z*-2} )
			size 0.03
			radius 5
			fade_power 2.05
			color	rgb <0, 0.35, 0.65>
		} //glow
		#set C = C +1;
	#end  //while (C < Copies)
#debug "\ndone parsing glowing ellips"
