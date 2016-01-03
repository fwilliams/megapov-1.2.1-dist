// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)glowlits.pov
// Description: Here the glow effects are coupled with light sources.
// Features demonstrated: glow
// Creation Date: $ 27 Sep 2000, 16:08:45 $
// Last modified: $ 14 Jun 2004, 22:36:41 $
// Author: Chris Huff
//
// -w320 -h240 +a0.3

#version unofficial megapov 1.1;

global_settings {
	assumed_gamma 1.0
}

camera {
	location <-5, 6,-18>
	up y*image_height right x*image_width
	look_at < 0, 1.5, 0>
	angle 45
}

//Types:
#local Float = 0;
#local Vector = < 0, 0, 0>;
#local Color = color rgb < 0, 0, 0>;

#macro SRand(RS) (rand(RS)*2 - 1) #end
#macro RRand(RS, Min, Max) (rand(RS)*(Max-Min) + Min) #end
#macro Clamp(V, Min, Max) (min(Max, max(Min, V))) #end
#macro Range(V, Rmn, Rmx) (V*(Rmx-Rmn) + Rmn) #end
#macro RClamp(V, Rmn, Rmx, Min, Max) (Clamp(Range(V, Rmn, Rmx), Min, Max)) #end

#local RsA = seed(574647);

#local J = Float;
#local J = 0;
#while(J<52)
	light_source {
		< SRand(RsA)*8, rand(RsA)*4, SRand(RsA)*8>
		color rgb 0.045*< rand(RsA), rand(RsA), rand(RsA)>
		glow { size rand(RsA)*0.65 type int(rand(RsA))}
		fade_distance 4 fade_power 2
	}
	#set J = J + 1;
#end

box {
	<-15, 0,-10>, < 15, 0, 10>
	pigment {checker color rgb 0.05, color rgb 1}
	finish {
		reflection {0.5, 0.75 metallic }
		diffuse 0.25 ambient 0
	}
}

sphere {
	< 0, 2, 0>, 2
	pigment {rgb 1}
	finish {
		reflection { 0.5, 0.85 metallic }
		diffuse 0.15 ambient 0
	}
}
