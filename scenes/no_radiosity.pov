// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)no_radiosity.pov
// Description: demo scene for no_radiosity patch
// Features demonstrated: no_radiosity flag, film exposure simulation
// Creation Date: $ 30 Jan 2004, 22:56:10 $
// Last modified: $ 14 Jun 2004, 22:37:53 $
// Author: Christoph Hormann <chris_hormann@gmx.de>
//
// -w320 -h240 +a0.3

#version unofficial MegaPov 1.1;

#declare Brightness=44;

#default { 
  texture { 
    pigment { color rgb 1.5 } 
    finish { diffuse 1 ambient 0.0 } 
  } 
}

global_settings { 
  max_trace_level 5
  assumed_gamma 1
  exposure 0.75    
  exposure_gain 1.5 
  radiosity {
    pretrace_start 0.08
    pretrace_end   0.01 
    brightness 1
    count 500
    recursion_limit 1
    error_bound 0.5
    low_error_factor 0.2
    randomize on
    media on
  }
}
            
camera {   
  location    <5.0, 7.0, 2.5>            
  direction   z
  sky         z  
  up          z  
  right       1.33333*x
  look_at     <0.3, 0.0, 0.7> 
  angle       42
}


plane { z, 0 }
     
box { <-15,  -5.0, -1>, <15,  -5.2,  5> } 

merge {
  box { <-2, -1.2, 0>, <2,  1.2,  0.1>  } 
  cylinder { <-2, 0, 0>, <-2, 0, 0.1>, 1.2 } 
  cylinder { < 2, 0, 0>, < 2, 0, 0.1>, 1.2 } 
}

#macro Glow(Color)
  media { 
    emission 1
    density { 
      spherical   
      poly_wave 5
      density_map { 
        [0 rgb 0]
        [1 rgb Color]
      }
    }
    method 3
  }
#end

union {
  difference {
    cylinder { -1.5*z, -1.1*z, 0.8 }  
    cylinder { -1.3*z, -1*z, 0.7 }  
  }
  sphere { 
    0, 1 
    hollow on
    pigment { rgbt 1 }
    interior { Glow(<1.0, 0.1, 0.2>*Brightness) }
    no_image
  }
  sphere { 
    0, 1 
    hollow on
    pigment { rgbt 1 }
    interior { Glow(<0.1, 0.2, 1.0>*Brightness) }
    no_radiosity
  }  
  translate <2, 0, 1.5>
}  

union {
  difference {
    cylinder { -1.5*z, -1.1*z, 0.8 }  
    cylinder { -1.3*z, -1*z, 0.7 }  
  }  
  sphere { 
    0, 1 
    hollow on
    pigment { rgbt 1 }
    interior { Glow(<0.1, 0.2, 1.0>*Brightness) }
    no_image
  }
  sphere { 
    0, 1 
    hollow on
    pigment { rgbt 1 }
    interior { Glow(<1.0, 0.1, 0.2>*Brightness) }
    no_radiosity
  }  
  translate <-2, 0, 1.5>
} 

