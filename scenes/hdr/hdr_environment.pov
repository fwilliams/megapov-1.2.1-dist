// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)hdr_environment.pov
// Description: HDR writing sample scene
// Features demonstrated: HDR image output
// Creation Date: $ 14 Apr 2003, 16:51:52 $
// Last modified: $ 18 Aug 2004, 09:53:08 $
// Author: Christoph Hormann <chris_hormann@gmx.de>
//
// @@ Scene that generates the environment map for 'hdr_mapping.pov'
//
// -w640 -h320 +a0.3 DECLARE=View=3
//
// to render an environment map use:
//
// -w1024 -h512 +fh -ohdr_env.hdr DECLARE=View=3

#version unofficial megapov 1.1;

// ----------------------------------------

#declare Sun=on;
#declare Light=off;

//#declare Sun=off;
//#declare Light=on;

#declare Doors=false;
//#declare Doors=true;

#ifndef (View)
  #declare View=1;
#end

// ----------------------------------------

global_settings {
  max_trace_level 10
  assumed_gamma 1
  adc_bailout 1/1e6

  radiosity {

    pretrace_start 0.08
    pretrace_end 0.01
    count 50
    //count 250
    nearest_count 8
    error_bound 0.8
    //error_bound 0.2
    recursion_limit 2
    //recursion_limit 1

    low_error_factor .5
    gray_threshold 0.0
    minimum_reuse 0.0015
    brightness 1.0

    randomize on
    normal on
    media on
  }

}


#switch (View)
  
  #case (1)
    camera {
      location    <4.8, -3, 2.0>
      direction   y
      sky         z
      up          z
      right       (4/3)*x
      look_at     <0, 0, 0.9>
      angle       70
      rotate 170*z
    }  
  #break
  
  #case (2)  
    camera {
      location    <-5.4, -4.1, 1.0>*2
      direction   y
      sky         z
      up          z
      right       (4/3)*x
      look_at     <0, 0, 0.9>
      angle       42
    }
  #break
  
  #case (3)      
    camera {
      spherical
      location <0,0,1>
      right     -x
      angle 360, 180
      look_at <0,-1,1>
    }

#end

#if (Sun)
  #declare Light_Pos=vnormalize(<-3, -3.3, 1.8>);

  light_source {
    Light_Pos*100000
    color rgb <2.0, 1.5, 1.0>*16
    area_light 1000*x 1000*y  3,3
    adaptive 1
    jitter orient circular
  }
#end


#if (Light)
  light_source {
    <4.8, -3, 2.8>
    #if (Sun)
      color rgb <2.0, 1.5, 1.0>*8      
    #else
      color rgb <2.0, 1.5, 1.0>*32
    #end
    fade_power 2
    fade_distance 1
    rotate 170*z
  }
#end


#if (Sun)
  sky_sphere {
    pigment {
      pigment_pattern {
        spherical
        poly_wave 6
        color_map { [0 rgb 0][1 rgb 1] }
        scale 3
        translate Light_Pos
      }
      pigment_map {
        [0 gradient z
          color_map {
            [0.00 rgb <0.8,0.9,1.0>*2.5]
            [0.10 rgb <0.6,0.7,1.0>*2.5]
            [0.25 rgb <0.2,0.3,0.8>*2.5]
          }
        ]
        [0.9 color rgb <2.0, 1.5, 1.0>*8*4]
        [0.91 color rgb <2.0, 1.5, 1.0>*15*9]
      }
    }
  }
#else
  sky_sphere {
    pigment {
      gradient z
      color_map {
        [0.00 rgb <0.8,0.7,0.5>]
        [0.10 rgb <0.5,0.6,0.7>]
        [0.25 rgb <0.1,0.2,0.6>]
      }
    }
  }
#end

#declare Tex_Ground=
  texture {
    pigment { color rgb 1 }
    finish { ambient 0.0 diffuse 0.35 }
  }

#include "colors.inc"
#include "stones.inc"

#declare Tex_Stone = 
  texture {
    T_Stone5
    finish {
      ambient 0
      diffuse 0.4
      specular 0
      reflection 0
    }
    normal {
      granite 0.2
      scale 0.5
    }
    scale 0.4
  }

#declare Tex_Stone_Floor = 
  texture {
    T_Stone10
    finish {
      ambient 0
      diffuse 0.3
      specular 0.2
      reflection 0.1
    }
    normal {
      granite 0.02
      scale 0.4
    }
    scale 0.4
  }



union {
  difference {
    merge {
      plane { 
        z, -0.1      
        texture { Tex_Ground }
      }    
      cylinder {  
        0, -z*3, 5
        texture { Tex_Stone_Floor }
      }
    }
    cylinder { 
      z, -z*0.8, 1.8 
      texture { Tex_Stone }
    }    
  }

  difference {
    cylinder { 3*z, 3.2*z, 2.2 }
    cylinder { 2*z, 4*z, 1.6 }
  }
  difference {
    sphere { 3.2*z, 1.7 }
    sphere { 3.2*z, 1.6 }
    plane { z, 3.19 }
    #local Cnt=0;
    #while (Cnt<360)
      cylinder {
        3.25*z, <3.0,0,3.2>, 0.25
        rotate Cnt*z
      }
      #local Cnt=Cnt+30;
    #end
  }
  difference {
    cylinder { 0, 0.12*z, 2.2 }
    cylinder { -z, z, 1.6 }
  }
  difference {
    box { <-2.2,0,3>, <5.2,-5,3.2> }
    cylinder { 2*z, 4*z, 1.7 }
  }
  #if (Doors)
    difference {
      box { <-2.2,0,3>, <-2.0,-5,-0.2> }
      box { <-3,-2.4,2.2>, <-1.0,-3.6,-0.5> }
    }
  #else
    box { <-2.2,0,3>, <-2.0,-5,-0.2> }
  #end
  box { < 5.2,0,3>, < 5.0,-5,-0.2> }
  #if (Doors)
    difference {
      box { < 5.2,0,3>, < 2.0,-0.2,-0.2> }
      box { < 4,1,2.2>, < 3.0,-1,-0.5> }
    }
  #else
    box { < 5.2,0,3>, < 2.0,-0.2,-0.2> }
  #end    
  box { <-2.2,-5,3>, < 5.2,-5,-0.2> }

  #local Cnt=0;

  #while (Cnt<181)

    cylinder {
      -z, 3.1*z, 0.12
      translate 2*x
      rotate Cnt*z
    }
    #local Cnt=Cnt+30;
  #end

  rotate 170*z
  texture { Tex_Stone }
}


