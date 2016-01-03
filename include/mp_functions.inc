// Persistence of Vision Ray Tracer version 3.5 Include File
//
// This include file is part of MegaPOV

#ifdef(MPFunctions_Inc_Temp)
// do nothing
#else
#declare MPFunctions_Inc_Temp = version;

#ifndef(Functions_Inc_Temp)
  #include "functions.inc"
#end

#ifdef(View_POV_Include_Stack)
#   debug "including mp_functions.inc\n"
#end

#version unofficial megapov 1.2;

#declare f_triangle = function { internal(79) }
// Parameters: x, y, z
    // 10 extra parameters required:
    //
    // 1. - 3. coordinates of the first vertex in the triangle.
    // 4. - 6. coordinates of the second vertex in the triangle.
    // 7. - 9. coordinates of the third vertex in the triangle.
    // 10. thickness of the triangle.


#end//mp_functions.inc

