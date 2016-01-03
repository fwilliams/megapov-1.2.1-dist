// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)interpolate_iso.pov
// Description: use of bicubic interpolation for isosurfaces
// Features demonstrated: bicubic interpolation
// Creation Date: $ 11 May 2005, 19:39:51 $
// Last modified: $ 22 May 2005, 19:01:12 $
// Author: Lutz-Peter Hooge
//
// @@ This scene demonstrates how bicubic interpolation of images
// @@ can be done with conventional means using user defined functions
// @@ and much faster using the bicubic interpolation patch
//
// -w512 -h384 +a0.3 -j +kff4
//

#version unofficial megapov 1.2;

// ----------------------------------------

// Variant 1: bilinear interpolation from official POV-Ray
// Variant 2: bicubic interpolation using the new patch
// Variant 3: bilinear interpolation 'by hand'
// Variant 4: bicubic interpolation 'by hand'

#if (!clock_on)
	#debug "This scene should be rendered as an animation with 4 frames\n"
	#debug "to render all variants of the patch demonstration.\n"
#end
	
#declare Variant=frame_number;

// ----------------------------------------

light_source
{
	<1,1,-1>*100
	color rgb 1.8
} 

#declare scape0_func=function
{
	pigment
	{
		image_map
		{
			png "plasma2.png"
			interpolate 2
		}
		scale 2
		rotate x*90
	}
}

#declare scape1_func=function
{
	pigment
	{
		image_map
		{
			png "plasma2.png"
			interpolate 3
		}
		scale 2
		rotate x*90
	}
}

#declare scape2_func=function
{
	pigment
	{
		image_map
		{
			png "plasma2.png"
			interpolate 0
		}
		scale 2
	}
}

#local fp = function{scape2_func(x,y,z).red}
#local xsize=50;
#local ysize=50;
#local dx=1/xsize;
#local dy=1/ysize;
#local q=function(x,s){x*s-int(x*s)}

#local Flin = function(f1,f2,x){f1 + (f2-f1)*x}
#local Fbilin = function
{
	Flin(               
		Flin(fp(x,y   ,0),fp(x+dx,y   ,0),q(x,xsize))
		,
		Flin(fp(x,y+dy,0),fp(x+dx,y+dy,0),q(x,xsize))
		,
		q(y,ysize)
	)
}

#local Fcub = function(f1,f2,f3,f4,x)
{
	(-f1/2	+f2*3/2	-f3*3/2	+f4/2	)*x*x*x
	+
	( f1	-f2*5/2	+f3*2	-f4/2	)*x*x
	+
	(-f1/2		+f3/2		)*x
	+
	(	f2			)
}

#declare Fbicub=function{
	Fcub
	(
		Fcub(
			fp(x-dx  ,y-dy,0),
			fp(x     ,y-dy,0),
			fp(x+dx  ,y-dy,0),
			fp(x+2*dx,y-dy,0),
			q(x,xsize)
		)
		,
		Fcub(
			fp(x-dx  ,y,0),
			fp(x     ,y,0),
			fp(x+dx  ,y,0),
			fp(x+2*dx,y,0),
			q(x,xsize)
		)
		,
		Fcub(
			fp(x-dx  ,y+dy,0),
			fp(x     ,y+dy,0),
			fp(x+dx  ,y+dy,0),
			fp(x+2*dx,y+dy,0),
			q(x,xsize)
		)
		,
		Fcub(
			fp(x-dx  ,y+2*dy,0),
			fp(x     ,y+2*dy,0),
			fp(x+dx  ,y+2*dy,0),
			fp(x+2*dx,y+2*dy,0),
			q(x,xsize)
		)
		,
		q(y,ysize)
	)
}


union
{
	plane
	{
		y,0
	}
	

	isosurface
	{
		function
		{
			y-0.1
				
			#switch (Variant)
				#case (1)
					-.2*scape0_func(x,0,z).red
				#break
				#case (2)
					-.2*scape1_func(x,0,z).red
				#break
				#case (3)
					-.2*Fbilin(x,z,0)
				#break
				#case (4)
					-.2*Fbicub(x,z,0)
				#break
			#else
				-.2*scape1_func(x,0,z).red
			#end
			//-.4*Flin(fp(x,0   ,0),fp(x+dx,0   ,0),q(x,xsize))
			//-.01*q(x,xsize)                                   
		}                 
		max_gradient 3
		contained_by
		{
			box
			{
				<0,0,0>,<1,1,1>
			}
		}
		pigment{color rgb <0.4, 0.4, 1>}
		finish{specular .2}
	}

	pigment
	{
		checker color rgb <.9,.9,1> color rgb <.5,.5,.7>
		scale .1
	}
}

camera
{  
	location <0,2,-2>
	look_at <.5,0,.5>
	angle 28
}
