// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)convolution_matrix.pov
// Description: postprocessing sample scene
// Features demonstrated: pprocess
// Creation Date: $ 22 Jul 2004, 00:00:00 $
// Last modified: $ 22 Jul 2004, 00:00:00 $
// Author: Wlodzimierz ABX Skiba
//
// @@ This scene demonstrates convolution_matrix.
//
// -w320 -h240 +a0.3

#version unofficial MegaPov 1.1;

#include "pprocess.inc"

#declare XDIM=9;
#declare YDIM=1;
#declare DIVISOR=4.5;
#declare LEVELING=0;
#declare MATRIX=array[XDIM*YDIM]{
  0.5,0.75,0.25,
  0.5,0.75,0.25,
  0.5,0.75,0.25
};

global_settings {
  assumed_gamma 1.0
  post_process{ 
    PP_Convolution_Matrix(XDIM,YDIM,DIVISOR,LEVELING,MATRIX)
    save_file concat("pp_",output_filename(0))
  }
}

#include "ppcontent.inc"
