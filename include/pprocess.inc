// Persistence of Vision Ray Tracer version 3.5 Include File
//
// This include file is part of MegaPOV

#ifdef(PProcess_Inc_Temp)
// do nothing
#else
#declare PProcess_Inc_Temp = version;

#ifdef(View_POV_Include_Stack)
#   debug "including pprocess.inc\n"
#end

#version unofficial megapov 1.2;

#include "functions.inc"
#include "math.inc"
#include "mp_consts.inc"

//--------------------------------------------------------------
//-----   initializers for outputs with colors   ---------------
//--------------------------------------------------------------
 
#macro PP_Init_Red_Output()
  #ifndef(f_output_red)
    #declare f_output_red=function{internal(80)};
  #end
#end

#macro PP_Init_Green_Output()
  #ifndef(f_output_green)
    #declare f_output_green=function{internal(81)};
  #end
#end

#macro PP_Init_Blue_Output()
  #ifndef(f_output_blue)
    #declare f_output_blue=function{internal(82)};
  #end
#end

#macro PP_Init_Alpha_Output()
  #ifndef(f_output_alpha)
    #declare f_output_alpha=function{internal(83)};
  #end
#end

#macro PP_Init_Colors_Outputs()
  PP_Init_Red_Output()
  PP_Init_Green_Output()
  PP_Init_Blue_Output()
#end

#macro PP_Init_Alpha_Colors_Outputs()
  PP_Init_Colors_Outputs()
  PP_Init_Alpha_Output()
#end

//--------------------------------------------------------------
//-----   initializers for outputs with intersection point   ---
//--------------------------------------------------------------

#macro PP_Init_IPoint_X_Output()
  #ifndef(f_output_ipoint_x)
    #declare f_output_ipoint_x=function{internal(84)};
  #end
#end

#macro PP_Init_IPoint_Y_Output()
  #ifndef(f_output_ipoint_y)
    #declare f_output_ipoint_y=function{internal(85)};
  #end
#end

#macro PP_Init_IPoint_Z_Output()
  #ifndef(f_output_ipoint_z)
    #declare f_output_ipoint_z=function{internal(86)};
  #end
#end

#macro PP_Init_IPoint_Outputs()
  PP_Init_IPoint_X_Output()
  PP_Init_IPoint_Y_Output()
  PP_Init_IPoint_Z_Output()
#end

//--------------------------------------------------------------
//-----   initializers for outputs with intersection normal   --
//--------------------------------------------------------------

#macro PP_Init_INormal_X_Output()
  #ifndef(f_output_inormal_x)
    #declare f_output_inormal_x=function{internal(87)};
  #end
#end

#macro PP_Init_INormal_Y_Output()
  #ifndef(f_output_inormal_y)
    #declare f_output_inormal_y=function{internal(88)};
  #end
#end

#macro PP_Init_INormal_Z_Output()
  #ifndef(f_output_inormal_z)
    #declare f_output_inormal_z=function{internal(89)};
  #end
#end

#macro PP_Init_INormal_Outputs()
  PP_Init_INormal_X_Output()
  PP_Init_INormal_Y_Output()
  PP_Init_INormal_Z_Output()
#end

//--------------------------------------------------------------
//-----   initializers for outputs with perturbed normal   -----
//--------------------------------------------------------------

#macro PP_Init_PNormal_X_Output()
  #ifndef(f_output_pnormal_x)
    #declare f_output_pnormal_x=function{internal(90)};
  #end
#end

#macro PP_Init_PNormal_Y_Output()
  #ifndef(f_output_pnormal_y)
    #declare f_output_pnormal_y=function{internal(91)};
  #end
#end

#macro PP_Init_PNormal_Z_Output()
  #ifndef(f_output_pnormal_z)
    #declare f_output_pnormal_z=function{internal(92)};
  #end
#end

#macro PP_Init_PNormal_Outputs()
  PP_Init_PNormal_X_Output()
  PP_Init_PNormal_Y_Output()
  PP_Init_PNormal_Z_Output()
#end

//--------------------------------------------------------------
//-----   initializer for output with depth   ------------------
//--------------------------------------------------------------

#macro PP_Init_Depth_Output()
  #ifndef(f_output_depth)
    #declare f_output_depth=function{internal(93)};
  #end
#end

//--------------------------------------------------------------
//-----   initializers for outputs with uv vectors   -----------
//--------------------------------------------------------------

#macro PP_Init_UV_U_Output()
  #ifndef(f_output_u)
    #declare f_output_u=function{internal(94)};
  #end
#end

#macro PP_Init_UV_V_Output()
  #ifndef(f_output_v)
    #declare f_output_v=function{internal(95)};
  #end
#end

#macro PP_Init_UV_Outputs()
  PP_Init_UV_U_Output()
  PP_Init_UV_V_Output()
#end

//--------------------------------------------------------------
//-----   initializers for references to previous effects   ----
//--------------------------------------------------------------

#macro PP_Init_PP_Red_Output()
  #ifndef(f_pp_red)
    #declare f_pp_red=function{internal(96)};
  #end
#end

#macro PP_Init_PP_Green_Output()
  #ifndef(f_pp_green)
    #declare f_pp_green=function{internal(97)};
  #end
#end

#macro PP_Init_PP_Blue_Output()
  #ifndef(f_pp_blue)
    #declare f_pp_blue=function{internal(98)};
  #end
#end

#macro PP_Init_PP_Alpha_Output()
  #ifndef(f_pp_alpha)
    #declare f_pp_alpha=function{internal(99)};
  #end
#end

#macro PP_Init_PP_Colors_Outputs()
  PP_Init_PP_Red_Output()
  PP_Init_PP_Green_Output()
  PP_Init_PP_Blue_Output()
#end

#macro PP_Init_PP_Alpha_Colors_Outputs()
  PP_Init_PP_Alpha_Output()
  PP_Init_PP_Colors_Outputs()
#end

//--------------------------------------------------------------
//-----   making pigment from functions with r,g,b and alpha   -
//--------------------------------------------------------------

#ifndef (PP_Fn_Range)
  #declare PP_Fn_Range=1e6;
#end

#macro Pig_f_rgb_a(_f_r, _f_g, _f_b, _a, Range)

  #local Pig_R=
    pigment {
      function { _f_r(x, y, z)*(1/Range) }
      color_map {
        [0 color rgb 0 transmit _a ]
        [1 color rgb 3*Range*x transmit _a ]
      }
    }

  #local Pig_G=
    pigment {
      function { _f_g(x, y, z)*(1/Range) }
      color_map {
        [0 color rgb 0 transmit _a ]
        [1 color rgb 3*Range*y transmit _a ]
      }
    }

  #local Pig_B=
    pigment {
      function { _f_b(x, y, z)*(1/Range) }
      color_map {
        [0 color rgb 0 transmit _a ]
        [1 color rgb 3*Range*z transmit _a ]
      }
    }

  pigment {
    average
    pigment_map {
      [1 Pig_R]
      [1 Pig_G]
      [1 Pig_B]
    }
  }

#end

#macro Pig_f_rgba(_f_r,_f_g,_f_b,_f_a)

  #local Pig_a0 = Pig_f_rgb_a(_f_r, _f_g, _f_b, 0, PP_Fn_Range);
  #local Pig_a1 = Pig_f_rgb_a(_f_r, _f_g, _f_b, 1, PP_Fn_Range);
  
  pigment{
    function { _f_a(x, y, z) }
    pigment_map {
      [0 Pig_a0]
      [1 Pig_a1]
    }
  }

#end

//--------------------------------------------------------------
//-----   clip colors effect   ---------------------------------
//--------------------------------------------------------------

#macro _filter_clip(_f_in,_p_min,_p_max)
  function{clip(_f_in(u,v),_p_min,_p_max)}
#end

#macro PP_Clip_Colors(CMin,CMax)
  PP_Init_Alpha_Colors_Outputs()
  _filter_clip(f_output_red  ,CMin.red     ,CMax.red     )
  _filter_clip(f_output_green,CMin.green   ,CMax.green   )
  _filter_clip(f_output_blue ,CMin.blue    ,CMax.blue    )
  _filter_clip(f_output_alpha,CMin.transmit,CMax.transmit)
#end

#macro PP_Clip_Colors_Ref(Ref,CMin,CMax)
  #if(Ref=0)
    PP_Clip_Colors(CMin,CMax)
  #else
    PP_Init_Alpha_Colors_Outputs()
    PP_Init_PP_Alpha_Colors_Outputs()
    _filter_clip(function(u,v){f_pp_red(u,v,Ref)}  ,CMin.red     ,CMax.red     )
    _filter_clip(function(u,v){f_pp_green(u,v,Ref)},CMin.green   ,CMax.green   )
    _filter_clip(function(u,v){f_pp_blue(u,v,Ref)} ,CMin.blue    ,CMax.blue    )
    _filter_clip(function(u,v){f_pp_alpha(u,v,Ref)},CMin.transmit,CMax.transmit)
  #end
#end

#macro PP_Clip_Colors_Cam(Cam,CMin,CMax)
  #local f_PigColor=function{pigment{camera_view{Cam}translate -y scale <1,-1,1>}};
  _filter_clip(function(u,v){f_PigColor(u,v,0).red     },CMin.red     ,CMax.red     )
  _filter_clip(function(u,v){f_PigColor(u,v,0).green   },CMin.green   ,CMax.green   )
  _filter_clip(function(u,v){f_PigColor(u,v,0).blue    },CMin.blue    ,CMax.blue    )
  _filter_clip(function(u,v){f_PigColor(u,v,0).transmit},CMin.transmit,CMax.transmit)
#end

#macro Pig_Clip_Colors_Cam(Cam,CMin,CMax)
  #local f_PigColor=function{pigment{camera_view{Cam}}};
  #local f_clr_r=_filter_clip(function(u,v){f_PigColor(u,v,0).red     },CMin.red     ,CMax.red     );
  #local f_clr_g=_filter_clip(function(u,v){f_PigColor(u,v,0).green   },CMin.green   ,CMax.green   );
  #local f_clr_b=_filter_clip(function(u,v){f_PigColor(u,v,0).blue    },CMin.blue    ,CMax.blue    );
  #local f_clr_a=_filter_clip(function(u,v){f_PigColor(u,v,0).transmit},CMin.transmit,CMax.transmit);
  #local Pig=Pig_f_rgba(f_clr_r,f_clr_g,f_clr_b,f_clr_a);
  Pig
#end



//--------------------------------------------------------------
//-----   color matrix effect   --------------------------------
//--------------------------------------------------------------

#macro _filter_dot(_f_red,_f_green,_f_blue,_p_red,_p_green,_p_blue)
  function{(_f_red(u,v)*_p_red+_f_green(u,v)*_p_green+_f_blue(u,v)*_p_blue)}
#end

#macro PP_Color_Matrix(Matrix)
  PP_Init_Colors_Outputs()
  _filter_dot(f_output_red,f_output_green,f_output_blue,Matrix[0],Matrix[1],Matrix[2])
  _filter_dot(f_output_red,f_output_green,f_output_blue,Matrix[3],Matrix[4],Matrix[5])
  _filter_dot(f_output_red,f_output_green,f_output_blue,Matrix[6],Matrix[7],Matrix[8])
  function{0}
#end

#macro PP_Color_Matrix_Ref(Ref,Matrix)
  #if(Ref=0)
    PP_Color_Matrix(Matrix)
  #else
    PP_Init_Colors_Outputs()
    PP_Init_PP_Colors_Outputs()
    _filter_dot(
      function(u,v){f_pp_red  (u,v,Ref)},
      function(u,v){f_pp_green(u,v,Ref)},
      function(u,v){f_pp_blue (u,v,Ref)},
      Matrix[0],Matrix[1],Matrix[2]
    )
    _filter_dot(
      function(u,v){f_pp_red  (u,v,Ref)},
      function(u,v){f_pp_green(u,v,Ref)},
      function(u,v){f_pp_blue (u,v,Ref)},
      Matrix[3],Matrix[4],Matrix[5]
    )
    _filter_dot(
      function(u,v){f_pp_red  (u,v,Ref)},
      function(u,v){f_pp_green(u,v,Ref)},
      function(u,v){f_pp_blue (u,v,Ref)},
      Matrix[6],Matrix[7],Matrix[8]
    )
    function{0}
  #end
#end

#macro PP_Color_Matrix_Cam(Cam,Matrix)
  #local f_PigColor=function{pigment{camera_view{Cam}translate -y scale <1,-1,1>}};
  _filter_dot(
    function(u,v){f_PigColor(u,v,0).red},
    function(u,v){f_PigColor(u,v,0).green},
    function(u,v){f_PigColor(u,v,0).blue},
    Matrix[0],Matrix[1],Matrix[2]
  )
  _filter_dot(
    function(u,v){f_PigColor(u,v,0).red},
    function(u,v){f_PigColor(u,v,0).green},
    function(u,v){f_PigColor(u,v,0).blue},
    Matrix[3],Matrix[4],Matrix[5]
  )
  _filter_dot(
    function(u,v){f_PigColor(u,v,0).red},
    function(u,v){f_PigColor(u,v,0).green},
    function(u,v){f_PigColor(u,v,0).blue},
    Matrix[6],Matrix[7],Matrix[8]
  )
  function{0}
#end

#macro Pig_Color_Matrix_Cam(Cam,Matrix)
  #local f_PigColor=function{pigment{camera_view{Cam}}};
  #local f_clr_r=_filter_dot(
    function(u,v){f_PigColor(u,v,0).red},
    function(u,v){f_PigColor(u,v,0).green},
    function(u,v){f_PigColor(u,v,0).blue},
    Matrix[0],Matrix[1],Matrix[2]
  );
  #local f_clr_g=_filter_dot(
    function(u,v){f_PigColor(u,v,0).red},
    function(u,v){f_PigColor(u,v,0).green},
    function(u,v){f_PigColor(u,v,0).blue},
    Matrix[3],Matrix[4],Matrix[5]
  );
  #local f_clr_b=_filter_dot(
    function(u,v){f_PigColor(u,v,0).red},
    function(u,v){f_PigColor(u,v,0).green},
    function(u,v){f_PigColor(u,v,0).blue},
    Matrix[6],Matrix[7],Matrix[8]
  );
  #local f_clr_a=function{0};
  #local Pig=Pig_f_rgba(f_clr_r,f_clr_g,f_clr_b,f_clr_a);
  Pig
#end



//--------------------------------------------------------------
//-----   convolution matrix effect   --------------------------
//--------------------------------------------------------------

#macro _filter_convolution(_f_ib,_XDim,_YDim,_Divisor,_Leveling,_Matrix)
  #local _X_Step=1/image_width;
  #local _Y_Step=1/image_height;
  #local _X_Start=-((_XDim-1)/image_width)/2;
  #local _Y_Start=-((_YDim-1)/image_height)/2;
  function{((
    _Leveling
    #local _Y=0;
    #while(_Y<_YDim)
      #local _Y0=_Y_Start+_Y_Step*_Y;
      #local _X=0;
      #while(_X<_XDim)
        #local _X0=_X_Start+_X_Step*_X;
        #local _C=Matrix[_Y*_XDim+_X];
        +_f_ib(clip(u+_X0,0,1),clip(v+_Y0,0,1))*_C
        #local _X=_X+1;
      #end
      #local _Y=_Y+1;
    #end
  )/_Divisor)}
#end

#macro PP_Convolution_Matrix(XDim,YDim,Divisor,Leveling,Matrix)
  #local Size=XDim*YDim;
  #if(Size!=dimension_size(Matrix,1))
    #error "Wrong convolution matrix (array) size"
  #else
    PP_Init_Alpha_Colors_Outputs()
    _filter_convolution(f_output_red  ,XDim,YDim,Divisor,Leveling,Matrix)
    _filter_convolution(f_output_green,XDim,YDim,Divisor,Leveling,Matrix)
    _filter_convolution(f_output_blue ,XDim,YDim,Divisor,Leveling,Matrix)
    _filter_convolution(f_output_alpha,XDim,YDim,Divisor,Leveling,Matrix)
  #end
#end

#macro PP_Convolution_Matrix_Ref(Ref,XDim,YDim,Divisor,Leveling,Matrix)
  #if(Ref=0)
    PP_Convolution_Matrix(XDim,YDim,Divisor,Leveling,Matrix)
  #else
    #local Size=XDim*YDim;
    #if(Size!=dimension_size(Matrix,1))
      #error "Wrong convolution matrix (array) size"
    #else
      PP_Init_Alpha_Colors_Outputs()
      PP_Init_PP_Alpha_Colors_Outputs()
      _filter_convolution(function(u,v){f_pp_red  (u,v,Ref)},XDim,YDim,Divisor,Leveling,Matrix)
      _filter_convolution(function(u,v){f_pp_green(u,v,Ref)},XDim,YDim,Divisor,Leveling,Matrix)
      _filter_convolution(function(u,v){f_pp_blue (u,v,Ref)},XDim,YDim,Divisor,Leveling,Matrix)
      _filter_convolution(function(u,v){f_pp_alpha(u,v,Ref)},XDim,YDim,Divisor,Leveling,Matrix)
    #end
  #end
#end

#macro PP_Convolution_Matrix_Cam(Cam,XDim,YDim,Divisor,Leveling,Matrix)
  #local f_PigColor=function{pigment{camera_view{Cam}translate -y scale <1,-1,1>}};
  #local Size=XDim*YDim;
  #if(Size!=dimension_size(Matrix,1))
    #error "Wrong convolution matrix (array) size"
  #else
    _filter_convolution(function(u,v){f_PigColor(u,v,0).red     },XDim,YDim,Divisor,Leveling,Matrix)
    _filter_convolution(function(u,v){f_PigColor(u,v,0).green   },XDim,YDim,Divisor,Leveling,Matrix)
    _filter_convolution(function(u,v){f_PigColor(u,v,0).blue    },XDim,YDim,Divisor,Leveling,Matrix)
    _filter_convolution(function(u,v){f_PigColor(u,v,0).transmit},XDim,YDim,Divisor,Leveling,Matrix)
  #end
#end

#macro Pig_Convolution_Matrix_Cam(Cam,XDim,YDim,Divisor,Leveling,Matrix)
  #local f_PigColor=function{pigment{camera_view{Cam}}};
  #local f_clr_r=_filter_convolution(function(u,v){f_PigColor(u,v,0).red     },XDim,YDim,Divisor,Leveling,Matrix);
  #local f_clr_g=_filter_convolution(function(u,v){f_PigColor(u,v,0).green   },XDim,YDim,Divisor,Leveling,Matrix);
  #local f_clr_b=_filter_convolution(function(u,v){f_PigColor(u,v,0).blue    },XDim,YDim,Divisor,Leveling,Matrix);
  #local f_clr_a=_filter_convolution(function(u,v){f_PigColor(u,v,0).transmit},XDim,YDim,Divisor,Leveling,Matrix);
  #local Pig=Pig_f_rgba(f_clr_r,f_clr_g,f_clr_b,f_clr_a);
  Pig
#end



//--------------------------------------------------------------
//-----   depth effect   ---------------------------------------
//--------------------------------------------------------------

#macro _filter_depth(_f_in,_firld_start,_firld_depth)
  function{clip(adj_range2(_f_in(u,v),_firld_start,_firld_start+_firld_depth,0,1),0,1)}
#end

#macro PP_Depth(Field_Start,Field_Depth)
  PP_Init_Depth_Output()
  _filter_depth(f_output_depth,Field_Start,Field_Depth)
  _filter_depth(f_output_depth,Field_Start,Field_Depth)
  _filter_depth(f_output_depth,Field_Start,Field_Depth)
  function{0}
#end

#macro PP_Depth_Cam(Cam,Field_Start,Field_Depth)
  #local f_PigColor=function{pigment{camera_view{Cam output Output_Depth}translate -y scale <1,-1,1>}};
  _filter_depth(function(u,v){f_PigColor(u,v,0).red  },Field_Start,Field_Depth)
  _filter_depth(function(u,v){f_PigColor(u,v,0).green},Field_Start,Field_Depth)
  _filter_depth(function(u,v){f_PigColor(u,v,0).blue },Field_Start,Field_Depth)
  function{0}
#end

#macro Pig_Depth_Cam(Cam,Field_Start,Field_Depth)
  #local f_PigColor=function{pigment{camera_view{Cam output Output_Depth}}};
  #local f_clr_r=_filter_depth(function(u,v){f_PigColor(u,v,0).red  },Field_Start,Field_Depth);
  #local f_clr_g=_filter_depth(function(u,v){f_PigColor(u,v,0).green},Field_Start,Field_Depth);
  #local f_clr_b=_filter_depth(function(u,v){f_PigColor(u,v,0).blue },Field_Start,Field_Depth);
  #local f_clr_a=function{0};
  #local Pig=Pig_f_rgba(f_clr_r,f_clr_g,f_clr_b,f_clr_a);
  Pig
#end



//--------------------------------------------------------------
//-----   find edges effect   ----------------------------------
//--------------------------------------------------------------

#macro _find_edges_avg_depth(_f_depth,_radius,_tresh,_width,_height)
  #local _pwidth=1/_width;
  #local _pheight=1/_height;
  #local _f=function(u,v,d){(
    0
    #local _weight=0;
    #local j=-_radius;
    #while(j<=_radius)
      #local k=-_radius;
      #while(k<=_radius)
        #if(((k!=0)|(j!=0))&(f_r(j,k,0)<=_radius))
          +select(abs(d-_f_depth(clip(u+j*_pwidth,0,1),clip(v+k*_pheight,0,1)))-_tresh,0,1)
          #local _weight=_weight+1;
        #end
        #local k=k+1;
      #end
      #local j=j+1;
    #end
    #if(_weight!=0)
      #local _weight=1/_weight;            
    #end
  )*_weight};
  function(u,v){_f(u,v,_f_depth(u,v))}
#end

#macro _find_edges_avg_normal(_f_depth,_f_normal_x,_f_normal_y,_f_normal_z,_radius,_tresh,_width,_height)
  #local _pwidth=1/_width;
  #local _pheight=1/_height;
  #local _g=function(nx,ny,nz,du,dv){
    select(
      _f_depth(du,dv)-MAX_MEGAPOV_DISTANCE,
      select((1-(nx*_f_normal_x(du,dv)+
                 ny*_f_normal_y(du,dv)+
                 nz*_f_normal_z(du,dv)))/2-_tresh,0,1),
      0
    )
  };
  #local _f=function(u,v,nx,ny,nz){(
    0
    #local _weight=0;
    #local j=-_radius;
    #while(j<=_radius)
      #local k=-_radius;
      #while(k<=_radius)
        #if(((k!=0)|(j!=0))&(f_r(j,k,0)<=_radius))
          +_g(nx,ny,nz,clip(u+j*_pwidth,0,1),clip(v+k*_pheight,0,1))
          #local _weight=_weight+1;
        #end
        #local k=k+1;
      #end
      #local j=j+1;
    #end
    #if(_weight!=0)
      #local _weight=1/_weight;
    #end
  )*_weight};
  function(u,v){select(
    _f_depth(u,v)-MAX_MEGAPOV_DISTANCE,
    _f(u,v,_f_normal_x(u,v),_f_normal_y(u,v),_f_normal_z(u,v)),
    0
  )}
#end

#macro _find_edges_avg_color(_f_red,_f_green,_f_blue,_radius,_tresh,_width,_height)
  #local _pwidth=1/_width;
  #local _pheight=1/_height;
  #local _g=function(r,g,b,du,dv){select((abs(r-_f_red(du,dv))+abs(g-_f_green(du,dv))+abs(b-_f_blue(du,dv)))/3-_tresh,0,1)};
  #local _f=function(u,v,r,g,b){(
    0
    #local _weight=0;
    #local j=-_radius;
    #while(j<=_radius)
      #local k=-_radius;
      #while(k<=_radius)
        #if(((k!=0)|(j!=0))&(f_r(j,k,0)<=_radius))
          +_g(r,g,b,clip(u+j*_pwidth,0,1),clip(v+k*_pheight,0,1))
          #local _weight=_weight+1;
        #end
        #local k=k+1;
      #end
      #local j=j+1;
    #end
    #if(_weight!=0)
      #local _weight=1/_weight;
    #end
  )*_weight};
  function(u,v){_f(u,v,_f_red(u,v),_f_green(u,v),_f_blue(u,v))}
#end

#macro _find_edges(_is_pigment,
                   _f_depth,
                   _f_nx,_f_ny,_f_nz,
                   _f_r,_f_g,_f_b,_f_a,
                   _depth_thresh,_normal_thresh,_color_thresh,
                   _line_radius,_sharpness,_pigment,
                   _background,_background_filter,_width,_height)
  #local _f_avg_depth=_find_edges_avg_depth(
    _f_depth,
    _line_radius,
    _depth_thresh,
    _width,
    _height
  );
  #local _f_avg_normal=_find_edges_avg_normal(
    _f_depth,
    _f_nx,_f_ny,_f_nz,
    _line_radius,
    _normal_thresh,
    _width,
    _height
  );
  #local _f_avg_color=_find_edges_avg_color(
    _f_r,_f_g,_f_b,
    _line_radius,
    _color_thresh,
    _width,
    _height
  );
  #local __sharpness=_sharpness*(_line_radius-1)+1;
  #local _f_filter_3=1;
  #local _f_filter_2=function(avgCol){
    select(
      _color_thresh,
      _f_filter_3,
      max(min(_f_filter_3,1-avgCol*__sharpness),0)
    )
  };
  #local _f_filter_1=function(avgNor,avgCol){
    select(
      _normal_thresh,
      _f_filter_2(avgCol),
      max(min(_f_filter_2(avgCol),1-avgNor*__sharpness),0)
    )
  };
  #local _f_filter_0=function(avgDth,avgNor,avgCol){
    select(
      _depth_thresh,
      _f_filter_1(avgNor,avgCol),
      max(min(_f_filter_1(avgNor,avgCol),1-avgDth*__sharpness),0)
    )
  };
  #local _f_filter=function(u,v){_f_filter_0(_f_avg_depth(u,v),_f_avg_normal(u,v),_f_avg_color(u,v))};
  #local _f_pig=function{pigment{_pigment translate -y scale <1,-1,1>}};
  #local _f_back=function{pigment{_background translate -y scale <1,-1,1>}};
  #local _f_filt_back=function{pigment{_background_filter translate -y scale <1,-1,1>}};
  #local _f_apply=function(p,f,s){p*(1-f)+s*f};
  #if((_depth_thresh!=0)|(_normal_thresh!=0)|(_color_thresh!=0))
    #if(_is_pigment)
      #local _pig_red=
    #end
      function{_f_apply(_f_pig(u,v,0).red  ,_f_filter(u,v),_f_apply(_f_back(u,v,0).red  ,_f_filt_back(u,v,0).red  ,_f_r(u,v)))}
    #if(_is_pigment)
      #local _pig_green=
    #end
      function{_f_apply(_f_pig(u,v,0).green,_f_filter(u,v),_f_apply(_f_back(u,v,0).green,_f_filt_back(u,v,0).green,_f_g(u,v)))}
    #if(_is_pigment)
      #local _pig_blue=
    #end
      function{_f_apply(_f_pig(u,v,0).blue ,_f_filter(u,v),_f_apply(_f_back(u,v,0).blue ,_f_filt_back(u,v,0).blue ,_f_b(u,v)))}
  #else
    #if((_depth_thresh=0)&(_normal_thresh=0)&(_color_thresh!=0))
      #if(_is_pigment)
        #local _pig_red=
      #end
        function{_f_avg_depth(u,v)}
      #if(_is_pigment)
        #local _pig_green=
      #end
        function{_f_avg_normal(u,v)}
      #if(_is_pigment)
        #local _pig_blue=
      #end
        function{_f_avg_color(u,v)}
    #else
      #if(_is_pigment)
        #local _pig_red=
      #end
        function{_f_r(u,v)}
      #if(_is_pigment)
        #local _pig_green=
      #end
        function{_f_g(u,v)}
      #if(_is_pigment)
        #local _pig_blue=
      #end
        function{_f_b(u,v)}
    #end
  #end
  #if(_is_pigment)
    #local _pig_alpha=
  #end
    function{_f_a(u,v)}
  #if(_is_pigment)
    #local Pig=Pig_f_rgba(_pig_red,_pig_green,_pig_blue,_pig_alpha);
    #local Pig=pigment{Pig translate -y scale <1,-1,1>};
    Pig
  #end
#end

#macro PP_Find_Edges_Back(Depth_Thresh,Normal_Thresh,Color_Thresh,Line_Radius,Sharpness,Pigment,Background,Background_Filter,Width,Height)
  PP_Init_Depth_Output()
  PP_Init_PNormal_Outputs()
  PP_Init_Alpha_Colors_Outputs()
  _find_edges(
    no,
    f_output_depth,
    f_output_pnormal_x,
    f_output_pnormal_y,
    f_output_pnormal_z,
    f_output_red,
    f_output_green,
    f_output_blue,
    f_output_alpha,
    Depth_Thresh,
    Normal_Thresh,
    Color_Thresh,
    Line_Radius,
    Sharpness,
    Pigment,
    Background,
    Background_Filter,
    Width,
    Height
  )
#end

#macro PP_Find_Edges(Depth_Thresh,Normal_Thresh,Color_Thresh,Line_Radius,Sharpness,Pigment)
  PP_Find_Edges_Back(Depth_Thresh,Normal_Thresh,Color_Thresh,Line_Radius,Sharpness,Pigment,pigment{rgb 0},pigment{rgb 1},image_width,image_height)
#end

#macro PP_Find_Edges_Back_Cam(Cam,Depth_Thresh,Normal_Thresh,Color_Thresh,Line_Radius,Sharpness,Pigment,Background,Background_Filter,Width,Height)
  #local f_PigDepth=function{pigment{camera_view{Cam output Output_Depth}translate -y scale <1,-1,1>}};
  #local f_PigNormal=function{pigment{camera_view{Cam output Output_Normal_Vector}translate -y scale <1,-1,1>}};
  #local f_PigColor=function{pigment{camera_view{Cam}translate -y scale <1,-1,1>}};
  _find_edges(
    no,
    function(u,v){f_PigDepth(u,v,0).red},
    function(u,v){f_PigNormal(u,v,0).x},
    function(u,v){f_PigNormal(u,v,0).y},
    function(u,v){f_PigNormal(u,v,0).z},
    function(u,v){f_PigColor(u,v,0).red},
    function(u,v){f_PigColor(u,v,0).green},
    function(u,v){f_PigColor(u,v,0).blue},
    function(u,v){f_PigColor(u,v,0).transmit},
    Depth_Thresh,
    Normal_Thresh,
    Color_Thresh,
    Line_Radius,
    Sharpness,
    Pigment,
    Background,
    Background_Filter,
    Width,
    Height
  )
#end

#macro PP_Find_Edges_Cam(Cam,Depth_Thresh,Normal_Thresh,Color_Thresh,Line_Radius,Sharpness,Pigment)
  PP_Find_Edges_Back_Cam(Cam,Depth_Thresh,Normal_Thresh,Color_Thresh,Line_Radius,Sharpness,Pigment,pigment{rgb 0},pigment{rgb 1},image_width,image_height)
#end

#macro Pig_Find_Edges_Back_Cam(Cam,Depth_Thresh,Normal_Thresh,Color_Thresh,Line_Radius,Sharpness,Pigment,Background,Background_Filter,Width,Height)
  #local f_PigDepth=function{pigment{camera_view{Cam output Output_Depth}translate -y scale <1,-1,1>}};
  #local f_PigNormal=function{pigment{camera_view{Cam output Output_Normal_Vector}translate -y scale <1,-1,1>}};
  #local f_PigColor=function{pigment{camera_view{Cam}translate -y scale <1,-1,1>}};
  _find_edges(
    yes,
    function(u,v){f_PigDepth(u,v,0).red},
    function(u,v){f_PigNormal(u,v,0).x},
    function(u,v){f_PigNormal(u,v,0).y},
    function(u,v){f_PigNormal(u,v,0).z},
    function(u,v){f_PigColor(u,v,0).red},
    function(u,v){f_PigColor(u,v,0).green},
    function(u,v){f_PigColor(u,v,0).blue},
    function(u,v){f_PigColor(u,v,0).transmit},
    Depth_Thresh,
    Normal_Thresh,
    Color_Thresh,
    Line_Radius,
    Sharpness,
    Pigment,
    Background,
    Background_Filter,
    Width,
    Height
  )
#end

#macro Pig_Find_Edges_Cam(Cam,Depth_Thresh,Normal_Thresh,Color_Thresh,Line_Radius,Sharpness,Pigment)
  Pig_Find_Edges_Back_Cam(Cam,Depth_Thresh,Normal_Thresh,Color_Thresh,Line_Radius,Sharpness,Pigment,pigment{rgb 0},pigment{rgb 1},image_width,image_height)
#end

#version PProcess_Inc_Temp;
#end