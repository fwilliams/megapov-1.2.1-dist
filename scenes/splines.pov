// Persistence Of Vision Ray Tracer Scene Description File
// -------------------------------------------------------
// File: @(#)splines.pov
// Description: Comparison of spline types.
// Features demonstrated: akima_spline, spline,
// Creation Date: $ 13 Aug 2004, 15:54:05 $
// Last modified: $ 13 Aug 2004, 22:39:12 $
// Author: Wlodzimierz ABX Skiba
//
// -w768 -h1024 +a0.3

#version unofficial MegaPov 1.1;

#include "colors.inc"

camera { 
    orthographic  
    right 1.1*x
    up 1.1*y*image_height/image_width
    direction z 
    location -z
}

#macro Spline_Entries()
    0 <0,0>
    1 <1,1>
    2 <2,0>
    3 <3,.5>
    4 <4,0>
    5 <5,.7>
    6 <7,0>
    7 <6.5,1>
    8 <8,1>
    9 <8,0>
    10 <10,1>
#end

#declare Spline_Base=spline{ Spline_Entries() }

#declare Control_Point_Pigment=pigment{color Red}
#declare Control_Point_Radius=0.05;

#declare Spline_Pigment=pigment{color Black}
#declare Spline_Radius=0.02;
#declare Spline_Accuracy=0.005;

#declare Position = 0;

#macro Draw_Spline(Spline,Name)
    union{
        #local Counter = 0;
        #while (Counter < dimension_size(Spline))
            #local Center = Spline_Base(Counter);
            sphere{ 
                <Center.x,Center.y,0> 
                Control_Point_Radius 
                pigment{ Control_Point_Pigment }
            }
            #if (Counter>0)
            cylinder{ 
                <Spline_Base(Counter-1).x,Spline_Base(Counter-1).y,0> 
                <Center.x,Center.y,0> 
                Spline_Radius/2
                pigment{ color Gray }
            }
            #end
            #local Center = Spline(Counter);
            #local C = Spline_Accuracy;
            #while (C < 1)
                #local New_Center = Spline(Counter + C);
                #if(vlength(Center-New_Center)!=0)
                    sphere{ 
                        <New_Center.x,New_Center.y,0> 
                        Spline_Radius 
                        pigment{ Spline_Pigment }
                    }
                    cylinder{ 
                        <Center.x,Center.y,0> 
                        <New_Center.x,New_Center.y,0> 
                        Spline_Radius 
                        pigment{ Spline_Pigment }
                    }
                #end
                #local Center = New_Center;
                #local C=C+Spline_Accuracy;
            #end
            #local Counter = Counter + 1;
        #end
        text{
            ttf "crystal.ttf" Name 0.1,0
            scale 1/2.5
            translate <11,.5,0>
            pigment{color blue 1}
        }
        scale 1/18
        translate -x/2
        #declare Position = Position + 1;
        translate -y*Position/10
    }
#end

background{1}

#default{finish{ambient 1 diffuse 0}}

union{
    Draw_Spline(spline{Spline_Base linear_spline},"linear_spline")
    Draw_Spline(spline{Spline_Base quadratic_spline },"quadratic_spline")
    Draw_Spline(spline{Spline_Base cubic_spline },"cubic_spline")
    Draw_Spline(spline{Spline_Base natural_spline },"natural_spline")
    Draw_Spline(spline{Spline_Base akima_spline },"akima_spline")
    Draw_Spline(spline{Spline_Base tcb_spline },"tcb_spline")
    Draw_Spline(spline{tcb_spline tension -1 bias 1 Spline_Entries()},"tcb_spline tension -1 bias 1")
    Draw_Spline(spline{tcb_spline continuity 2 Spline_Entries()},"tcb_spline continuity 2")
    Draw_Spline(spline{Spline_Base basic_x_spline },"basic_x_spline")
    Draw_Spline(spline{Spline_Base extended_x_spline},"extended_x_spline")
    Draw_Spline(spline{extended_x_spline freedom_degree .5 Spline_Entries()},"extended_x_spline freedom_degree 0.5")
    Draw_Spline(spline{Spline_Base general_x_spline},"general_x_spline")
    Draw_Spline(spline{general_x_spline freedom_degree .5 Spline_Entries()},"general_x_spline freedom_degree 0.5")
    Draw_Spline(spline{general_x_spline freedom_degree -1 Spline_Entries()},"general_x_spline freedom_degree -1")
    translate y*Position/20
}