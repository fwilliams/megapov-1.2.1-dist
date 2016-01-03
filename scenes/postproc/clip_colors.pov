// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)clip_colors.pov
// Description: postprocessing sample scene
// Features demonstrated: pprocess
// Creation Date: $ 22 Jul 2004, 00:00:00 $
// Last modified: $ 22 Jul 2004, 00:00:00 $
// Author: Wlodzimierz ABX Skiba
//
// @@ This scene demonstrates clip_colors.
//
// -w320 -h240 +a0.3

#version unofficial MegaPov 1.1;

#include "pprocess.inc"

#declare CMin=rgb <0.5,0,0.5>;
#declare CMax=rgb <1,0.2,1>;

global_settings {
  assumed_gamma 1.0
  post_process{ 
    PP_Clip_Colors(CMin,CMax) 
    save_file concat("pp_",output_filename(0))
  }
}

#include "ppcontent.inc"
