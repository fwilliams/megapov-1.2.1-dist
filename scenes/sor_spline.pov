// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)sor_spline.pov
// Description: New sor_spline spline type demonstration
// Features demonstrated: sor_spline spline type
// Creation Date: $ 14 Jun 2004, 16:26:15 $
// Last modified: $ 14 Jun 2004, 22:37:24 $
// Author: Wlodzimierz ABX Skiba
//
// Splines are used in POV-Ray in several contexts.
// When You want to use some object placed "evenly" on surface of 
// sor object you can't do it with spline. 
// But sor is listed in documentation in spline based objects list! 
// So let's add spline base on sor equations. Below description can 
// be also considered as tutorial for introducing new types of splines. 
// Building it I have used equations available in POV-Ray documentation 
// evaluated by my in some old post. This patch introduces new keyword 
// sor_spline. To move data from sor object to sor_spline order of 
// coordinates has to be changed. Old y coordinate is now clock in spline. 
// Advantage is that one splane can hold data from five old sors. 
// That's becouse it can operate up to five dimensions along clock value.
//
// -w320 -h240 +a0.3

#version unofficial MegaPOV 1.1;

#declare S=spline{
   sor_spline
  -1.000000,0.000000*x
   0.000000,0.118143*x
   0.540084,0.620253*x
   0.827004,0.210970*x
   0.962025,0.194093*x
   1.000000,0.286920*x
   1.033755,0.468354*x
};

union{
  sor{
    7
    <0.000000, -1.000000>
    <0.118143,  0.000000>
    <0.620253,  0.540084>
    <0.210970,  0.827004>
    <0.194093,  0.962025>
    <0.286920,  1.000000>
    <0.468354,  1.033755>
  }
  #local C=0;
  #while(C<=1)
    #local R=0;
    #while(R<360)
      sphere{<0,C,-S(C).x> , .01 rotate y*R}
      #local R=R+30;
    #end
    #local C=C+.01;
  #end
  translate 1.5*z-y/2
  pigment{color rgb 1}
}

light_source{-9 1}
background{1}
camera{right x up y location y/9}