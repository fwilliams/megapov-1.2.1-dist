// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)attach.pov
// Description: Simulation of cloth. Here used as a cloth fixed at one of its corners.
// Features demonstrated: simcloth with constraints
// Creation Date: $ 14 Jun 2004, 15:46:08 $
// Last modified: $ 15 Jun 2004, 00:38:21 $
// Author: Christophe Bouffartigue (tofbouf@free.fr)
//
// First render with clock off to get the initial attach.cth file
// Then render with clock on for about 100 frames
//
// -w320 -h240 +a0.3
// -w320 -h240 +a0.3 -j +kff100

#version unofficial megapov 1.1;

// Write the initial .cth file
	#local Precision = 2;
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
				#local tempy = -l2/2 + j*nlng;
	            #local tempz = ht + (-1+2*rand(st))*nlng*0.01;
				#write(file, tempx, ",", tempy, ",", tempz, ", 0.0, 0.0, 0.0,\n")
				#set j=j+1;
			#end
			#set i=i+1;
		#end
		#fclose file
	#end

// Add constraints to the .cth file
	#macro WriteInitialDrapeau()
		#if(clock_on=0)
			WriteClothFile("attach.cth", 40*Precision, 40*Precision, 0.5/Precision, 100, 0)
		#end
		#fopen file "attach.cth" append
	
		#write(file, 39*Precision, ", 0.0, 0.0, 0.0,\n")
		#write(file, 38*Precision, ", 0.5, 0.5, 0.5,\n")
		#write(file, (40+38)*Precision, ", 0.5, 0.5, 0.5,\n")
		#write(file, (40+39)*Precision, ", 0.5, 0.5, 0.5,\n")
	
		#fclose file
	
	#end

#if(clock_on=off) WriteInitialDrapeau() #end


simcloth {
	gravity     -0.4*y
	neighbors   1
	internal_collision off
	damping     0.95
	intervals   0.04
	iterations  #if(clock_on=0) 0 #else 100 #end
	input       "attach.cth"
	output      "attach.cth"
	mesh_output "attach_s.msh"
	smooth_mesh on
	uv_mesh     on
}


#declare Drapeau = mesh {
	#include "attach_s.msh"
	uv_mapping
	texture {
		pigment {
			checker
			color rgb <1,.5, .2>, color rgb <.9, .85, .4>
			scale <1/10, 1/10, 1>
		}
		finish { ambient .3 diffuse .7 }
	}
}

//camera {location <30, 10, -90> angle 30 look_at 0*x }
camera {
	perspective 
	location <0, 0, -70>
	up y*image_height right x*image_width
	angle 35
	look_at <0.0, 0.0, 0.0>
	rotate x*10
	rotate y*5
	translate y*-3
}

light_source {
	10000*y, color rgb 1.2
	rotate -x*30
	rotate y*45
}


object { Drapeau }

text {
	ttf "crystal.ttf",
	"MegaPOV"
	0.5, <0.0, 0.0, 0.0>
	h_align_center
	pigment {
		rgb <0.847379, 0.810132, 0.698390>
	}
	translate z*1
	scale <4, 4, 1>
}

