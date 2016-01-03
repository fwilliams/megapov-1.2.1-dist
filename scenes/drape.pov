// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)drape.pov
// Description: Simulation of cloth. Here used as a cloth falling on a rounded box.
// Features demonstrated: simcloth
// Creation Date: $ 14 Jun 2004, 16:03:49 $
// Last modified: $ 14 Jun 2004, 22:36:52 $
// Author: Christophe Bouffartigue (tofbouf@free.fr)
//
//
// First render with the clock off. The starting cloth patch is written to the file drape.cth
// Then render the animation with about 20 frames
//
// -w320 -h240 +a0.3
// -w320 -h240 +a0.3 -j +kff20

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
			#local vtemp = <tempx, 0, tempz>;
			#local vtemp = vaxis_rotate(vtemp, z, -70);
            #local tempy = ht + (-1+2*rand(st))*nlng*0.1;
			#local vtemp = vtemp + tempy*y + 2*x;
			#write(file, vtemp.x, ",", vtemp.y, ",", vtemp.z, ", 0.0, 0.0, 0.0,\n")
			#local j=j+1;
		#end
		#local i=i+1;
	#end
	#fclose file
#end


#declare R = 1;
#declare Cube = union {
    box { < R, 0, R>, < 10-R, 7, 10-R> }
    box { < R, 0, 0>, < 10-R, 7-R, 10> }
    box { < 0, 0, R>, < 10, 7-R, 10-R> }
    cylinder { < R, 0, R>,  < R, 7-R, R>, R }
    cylinder { < R, 0, 10-R>,  < R, 7-R, 10-R>, R }
    cylinder { < 10-R, 0, R>,  < 10-R, 7-R, R>, R }
    cylinder { < 10-R, 0, 10-R>,  < 10-R, 7-R, 10-R>, R }
    cylinder { < R, 7-R, R>,  < 10-R, 7-R, R>, R }
    cylinder { < R, 7-R, R>,  < R, 7-R, 10-R>, R }
    cylinder { < 10-R, 7-R, R>,  < 10-R, 7-R, 10-R>, R }
    cylinder { < R, 7-R, 10-R>,  < 10-R, 7-R, 10-R>, R }
    sphere { < R, 7-R, R>, R }
    sphere { < R, 7-R, 10-R>, R }
    sphere { < 10-R, 7-R, R>, R }
    sphere { < 10-R, 7-R, 10-R>, R }
    translate -2*x
}

#declare Obstacle = union {
    plane { y,0 }
	object { Cube }
}

#declare Precision = 2;
#if(clock_on=off)  WriteClothFile("drape.cth", 40*Precision, 50*Precision, 2/5/Precision, 60, 15) #end

simcloth {
    environment Obstacle
    friction 0.0
    gravity -1*y
	neighbors 1
	internal_collision on
    damping 0.95
    intervals 0.02
    iterations #if(clock_on=off) 0 #else 200 #end
    input "drape.cth"
    output "drape.cth"
    mesh_output "drape.msh"
    smooth_mesh on
    uv_mesh on
}

#declare Drap = mesh {
    #include "drape.msh"
    uv_mapping
    texture {
        pigment {
            checker color rgb<1, .5, .2> color rgb<1, .8 ,.4>
            scale <1/10, 3/50, 1>
        }
    }
}

camera {
	location <4, 12, -20>
	up y*image_height right x*image_width
	angle 45
	look_at 4*y
}

light_source { -20*z+5*y+2*x, color rgb .5 shadowless }

light_source { <10,20,-10>*3, color rgb 1.2
	spotlight
	radius 20
	falloff 30
	tightness 2
	point_at 0
	area_light x*5, y*5, 8, 8
	adaptive 1
	circular orient
}


object { Drap translate .05*y }
object { Obstacle translate .05*x +.05*z
	pigment { rgb .95 }
}

