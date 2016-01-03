// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)find_edges.pov
// Description: postprocessing sample scene
// Features demonstrated: pprocess
// Creation Date: $ 07 Sep 2004, 00:00:00 $
// Last modified: $ 07 Sep 2004, 14:34:16 $
// Author: Wlodzimierz ABX Skiba
//
// @@ This scene demonstrates find_edges.
//
// -w320 -h240 +a0.3

#version unofficial MegaPov 1.1;

#include "pprocess.inc"

#declare Depth_Thresh=1;
#declare Normal_Thresh=.3;
#declare Color_Thresh=.15;
#declare Line_Radius=2;
#declare Sharpness=1.0;
#declare Pigment=pigment{rgb 0};

global_settings {
  assumed_gamma 1.0
  post_process{ 
    PP_Find_Edges(Depth_Thresh,Normal_Thresh,Color_Thresh,Line_Radius,Sharpness,Pigment)
    save_file concat("pp_",output_filename(0))
  }
}

#include "ppcontent.inc"
