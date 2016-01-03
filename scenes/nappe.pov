// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)nappe.pov
// Description: Simulation of cloth. Here used as a tablecloth.
// Features demonstrated: simcloth
// Creation Date: $ 14 Jun 2004, 16:13:37 $
// Last modified: $ 13 Jul 2004, 22:37:09 $
// Author: Christophe Bouffartigue
//
// @@ Demo showing the use of simcloth as tablecloth
//
// First render with the clock off. The starting cloth patch is written to the file nappe.cth
// Then render the animation with about 40 frames
//
// -w320 -h240 +a0.3
// -w320 -h240 +a0.3 -j +kff40

#version unofficial MegaPov 1.1;

#macro WriteClothFile(nomfile, n1, n2, nlng, ks, ht)
	#debug "\nWriting new .cth file\n"
	#fopen file nomfile write
	#write(file, n1, ",", n2, ",", nlng, ",", ks, ",\n")
	#local l1 = nlng*(n1-1);
	#local l2 = nlng*(n2-1);
	#local st = seed(1234);
	#local i=0;
	#while (i<n1)
		#local j=0;
		#while (j<n2)
			#local tempx = -l1/2 + i*nlng;
			#local tempz = -l2/2 + j*nlng;
            #local tempy = ht + (-1+2*rand(st))*nlng*0.1;
			#write(file, tempx, ",", tempy, ",", tempz, ", 0.0, 0.0, 0.0,\n")
			#set j=j+1;
		#end
		#set i=i+1;
	#end
	#fclose file
#end

#declare Table =
union {
	cylinder { 0.8*y, 0.9*y, 0.8 }
	torus { 0.8, 0.05 sturm translate 0.85*y }
	cylinder { 0.85*y, 0, 0.05 }
	cylinder { 0, 0.05*y, 0.4 }
}

#local Precision = 2;
#if(clock_on=0) WriteClothFile("nappe.cth", 60*Precision, 60*Precision, 1.85/60/Precision, 60, 0.95) #end	

simcloth {
	environment Table
	friction 0
	gravity -0.4*y
	damping 0.90
	intervals 0.02
	iterations #if(clock_on=0) 0 #else 40 #end
	input "nappe.cth"
	output "nappe.cth"
	mesh_output "nappe.msh"
	smooth_mesh on
	uv_mesh on
}
#include "functions.inc"
#declare Nappe =
mesh {
	#include "nappe.msh"
	uv_mapping
	texture {
		pigment { checker color rgb <1, 0.5, 0.2> color rgb<1, 0.8 ,0.4> scale <1/10, 1/10, 1/10>}
	}
}
camera {
	perspective 
	location <0.2, 1.2, -2>
	up y*image_height right x*image_width
	angle 60
	look_at <0.0, 0.5, 0.0>
}

light_source { -0.2*x+0.5*y-2*z, color rgb 0.5 shadowless }

light_source {
	<5, 10, -5>, color rgb 1.2
	spotlight
	radius 20  falloff 30  tightness 0
	point_at 0
	area_light <5, 0, 0>,   < 0,  5, 0 >,  8,  8
	adaptive 1
	orient circular 
}

object { Nappe translate .001*y }
object { Table scale <.98, 1, .98>
	pigment { rgb <.8, .5, .1> }
}

// floor
box { <-4, -0.1, -5>, <4, 0, 5> texture { pigment { color rgb .8 }finish { ambient 0.3 diffuse 0.7 }}}
// walls
box { <-3.1, -0.1, -5>, <-3, 5, 5> texture { pigment { color rgb .8 }finish { ambient 0.3 diffuse 0.7 }}}
box { <-4, -0.1, 3>, <4, 5, 3.1> texture { pigment { color rgb .8 }finish { ambient 0.3 diffuse 0.7 }}}
