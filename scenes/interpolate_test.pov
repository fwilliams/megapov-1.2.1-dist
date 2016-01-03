// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)interpolate_test.pov
// Description: bicubic interpolation of image maps
// Features demonstrated: bicubic interpolation
// Creation Date: $ 11 May 2005, 19:39:51 $
// Last modified: $ 22 May 2005, 19:08:02 $
// Author: Lutz-Peter Hooge
//
// @@ A simple demonstration of bicubic interpolation of image maps
//
// -w320 -h240 +a0.3
//

#version unofficial megapov 1.2;

camera
{
	orthographic
	location <.5,.5,5>
	look_at .5
	right .05
	up .05
}        

#declare tex=texture
{
	pigment
	{                 
		image_map
		{
			png "test.png"
			interpolate 3
		}
	}
	finish{ambient 1 diffuse 0}
} 

box
{
	0,1
	texture{tex}
}
