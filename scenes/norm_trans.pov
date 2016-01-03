// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)norm_trans.pov
// Description: normal transform patch demo scene
// Features demonstrated: normal transform modifier
// Creation Date: $ 14 Jan 2003, 16:20:11 $
// Last modified: $ 14 Jun 2004, 22:37:50 $
// Author: Christoph Hormann <chris_hormann@gmx.de>
//
// @@ This scene demostrates how to use the normal transform
// @@ modifier to correctly transform the normal vectors of a
// @@ smooth triangle
//
// -w320 -h240 +a0.3

#version unofficial megapov 1.1;

global_settings {
  max_trace_level 10
  assumed_gamma 1.0
}

background { color rgb <0.1,0.2,0.9> }


camera {
  location  <-6.0, -16.0, 7.0>
  up z
  sky z
  look_at   <0.0, 0.0, 0.2>
  angle 33
}

light_source {
  <1000, -3000, 3500>
  color rgb 1.35
}

// ----------------------------------------

plane {
  z, 0

  texture {
    pigment {
      leopard
      color_map {
        [0.2 color rgb <1, 1, 1.1>]
        [0.55 color rgb 0.9]
      }
      scale 0.2
    }
  }
}

// ----------------------------------------

#macro Arrow(Start, End, Radius, Type)

  #local Dir=End-Start;

  union {
    cylinder { Start, Start+Dir-vnormalize(Dir)*Radius*8, Radius }
    cone { Start+Dir-vnormalize(Dir)*Radius*8, Radius*2.2, End, 0 }

    texture {
      pigment { color rgb <1.0, 0.3, 0> }
      finish { ambient 0.1 diffuse 0.6 specular 0.5 }
    }
  }
#end

#declare T_Triangle=
  texture {
    pigment { color rgbft <0.2, 0.4, 0.2, 0.2, 0.4 >}
    finish {
      diffuse 0.8
      brilliance 3
      ambient 0.03
      specular 0.2 roughness 0.12
      reflection 0.3
      conserve_energy
    }
  }

#include "transforms.inc"

// ======== the two transforms ================

#declare Trans1=
  transform {
    translate -10*x
    rotate 20*x
    scale 1.6
    translate <2.2, 2.2, 0.7>
  }


#declare Trans2=
  transform {
    translate -10*x
    rotate -40*y
    rotate 16*x
    rotate 50*z
    scale 0.9
    translate <-2.2, -2.2, 0.8>
  }

// ======== the triangle data ================

#declare P1=<9.2, -1.4, 0.2>;
#declare P2=<8.8, 0.8, 0.45>;
#declare P3=<11.5, 0.3, 0.3>;

#declare N1=vnormalize(<0.0, -0.5, 0.8>);
#declare N2=vnormalize(<-0.3, 0.3, 0.8>);
#declare N3=vnormalize(<0.4, -0.2, 0.8>);


// ======== transform 1 ================

#declare P1a=vtransform(P1, Trans1);
#declare P2a=vtransform(P2, Trans1);
#declare P3a=vtransform(P3, Trans1);

#declare Trans=transform { Trans1 }
//#declare Trans=transform { Trans1 normal }

#declare N1a=vnormalize(vtransform(N1, Trans));
#declare N2a=vnormalize(vtransform(N2, Trans));
#declare N3a=vnormalize(vtransform(N3, Trans));

union {
  Arrow(P1a, P1a+N1a*1.5, 0.05, 0)
  Arrow(P2a, P2a+N2a*1.5, 0.05, 0)
  Arrow(P3a, P3a+N3a*1.5, 0.05, 0)
}

object {
  smooth_triangle { P1a, N1a, P2a, N2a, P3a, N3a }
  texture { T_Triangle }
}

// ======== transform 2 ================

#declare P1a=vtransform(P1, Trans2);
#declare P2a=vtransform(P2, Trans2);
#declare P3a=vtransform(P3, Trans2);

//#declare Trans=transform { Trans2 }
#declare Trans=transform { Trans2 normal }

#declare N1a=vnormalize(vtransform(N1, Trans));
#declare N2a=vnormalize(vtransform(N2, Trans));
#declare N3a=vnormalize(vtransform(N3, Trans));

union {
  Arrow(P1a, P1a+N1a*1.5, 0.05, 0)
  Arrow(P2a, P2a+N2a*1.5, 0.05, 0)
  Arrow(P3a, P3a+N3a*1.5, 0.05, 0)
}

object {
  smooth_triangle { P1a, N1a, P2a, N2a, P3a, N3a }
  texture { T_Triangle }
}


