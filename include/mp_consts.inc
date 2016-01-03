// Persistence of Vision Ray Tracer version 3.5 Include File
//
// This include file is part of MegaPOV

#ifdef(MPConsts_Inc_Temp)
// do nothing
#else
#declare MPConsts_Inc_Temp = version;

#ifdef(View_POV_Include_Stack)
#   debug "including mp_consts.inc\n"
#end

#version unofficial megapov 1.2;

// OUTPUT IN CAMERA_VIEW CONSTANTS
#declare Output_Color                   = 0;
#declare Output_Intersection_Point      = 1;
#declare Output_Normal_Vector           = 2;
#declare Output_Perturbed_Normal_Vector = 3;
#declare Output_Depth                   = 4;
#declare Output_UV_Vector               = 5;

#declare MAX_MEGAPOV_DISTANCE           = 1e7;

#version MPConsts_Inc_Temp;
#end