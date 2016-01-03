// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)bear.pov
// Description: Media fur example
// Features demonstrated: media fur
// Creation Date: $ 13 Aug 2004, 15:54:05 $
// Last modified: $ 13 Aug 2004, 22:39:12 $
// Author: Thomas Wilhalm
//
// -w640 -h480 +a0.3

#version unofficial megapov 1.1;

#include "functions.inc"

#declare show_block=1;
#declare show_marble=1;
#declare show_head=1;
#declare show_arms=1;
#declare show_body=1;
#declare show_focalblur=0;

global_settings { 
  noise_generator 2
  assumed_gamma 1 
  ambient_light 0.0 
  max_trace_level 50
  radiosity{
    pretrace_start 0.08
    pretrace_end   0.01
    count 35             // CHANGE range from 20 to 150
    nearest_count 5      // CHANGE range from 3 to 10
    error_bound 1.8      // CHANGE - range from 1 to 3
    recursion_limit 5    // CHANGE
    
    low_error_factor .5  // leave this
    gray_threshold 0.0   // leave this
    minimum_reuse 0.015  // leave this
    brightness 1         // leave this
    
    //adc_bailout 0.01/2   // use adc_bailout = 0.01 / brightest_ambient_object
  }
}

#include "finish.inc"

#declare golden=0.6180339;

//----------------------------------------------------------------------
// bear
//----------------------------------------------------------------------

#declare pig0 = pigment { color rgb 0.7 } 
#declare pig1 =
  pigment { leopard
    color_map { [0.0 color rgb <0.7,0.2,0.1>] [0.7 color rgb <1,0.5,0.3>] }
    turbulence 1
    scale 0.16}
#declare pig2 = pigment { color rgb <0.7,0.6,0.2> }
#declare pig3 = pigment { color rgb <198,57,5>/255 }

#declare bodyheight = 1.1;
#declare bodywidth = 0.8;
#declare bodydepth = 0.6;
#declare headheight = 0.75;
#declare headwidth = bodywidth;
#declare headdepth = 0.5;
#declare earmajorradius = headheight/6;
#declare earminorradius = earmajorradius*0.6;
#declare nosewidth = 0.35*headwidth;
#declare armwidth = 0.25*bodywidth;
#declare armlength = 0.4*bodyheight;
#declare legwidth = 0.3*bodywidth;
#declare leglength = 0.45*bodyheight;
#declare eyewidth = 0.1*bodywidth;

//----------------------------------------------------------------------
// body

sphere { 0, 0.5 scale <bodywidth,bodyheight,bodydepth> 
  translate bodyheight/2*y 
  pigment { pig1 }
}
#if (show_body)
intersection {
  isosurface {
    function{x*x+y*y+z*z-(0.5+0.15)+0.05*f_noise3d(30*x,30*y,30*z)}
    contained_by { sphere{ 0, 0.5+0.2+0.1 } }
    hollow pigment { color rgbf <1,1,1,1> }
    interior {
      media {
	method 1 samples 1,100 absorption 15
	scattering { 6, rgb 1 diffuse 5 reflection 0.7 reflection_exponent 4
	  ratio 0.6 frequency 100 waves 20, 1 
	  structure { sphere { 0, 0.5 } }
	  pigment { pig1 }
	  force -6*y
	}
	density { rgb 1 }
      }
    }
    scale <bodywidth,bodyheight,bodydepth> translate bodyheight/2*y 
  }
  plane { -y,0 }
}
intersection {
  sphere { 0, 0.5+0.2
    hollow pigment { color rgbf <1,1,1,1> }
    interior {
      media {
	method 1 samples 1,100 absorption 15
	scattering { 6, rgb 1 diffuse 5 reflection 0.7 reflection_exponent 4
	  ratio 0.6 frequency 80 waves 20, 1 
	  structure { sphere { 0, 0.5 } }
	  pigment { pig1 }
	  force -6*y
	}
	density { rgb 1 }
      }
    }
    scale <bodywidth,bodyheight,bodydepth> translate bodyheight/2*y 
  }
  plane { -y,0 }
}
#end

//----------------------------------------------------------------------
// head

#if (show_head)

#declare Torus = function { f_torus( x,y,z , earmajorradius,earminorradius+0.1 )}
#declare Sphere = function { f_sphere(x,y,z,0.5+0.15)}

// head
union {
  union {
    sphere { 0, 0.5 pigment { pig1 } }
    isosurface { 
      function{ Sphere(x,y,z) + 0.05*f_noise3d(30*x,30*y,30*z) }
      contained_by { sphere { 0, 0.5+0.1+0.1 } }
      hollow pigment { color rgbf <1,1,1,1> }
    interior {
      media {
        method 1 samples 1,100 absorption 15
        scattering { 6, rgb 1 diffuse 5 reflection 0.7 reflection_exponent 4
          ratio 0.7 frequency 80 waves 20,1 force <0,-6,0>
          structure { sphere { 0, 0.5 } }
          pigment { pig1 }
        }
        density { rgb 1 }
      }
    }
  }
  sphere { 0, 0.5+0.1
    hollow pigment { color rgbf <1,1,1,1> }
    interior {
      media {
        method 1 samples 1,100 absorption 15
        scattering { 6, rgb 1 diffuse 5 reflection 0.7 reflection_exponent 4
          ratio 0.7 frequency 100 waves 20,1 force <0,-6,0>
          structure { sphere { 0, 0.5 } }
          pigment { pig1 }
        }
        density { rgb 1 }
      }
    }
    }
    scale <headwidth,headheight,headdepth> 
    translate (bodyheight+headheight/2)*y 
  }

  // left ear
  union {
    torus { earmajorradius, earminorradius 
      rotate x*90 
      pigment { pig1 }
    } // torus
    isosurface { 
      function { Torus(x,y,z) + 0.02*f_noise3d(40*x,40*y,40*z) }
      contained_by { box { -<earmajorradius+earminorradius+0.2,
                           earminorradius+0.1,
                           earmajorradius+earminorradius+0.2>, 
                          <earmajorradius+earminorradius+0.2,
                           earminorradius+0.1,
                           earmajorradius+earminorradius+0.2> }}
      rotate x*90
      hollow pigment { color rgbf <1,1,1,1> }
      interior {
        media {
	  method 1 samples 1,100 absorption 15
	  scattering { 6, rgb 1 diffuse 5 reflection 0.7 reflection_exponent 4
	    ratio 0.7 frequency 80 waves 20,1 force -6*y
	    structure { torus { earmajorradius, earminorradius+0.1 } }
	    pigment { pig1 }
	  } // scattering
	  density { rgb 1 }
        } // media
      } // interior
    } // isosurface
    torus { earmajorradius, earminorradius+0.07
      hollow pigment { color rgbf <1,1,1,1> }
      interior {
        media {
	method 1 samples 1,100 absorption 15
	  scattering { 6, rgb 1 diffuse 5 reflection 0.7 reflection_exponent 4
	    ratio 0.7 frequency 110 waves 20,1 force -6*y
	    structure { torus { earmajorradius, earminorradius+0.1 } }
	    pigment { pig1 }
	  } // scattering
	density { rgb 1 }
        } // media
      } // interior 
      rotate x*90
    }
    // mark "T. Willhalm"
    bicubic_patch {
      type 1 flatness 0.001
      u_steps 4 v_steps 4
      <0,-0.05,0>,   <0.1,-0.05,-0.2>,   <0.2,-0.05,-0.2>,  <0.3,-0.05,-0.2>, 
      <0,-0.025,0>,  <0.1,-0.025,-0.15>, <0.2,-0.025,-0.2>, <0.3,-0.025,-0.2>,
      <0,0.025,0>,   <0.1,0.025,-0.15>,  <0.2,0.025,-0.2>,  <0.3,0.025,-0.2>,
      <0,0.05,0>,    <0.1,0.05,-0.2>,    <0.2,0.05,-0.2>,   <0.3,0.05,-0.22>
      uv_mapping
      texture {
        pigment { 
	  object {
	    text {  
	      ttf "crystal.ttf" "T.Willhalm" 0.5,0
	      translate <0.6,0.5,-0.25>
	      scale <0.2, 0.6, 1>*0.8
	    }
            pigment{color rgb 1},
            pigment{color blue 1}
	  }
	  //image_map { png "thw.png" }
	  //scale <1,1,1>
        }
        finish { Shiny }
      }
      rotate z*37
    }
    translate <headwidth/2, 
               bodyheight+headheight-earmajorradius-earminorradius, 
               earminorradius>   
  }

  // right ear
  union {
    torus { earmajorradius, earminorradius rotate x*90 
      pigment { pig1 }
    } // torus
    isosurface { 
      function { Torus(x,y,z) + 0.02*f_noise3d(40*x,40*y,40*z)}
      contained_by { box {-<earmajorradius+earminorradius+0.2,
                           earminorradius+0.1,
                           earmajorradius+earminorradius+0.2>, 
                          <earmajorradius+earminorradius+0.2,
                           earminorradius+0.1,
                           earmajorradius+earminorradius+0.2>}}
      rotate x*90
      hollow pigment { color rgbf <1,1,1,1> }
      interior {
        media {
	  method 1 samples 1,100 absorption 15
	  scattering { 6, rgb 1 diffuse 5 reflection 0.7 reflection_exponent 4
	    ratio 0.7 frequency 80 waves 20,1 force -6*y
	    structure { torus { earmajorradius, earminorradius+0.1 } }
	    pigment { pig1 }
	  } // scattering
	  density { rgb 1 }
        } // media
      } // interior
    } // isosurface
    torus { earmajorradius, earminorradius+0.07 rotate x*90
      hollow pigment { color rgbf <1,1,1,1> }
      interior {
        media {
  	  method 1 samples 1,100 absorption 15
	  scattering { 6, rgb 1 diffuse 5 reflection 0.7 reflection_exponent 4
	    ratio 0.7 frequency 110 waves 20,1 force -6*y
	    structure { torus { earmajorradius, earminorradius+0.1 } }
	    pigment { pig1 }
	  } // scattering
	density { rgb 1 }
        } // media
      } // interior 
    }
    translate <-headwidth/2, 
               bodyheight+headheight-earmajorradius-earminorradius, 
               earminorradius>   
  }

  // nose

  union {
    sphere { 0, nosewidth/2     
      pigment { pig1 }
    }
    union {
      sphere { <0,0,-0.1*headdepth>, nosewidth/3 }
      intersection { 
        torus { nosewidth/2, 0.01 rotate z*90 }
        plane { y,0 }
        plane { <0,-1,1>,0 }
      }
      intersection { 
        torus { nosewidth/2, 0.01 rotate -45*x }
        plane { <3,0,1>,0 }
        plane { <-3,0,1>,0 }
      }
      pigment { rgb 0 }
    }
    sphere { 0, nosewidth/2+0.01
      hollow pigment { color rgbf 1 }
      interior {
        media {
          method 1 samples 1,100 absorption 15
          scattering { 6, rgb 1 diffuse 5 reflection 0.7 reflection_exponent 4
            ratio 0.7 frequency 100 waves 20,1 force -6*y 
            structure { sphere { 0, nosewidth/2+0.02 } }
            pigment { pig1 }
          }
        density { rgb 2 }
        }
      }
    }
    translate <0, bodyheight+headheight/2-0.3*nosewidth, -0.4*headdepth>
  }

  // eyes

  sphere { <-0.2*headwidth, bodyheight+0.55*headheight, -0.5*headdepth>, 
    eyewidth/2     
    texture {
      pigment { color rgb 0 }
      finish { Shiny }
    }
  }
  sphere { <0.2*headwidth, bodyheight+0.55*headheight, -0.5*headdepth>, 
    eyewidth/2     
    texture {
      pigment { color rgb 0 }
      finish { Shiny }
    }
  }
  rotate 15*y
  translate 0.1*y
} // head
#end

//----------------------------------------------------------------------
// arms and legs

#declare Ellipsoid = function { f_superellipsoid(x,y,z,1,0.6)}

#macro Cylinder(Length,Angle) 
union {
  superellipsoid { <1,0.6> translate <0,0,1> 
                   scale <armwidth/2, 
		          armwidth/2, 
			  -(Length/2+armwidth/2)>
		   translate <0,0,armwidth/2>
		   rotate Angle  
    pigment { pig1 }
  }
#if (show_arms)
  isosurface { function {-Ellipsoid(x,y,z) + 0.05*f_noise3d(10*x,10*y,20*z)}
               contained_by { box{ -1.1, 1.1 }} 
                     translate <0,0,1> 
                     scale <armwidth/2+0.1, 
		            armwidth/2+0.1, 
			    -(Length/2+armwidth/2+0.1)>
		     translate <0,0,armwidth/2+0.1>
		     rotate Angle  
    hollow pigment { color rgbf <1,1,1,1> }
    interior {
      media {
	method 1 samples 1,100 absorption 15
	scattering { 6, rgb 1 diffuse 5 reflection 0.7 reflection_exponent 4
	  ratio 0.6 frequency 100 waves 20, 1 force -6*y
	  structure { cylinder { <0,0,0>, vrotate(<0,0,-Length>,Angle), armwidth/2 } }
	  pigment { pig1 }
	} // scattering
	density { rgb 1 }
      } // media
    } // interior
  } // isosurface
  superellipsoid { <1,0.6> translate <0,0,1> 
                     scale <armwidth/2+0.07, 
		            armwidth/2+0.07, 
			    -(Length/2+armwidth/2+0.07)>
		     translate <0,0,armwidth/2+0.07>
		     rotate Angle  
    hollow pigment { color rgbf <1,1,1,1> }
    interior {
      media {
	method 1 samples 1,100 absorption 15
	scattering { 6, rgb 1 diffuse 5 reflection 0.7 reflection_exponent 4
	  ratio 0.6 frequency 120 waves 20, 1 force -6*y
	  structure { cylinder { <0,0,0>, vrotate(<0,0,-Length>,Angle), armwidth/2 } }
	  pigment { pig1 }
	} // scattering
	density { rgb 1 }
      } // media
    } // interior
  } // superellipsoid
#end
} // union 
#end

// left arm
object { Cylinder(armlength,<0,-7,0>)
  translate <(0.8*bodywidth+armwidth)/2, bodyheight-0.6*armwidth,0>
}
// right arm
object { Cylinder(armlength,<25,7,0>)
  translate <-(0.8*bodywidth+armwidth)/2, bodyheight-0.6*armwidth,0>
}
// left leg
object { Cylinder(leglength,<0,-15,0>)
  translate <(0.7*bodywidth+legwidth)/2,legwidth/2,0> 
}
// right leg
object { Cylinder(leglength,<0,15,0>)
  translate <-(0.7*bodywidth+legwidth)/2,legwidth/2,0> 
}


//----------------------------------------------------------------------
// stone floor
//----------------------------------------------------------------------

#declare White_pigment = 
pigment {
   agate
   color_map {
     [ 0.0 color rgb 1.0]
     [ 0.2 color rgb 0.99]
     [ 0.6 color rgb 0.95]
     [ 0.9 color rgb 0.9]
     [ 1.0 color rgb 0.5]
   }
   scale 0.09
}

plane { y, -0.03 pigment {color rgb 1} }

#if (show_marble)
#declare X=-4;
#while (X<4)
  #declare Z=-2;
  #while (Z<8)
    superellipsoid { <0.1,0.1> scale 0.5 translate <X,-0.5,Z> 
      hollow 
      texture{
	pigment { rgbf 1 }
	finish { 
	  specular 0.35 roughness 0.01 
	  diffuse 0
	}
	scale 2
      }
      interior {
	media {
          method 2
	  scattering { 1, rgb 1 }
	  density { rgb 100 }
	}
      }
    }
    #declare Z = Z+1;
  #end
  #declare X = X+1;
#end
#end

//----------------------------------------------------------------------
// wood block
//----------------------------------------------------------------------

#if (show_block)

#declare woodpigment =
    pigment {
        wood
        turbulence 0.03725
        omega 0.65725
        lambda 2.425
        color_map {
            [0.250 color rgb 0.5*<1.00000, 0.53373, 0.11665>]
            [0.350 color rgb 0.5*<0.66275, 0.28607, 0.00000>]
            [0.525 color rgb 0.5*<1.00000, 0.53363, 0.11715>]
            [0.600 color rgb 0.5*<0.66475, 0.28647, 0.00000>]
            [0.750 color rgb 0.5*<1.00000, 0.53353, 0.11565>]
            [0.850 color rgb 0.5*<0.66275, 0.28667, 0.00000>]
            [1.000 color rgb 0.5*<1.00000, 0.53143, 0.11795>]
        }
	rotate <10,7,3>
        scale 1*<2.5, 2.25, 10>
    }


#declare woodblocksize = 0.25;
#declare woodblockpos = <-1,woodblocksize+0.02,0>;
#declare fontsize = 0.6*woodblocksize;
#declare fontwidth = golden*fontsize;
#declare linewidth = 0.18*fontsize;

difference {
  // block
  intersection {
    box { -woodblocksize, woodblocksize}
    sphere { 0, woodblocksize*1.4 }
  texture {
    pigment { woodpigment }
    finish {
      diffuse 0.9
      ambient 0.3
      phong 0.5
      phong_size 20
    }
    scale 0.01
    rotate <14,9,5>
  }
  }
  // "J"
  union {
     sphere { <-fontsize,-fontwidth,0>, linewidth }
     cylinder {<-fontsize,-fontwidth,0>,<-fontsize,fontwidth,0>, linewidth}
     sphere { <-fontsize,fontwidth,0>, linewidth }
     cylinder {<-fontsize,fontwidth,0>,<0.0001+(fontsize-fontwidth),fontwidth,0>, linewidth}
     intersection {
       torus { fontwidth, linewidth rotate x*90 }
       plane { -x,0}
       translate <fontsize-fontwidth,0,0>
     }
     sphere { <fontsize-fontwidth,-fontwidth,0>, linewidth }
     translate <0,0,-woodblocksize> 

     texture {
       finish {
         diffuse 0.8
         ambient 0
         phong 0.5 phong_size 20
       } 
       pigment { color rgb <1,0,0> }
     }
  } 
  // "A"
  union {
     cylinder {<fontsize,0,fontwidth>,<-0.0001-(fontsize-fontwidth),0,fontwidth>, linewidth}
     cylinder {<fontsize,0,-fontwidth>,<-0.0001-(fontsize-fontwidth),0,-fontwidth>, linewidth}
     cylinder {<0,0,-fontwidth>,<0,0,fontwidth>, linewidth}
     intersection {
       torus { fontwidth, linewidth }
       plane { x,0}
       translate <-(fontsize-fontwidth),0,0>
     }
     sphere { <fontsize,0,fontwidth>, linewidth }
     sphere { <fontsize,0,-fontwidth>, linewidth }
     translate <0,woodblocksize,0> 

     texture {
       finish {
         diffuse 0.8
         ambient 0
         phong 0.5 phong_size 20
       } 
       pigment { color rgb <0,0.5,0> }
     }
  }
  // "N"
  union {
     sphere { <0,fontwidth,-fontsize>, linewidth }
     cylinder {<0,fontwidth,-fontsize>,  <0,fontwidth,fontsize>, linewidth }
     sphere { <0,fontwidth,fontsize>, linewidth }
     cylinder {<0,fontwidth,fontsize>,  <0,-fontwidth,-fontsize>, linewidth }
     sphere { <0,-fontwidth,-fontsize>, linewidth }
     cylinder {<0,-fontwidth,-fontsize>,  <0,-fontwidth,fontsize>, linewidth }
     sphere { <0,-fontwidth,fontsize>, linewidth }
     rotate 90*x
     translate <woodblocksize,0,0> 

     texture {
       finish {
         diffuse 0.8
         ambient 0
         phong 0.5 phong_size 20
       } 
       pigment { color rgb <0,0,0.6> }
     }
  }

  rotate 45*y
  translate woodblockpos

}
#end

//----------------------------------------------------------------------
// camera and lighting
//----------------------------------------------------------------------

camera {
// all
  location <-2, 1.7, -3>
  look_at <0,1,0>
// block
//  location <-1, 1.5, -1.5> 
//  look_at woodblockpos
#if (show_focalblur)
  aperture 0.01
  blur_samples 100
  focal_point  <0, bodyheight+headheight/2-0.3*nosewidth, -0.4*headdepth> 
#end
}

light_source { < 0, 16, -20 > color 1 
	spotlight point_at <0,1,0> radius 0.1 falloff 5
}


