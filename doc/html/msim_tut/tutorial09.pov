// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)tutorial09.pov
// Description: mechanics simulation tutorial scene 9
// Features demonstrated: mechsim
// Creation Date: $ 29 Apr 2005, 11:54:09 $
// Last modified: $ 29 Apr 2005, 13:07:44 $
// Author: Christoph Hormann
//
//
// -w320 -h240 +a0.3 -j +kff250

#version unofficial megapov 1.2;

#include "mechsim.inc"

// Gravitation constant: 6.672e-11 m^3*kg^-1*s^-2
#declare G=6.672e-11;

// Newton's law of gravitation
#declare fn_Gravity=
	function(x, y, z, dist, m1, m2) {
		(G*m1*m2)/(dist*dist)
	}

#declare Mio_km=1.0e9;

global_settings {
	assumed_gamma 1.0

	mechsim {
		method 1

		interaction {
			function(x, y, z, dist, m1, m2) { fn_Gravity(x, y, z, dist, m1, m2) }
		}

		#if (frame_number=1)
			step_count 0

			topology {

				// Sun
				mass { <0,0,0>, <0,0,0>, 696.0e6 mass 1.99e30 }
				// Earth
				mass { <149.6*Mio_km,0,0>, <0,29.8*1000,0>, (6371.0)*1000 mass 5.97e24 }

				save_file "tut09.dat"
			}
		#else
			step_count 2000

			// 1 day per step
			time_step (24*3600)/2000

			topology {
				load_file "tut09.dat"
				save_file "tut09.dat"
			}
		#end
	}
}

// ----------------------------------------

camera {
	location  <-5.0, 0.0, 3.0>*200
	up z
	sky z
	look_at   <0.0, 0.0, 0.0>
	angle 18
}

// ----------------------------------------

// Sun
glow {
	type 0
	location mechsim:mass(0):position/Mio_km
	size mechsim:mass(0):radius*1.5/Mio_km
	radius mechsim:mass(0):radius*350/Mio_km
	fade_power 2
	color	rgb <2.0, 1.5, 1.0>
}
light_source {
	mechsim:mass(0):position/Mio_km
	color rgb <2.0, 1.5, 1.0>
}

// Earth
sphere {
	mechsim:mass(1):position/Mio_km,
	mechsim:mass(1):radius*800/Mio_km
	texture {
		pigment { color rgb <0,0.5,1> }
		finish { ambient 0.1 diffuse 0.85 }
	}
}

torus {
	149.6,
	mechsim:mass(1):radius*800*0.15/Mio_km
	rotate 90*x
	texture {
		pigment {  color rgb <0,0,0.4> }
		finish { ambient 1 diffuse 0 }
	}
}
