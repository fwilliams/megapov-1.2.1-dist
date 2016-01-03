// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)hdr_mapping.pov
// Description: HDRI mapping sample scene
// Features demonstrated: HDR image reading
// Creation Date: $ 14 Apr 2003, 16:55:14 $
// Last modified: $ 14 Jun 2004, 22:36:49 $
// Author: Christoph Hormann/Mael
//
// @@ Scene that uses the environment map generated with 'hdr_environment.pov'
//
// requires HDR environment map from the scene 'hdr_environment.pov'
//
// +w320 +h240 +a0.3


#version unofficial megapov 1.1;

global_settings {
  max_trace_level 15
  radiosity {
    pretrace_start 0.08
    pretrace_end   0.01
    count 800
    //count 250
    nearest_count 8
    //nearest_count 5
    error_bound 0.07
    //error_bound 0.2
    recursion_limit 2
    brightness 1

    normal on
    randomize on
  }
}

camera { 
  location <5,4,-2> 
  right (image_width/image_height)*x 
  up 1*y 
  look_at <-.4,1,0> 
}

sphere {
  <-2,1,-2>,1
  pigment { color rgb 0.2 }
  finish {
    ambient 0
    diffuse 0.2
    reflection {
      0.9
    }
  }
}

sphere {
  <0,1,-.5>,1
  pigment { color rgb 1 }
  finish { ambient 0 diffuse .8 }
  normal {
    crackle .8
    turbulence 0.2
    scale .2
  }
}

sphere {
  <2,1,1>,1
  texture {
    pigment { color rgbt 1 }
    finish {
      ambient 0
      diffuse 0
      reflection {
        0.1, 1.0
        fresnel on
      }
      conserve_energy
    }
  }
  interior {
    ior 1.5
    fade_distance 1.1
    fade_color <0.11, 0.1, 0.3>
  }
}

cylinder {
  -y, 0, 4.5
  texture {
    pigment { color rgb 1 }
    finish { ambient 0 diffuse 0.7 }
  }
}

sphere {
  0,200
  //pigment { image_map { hdr "kitchen_probe.hdr" once interpolate 2 map_type 7 } }
  pigment { image_map { hdr "hdr_env.hdr" once interpolate 2 map_type 1 } }
  finish { ambient 0.8 diffuse 0 }
  scale <-1,1,1>
  hollow
  rotate 120*y
}
