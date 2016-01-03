// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)planets.pov
// Description: Planet movement simulation
// Features demonstrated: mechsim
// Creation Date: $ 14 Apr 2003, 16:55:14 $
// Last modified: $ 29 Apr 2005, 12:33:49 $
// Author: Christoph Hormann
//
// @@ This scene simulates the movement of the inner
// @@ planets of the solar system in real scale using
// @@ the interaction feature of the mechsim patch.
// @@ Starting conditions are simplified (all orbits in 
// @@ the same plane).  Timescale is 1 day per frame.  
// @@ The scaling of the planets in the scene is 
// @@ exaggerated to make them visible.
//
// -w640 -h480 +a0.3 -j +kff365

#version unofficial megapov 1.2;

#declare show_Orbits=true;


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


		#if (file_exists("planets.dat") & (frame_number>1))
			step_count 2000

			// 1 day per step
			time_step (24*3600)/2000

			topology {
				load_file "planets.dat"
				save_file "planets.dat"
			}
		#else
			step_count 0

			topology {

				// Sun
				mass { <0,0,0>, <0,0,0>, 696.0e6 mass 1.99e30 }
				// Mercury
				mass { <57.9*Mio_km,0,0>, <0,47.9*1000,0>, (4879/2)*1000 mass 0.330e24 }
				// Venus
				mass { <108.2*Mio_km,0,0>, <0,35.0*1000,0>, (12104/2)*1000 mass 4.87e24 }
				// Earth
				mass { <149.6*Mio_km,0,0>, <0,29.8*1000,0>, (6371.0)*1000 mass 5.97e24 }

				// Moon
				mass { <(0.3844+149.6)*Mio_km,0,0>, <0,(29.8+1.023)*1000,0>, (1737.4)*1000 mass 0.07349e24 }

				// Mars
				mass { <227.9*Mio_km,0,0>, <0,24.1*1000,0>, (6794/2)*1000 mass 0.642e24 }

				save_file "planets.dat"
			}
		#end
	}
}

// ----------------------------------------

camera {
	location  <-1.0, 0.0, 10.0>*200
	up z
	sky z
	look_at   <0.0, 0.0, 0.0>
	angle 20
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
/*
sphere {
	mechsim:mass(0):position/Mio_km,
	mechsim:mass(0):radius*30/Mio_km
	texture {
		pigment { color rgb <1,1,0> }
		finish { ambient 1 diffuse 0 }
	}
}
*/

// Mercury
sphere {
	mechsim:mass(1):position/Mio_km,
	mechsim:mass(1):radius*800/Mio_km
	texture {
		pigment { color rgb <1,0,0> }
		finish { ambient 1 diffuse 0 }
	}
}

// Venus
sphere {
	mechsim:mass(2):position/Mio_km,
	mechsim:mass(2):radius*800/Mio_km
	texture {
		pigment { color rgb <0,0,1> }
		finish { ambient 1 diffuse 0 }
	}
}

// Earth
sphere {
	mechsim:mass(3):position/Mio_km,
	mechsim:mass(3):radius*800/Mio_km
	texture {
		pigment { color rgb <0,1,0.8> }
		finish { ambient 1 diffuse 0 }
	}
}

// Moon
cylinder {
	//mechsim:mass(4):position/Mio_km,
	//mechsim:mass(4):radius*800/Mio_km
	mechsim:mass(3):position/Mio_km,
	mechsim:mass(3):position/Mio_km+
	30*(mechsim:mass(4):position/Mio_km-mechsim:mass(3):position/Mio_km),
	mechsim:mass(3):radius*200/Mio_km
	texture {
		pigment { color rgb <0.5,0.5,0.5> }
		finish { ambient 1 diffuse 0 }
	}
}

// Mars
sphere {
	mechsim:mass(5):position/Mio_km,
	mechsim:mass(5):radius*800/Mio_km
	texture {
		pigment { color rgb <1,0.5,0> }
		finish { ambient 1 diffuse 0 }
	}
}

#if (show_Orbits)
	union {
		torus { 57.9, 1.0 }
		torus { 108.2, 1.0 }
		torus { 149.6, 1.0 }
		torus { 227.9, 1.0 }
		rotate 90*x
		texture {
			pigment {  color rgb <0,0,0.5> }
			finish { ambient 1 diffuse 0 }
		}
	}
#end
