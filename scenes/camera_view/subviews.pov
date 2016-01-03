// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)subviews.pov
// Description: Sample usage of camera_view and screen.inc
// Features demonstrated: camera_view
// Creation Date: $ 20 Aug 2004, 00:00:00 $
// Last modified: $ 20 Aug 2004, 00:00:00 $
// Author: Wlodzimierz ABX Skiba
//
// -w750 -h450 +a0.3

#version unofficial MegaPov 1.1;

#include "colors.inc"
#include "math.inc"
#include "functions.inc"
#include "screen.inc"

background { colour Silver }

global_settings {
  assumed_gamma 1.0
}

#declare Skin = pigment{color White}
#declare Hair = pigment{color Black}
#declare Lip  = pigment{color Red}
#declare Eye  = pigment{color Blue}

#declare Radius = 10;
#declare Visible = 1.5;
#declare FaceRadius = sqrt( pow(Radius,2) - pow(Radius-Visible,2) );

#declare Face=sphere{
  <0,0,Radius-Visible>
  Radius
  pigment{Skin}
}

#declare Neck = cone{
  <0,0,0>
  0
  <0,-1.2*FaceRadius,0>
  FaceRadius/2
  pigment{Skin}
  scale <1,1,.2>
}

#declare Hairs = torus{
  FaceRadius-Visible/2
  Visible/2
  rotate x*90
  scale <1,.5,1>
  translate y*FaceRadius/2
  pigment{Hair}
}

#declare Eyes = union{
  sphere{< Visible,Visible,0> Visible}
  sphere{<-Visible,Visible,0> Visible}
  pigment{Eye}
}

#declare Nose = cone{
  <0,FaceRadius-Visible/2,0>
  0
  <0,-Visible,-Visible>
  Visible/2
  pigment{Skin}
}

#declare Lips = cone{
  <0,-3*Visible/2,0>
  0
  <0,-2*Visible,-Visible>
  2*Visible/3
  pigment{Lip}
}

#declare Head = union{
  object{Face}
  object{Neck}
  object{Nose}
  object{Eyes}
  object{Lips}
  object{Hairs}
}

#declare FrontHead = difference{
  object{Head}
  box{-<Radius+1,Radius+1,0> <Radius+1,Radius+1,2*Radius+1>}
}

object{FrontHead}

#local CamFront = camera{
  orthographic
  location -3*Visible*z/2
  look_at <0,0,0>
  up y*FaceRadius*1.2*2
  right x*FaceRadius*1.2*2
}

#local CamTop = camera{
  CamFront
  translate -z*FaceRadius
  rotate x*90
}

#local CamSide = camera{
  CamFront
  translate -z*FaceRadius
  rotate y*90
}

Set_Camera_Location(<-FaceRadius,FaceRadius/3,-Visible*10>)
Set_Camera_Look_At(<0,0,0>)
light_source{ <100*Radius,300*Radius,-500*Radius> color White }

Screen_Plane (texture{pigment{camera_view{CamFront output 1}}}, .001, <0,2/3>, <1/5,3/3>) // coordinates
Screen_Plane (texture{pigment{camera_view{CamFront output 2}}}, .001, <0,1/3>, <1/5,2/3>) // intersection
Screen_Plane (texture{pigment{camera_view{CamFront output 4}}}, .001, <0,0/3>, <1/5,1/3>) // depth

Screen_Plane (texture{pigment{camera_view{CamSide }}}, .001, <4/5,2/3>, <1,3/3>) // side view
Screen_Plane (texture{pigment{camera_view{CamFront}}}, .001, <4/5,1/3>, <1,2/3>) // front view
Screen_Plane (texture{pigment{camera_view{CamTop  }}}, .001, <4/5,0/3>, <1,1/3>) // top view