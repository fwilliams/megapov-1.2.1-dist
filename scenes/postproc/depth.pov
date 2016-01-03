// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)depth.pov
// Description: postprocessing sample scene
// Features demonstrated: pprocess
// Creation Date: $ 22 Jul 2004, 00:00:00 $
// Last modified: $ 22 Jul 2004, 00:00:00 $
// Author: Wlodzimierz ABX Skiba
//
// @@ This scene demonstrates depth effect.
//
// -w320 -h240 +a0.3

#version unofficial MegaPov 1.1;

#include "pprocess.inc"

#declare DepthMin=0;
#declare DepthMax=10;

global_settings {
  assumed_gamma 1.0
  post_process{ 
    PP_Depth(DepthMin,DepthMax)
    save_file concat("pp_",output_filename(0))
  }
}

#include "ppcontent.inc"

