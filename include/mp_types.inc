// Persistence of Vision Ray Tracer version 3.5 Include File
//
// This include file is part of MegaPOV

#ifdef(MPTypes_Inc_Temp)
// do nothing
#else
#declare MPTypes_Inc_Temp = version;

#ifdef(View_POV_Include_Stack)
#   debug "including mp_types.inc\n"
#end

#version unofficial megapov 1.2;

#declare UNDEFINED_ID     =  0;
#declare FLOAT_ID         =  1;
#declare VECTOR_ID        =  2;
#declare COLOR_ID         =  3;
#declare COLOUR_ID        =  COLOR_ID;
#declare FUNCTION_ID      =  4;
#declare STRING_ID        =  5;
#declare ARRAY_ID         =  6;
#declare SPLINE_ID        =  7;
#declare TRANSFORM_ID     =  8;
#declare CAMERA_ID        =  9;
#declare LIGHT_SOURCE_ID  = 10;
#declare OBJECT_ID        = 11;
#declare MATERIAL_ID      = 12;
#declare INTERIOR_ID      = 13;
#declare TEXTURE_ID       = 14;
#declare TEXTURE_MAP_ID   = 15;
#declare PIGMENT_ID       = 16;
#declare COLOR_MAP_ID     = 17;
#declare COLOUR_MAP_ID    = COLOR_MAP_ID;
#declare PIGMENT_MAP_ID   = 18;
#declare NORMAL_ID        = 19;
#declare SLOPE_MAP_ID     = 20;
#declare NORMAL_MAP_ID    = 21;
#declare FINISH_ID        = 22;
#declare MEDIA_ID         = 23;
#declare DENSITY_ID       = 24;
#declare DENSITY_MAP_ID   = 25;
#declare FOG_ID           = 26;
#declare RAINBOW_ID       = 27;
#declare SKY_SPHERE_ID    = 28;

#macro Type_Of(_Id_)
  #local T=UNDEFINED_ID;
  #local U=T;
  #local T=((T=U)?is(_Id_,float       )?FLOAT_ID       :U:T);
  #local T=((T=U)?is(_Id_,vector      )?VECTOR_ID      :U:T);
  #local T=((T=U)?is(_Id_,color       )?COLOR_ID       :U:T);
  #local T=((T=U)?is(_Id_,function    )?FUNCTION_ID    :U:T);
  #local T=((T=U)?is(_Id_,string      )?STRING_ID      :U:T);
  #local T=((T=U)?is(_Id_,array       )?ARRAY_ID       :U:T);
  #local T=((T=U)?is(_Id_,spline      )?SPLINE_ID      :U:T);
  #local T=((T=U)?is(_Id_,transform   )?TRANSFORM_ID   :U:T);
  #local T=((T=U)?is(_Id_,camera      )?CAMERA_ID      :U:T);
  #local T=((T=U)?is(_Id_,light_source)?LIGHT_SOURCE_ID:U:T);
  #local T=((T=U)?is(_Id_,object      )?OBJECT_ID      :U:T);
  #local T=((T=U)?is(_Id_,material    )?MATERIAL_ID    :U:T);
  #local T=((T=U)?is(_Id_,interior    )?INTERIOR_ID    :U:T);
  #local T=((T=U)?is(_Id_,texture     )?TEXTURE_ID     :U:T);
  #local T=((T=U)?is(_Id_,texture_map )?TEXTURE_MAP_ID :U:T);
  #local T=((T=U)?is(_Id_,pigment     )?PIGMENT_ID     :U:T);
  #local T=((T=U)?is(_Id_,color_map   )?COLOR_MAP_ID   :U:T);
  #local T=((T=U)?is(_Id_,pigment_map )?PIGMENT_MAP_ID :U:T);
  #local T=((T=U)?is(_Id_,normal      )?NORMAL_ID      :U:T);
  #local T=((T=U)?is(_Id_,slope_map   )?SLOPE_MAP_ID   :U:T);
  #local T=((T=U)?is(_Id_,normal_map  )?NORMAL_MAP_ID  :U:T);
  #local T=((T=U)?is(_Id_,finish      )?FINISH_ID      :U:T);
  #local T=((T=U)?is(_Id_,media       )?MEDIA_ID       :U:T);
  #local T=((T=U)?is(_Id_,density     )?DENSITY_ID     :U:T);
  #local T=((T=U)?is(_Id_,density_map )?DENSITY_MAP_ID :U:T);
  #local T=((T=U)?is(_Id_,fog         )?FOG_ID         :U:T);
  #local T=((T=U)?is(_Id_,rainbow     )?RAINBOW_ID     :U:T);
  #local T=((T=U)?is(_Id_,sky_sphere  )?SKY_SPHERE_ID  :U:T);
  (T)
#end

#declare NOT_SPLINE         =  0;
#declare LINEAR_SPLINE      =  1;
#declare QUADRATIC_SPLINE   =  2;
#declare NATURAL_SPLINE     =  3;
#declare CATMULL_ROM_SPLINE =  4;
#declare CUBIC_SPLINE       =  CATMULL_ROM_SPLINE;
#declare SOR_SPLINE         =  5;
#declare TCB_SPLINE         =  6;
#declare AKIMA_SPLINE       =  7;
#declare BASIC_X_SPLINE     =  8;
#declare EXTENDED_X_SPLINE  =  9;
#declare GENERAL_X_SPLINE   = 10;

#macro Type_Of_Spline(_Id_)
  #local T=NOT_SPLINE;
  #if(is(_Id_,spline))
    #local U=T;
    #local T=((T=U)?is(_Id_,linear_spline    )?LINEAR_SPLINE    :U:T);
    #local T=((T=U)?is(_Id_,quadratic_spline )?QUADRATIC_SPLINE :U:T);
    #local T=((T=U)?is(_Id_,natural_spline   )?NATURAL_SPLINE   :U:T);
    #local T=((T=U)?is(_Id_,cubic_spline     )?CUBIC_SPLINE     :U:T);
    #local T=((T=U)?is(_Id_,sor_spline       )?SOR_SPLINE       :U:T);
    #local T=((T=U)?is(_Id_,tcb_spline       )?TCB_SPLINE       :U:T);
    #local T=((T=U)?is(_Id_,akima_spline     )?AKIMA_SPLINE     :U:T);
    #local T=((T=U)?is(_Id_,basic_x_spline   )?BASIC_X_SPLINE   :U:T);
    #local T=((T=U)?is(_Id_,extended_x_spline)?EXTENDED_X_SPLINE:U:T);
    #local T=((T=U)?is(_Id_,general_x_spline )?GENERAL_X_SPLINE :U:T);
  #end
  (T)
#end

#declare NOT_OBJECT             =  0;
#declare BICUBIC_PATCH_OBJECT   =  1;
#declare BLOB_OBJECT            =  2;
#declare BOX_OBJECT             =  3;
#declare CONE_OBJECT            =  4;
#declare CUBIC_OBJECT           =  5;
#declare CYLINDER_OBJECT        =  6;
#declare DISC_OBJECT            =  7;
#declare HEIGHT_FIELD_OBJECT    =  8;
#declare INTERSECTION_OBJECT    =  9;
#declare DIFFERENCE_OBJECT      = INTERSECTION_OBJECT;
#declare ISOSURFACE_OBJECT      = 10;
#declare JULIA_FRACTAL_OBJECT   = 11;
#declare LATHE_OBJECT           = 12;
#declare MERGE_OBJECT           = 13;
#declare MESH_OBJECT            = 14;
#declare MESH2_OBJECT           = MESH_OBJECT;
#declare PARAMETRIC_OBJECT      = 15;
#declare PLANE_OBJECT           = 16;
#declare POLY_OBJECT            = 17;
#declare POLYGON_OBJECT         = 18;
#declare PRISM_OBJECT           = 19;
#declare QUADRIC_OBJECT         = 20;
#declare QUARTIC_OBJECT         = 21;
#declare SMOOTH_TRIANGLE_OBJECT = 22;
#declare SOR_OBJECT             = 23;
#declare SPHERE_OBJECT          = 24;
#declare SPHERE_SWEEP_OBJECT    = 25;
#declare SUPERELLIPSOID_OBJECT  = 26;
#declare TEXT_OBJECT            = 27;
#declare TORUS_OBJECT           = 28;
#declare TRIANGLE_OBJECT        = 29;
#declare UNION_OBJECT           = 30;

#macro Type_Of_Object(_Id_)
  #local T=NOT_OBJECT;
  #if(is(_Id_,object))
    #local U=T;
    #local T=((T=U)?is(_Id_,bicubic_patch  )?BICUBIC_PATCH_OBJECT  :U:T);
    #local T=((T=U)?is(_Id_,blob           )?BLOB_OBJECT           :U:T);
    #local T=((T=U)?is(_Id_,box            )?BOX_OBJECT            :U:T);
    #local T=((T=U)?is(_Id_,cone           )?CONE_OBJECT           :U:T);
    #local T=((T=U)?is(_Id_,cubic          )?CUBIC_OBJECT          :U:T);
    #local T=((T=U)?is(_Id_,cylinder       )?CYLINDER_OBJECT       :U:T);
    #local T=((T=U)?is(_Id_,disc           )?DISC_OBJECT           :U:T);
    #local T=((T=U)?is(_Id_,height_field   )?HEIGHT_FIELD_OBJECT   :U:T);
    #local T=((T=U)?is(_Id_,intersection   )?INTERSECTION_OBJECT   :U:T);
    #local T=((T=U)?is(_Id_,isosurface     )?ISOSURFACE_OBJECT     :U:T);
    #local T=((T=U)?is(_Id_,julia_fractal  )?JULIA_FRACTAL_OBJECT  :U:T);
    #local T=((T=U)?is(_Id_,lathe          )?LATHE_OBJECT          :U:T);
    #local T=((T=U)?is(_Id_,merge          )?MERGE_OBJECT          :U:T);
    #local T=((T=U)?is(_Id_,mesh           )?MESH_OBJECT           :U:T);
    #local T=((T=U)?is(_Id_,parametric     )?PARAMETRIC_OBJECT     :U:T);
    #local T=((T=U)?is(_Id_,plane          )?PLANE_OBJECT          :U:T);
    #local T=((T=U)?is(_Id_,poly           )?POLY_OBJECT           :U:T);
    #local T=((T=U)?is(_Id_,polygon        )?POLYGON_OBJECT        :U:T);
    #local T=((T=U)?is(_Id_,prism          )?PRISM_OBJECT          :U:T);
    #local T=((T=U)?is(_Id_,quadric        )?QUADRIC_OBJECT        :U:T);
    #local T=((T=U)?is(_Id_,quartic        )?QUARTIC_OBJECT        :U:T);
    #local T=((T=U)?is(_Id_,smooth_triangle)?SMOOTH_TRIANGLE_OBJECT:U:T);
    #local T=((T=U)?is(_Id_,sor            )?SOR_OBJECT            :U:T);
    #local T=((T=U)?is(_Id_,sphere         )?SPHERE_OBJECT         :U:T);
    #local T=((T=U)?is(_Id_,sphere_sweep   )?SPHERE_SWEEP_OBJECT   :U:T);
    #local T=((T=U)?is(_Id_,superellipsoid )?SUPERELLIPSOID_OBJECT :U:T);
    #local T=((T=U)?is(_Id_,text           )?TEXT_OBJECT           :U:T);
    #local T=((T=U)?is(_Id_,torus          )?TORUS_OBJECT          :U:T);
    #local T=((T=U)?is(_Id_,triangle       )?TRIANGLE_OBJECT       :U:T);
    #local T=((T=U)?is(_Id_,union          )?UNION_OBJECT          :U:T);
  #end
  (T)
#end

#declare NOT_CAMERA              = 0;
#declare CYLINDER_CAMERA         = 1;
#declare FISHEYE_CAMERA          = 2;
#declare OMNIMAX_CAMERA          = 3;
#declare ORTHOGRAPHIC_CAMERA     = 4;
#declare PANORAMIC_CAMERA        = 5;
#declare PERSPECTIVE_CAMERA      = 6;
#declare SPHERICAL_CAMERA        = 7;
#declare ULTRA_WIDE_ANGLE_CAMERA = 8; 
#declare USER_DEFINED_CAMERA     = 9;

#macro Type_Of_Camera(_Id_)
  #local T=NOT_CAMERA;
  #if(is(_Id_,camera))
    #local U=T;
    #local T=((T=U)?is(_Id_,cylinder        )?CYLINDER_CAMERA        :U:T);
    #local T=((T=U)?is(_Id_,fisheye         )?FISHEYE_CAMERA         :U:T);
    #local T=((T=U)?is(_Id_,omnimax         )?OMNIMAX_CAMERA         :U:T);
    #local T=((T=U)?is(_Id_,orthographic    )?ORTHOGRAPHIC_CAMERA    :U:T);
    #local T=((T=U)?is(_Id_,panoramic       )?PANORAMIC_CAMERA       :U:T);
    #local T=((T=U)?is(_Id_,perspective     )?PERSPECTIVE_CAMERA     :U:T);
    #local T=((T=U)?is(_Id_,spherical       )?SPHERICAL_CAMERA       :U:T);
    #local T=((T=U)?is(_Id_,ultra_wide_angle)?ULTRA_WIDE_ANGLE_CAMERA:U:T);
    #local T=((T=U)?is(_Id_,user_defined    )?USER_DEFINED_CAMERA    :U:T);
  #end
  (T)
#end


#version MPTypes_Inc_Temp;
#end