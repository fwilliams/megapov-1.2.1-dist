// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)exposure.pov
// Description: Demonstrates the film exposure simulation feature
// Features demonstrated: film exposure simulation
// Creation Date: $ 14 Dec 2002, 16:05:22 $
// Last modified: $ 14 Jun 2004, 22:36:32 $
// Author: Christoph Hormann <chris_hormann@gmx.de>
//
// Render instructions:
// --------------------
//
// To render the different exposure settings use something like:
//
// -w320 -h240 +a0.3 -j +kff7

#version unofficial megapov 1.1;

#declare Camera=1;
//#declare Camera=2;  // alternative view

global_settings {
  max_trace_level 10
  assumed_gamma 1

  radiosity {
    pretrace_start 0.08
    pretrace_end 0.01
    count 320

    nearest_count 7
    error_bound 0.3
    recursion_limit 1

    low_error_factor .5
    gray_threshold 0.0
    minimum_reuse 0.015
    brightness 1.0
  }


  photons {
    spacing 0.003
  }

  //----------------------------------------------------------
  //   exposure settings
  //----------------------------------------------------------

  #switch (frame_number)

    #case (0) #warning "Use '+kff7 to render all versions of this scene" #break
    #case (2)
      exposure 0.05 exposure_gain 20   // almost linear
      #break
    #case (3)
      exposure 0.2  exposure_gain 5.5
      #break
    #case (4)
      exposure 0.5  exposure_gain 2.5
      #break
    #case (5)
      exposure 1    exposure_gain 1.6
      #break
    #case (6)
      exposure 10   exposure_gain 1
      #break
    #case (7)
      exposure 100  exposure_gain 1    // high compression
      #break
  #end

  //----------------------------------------------------------
}

#if (Camera=1)
  camera {
    location    <5.4, 4.1, 1.0>
    direction   y
    sky         z
    up          z
    right       (4/3)*x
    look_at     <0, 0, 0.9>
    angle       42
  }
#end

#if (Camera=2)
  camera {
    location    <-1.6, -3.0, 0.8>
    direction   y
    sky         z
    up          z
    right       (4/3)*x
    look_at     <0.2, 0, 0.75>
    angle       42
  }
#end

light_source {
  <3, 3.3, 1.8>*100000
  color rgb <2.0, 1.5, 1.0>

  photons { reflection on }
}

sky_sphere {
  pigment {
    gradient z
    color_map {
      [0.00 rgb <0.8,0.9,1.0>]
      [0.10 rgb <0.6,0.7,1.0>]
      [0.25 rgb <0.2,0.3,0.8>]
    }
  }
}

#declare Tex_Ground=
  texture {
    pigment { color rgb 1 }
    finish { ambient 0.0 diffuse 0.65 }
  }

#declare T_Metal=
  texture {
    pigment {
      color rgb 0.8
    }
    finish{
      diffuse 0.2
      brilliance 12
      ambient 0.0
      specular 0.5
      roughness 0.01

      reflection {
        0.8
        metallic
      }

      conserve_energy
    }
  }

plane {
  z, 0
  texture { Tex_Ground }
}

union {
  box { <-4.0, -4.0, -0.1>, <4.0, -4.1, 2.0> }

  box { <-4.0, -4.0, -0.1>, <-3.9, 2.0, 2.0> }
  box { < 4.0, -4.0, -0.1>, < 3.9, 2.0, 2.0> }

  box { <-4.0, -4.0,  2.1>, <4.0,  2.0, 1.999> }

  box { <-4.0, -0.5, -0.1>, <-1.0, -0.65, 2.0> }

  box { <0.3, -4, -0.1>, <0.45, -0.6, 0.5> }
  box { <0.3, -0.6, -0.1>, <0.45, -0.45, 2.0> }

  #local XPos=-3.9;

  #while (XPos<1.8)

    box { <XPos-0.12, 2.0, -0.1>, <XPos+0.12,  1.8, 2.0> }

    #local XPos=XPos+0.6;
  #end

  cylinder { <2.3, 0.8, -0.1>, <2.3, 0.8, 2>, 0.15 }

  union {
    sphere { <1.6, 1.3, 0.22>, 0.22 }
    sphere { <1.6, 2.6, 0.15>, 0.15 }

    texture { T_Metal }
    photons { target reflection on }
  }

  texture { Tex_Ground }
}



