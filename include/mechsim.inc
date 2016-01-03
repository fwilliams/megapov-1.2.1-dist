// Persistence Of Vision Ray Tracer Include File
// ---------------------------------------------
// File: @(#)mechsim.inc
// Description: mechanics simulation include file - version 0.4
// Features demonstrated: mechsim
// Creation Date: $ August 2002 $
// Last modified: $ 27 May 2005, 16:34:33 $
// Author: Christoph Hormann <chris_hormann@gmx.de>
//
// This include file is part of the MechSim patch in MegaPOV
// Like the patch it is subject to the conditions in povlegal.doc
// that comes with MegaPOV No part of it may be used outside POV-Ray
// without permission
//

#ifdef(MECHSIM_Inc_Temp)
// do nothing
#else
#declare MECHSIM_Inc_Temp = version;

#ifdef(View_POV_Include_Stack)
#   debug "including mechsim.inc\n"
#end

#version unofficial megapov 1.2;

#include "math.inc"
#include "transforms.inc"

// #######################################################################################
//   constants
// #######################################################################################

#declare MSIM_INCLUDE_VERSION=0.4;

#declare MECHSIM_METHOD_EULER=1;
#declare MECHSIM_METHOD_HEUN=2;
#declare MECHSIM_METHOD_RUNGE_KUTTA4=3;
#declare MECHSIM_METHOD_GRADIENT=4;

#declare MECHSIM_COLLISION_NONE=0;
#declare MECHSIM_COLLISION_ALL=1;
#declare MECHSIM_COLLISION_GROUP=2;

#declare MECHSIM_ENV_METHOD_FORCE=1;
#declare MECHSIM_ENV_METHOD_IMPACT=2;

#declare MECHSIM_COLLISION_BOUNDING_NO=0;
#declare MECHSIM_COLLISION_BOUNDING_AUTO=1;
#declare MECHSIM_COLLISION_BOUNDING_BOX=2;
#declare MECHSIM_COLLISION_BOUNDING_HASH=3;

#declare No_Trans=transform{}

#declare No_Fixed=function(x, y, z) {-1}
#declare No_Attach=function(x, y, z) {-1}
#declare No_Force=function(x, y, z) {-1}

// #######################################################################################
//   global parameters
// #######################################################################################

#ifndef (MSim_File_Decimals)
	#declare MSim_File_Decimals=12;
#end

#ifndef (MSim_Test_Render)
	#declare MSim_Test_Render=false;
#end

#ifndef (MSim_Tex_N)
	#declare MSim_Tex_N=
	texture {
		pigment {
			color rgb <0.8,0.8,1.0>
		}
		finish{
			diffuse 0.3
			ambient 0.0
			specular 0.6

			#if (!MSim_Test_Render)
				reflection {
					0.8
					metallic
				}
			#end

			conserve_energy
		}
	}
#end

#ifndef (MSim_Tex_C)
	#declare MSim_Tex_C=
	texture {
		pigment {
			color rgb <1, 0.5, 0.1>
		}
		finish{
			diffuse 0.3
			ambient 0.0
			specular 0.6

			#if (!MSim_Test_Render)
				reflection {
					0.8
					metallic
				}
			#end

			conserve_energy
		}
	}
#end

#ifndef (MSim_Tex_Mesh)
	#declare MSim_Tex_Mesh=
	texture {
		pigment {
			color rgb <0.4, 0.3, 1>
		}
		finish{
			diffuse 0.3
			ambient 0.0
			specular 0.6

			#if (!MSim_Test_Render)
				reflection {
					0.8
					metallic
				}
			#end

			conserve_energy
		}
	}
#end

#ifndef (fn_Stress_CM)
	#declare fn_Stress_CM=
	function {
		pigment {
			gradient x
			color_map {
				[ 0.00 color rgb<0.450, 0.750, 0.620> ]
				[ 0.25 color rgb<0.256, 0.430, 1.000> ]
				[ 0.50 color rgb<0.000, 0.000, 0.441> ]
				[ 0.75 color rgb<1.000, 0.456, 0.456> ]
				[ 1.00 color rgb<0.900, 0.800, 0.000> ]
			}
		}
	}
#end


// =======================================================================================
//  Vector_Function()
//
//  generates a pigment function from three float functions
//  representing the x, y and z directions
//
//  Parameters:
//      Fn_X, Fn_Y, Fn_Z - three user defined functions
//
//  The way this macro works makes it necessary to have a limited range for the
//  function values.  Vector_Function() is a wrapper macro for
//  Vector_Function_Range() using a default range of 1e6.  If necessary this can be
//  changed by declaring a different value for MSim_Fn_Range before including
//  'mechsim.inc'.
//
// =======================================================================================

#ifndef (MSim_Fn_Range)
	#declare MSim_Fn_Range=1e6;
#end

#macro Vector_Function_Range(Fn_X, Fn_Y, Fn_Z, Range)

	#local PigX=
	pigment {
		function { 0.5+Fn_X(x, y, z)*(0.5/Range) }
		color_map {
			[0.0 color rgb -3*Range*x ]
			[0.5 color rgb 0 ]
			[1.0 color rgb  3*Range*x ]
		}
	}

	#local PigY=
	pigment {
		function { 0.5+Fn_Y(x, y, z)*(0.5/Range) }
		color_map {
			[0.0 color rgb -3*Range*y ]
			[0.5 color rgb 0 ]
			[1.0 color rgb  3*Range*y ]
		}
	}

	#local PigZ=
	pigment {
		function { 0.5+Fn_Z(x, y, z)*(0.5/Range) }
		color_map {
			[0.0 color rgb -3*Range*z ]
			[0.5 color rgb 0 ]
			[1.0 color rgb  3*Range*z ]
		}
	}

	function {
		pigment {
			average
			pigment_map {
				[1 PigX]
				[1 PigY]
				[1 PigZ]
			}
		}
	}

#end

#macro Vector_Function(Fn_X, Fn_Y, Fn_Z)

Vector_Function_Range(
	function { Fn_X(x, y, z) },
	function { Fn_Y(x, y, z) },
	function { Fn_Z(x, y, z) },
	MSim_Fn_Range
)

#end

// #######################################################################################
//   Object diplay macros
// #######################################################################################

// =======================================================================================
//  MechSim_Show_Objects_X()
//
//  generates objects representing parts of the simulation topology
//  this variant also shows viscoelastic connections
//
//  Parameters:
//      Start_Mass_Index       - index of the first mass that should be displayed.
//                               Should be stored when the topology is generated.
//      Start_Connection_Index - index of the first connection
//      Start_VE_Index         - index of the first viscoelastic connection
//      Start_Face_Index       - index of the first face
//      End_Mass_Index         - index of the last mass that should be displayed.
//                               if <0 all masses until the last are displayed.
//      End_Connection_Index   - index of the last connection that should be displayed.
//                               if <0 all connections until the last are displayed.
//      End_VE_Index           - index of the last viscoelastic connection that should be displayed.
//                               if <0 all viscoelastic connections until the last are displayed.
//      End_Face_Index         - index of the last face that should be displayed.
//                               if <0 all faces until the last are displayed.
//      Connect_Rad            - Radius to use for the connections, values <0 lead
//                               to using  0.4*mass radius.
//      Show_Faces             - Only generate a mesh from the faces instead of
//                               cylinders and spheres.
//      Stress_Fact            - if >0 the connections are textured to visualize
//                               the stress.  Values are scaled with this factor.
//      File_Name              - string, if length is >0 the objects are written to a
//                               file with that name in addition
//
// =======================================================================================
#macro MechSim_Show_Objects_X(Start_Mass_Index, Start_Connection_Index, Start_VE_Index, Start_Face_Index, End_Mass_Index, End_Connection_Index, End_VE_Index, End_Face_Index, Connect_Rad, Show_Faces, Stress_Fact, File_Name)

	object {
	#if (End_Mass_Index<0)
		#local End_Mass=mechsim:mass_count;
	#else
		#local End_Mass=End_Mass_Index;
	#end

	#if (End_Connection_Index<0)
		#local End_Connection=mechsim:connection_count;
	#else
		#local End_Connection=End_Connection_Index;
	#end

	#if (End_VE_Index<0)
		#local End_VE=mechsim:viscoelastic_count;
	#else
		#local End_VE=End_VE_Index;
	#end

	#if (End_Face_Index<0)
		#local End_Face=mechsim:face_count;
	#else
		#local End_Face=End_Face_Index;
	#end

	#if (strlen(File_Name)=0)
		#local Write_File=false;
		#debug "Generating Objects..."
	#else
		#local Write_File=true;

		#fopen FILE File_Name write

		#if (Show_Faces)
			#write (FILE, "// simulation topology objects (",str(End_Face-Start_Face_Index,0,0)," faces)\n")
		#else
			#if (Connect_Rad != 0)
				#write (FILE, "// simulation topology objects (",str(End_Mass-Start_Mass_Index,0,0)," masses, ",
				                                                 str(End_VE-Start_VE_Index,0,0)," viscoelastic connections, ",
				                                                 str(End_Connection-Start_Connection_Index,0,0)," connections)\n")
			#else
				#write (FILE, "// simulation topology objects (",str(End_Mass-Start_Mass_Index,0,0)," masses)\n")
			#end
		#end
		#write (FILE, "// written by MechSim include file version ",str(MSIM_INCLUDE_VERSION,1,1),"\n\n")

		#if (Stress_Fact>0)
			#write (FILE, "#local Fin_Stress=\n")
			#write (FILE, "  finish {\n")
			#write (FILE, "    specular 0.3\n")
			#write (FILE, "    diffuse 0.7\n")
			#write (FILE, "  }\n\n")
		#end

		#debug concat("Generating Objects (writing to file ",File_Name,")...")

	#end

	#if (!Show_Faces)
		#if ((End_Mass>Start_Mass_Index) | (End_Connection>Start_Connection_Index) | (End_VE>Start_VE_Index))

			#if ((End_Mass>Start_Mass_Index) & ((End_Connection>Start_Connection_Index) | (End_VE>Start_VE_Index)))
				union {
					#if (Write_File) #write (FILE, "  union {\n") #end
			#else
				object {
					#if (Write_File) #write (FILE, "  object {\n") #end
			#end

			#if (End_Mass>Start_Mass_Index)

				#if (End_Mass>Start_Mass_Index+1)
					union {
						#if (Write_File) #write (FILE, "  union {\n") #end
				#else
					object {
						#if (Write_File) #write (FILE, "  object {\n") #end
				#end

				#local Cnt=Start_Mass_Index;

				#while (Cnt<End_Mass)
					sphere {
						mechsim:mass(Cnt):position,
	          mechsim:mass(Cnt):radius
	        }

					#if (Write_File)
						#write (FILE, "    sphere {<",vstr(3,mechsim:mass(Cnt):position,",",0,MSim_File_Decimals), ">, ",
							                             str(mechsim:mass(Cnt):radius,0,MSim_File_Decimals), " }\n")
					#end

					#local Cnt=Cnt+1;
				#end

						texture { MSim_Tex_N }
					}

				#if (Write_File)
					#write (FILE, "    texture { MSim_Tex_N }\n  }\n")
				#end
			#end

			#if (End_Connection>Start_Connection_Index)

				#if (Connect_Rad != 0)

					#if (End_Connection>Start_Connection_Index+1)
						union {
							#if (Write_File) #write (FILE, "  union {\n") #end
					#else
						object {
							#if (Write_File) #write (FILE, "  object {\n") #end
					#end

					#local Cnt=Start_Connection_Index;

					#while (Cnt<End_Connection)
						#local Dist = vlength(mechsim:mass(mechsim:connection(Cnt):index1):position-
							                    mechsim:mass(mechsim:connection(Cnt):index2):position);
						#if (Dist>0.0001)
							cylinder {
								mechsim:mass(mechsim:connection(Cnt):index1):position,
								mechsim:mass(mechsim:connection(Cnt):index2):position,

								#if (Write_File)
									#write (FILE, "    cylinder {<",vstr(3,mechsim:mass(mechsim:connection(Cnt):index1):position,",",0,MSim_File_Decimals), ">, <",
										                              vstr(3,mechsim:mass(mechsim:connection(Cnt):index2):position,",",0,MSim_File_Decimals), ">, ")
								#end

								#if (Connect_Rad<0)
									#local Radius=mechsim:mass(mechsim:connection(Cnt):index1):radius*0.4;
								#else
									#local Radius=Connect_Rad;
								#end

								Radius

								#if (Write_File)
									#write (FILE, str(Radius,0,MSim_File_Decimals), " ")
								#end

								#if (Stress_Fact>0)

									#local Stress=((Dist-mechsim:connection(Cnt):length)/mechsim:connection(Cnt):length)*Stress_Fact + 0.5;
									#local Stress=max(0.0, min(1.0, Stress));
									texture {
										pigment { color fn_Stress_CM(Stress, 0, 0) }
										finish {
											specular 0.3
											diffuse 0.7
										}
									}

									#if (Write_File)
										#write (FILE, "texture{pigment{ color rgb <",vstr(3,fn_Stress_CM(Stress,0,0),",",0,4), "> }finish{Fin_Stress}} ")
									#end

								#end
							}
							#if (Write_File)
								#write (FILE, "}\n")
							#end

						#end

						#local Cnt=Cnt+1;
					#end

					#if (Stress_Fact<=0)
						  texture { MSim_Tex_C }

						#if (Write_File)
							#write (FILE, "    texture { MSim_Tex_C }\n")
						#end
					#end
						}
					#if (Write_File)
						#write (FILE, "  }\n")
					#end
				#end
			#end

			#if (End_VE>Start_VE_Index)

				#if (Connect_Rad != 0)

					#if (End_VE>Start_VE_Index+1)
						union {
							#if (Write_File) #write (FILE, "  union {\n") #end
					#else
						object {
							#if (Write_File) #write (FILE, "  object {\n") #end
					#end

					#local Cnt=Start_VE_Index;

					#while (Cnt<End_VE)
						#local Dist = vlength(mechsim:mass(mechsim:viscoelastic(Cnt):index1):position-
							                    mechsim:mass(mechsim:viscoelastic(Cnt):index2):position);
						#if (Dist>0.0001)
							cylinder {
								mechsim:mass(mechsim:viscoelastic(Cnt):index1):position,
								mechsim:mass(mechsim:viscoelastic(Cnt):index2):position,

								#if (Write_File)
									#write (FILE, "    cylinder {<",vstr(3,mechsim:mass(mechsim:viscoelastic(Cnt):index1):position,",",0,MSim_File_Decimals), ">, <",
										                              vstr(3,mechsim:mass(mechsim:viscoelastic(Cnt):index2):position,",",0,MSim_File_Decimals), ">, ")
								#end

								#if (Connect_Rad<0)
									#local Radius=mechsim:mass(mechsim:viscoelastic(Cnt):index1):radius*0.4;
								#else
									#local Radius=Connect_Rad;
								#end

								Radius

								#if (Write_File)
									#write (FILE, str(Radius,0,MSim_File_Decimals), " ")
								#end

								#if (Stress_Fact>0)

									#local Stress=((Dist-mechsim:viscoelastic(Cnt):length)/mechsim:viscoelastic(Cnt):length)*Stress_Fact + 0.5;
									#local Stress=max(0.0, min(1.0, Stress));
									texture {
										pigment { color fn_Stress_CM(Stress, 0, 0) }
										finish {
											specular 0.3
											diffuse 0.7
										}
									}

									#if (Write_File)
										#write (FILE, "texture{pigment{ color rgb <",vstr(3,fn_Stress_CM(Stress,0,0),",",0,4), "> }finish{Fin_Stress}} ")
									#end

								#end
							}
							#if (Write_File)
								#write (FILE, "}\n")
							#end

						#end

						#local Cnt=Cnt+1;
					#end

					#if (Stress_Fact<=0)
						  texture { MSim_Tex_C }

						#if (Write_File)
							#write (FILE, "    texture { MSim_Tex_C }\n")
						#end
					#end
						}
					#if (Write_File)
						#write (FILE, "  }\n")
					#end
				#end
			#end
					}
			#if (Write_File)
				#write (FILE, "}\n")
			#end
		#end
	#else
		#if (mechsim:face_count)
			mesh {

				#if (Write_File)
					#write (FILE, "mesh {\n")
				#end

				#local Cnt=Start_Face_Index;

				#while (Cnt<End_Face)

					triangle { mechsim:mass(mechsim:face(Cnt):index1):position,
						         mechsim:mass(mechsim:face(Cnt):index2):position,
						         mechsim:mass(mechsim:face(Cnt):index3):position }

					#if (Write_File)
						#write (FILE, "triangle { <",vstr(3,mechsim:mass(mechsim:face(Cnt):index1):position,",",0,MSim_File_Decimals), ">, <",
							                           vstr(3,mechsim:mass(mechsim:face(Cnt):index2):position,",",0,MSim_File_Decimals), ">, <",
							                           vstr(3,mechsim:mass(mechsim:face(Cnt):index3):position,",",0,MSim_File_Decimals), "> }\n")
					#end

					#local Cnt=Cnt+1;
				#end

				texture { MSim_Tex_Mesh }
			}

			#if (Write_File)
				#write (FILE, "}\n")
			#end

		#end
	#end

	#if (Write_File)
		#fclose FILE
	#end

	#debug "Done\n"
	}

#end

// =======================================================================================
//  MechSim_Show_Objects()
//
//  generates objects representing parts of the simulation topology
//
//  Parameters:
//      Start_Mass_Index       - index of the first mass that should be displayed.
//                               Should be stored when the topology is generated.
//      Start_Connection_Index - index of the first connection
//      Start_Face_Index       - index of the first face
//      End_Mass_Index         - index of the last mass that should be displayed.
//                               if <0 all masses until the last are displayed.
//      End_Connection_Index   - index of the last connection that should be displayed.
//                               if <0 all connections until the last are displayed.
//      End_Face_Index         - index of the last face that should be displayed.
//                               if <0 all faces until the last are displayed.
//      Connect_Rad            - Radius to use for the connections, values <0 lead
//                               to using  0.4*mass radius.
//      Show_Faces             - Only generate a mesh from the faces instead of
//                               cylinders and spheres.
//      Stress_Fact            - if >0 the connections are textured to visualize
//                               the stress.  Values are scaled with this factor.
//      File_Name              - string, if length is >0 the objects are written to a
//                               file with that name in addition
//
// =======================================================================================
#macro MechSim_Show_Objects(Start_Mass_Index, Start_Connection_Index, Start_Face_Index,
                            End_Mass_Index, End_Connection_Index, End_Face_Index,
                            Connect_Rad, Show_Faces, Stress_Fact, File_Name)
	MechSim_Show_Objects_X(
		Start_Mass_Index, Start_Connection_Index, 0, Start_Face_Index,
		End_Mass_Index, End_Connection_Index, 0, End_Face_Index,
		Connect_Rad, Show_Faces, Stress_Fact, File_Name
	)

#end

// =======================================================================================
//  MechSim_Show_All_Objects()
//
//  like MechSim_Show_Objects() but showing all elements of the simulation
//
//  Parameters:
//      Connect_Rad - Radius to use for the connections, values <0 lead to using
//                    0.4*mass radius
//      Show_Faces  - Only generate a mesh from the faces instead of
//                    cylinders and spheres
//      Stress_Fact - if >0 the connections are textured to visualize the stress.
//                    values are scaled with this factor
//      File_Name   - string, if length is >0 the objects are written to a
//                    file with that name in addition
//
// =======================================================================================
#macro MechSim_Show_All_Objects(Connect_Rad, Show_Faces, Stress_Fact, File_Name)

	MechSim_Show_Objects_X(0,0,0,0, -1, -1, -1, -1, Connect_Rad, Show_Faces, Stress_Fact, File_Name)

#end

// =======================================================================================
//  MechSim_Show_All_Default()
//
//  like MechSim_Show_All_Objects() but using reasonable defaults for parameters
//
// =======================================================================================
#macro MechSim_Show_All_Default()

	#if (mechsim:face_count)
		MechSim_Show_Objects_X(0,0,0,0, -1, -1, -1, -1, -1, true, -1, "")
	#else
		MechSim_Show_Objects_X(0,0,0,0, -1, -1, -1, -1, -1, false, -1, "")		
	#end

#end

// =======================================================================================
//  MechSim_Show_Patch() macro
//
//  generating a mesh corresponding to the topology generated by a
//  MechSim_Generate_Patch() macro
//
//  Parameters:
//      Start_Face_Index - index of the first face that's part of the patch.  Should
//                         be stored when the patch is generated
//      XSize, YSize     - Size of the patch, number of nodes in x- and y-direction
//      Smooth           - boolean value, if true normal vectors are generated
//      UV               - boolean value, if true UV-coordinates are generated
//                         (from 0 to 1 in x-direction)
//      Stress_Fact      - if >0 the mesh is textured to visualize the stress.
//                         values are scaled with this factor
//      File_Name        - string, if length is >0 the mesh is written to a file
//                         with that name in addition
//
// =======================================================================================
#macro MechSim_Show_Patch(Start_Face_Index, XSize, YSize, Smooth, UV, Stress_Fact, File_Name)

	#if ((mechsim:face_count-Start_Face_Index)>0)

		#if (strlen(File_Name)=0)
			#local Write_File=false;
			#debug "Generating Patch Triangle Mesh..."
		#else
			#local Write_File=true;

			#fopen FILE File_Name write

			#write (FILE, "// rectangular patch mesh (",str(XSize,0,0),"x",str(YSize,0,0)," vertices)\n")
			#write (FILE, "// written by MechSim include file version ",str(MSIM_INCLUDE_VERSION,1,1),"\n\n")
			#write (FILE, "mesh2 {\n\n")
			#debug concat("Generating Patch Triangle Mesh (writing to file ",File_Name,")...")

		#end

		#local Start_Mass_Index = mechsim:face(Start_Face_Index):index1;

		#if (abs(Stress_Fact)>0)

			#local Vertex_Mult=array[XSize*YSize]
			#local Vertex_Stress=array[XSize*YSize]
			#local Vertex_Text=array[XSize*YSize]

			#if (Write_File)
				#write (FILE, "  #local Vertex_Text=array[",str(XSize*YSize,0,0),"]\n")
				#write (FILE, "  #local Fin_Stress=\n")
				#write (FILE, "    finish {\n")
				#write (FILE, "      specular 0.3\n")
				#write (FILE, "      diffuse 0.7\n")
				#write (FILE, "    }\n\n")
			#end

			#local Cnt=0;
			#while (Cnt < XSize*YSize)
				#local Vertex_Mult[Cnt]=0;
				#local Vertex_Stress[Cnt]=0;
				#local Cnt=Cnt+1;
			#end

			#local Cnt=0;
			#while (Cnt < mechsim:connection_count)

				#if ((mechsim:connection(Cnt):index1 >= Start_Mass_Index) &
					   (mechsim:connection(Cnt):index2 >= Start_Mass_Index) &
					   (mechsim:connection(Cnt):index1 < Start_Mass_Index+(XSize*YSize)) &
					   (mechsim:connection(Cnt):index2 < Start_Mass_Index+(XSize*YSize)))

					#local Dist = vlength(mechsim:mass(mechsim:connection(Cnt):index1):position-
						                    mechsim:mass(mechsim:connection(Cnt):index2):position);

					#local Stress=((Dist-mechsim:connection(Cnt):length)/mechsim:connection(Cnt):length)*Stress_Fact + 0.5;
					#local Vertex_Stress[mechsim:connection(Cnt):index1-Start_Mass_Index]=
					       Vertex_Stress[mechsim:connection(Cnt):index1-Start_Mass_Index]+max(0.0, min(1.0, Stress));
					#local Vertex_Mult[mechsim:connection(Cnt):index1-Start_Mass_Index]=
					       Vertex_Mult[mechsim:connection(Cnt):index1-Start_Mass_Index]+1;
					#local Vertex_Stress[mechsim:connection(Cnt):index2-Start_Mass_Index]=
					       Vertex_Stress[mechsim:connection(Cnt):index2-Start_Mass_Index]+max(0.0, min(1.0, Stress));
					#local Vertex_Mult[mechsim:connection(Cnt):index2-Start_Mass_Index]=
					       Vertex_Mult[mechsim:connection(Cnt):index2-Start_Mass_Index]+1;

				#end
				#local Cnt=Cnt+1;
			#end

		#end

		#if (Write_File)
			#write (FILE, "  vertex_vectors {\n")
			#write (FILE, "    ",str(XSize*YSize,0,0))
		#end

		mesh2 {
			vertex_vectors {
				(XSize*YSize)

				#local Cnt=Start_Mass_Index;
				#while (Cnt < XSize*YSize + Start_Mass_Index)
					,
					mechsim:mass(Cnt):position

					#if (Write_File)
						#write (FILE, ",\n    <",vstr(3,mechsim:mass(Cnt):position,",",0,MSim_File_Decimals), ">")
					#end

					#local Cnt=Cnt+1;
				#end
			}

			#if (Write_File)
				#write (FILE, "\n  }\n")
			#end

			#if (Smooth)

				#if (Write_File)
					#write (FILE, "  normal_vectors {\n")
					#write (FILE, "    ",str(XSize*YSize,0,0))
				#end

				normal_vectors {
					(XSize*YSize)

					#local Cnt=Start_Mass_Index;
					#while (Cnt < XSize*YSize + Start_Mass_Index)
						,

						#local Pos=<mod(Cnt-Start_Mass_Index, XSize), div(Cnt-Start_Mass_Index, XSize)>;

						#if (Pos.x=0)
							#if (Pos.y=0)
								#local Norm=vcross(mechsim:mass(Cnt+1):position-mechsim:mass(Cnt):position,
									                 mechsim:mass(Cnt+XSize):position-mechsim:mass(Cnt):position);
							#else
								#if (Pos.y=YSize-1)
									#local Norm=vcross(mechsim:mass(Cnt+1):position-mechsim:mass(Cnt):position,
										                 mechsim:mass(Cnt):position-mechsim:mass(Cnt-XSize):position);
								#else /* Pos.y middle */
									#local Norm=vcross(mechsim:mass(Cnt+1):position-mechsim:mass(Cnt):position,
										                 mechsim:mass(Cnt+XSize):position-mechsim:mass(Cnt-XSize):position);
								#end
							#end
						#else
							#if (Pos.x=XSize-1)
								#if (Pos.y=0)
									#local Norm=vcross(mechsim:mass(Cnt):position-mechsim:mass(Cnt-1):position,
										                 mechsim:mass(Cnt+XSize):position-mechsim:mass(Cnt):position);
								#else
									#if (Pos.y=YSize-1)
										#local Norm=vcross(mechsim:mass(Cnt):position-mechsim:mass(Cnt-1):position,
											                 mechsim:mass(Cnt):position-mechsim:mass(Cnt-XSize):position);

									#else /* Pos.y middle */
										#local Norm=vcross(mechsim:mass(Cnt):position-mechsim:mass(Cnt-1):position,
											                 mechsim:mass(Cnt+XSize):position-mechsim:mass(Cnt-XSize):position);
									#end
								#end
							#else /* Pos.x middle */
								#if (Pos.y=0)
									#local Norm=vcross(mechsim:mass(Cnt+1):position-mechsim:mass(Cnt-1):position,
										                 mechsim:mass(Cnt+XSize):position-mechsim:mass(Cnt):position);
								#else
									#if (Pos.y=YSize-1)
										#local Norm=vcross(mechsim:mass(Cnt+1):position-mechsim:mass(Cnt-1):position,
											                 mechsim:mass(Cnt):position-mechsim:mass(Cnt-XSize):position);
									#else /* Pos.y and Pos.x middle */
										#local Norm=vcross(mechsim:mass(Cnt+1):position-mechsim:mass(Cnt-1):position,
											                 mechsim:mass(Cnt+XSize):position-mechsim:mass(Cnt-XSize):position);
									#end
								#end
							#end
						#end

						Norm

						#if (Write_File)
							#write (FILE, ",\n    <",vstr(3,Norm,",",0,MSim_File_Decimals), ">")
						#end

						#local Cnt=Cnt+1;
					#end
				}

				#if (Write_File)
					#write (FILE, "\n  }\n")
				#end

			#end

			#if (UV)

				#if (Write_File)
					#write (FILE, "  uv_vectors {\n")
					#write (FILE, "    ",str(XSize*YSize,0,0))
				#end

				uv_vectors {
					(XSize*YSize)

					#local Cnt=Start_Mass_Index;
					#while (Cnt < XSize*YSize + Start_Mass_Index)
						,
						#local UV_Pos=<mod(Cnt-Start_Mass_Index, XSize), div(Cnt-Start_Mass_Index, XSize)>/(XSize-1);

						UV_Pos

						#if (Write_File)
							#write (FILE, ",\n    <",vstr(2,UV_Pos,",",0,MSim_File_Decimals), ">")
						#end

						#local Cnt=Cnt+1;
					#end

				}

				#if (Write_File)
					#write (FILE, "\n  }\n")
				#end

			#end

			#if (abs(Stress_Fact)>0)

				#if (Write_File)
					#write (FILE, "  texture_list {\n")
					#write (FILE, "    ",str(XSize*YSize,0,0))
				#end

				texture_list {
					(XSize*YSize)

					#local Cnt=0;
					#while (Cnt < XSize*YSize)

						#local Vertex_Text[Cnt]=
						texture {
							pigment { color fn_Stress_CM(Vertex_Stress[Cnt]/Vertex_Mult[Cnt], 0, 0) }
							finish {
								specular 0.3
								diffuse 0.7
							}
						}

						,

						texture { Vertex_Text[Cnt] }

						#if (Write_File)
							#write (FILE, "\n    #local Vertex_Text[",str(Cnt,0,0),"]=texture{pigment{ color rgb <",
								            vstr(3, fn_Stress_CM(Vertex_Stress[Cnt]/Vertex_Mult[Cnt],0,0),",",0,4),
								            "> }finish{Fin_Stress}}\n")

							#write (FILE, "    , texture { Vertex_Text[",str(Cnt,0,0),"] }")
						#end

						#local Cnt=Cnt+1;
					#end
				}

				#if (Write_File)
					#write (FILE, "\n  }\n")
				#end

			#end

			#if (Write_File)
				#write (FILE, "  face_indices {\n")
				#write (FILE, "    ",str((XSize-1)*(YSize-1)*2,0,0))
			#end

			face_indices {
				(XSize-1)*(YSize-1)*2

				#local Cnt=Start_Face_Index;

				#while (Cnt< (XSize-1)*(YSize-1)*2 + Start_Face_Index)
					,
					<mechsim:face(Cnt):index1-Start_Mass_Index,
					 mechsim:face(Cnt):index2-Start_Mass_Index,
					 mechsim:face(Cnt):index3-Start_Mass_Index>

					#if (Write_File)
						#write (FILE, ",\n    <",vstr(3,<mechsim:face(Cnt):index1-Start_Mass_Index,
							                               mechsim:face(Cnt):index2-Start_Mass_Index,
							                               mechsim:face(Cnt):index3-Start_Mass_Index>,",",0,0), ">")
					#end

					#if (Stress_Fact>0)
						,
						mechsim:face(Cnt):index1-Start_Mass_Index,
						mechsim:face(Cnt):index2-Start_Mass_Index,
						mechsim:face(Cnt):index3-Start_Mass_Index

						#if (Write_File)
							#write (FILE, ", ",vstr(3,<mechsim:face(Cnt):index1-Start_Mass_Index,
								                         mechsim:face(Cnt):index2-Start_Mass_Index,
								                         mechsim:face(Cnt):index3-Start_Mass_Index>,",",0,0))
						#end

					#end

					#local Cnt=Cnt+1;
				#end
			}

			//texture { MSim_Tex_Mesh }
		}

		#if (Write_File)
			#write (FILE, "\n  }\n}\n")
			#fclose FILE
		#end

	#end

	#debug "Done\n"

#end

// =======================================================================================
//  MechSim_Show_Grid() macro
//
//  generating a mesh for the outer surface of a grid generated with the
//  MechSim_Generate_Grid() macro (with 'Faces' parameter true)
//
//  Parameters:
//      Start_Face_Index - index of the first face that's part of the patch.  Should
//                         be stored when the patch is generated
//      XSize, YSize     - Size of the patch, number of nodes in x- and y-direction
//      Smooth           - boolean value, if true normal vectors are generated
//      UV               - boolean value, if true UV-coordinates are generated
//                         (from 0 to 1 in x-direction)
//      Stress_Fact      - if >0 the mesh is textured to visualize the stress.
//                         values are scaled with this factor
//      File_Name        - string, if length is >0 the mesh is written to a file
//                         with that name in addition
//
// =======================================================================================
#macro MechSim_Show_Grid(Start_Face_Index, XSize, YSize, ZSize, Smooth, UV, Stress_Fact, File_Name)

	#local FCount=(XSize-1)*(YSize-1)*4 + (XSize-1)*(ZSize-1)*4 + (ZSize-1)*(YSize-1)*4;

	#if ((mechsim:face_count-Start_Face_Index)>=FCount)

		#if (strlen(File_Name)=0)
			#local Write_File=false;
			#debug "Generating Grid Surface Triangle Mesh...\n"
		#else
			#local Write_File=true;

			#fopen FILE File_Name write

			#write (FILE, "// grid mesh (",str(XSize,0,0),"x",str(YSize,0,0),"x",str(ZSize,0,0)," vertices)\n")
			#write (FILE, "// written by MechSim include file version ",str(MSIM_INCLUDE_VERSION,1,1),"\n\n")
			#debug concat("Generating Grid Triangle Mesh (writing to file ",File_Name,")...\n")

		#end

		#local Start_Mass_Index = mechsim:face(Start_Face_Index):index1;
		#local Count=(XSize*YSize*ZSize);
		#local EPS=1e-6;

		#if (abs(Stress_Fact)>0)

			#local Vertex_Mult=array[XSize*YSize*ZSize]
			#local Vertex_Stress=array[XSize*YSize*ZSize]
			#local Vertex_Text=array[XSize*YSize*ZSize]

			#if (Write_File)
				#write (FILE, "  #local Vertex_Text=array[",str(XSize*YSize*ZSize,0,0),"]\n")
				#write (FILE, "  #local Fin_Stress=\n")
				#write (FILE, "    finish {\n")
				#write (FILE, "      specular 0.3\n")
				#write (FILE, "      diffuse 0.7\n")
				#write (FILE, "    }\n\n")
			#end

			#local Cnt=0;
			#while (Cnt < Count)
				#local Vertex_Mult[Cnt]=0;
				#local Vertex_Stress[Cnt]=0;
				#local Cnt=Cnt+1;
			#end

			#local Cnt=0;
			#while (Cnt < mechsim:viscoelastic_count)

				#if ((mechsim:viscoelastic(Cnt):index1 >= Start_Mass_Index) &
					   (mechsim:viscoelastic(Cnt):index2 >= Start_Mass_Index) &
					   (mechsim:viscoelastic(Cnt):index1 < Start_Mass_Index+Count) &
					   (mechsim:viscoelastic(Cnt):index2 < Start_Mass_Index+Count))

					#local Dist = vlength(mechsim:mass(mechsim:viscoelastic(Cnt):index1):position-
						                    mechsim:mass(mechsim:viscoelastic(Cnt):index2):position);

					#local Stress=((Dist-mechsim:viscoelastic(Cnt):length)/mechsim:viscoelastic(Cnt):length)*Stress_Fact + 0.5;
					#local Vertex_Stress[mechsim:viscoelastic(Cnt):index1-Start_Mass_Index]=
					       Vertex_Stress[mechsim:viscoelastic(Cnt):index1-Start_Mass_Index]+max(0.0, min(1.0, Stress));
					#local Vertex_Mult[mechsim:viscoelastic(Cnt):index1-Start_Mass_Index]=
					       Vertex_Mult[mechsim:viscoelastic(Cnt):index1-Start_Mass_Index]+1;
					#local Vertex_Stress[mechsim:viscoelastic(Cnt):index2-Start_Mass_Index]=
					       Vertex_Stress[mechsim:viscoelastic(Cnt):index2-Start_Mass_Index]+max(0.0, min(1.0, Stress));
					#local Vertex_Mult[mechsim:viscoelastic(Cnt):index2-Start_Mass_Index]=
					       Vertex_Mult[mechsim:viscoelastic(Cnt):index2-Start_Mass_Index]+1;

				#end
				#local Cnt=Cnt+1;
			#end

			#local Cnt=0;
			#while (Cnt < mechsim:connection_count)

				#if ((mechsim:connection(Cnt):index1 >= Start_Mass_Index) &
					   (mechsim:connection(Cnt):index2 >= Start_Mass_Index) &
					   (mechsim:connection(Cnt):index1 < Start_Mass_Index+Count) &
					   (mechsim:connection(Cnt):index2 < Start_Mass_Index+Count))

					#local Dist = vlength(mechsim:mass(mechsim:connection(Cnt):index1):position-
						                    mechsim:mass(mechsim:connection(Cnt):index2):position);

					#local Stress=((Dist-mechsim:connection(Cnt):length)/mechsim:connection(Cnt):length)*Stress_Fact + 0.5;
					#local Vertex_Stress[mechsim:connection(Cnt):index1-Start_Mass_Index]=
					       Vertex_Stress[mechsim:connection(Cnt):index1-Start_Mass_Index]+max(0.0, min(1.0, Stress));
					#local Vertex_Mult[mechsim:connection(Cnt):index1-Start_Mass_Index]=
					       Vertex_Mult[mechsim:connection(Cnt):index1-Start_Mass_Index]+1;
					#local Vertex_Stress[mechsim:connection(Cnt):index2-Start_Mass_Index]=
					       Vertex_Stress[mechsim:connection(Cnt):index2-Start_Mass_Index]+max(0.0, min(1.0, Stress));
					#local Vertex_Mult[mechsim:connection(Cnt):index2-Start_Mass_Index]=
					       Vertex_Mult[mechsim:connection(Cnt):index2-Start_Mass_Index]+1;

				#end
				#local Cnt=Cnt+1;
			#end

			#local Cnt=0;
			#while (Cnt < Count)

				#local Vertex_Text[Cnt]=
				texture {
					pigment { color fn_Stress_CM(Vertex_Stress[Cnt]/Vertex_Mult[Cnt], 0, 0) }
					finish {
						specular 0.3
						diffuse 0.7
					}
				}

				#if (Write_File)
					#write (FILE, "  #local Vertex_Text[",str(Cnt,0,0),"]=texture{pigment{ color rgb <",
						      vstr(3, fn_Stress_CM(Vertex_Stress[Cnt]/Vertex_Mult[Cnt],0,0),",",0,4),
						      "> }finish{Fin_Stress}}\n")
				#end

				#local Cnt=Cnt+1;
			#end

		#end

		mesh {

			#if (Write_File)
				#write (FILE, "\nmesh {\n")
			#end

			#if (Smooth)

				#local Normals=array[Count][3]

				#local Cnt=0;
				#while (Cnt<Count)
					#local Normals[Cnt][0]=<0,0,0>;
					#local Normals[Cnt][1]=<0,0,0>;
					#local Normals[Cnt][2]=<0,0,0>;
					#local Cnt=Cnt+1;
				#end

				#local Cnt=Start_Face_Index;

				#while (Cnt<Start_Face_Index+FCount)

					#local Norm=vnormalize(vcross(mechsim:mass(mechsim:face(Cnt):index1):position-mechsim:mass(mechsim:face(Cnt):index2):position,
						                            mechsim:mass(mechsim:face(Cnt):index1):position-mechsim:mass(mechsim:face(Cnt):index3):position));

					#local Coord1=<mod(mechsim:face(Cnt):index1-Start_Mass_Index, XSize),
					               div(mod(mechsim:face(Cnt):index1-Start_Mass_Index, XSize*YSize), XSize),
					               div(mechsim:face(Cnt):index1-Start_Mass_Index, XSize*YSize)>;

					#local Coord2=<mod(mechsim:face(Cnt):index2-Start_Mass_Index, XSize),
					               div(mod(mechsim:face(Cnt):index2-Start_Mass_Index, XSize*YSize), XSize),
					               div(mechsim:face(Cnt):index2-Start_Mass_Index, XSize*YSize)>;

					#local Coord3=<mod(mechsim:face(Cnt):index3-Start_Mass_Index, XSize),
					               div(mod(mechsim:face(Cnt):index3-Start_Mass_Index, XSize*YSize), XSize),
					               div(mechsim:face(Cnt):index3-Start_Mass_Index, XSize*YSize)>;

					#if ((abs(Coord1.x-Coord2.x)<EPS)&(abs(Coord2.x-Coord3.x)<EPS))
						// ------ x-negative/positive Face ------
						#local Normals[mechsim:face(Cnt):index1-Start_Mass_Index][0]=
						       Normals[mechsim:face(Cnt):index1-Start_Mass_Index][0] + Norm;
						#local Normals[mechsim:face(Cnt):index2-Start_Mass_Index][0]=
						       Normals[mechsim:face(Cnt):index2-Start_Mass_Index][0] + Norm;
						#local Normals[mechsim:face(Cnt):index3-Start_Mass_Index][0]=
						       Normals[mechsim:face(Cnt):index3-Start_Mass_Index][0] + Norm;
					#end

					#if ((abs(Coord1.y-Coord2.y)<EPS)&(abs(Coord2.y-Coord3.y)<EPS))
						// ------ y-negative/positive Face ------
						#local Normals[mechsim:face(Cnt):index1-Start_Mass_Index][1]=
						       Normals[mechsim:face(Cnt):index1-Start_Mass_Index][1] + Norm;
						#local Normals[mechsim:face(Cnt):index2-Start_Mass_Index][1]=
						       Normals[mechsim:face(Cnt):index2-Start_Mass_Index][1] + Norm;
						#local Normals[mechsim:face(Cnt):index3-Start_Mass_Index][1]=
						       Normals[mechsim:face(Cnt):index3-Start_Mass_Index][1] + Norm;
					#end

					#if ((abs(Coord1.z-Coord2.z)<EPS)&(abs(Coord2.z-Coord3.z)<EPS))
						// ------ z-negative/positive Face ------
						#local Normals[mechsim:face(Cnt):index1-Start_Mass_Index][2]=
						       Normals[mechsim:face(Cnt):index1-Start_Mass_Index][2] + Norm;
						#local Normals[mechsim:face(Cnt):index2-Start_Mass_Index][2]=
						       Normals[mechsim:face(Cnt):index2-Start_Mass_Index][2] + Norm;
						#local Normals[mechsim:face(Cnt):index3-Start_Mass_Index][2]=
						       Normals[mechsim:face(Cnt):index3-Start_Mass_Index][2] + Norm;
					#end

					#local Cnt=Cnt+1;
				#end

				#local Cnt=Start_Face_Index;

				#while (Cnt<Start_Face_Index+FCount)

					#if ( // --- is x-Face? ---
						   (vlength(Normals[mechsim:face(Cnt):index1-Start_Mass_Index][0])>0.5)&
						   (vlength(Normals[mechsim:face(Cnt):index2-Start_Mass_Index][0])>0.5)&
						   (vlength(Normals[mechsim:face(Cnt):index3-Start_Mass_Index][0])>0.5)
					    )
						smooth_triangle {
							mechsim:mass(mechsim:face(Cnt):index1):position,
							vnormalize(Normals[mechsim:face(Cnt):index1-Start_Mass_Index][0]),
							mechsim:mass(mechsim:face(Cnt):index2):position,
							vnormalize(Normals[mechsim:face(Cnt):index2-Start_Mass_Index][0]),
							mechsim:mass(mechsim:face(Cnt):index3):position,
							vnormalize(Normals[mechsim:face(Cnt):index3-Start_Mass_Index][0])
							#if (abs(Stress_Fact)>0)
								texture_list {
									Vertex_Text[mechsim:face(Cnt):index1]
									Vertex_Text[mechsim:face(Cnt):index2]
									Vertex_Text[mechsim:face(Cnt):index3]
								}
							#end
						}

						#if (Write_File)
							#write (FILE, "smooth_triangle { <",vstr(3,mechsim:mass(mechsim:face(Cnt):index1):position,",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,vnormalize(Normals[mechsim:face(Cnt):index1-Start_Mass_Index][0]),",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,mechsim:mass(mechsim:face(Cnt):index2):position,",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,vnormalize(Normals[mechsim:face(Cnt):index2-Start_Mass_Index][0]),",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,mechsim:mass(mechsim:face(Cnt):index3):position,",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,vnormalize(Normals[mechsim:face(Cnt):index3-Start_Mass_Index][0]),",",0,MSim_File_Decimals), ">")

							#if (abs(Stress_Fact)>0)
								#write (FILE, "\n  texture_list { Vertex_Text[",
									      str(mechsim:face(Cnt):index1,0,0), "] Vertex_Text[",
									      str(mechsim:face(Cnt):index2,0,0), "] Vertex_Text[",
									      str(mechsim:face(Cnt):index3,0,0), "] } }\n"
							#else
								#write (FILE, " }\n")
							#end
						#end

					#end

					#if ( // --- is y-Face? ---
						   (vlength(Normals[mechsim:face(Cnt):index1-Start_Mass_Index][1])>0.5)&
						   (vlength(Normals[mechsim:face(Cnt):index2-Start_Mass_Index][1])>0.5)&
						   (vlength(Normals[mechsim:face(Cnt):index3-Start_Mass_Index][1])>0.5)
					    )
						smooth_triangle {
							mechsim:mass(mechsim:face(Cnt):index1):position,
							vnormalize(Normals[mechsim:face(Cnt):index1-Start_Mass_Index][1]),
							mechsim:mass(mechsim:face(Cnt):index2):position,
							vnormalize(Normals[mechsim:face(Cnt):index2-Start_Mass_Index][1]),
							mechsim:mass(mechsim:face(Cnt):index3):position,
							vnormalize(Normals[mechsim:face(Cnt):index3-Start_Mass_Index][1])
							#if (abs(Stress_Fact)>0)
								texture_list {
									Vertex_Text[mechsim:face(Cnt):index1]
									Vertex_Text[mechsim:face(Cnt):index2]
									Vertex_Text[mechsim:face(Cnt):index3]
								}
							#end
						}

						#if (Write_File)
							#write (FILE, "smooth_triangle { <",vstr(3,mechsim:mass(mechsim:face(Cnt):index1):position,",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,vnormalize(Normals[mechsim:face(Cnt):index1-Start_Mass_Index][1]),",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,mechsim:mass(mechsim:face(Cnt):index2):position,",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,vnormalize(Normals[mechsim:face(Cnt):index2-Start_Mass_Index][1]),",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,mechsim:mass(mechsim:face(Cnt):index3):position,",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,vnormalize(Normals[mechsim:face(Cnt):index3-Start_Mass_Index][1]),",",0,MSim_File_Decimals), ">")
							#if (abs(Stress_Fact)>0)
								#write (FILE, "\n  texture_list { Vertex_Text[",
									      str(mechsim:face(Cnt):index1,0,0), "] Vertex_Text[",
									      str(mechsim:face(Cnt):index2,0,0), "] Vertex_Text[",
									      str(mechsim:face(Cnt):index3,0,0), "] } }\n"
							#else
								#write (FILE, " }\n")
							#end
						#end

					#end

					#if ( // --- is z-Face? ---
						   (vlength(Normals[mechsim:face(Cnt):index1-Start_Mass_Index][2])>0.5)&
						   (vlength(Normals[mechsim:face(Cnt):index2-Start_Mass_Index][2])>0.5)&
						   (vlength(Normals[mechsim:face(Cnt):index3-Start_Mass_Index][2])>0.5)
					    )
						smooth_triangle {
							mechsim:mass(mechsim:face(Cnt):index1):position,
							vnormalize(Normals[mechsim:face(Cnt):index1-Start_Mass_Index][2]),
							mechsim:mass(mechsim:face(Cnt):index2):position,
							vnormalize(Normals[mechsim:face(Cnt):index2-Start_Mass_Index][2]),
							mechsim:mass(mechsim:face(Cnt):index3):position,
							vnormalize(Normals[mechsim:face(Cnt):index3-Start_Mass_Index][2])
							#if (abs(Stress_Fact)>0)
								texture_list {
									Vertex_Text[mechsim:face(Cnt):index1]
									Vertex_Text[mechsim:face(Cnt):index2]
									Vertex_Text[mechsim:face(Cnt):index3]
								}
							#end
						}

						#if (Write_File)
							#write (FILE, "smooth_triangle { <",vstr(3,mechsim:mass(mechsim:face(Cnt):index1):position,",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,vnormalize(Normals[mechsim:face(Cnt):index1-Start_Mass_Index][2]),",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,mechsim:mass(mechsim:face(Cnt):index2):position,",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,vnormalize(Normals[mechsim:face(Cnt):index2-Start_Mass_Index][2]),",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,mechsim:mass(mechsim:face(Cnt):index3):position,",",0,MSim_File_Decimals), ">, <",
								                                  vstr(3,vnormalize(Normals[mechsim:face(Cnt):index3-Start_Mass_Index][2]),",",0,MSim_File_Decimals), ">")
							#if (abs(Stress_Fact)>0)
								#write (FILE, "\n  texture_list { Vertex_Text[",
									      str(mechsim:face(Cnt):index1,0,0), "] Vertex_Text[",
									      str(mechsim:face(Cnt):index2,0,0), "] Vertex_Text[",
									      str(mechsim:face(Cnt):index3,0,0), "] } }\n"
							#else
								#write (FILE, " }\n")
							#end
						#end

					#end
					#local Cnt=Cnt+1;

				#end

			#else // not Smooth

				#local Cnt=Start_Face_Index;

				#while (Cnt<Start_Face_Index+FCount)

					triangle {
						mechsim:mass(mechsim:face(Cnt):index1):position,
						mechsim:mass(mechsim:face(Cnt):index2):position,
						mechsim:mass(mechsim:face(Cnt):index3):position
						#if (abs(Stress_Fact)>0)
							texture_list {
								Vertex_Text[mechsim:face(Cnt):index1]
								Vertex_Text[mechsim:face(Cnt):index2]
								Vertex_Text[mechsim:face(Cnt):index3]
							}
						#end
					}

					#if (Write_File)
						#write (FILE, "triangle { <",vstr(3,mechsim:mass(mechsim:face(Cnt):index1):position,",",0,MSim_File_Decimals), ">, <",
							                           vstr(3,mechsim:mass(mechsim:face(Cnt):index2):position,",",0,MSim_File_Decimals), ">, <",
							                           vstr(3,mechsim:mass(mechsim:face(Cnt):index3):position,",",0,MSim_File_Decimals), ">")
						#if (abs(Stress_Fact)>0)
							#write (FILE, "\n  texture_list { Vertex_Text[",
								      str(mechsim:face(Cnt):index1,0,0), "] Vertex_Text[",
									    str(mechsim:face(Cnt):index2,0,0), "] Vertex_Text[",
									    str(mechsim:face(Cnt):index3,0,0), "] } }\n"
						#else
							#write (FILE, " }\n")
						#end
					#end

					#local Cnt=Cnt+1;
				#end

			#end

			texture { MSim_Tex_Mesh }
		}

		#if (Write_File)
			#write (FILE, "}\n")
		#end

	#end

	#debug "Done\n"

#end

// =======================================================================================
//  MechSim_Show_Sphere() macro
//
//  generating a mesh for the outer surface of a grid generated with the
//  MechSim_Generate_Sphere() macro (fith 'Faces' parameter true)
//
//  Parameters:
//      Start_Face_Index - index of the first face that's part of the patch.  Should
//                         be stored when the patch is generated
//      XSize, YSize     - Size of the patch, number of nodes in x- and y-direction
//      Smooth           - boolean value, if true normal vectors are generated
//      UV               - boolean value, if true UV-coordinates are generated
//                         (from 0 to 1 in x-direction)
//      Stress_Fact      - if >0 the mesh is textured to visualize the stress.
//                         values are scaled with this factor
//      File_Name        - string, if length is >0 the mesh is written to a file
//                         with that name in addition
//
// =======================================================================================
#macro MechSim_Show_Sphere(Start_Face_Index, Face_Count, Smooth, UV, Stress_Fact, File_Name)

	#if ((mechsim:face_count-Start_Face_Index)>=Face_Count)

		#if (strlen(File_Name)=0)
			#local Write_File=false;
			#debug "Generating Sphere Surface Triangle Mesh...\n"
		#else
			#local Write_File=true;

			#fopen FILE File_Name write

			#write (FILE, "// sphere mesh (",str(XSize,0,0),"x",str(YSize,0,0),"x",str(ZSize,0,0)," vertices)\n")
			#write (FILE, "// written by MechSim include file version ",str(MSIM_INCLUDE_VERSION,1,1),"\n\n")
			#write (FILE, "mesh {\n\n")
			#debug concat("Generating Sphere Triangle Mesh (writing to file ",File_Name,")...\n")

		#end

		mesh {

			#if (Write_File)
				#write (FILE, "mesh {\n")
			#end

			#if (Smooth)

				#local Center_Pos=mechsim:mass(mechsim:face(Start_Face_Index):index1-1):position;

				#local Cnt=Start_Face_Index;

				#while (Cnt<Start_Face_Index+Face_Count)

					smooth_triangle { mechsim:mass(mechsim:face(Cnt):index1):position,
						                vnormalize(mechsim:mass(mechsim:face(Cnt):index1):position-Center_Pos),
						                mechsim:mass(mechsim:face(Cnt):index2):position,
						                vnormalize(mechsim:mass(mechsim:face(Cnt):index2):position-Center_Pos),
						                mechsim:mass(mechsim:face(Cnt):index3):position,
						                vnormalize(mechsim:mass(mechsim:face(Cnt):index3):position-Center_Pos) }

					#if (Write_File)
						#write (FILE, "triangle { <",vstr(3,mechsim:mass(mechsim:face(Cnt):index1):position,",",0,MSim_File_Decimals), ">, <",
							                           vstr(3,mechsim:mass(mechsim:face(Cnt):index2):position,",",0,MSim_File_Decimals), ">, <",
							                           vstr(3,mechsim:mass(mechsim:face(Cnt):index3):position,",",0,MSim_File_Decimals), "> }\n")
					#end

					#local Cnt=Cnt+1;
				#end

			#else // not Smooth

				#local Cnt=Start_Face_Index;

				#while (Cnt<Start_Face_Index+Face_Count)

					triangle { mechsim:mass(mechsim:face(Cnt):index1):position,
						         mechsim:mass(mechsim:face(Cnt):index2):position,
						         mechsim:mass(mechsim:face(Cnt):index3):position }

					#if (Write_File)
						#write (FILE, "triangle { <",vstr(3,mechsim:mass(mechsim:face(Cnt):index1):position,",",0,MSim_File_Decimals), ">, <",
							                           vstr(3,mechsim:mass(mechsim:face(Cnt):index2):position,",",0,MSim_File_Decimals), ">, <",
							                           vstr(3,mechsim:mass(mechsim:face(Cnt):index3):position,",",0,MSim_File_Decimals), "> }\n")
					#end

					#local Cnt=Cnt+1;
				#end

			#end

			texture { MSim_Tex_Mesh }
		}

		#if (Write_File)
			#write (FILE, "}\n")
		#end

	#end

	#debug "Done\n"

#end

// =======================================================================================
//  MechSim_Show_Con() macro
//
//  generating a cylinder representing a connection
//
//  Parameters:
//      Idx - connection index
//
// =======================================================================================

#macro MechSim_Show_Con(Idx)

  #local Dist = vlength(mechsim:mass(mechsim:connection(Idx):index1):position-
		                    mechsim:mass(mechsim:connection(Idx):index2):position);
  #if (Dist>0.0001)
		cylinder {
			mechsim:mass(mechsim:connection(Idx):index1):position,
			mechsim:mass(mechsim:connection(Idx):index2):position,
			(mechsim:mass(mechsim:connection(Idx):index1):radius+mechsim:mass(mechsim:connection(Idx):index2):radius)*0.25
		}
	#end
#end

// =======================================================================================
//  MechSim_Show_Con_VE() macro
//
//  generating a cylinder representing a viscoelastic connection
//
//  Parameters:
//      Idx - connection index
//
// =======================================================================================

#macro MechSim_Show_Con_VE(Idx)

  #local Dist = vlength(mechsim:mass(mechsim:viscoelastic(Idx):index1):position-
		                    mechsim:mass(mechsim:viscoelastic(Idx):index2):position);
  #if (Dist>0.0001)
		cylinder {
			mechsim:mass(mechsim:viscoelastic(Idx):index1):position,
			mechsim:mass(mechsim:viscoelastic(Idx):index2):position,
			(mechsim:mass(mechsim:viscoelastic(Idx):index1):radius+mechsim:mass(mechsim:viscoelastic(Idx):index2):radius)*0.25
		}
	#end
#end


// #######################################################################################
//   Grid topology generation macros
// #######################################################################################

// =======================================================================================
//  MechSim_Generate_Grid_X() macro
//
//  basis macro for generating 3D grid topologies.
//  Do not use this but the wrapper macros below.
//
//  Parameters:
//      Velocity     - vector defining the common starting velocity of all masses.
//      Radius       - radius of all masses.
//      fn_Density   - user defined function controlling the density of the masses.
//                     x, y and z are evaluated in [0..1] range.
//      fn_Stiffness - user defined function controlling the stiffness of the connections.
//      fn_Damping   - user defined function controlling the damping of the connections.
//      VE_Elements  - array with the parameters for viscoelastic connections
//      VE_Accuracy  - accuracy value for viscoelastic connections -
//                     <= 0 means to create normal connections
//      Faces        - Boolean value controlling whether faces are generated for the surface.
//                     If true faces are generated on the outside shape.
//      Cube_Scale   - 3D vector controlling the distances in the grid. It defines the size of an elementary cell.
//      Grid_Size    - 3D vector containing the number of masses in all three directions.
//      Transf       - Transform applied to the mass positions
//      fn_Fixed     - user defined function controlling which masses are fixed.
//									   x, y and z are evaluated in [0..1] range. For function values > 0 the masses are fixed.
//      fn_Attach    - user defined function controlling which masses are attached.
//                     x, y and z are evaluated in [0..1] range. The function value determines the attachment index.
//      fn_Force     - user defined function controlling custom forces.
//                     x, y and z are evaluated in [0..1] range. The function value determines the custom force index.
//      Connect_Arr  - Array containing weights for connection stiffness and damping.
//
// =======================================================================================
#macro MechSim_Generate_Grid_X(Velocity, Radius, fn_Density, fn_Stiffness, fn_Damping, VE_Elements, VE_Accuracy, Faces, Cube_Scale, Grid_Size, Transf, fn_Fixed, fn_Attach, fn_Force, Connect_Arr)

	#debug "Generating Grid..."

	#local Vel=Velocity+<0,0,0>;
	#local CubeScale=Cube_Scale+<0,0,0>;
	#local GridSize=Grid_Size+<0,0,0>;

	#local EPS=0.001*CubeScale.x;

	#local StIdx=mechsim:mass_count;
	#local Count=(GridSize.x*GridSize.y*GridSize.z);
	#local Diagonal=dimension_size(Connect_Arr, 1);
	#if (Connect_Arr[0]=0)
		#local Diagonal=0;
	#end

	#local Cnt=0;

	#while (Cnt<Count)

		#local Coord=<mod(Cnt, GridSize.x),
		              div(mod(Cnt, GridSize.x*GridSize.y), GridSize.x),
		              div(Cnt, GridSize.x*GridSize.y)>;


		#local Coord2=<Coord.x*CubeScale.x,
		               Coord.y*CubeScale.y,
		               Coord.z*CubeScale.z>;

		#local CoordF=<Coord.x/(GridSize.x-1),
                   Coord.y/(GridSize.y-1),
                   Coord.z/(GridSize.z-1)>;

		mass {
			vtransform(Coord2, Transf), Vel, Radius density fn_Density(CoordF.x, CoordF.y, CoordF.z)
			#if ( fn_Fixed(CoordF.x, CoordF.y, CoordF.z)>0 )
				fixed on
			#else
				#local Attach=fn_Attach(CoordF.x, CoordF.y, CoordF.z);
				#if ( Attach>-0.1 )
					attach Attach
				#end
				#local Force=fn_Force(CoordF.x, CoordF.y, CoordF.z);
				#if ( Force>-0.1 )
					force Force
				#end
			#end
		}

		#local Cnt=Cnt+1;
	#end

	#if (Faces)

		#local Cnt=0;

		#while (Cnt<Count)

			#local Coord=<mod(Cnt, GridSize.x),
			              div(mod(Cnt, GridSize.x*GridSize.y), GridSize.x),
			              div(Cnt, GridSize.x*GridSize.y)>;

			#local UpB=GridSize-1-EPS;

			#if (((Coord.x<EPS)|(Coord.x>UpB.x))&
				    (Coord.y<UpB.y)&(Coord.z<UpB.z))  // ------ x-negative/positive Face ------

				face { StIdx+Cnt, StIdx+Cnt+GridSize.x, StIdx+Cnt+GridSize.x*GridSize.y+GridSize.x }
				face { StIdx+Cnt, StIdx+Cnt+GridSize.x*GridSize.y+GridSize.x, StIdx+Cnt+GridSize.x*GridSize.y }
			#end

			#if (((Coord.y<EPS)|(Coord.y>UpB.y))&
				    (Coord.x<UpB.x)&(Coord.z<UpB.z))  // ------ y-negative/positive Face ------

				face { StIdx+Cnt, StIdx+Cnt+1, StIdx+Cnt+GridSize.x*GridSize.y+1 }
				face { StIdx+Cnt, StIdx+Cnt+GridSize.x*GridSize.y+1, StIdx+Cnt+GridSize.x*GridSize.y}
			#end

			#if (((Coord.z<EPS)|(Coord.z>UpB.z))&
				    (Coord.x<UpB.x)&(Coord.y<UpB.y))  // ------ z-negative/positive Face ------

				face { StIdx+Cnt, StIdx+Cnt+1, StIdx+Cnt+GridSize.x+1 }
				face { StIdx+Cnt, StIdx+Cnt+GridSize.x+1, StIdx+Cnt+GridSize.x }
			#end

			#local Cnt=Cnt+1;

		#end
	#end


	#if (Diagonal>0)

		#if (VE_Accuracy>0)
			#local VE_Elem_Cnt=dimension_size(VE_Elements, 1);
		#else
			#local VE_Elem_Cnt=0;
		#end

		#local Cnt=0;

		#while (Cnt<Count)

			#local Coord=<mod(Cnt, GridSize.x),
			              div(mod(Cnt, GridSize.x*GridSize.y), GridSize.x),
			              div(Cnt, GridSize.x*GridSize.y)>;

			#local CoordF=<Coord.x/(GridSize.x-1),
			               Coord.y/(GridSize.y-1),
			               Coord.z/(GridSize.z-1)>;

			#local Stiffness=fn_Stiffness(CoordF.x, CoordF.y, CoordF.z);
			#local Damping=fn_Damping(CoordF.x, CoordF.y, CoordF.z);

			#if (Coord.x<GridSize.x-1)

				#if (VE_Elem_Cnt=0)
					connection {
						StIdx+Cnt, StIdx+Cnt+1
						stiffness Stiffness*Connect_Arr[0]
						damping Damping*Connect_Arr[0]
					}
				#else
					viscoelastic {
						StIdx+Cnt, StIdx+Cnt+1 stiffness Stiffness*Connect_Arr[0]

						#local ECnt=0;

						#while (ECnt<VE_Elem_Cnt)
							element { VE_Elements[ECnt][0]*Connect_Arr[0], VE_Elements[ECnt][1]*Connect_Arr[0] }
							#local ECnt=ECnt+1;
						#end
					}
				#end

				#if (Diagonal>1)
					#if (Coord.y<GridSize.y-1)

						#if (VE_Elem_Cnt=0)
							connection {
								StIdx+Cnt, StIdx+Cnt+GridSize.x+1
								stiffness Stiffness*Connect_Arr[1]
								damping Damping*Connect_Arr[1]
							}
						#else
							viscoelastic {
								StIdx+Cnt, StIdx+Cnt+GridSize.x+1 stiffness Stiffness*Connect_Arr[1]

								#local ECnt=0;

								#while (ECnt<VE_Elem_Cnt)
									element { VE_Elements[ECnt][0]*Connect_Arr[1], VE_Elements[ECnt][1]*Connect_Arr[1] }
									#local ECnt=ECnt+1;
								#end
							}
						#end

						#if (Diagonal>2)

							#if (VE_Elem_Cnt=0)
								connection {
									StIdx+Cnt+1, StIdx+Cnt+GridSize.x
									stiffness Stiffness*Connect_Arr[2]
									damping Damping*Connect_Arr[2]
								}
							#else
								viscoelastic {
									StIdx+Cnt+1, StIdx+Cnt+GridSize.x stiffness Stiffness*Connect_Arr[2]

									#local ECnt=0;

									#while (ECnt<VE_Elem_Cnt)
										element { VE_Elements[ECnt][0]*Connect_Arr[2], VE_Elements[ECnt][1]*Connect_Arr[2] }
										#local ECnt=ECnt+1;
									#end
								}
							#end

						#end
					#end
				#end
			#end
			#if (Coord.y<GridSize.y-1)

				#if (VE_Elem_Cnt=0)
					connection {
						StIdx+Cnt, StIdx+Cnt+GridSize.x
						stiffness Stiffness*Connect_Arr[0]
						damping Damping*Connect_Arr[0]
					}
				#else
					viscoelastic {
						StIdx+Cnt, StIdx+Cnt+GridSize.x stiffness Stiffness*Connect_Arr[0]

						#local ECnt=0;

						#while (ECnt<VE_Elem_Cnt)
							element { VE_Elements[ECnt][0]*Connect_Arr[0], VE_Elements[ECnt][1]*Connect_Arr[0] }
							#local ECnt=ECnt+1;
						#end
					}
				#end

				#if (Diagonal>1)
					#if (Coord.z<GridSize.z-1)

						#if (VE_Elem_Cnt=0)
							connection {
								StIdx+Cnt, StIdx+Cnt+GridSize.x*(GridSize.y+1)
								stiffness Stiffness*Connect_Arr[1]
								damping Damping*Connect_Arr[1]
							}
						#else
							viscoelastic {
								StIdx+Cnt, StIdx+Cnt+GridSize.x*(GridSize.y+1) stiffness Stiffness*Connect_Arr[1]

								#local ECnt=0;

								#while (ECnt<VE_Elem_Cnt)
									element { VE_Elements[ECnt][0]*Connect_Arr[1], VE_Elements[ECnt][1]*Connect_Arr[1] }
									#local ECnt=ECnt+1;
								#end
							}
						#end

						#if (Diagonal>2)

							#if (VE_Elem_Cnt=0)
								connection {
									StIdx+Cnt+GridSize.x, StIdx+Cnt+GridSize.x*GridSize.y
									stiffness Stiffness*Connect_Arr[2]
									damping Damping*Connect_Arr[2]
								}
							#else
								viscoelastic {
									StIdx+Cnt+GridSize.x, StIdx+Cnt+GridSize.x*GridSize.y stiffness Stiffness*Connect_Arr[2]

									#local ECnt=0;

									#while (ECnt<VE_Elem_Cnt)
										element { VE_Elements[ECnt][0]*Connect_Arr[2], VE_Elements[ECnt][1]*Connect_Arr[2] }
										#local ECnt=ECnt+1;
									#end
								}
							#end

						#end
					#end
				#end
			#end
			#if (Coord.z<GridSize.z-1)

				#if (VE_Elem_Cnt=0)
					connection {
						StIdx+Cnt, StIdx+Cnt+GridSize.x*GridSize.y
						stiffness Stiffness*Connect_Arr[0]
						damping Damping*Connect_Arr[0]
					}
				#else
					viscoelastic {
						StIdx+Cnt, StIdx+Cnt+GridSize.x*GridSize.y stiffness Stiffness*Connect_Arr[0]

						#local ECnt=0;

						#while (ECnt<VE_Elem_Cnt)
							element { VE_Elements[ECnt][0]*Connect_Arr[0], VE_Elements[ECnt][1]*Connect_Arr[0] }
							#local ECnt=ECnt+1;
						#end
					}
				#end

				#if (Diagonal>1)
					#if (Coord.x<GridSize.x-1)

						#if (VE_Elem_Cnt=0)
							connection {
								StIdx+Cnt, StIdx+Cnt+GridSize.x*GridSize.y+1
								stiffness Stiffness*Connect_Arr[1]
								damping Damping*Connect_Arr[1]
							}
						#else
							viscoelastic {
								StIdx+Cnt, StIdx+Cnt+GridSize.x*GridSize.y+1 stiffness Stiffness*Connect_Arr[1]

								#local ECnt=0;

								#while (ECnt<VE_Elem_Cnt)
									element { VE_Elements[ECnt][0]*Connect_Arr[1], VE_Elements[ECnt][1]*Connect_Arr[1] }
									#local ECnt=ECnt+1;
								#end
							}
						#end

						#if (Diagonal>2)

							#if (VE_Elem_Cnt=0)
								connection {
									StIdx+Cnt+1, StIdx+Cnt+GridSize.x*GridSize.y
									stiffness Stiffness*Connect_Arr[2]
									damping Damping*Connect_Arr[2]
								}
							#else
								viscoelastic {
									StIdx+Cnt+1, StIdx+Cnt+GridSize.x*GridSize.y stiffness Stiffness*Connect_Arr[2]

									#local ECnt=0;

									#while (ECnt<VE_Elem_Cnt)
										element { VE_Elements[ECnt][0]*Connect_Arr[2], VE_Elements[ECnt][1]*Connect_Arr[2] }
										#local ECnt=ECnt+1;
									#end
								}
							#end

						#end
					#end
				#end
			#end

			#if (Diagonal>3)
				#if ((Coord.x<GridSize.x-1) &
					   (Coord.y<GridSize.y-1) &
					   (Coord.z<GridSize.z-1))

					#if (VE_Elem_Cnt=0)
						connection {
							StIdx+Cnt, StIdx+Cnt+GridSize.x*(GridSize.y+1)+1
							stiffness Stiffness*Connect_Arr[3]
							damping Damping*Connect_Arr[3]
						}
						connection {
							StIdx+Cnt+1, StIdx+Cnt+GridSize.x*(GridSize.y+1)
							stiffness Stiffness*Connect_Arr[3]
							damping Damping*Connect_Arr[3]
						}
						connection {
							StIdx+Cnt+GridSize.x, StIdx+Cnt+GridSize.x*GridSize.y+1
							stiffness Stiffness*Connect_Arr[3]
							damping Damping*Connect_Arr[3]
						}
						connection {
							StIdx+Cnt+GridSize.x+1, StIdx+Cnt+GridSize.x*GridSize.y
							stiffness Stiffness*Connect_Arr[3]
							damping Damping*Connect_Arr[3]
						}
					#else
						viscoelastic {
							StIdx+Cnt, StIdx+Cnt+GridSize.x*(GridSize.y+1)+1 stiffness Stiffness*Connect_Arr[3]

							#local ECnt=0;

							#while (ECnt<VE_Elem_Cnt)
								element { VE_Elements[ECnt][0]*Connect_Arr[3], VE_Elements[ECnt][1]*Connect_Arr[3] }
								#local ECnt=ECnt+1;
							#end
						}
						viscoelastic {
							StIdx+Cnt+1, StIdx+Cnt+GridSize.x*(GridSize.y+1) stiffness Stiffness*Connect_Arr[3]

							#local ECnt=0;

							#while (ECnt<VE_Elem_Cnt)
								element { VE_Elements[ECnt][0]*Connect_Arr[3], VE_Elements[ECnt][1]*Connect_Arr[3] }
								#local ECnt=ECnt+1;
							#end
						}
						viscoelastic {
							StIdx+Cnt+GridSize.x, StIdx+Cnt+GridSize.x*GridSize.y+1 stiffness Stiffness*Connect_Arr[3]

							#local ECnt=0;

							#while (ECnt<VE_Elem_Cnt)
								element { VE_Elements[ECnt][0]*Connect_Arr[3], VE_Elements[ECnt][1]*Connect_Arr[3] }
								#local ECnt=ECnt+1;
							#end
						}
						viscoelastic {
							StIdx+Cnt+GridSize.x+1, StIdx+Cnt+GridSize.x*GridSize.y stiffness Stiffness*Connect_Arr[3]

							#local ECnt=0;

							#while (ECnt<VE_Elem_Cnt)
								element { VE_Elements[ECnt][0]*Connect_Arr[3], VE_Elements[ECnt][1]*Connect_Arr[3] }
								#local ECnt=ECnt+1;
							#end
						}
					#end

				#end
			#end

			#local Cnt=Cnt+1;
		#end
	#end

	#debug "Done\n"

#end

// =======================================================================================
//  MechSim_Generate_Grid_Fn() macro
//
//  topology generation macro building a 3D grid of masses connected and with optional
//  faces on the outside.  density, stiffness and damping can be controlled by functions
//  functions also control fixed and attached masses
//
//  Parameters:
//      Velocity     - vector defining the common starting velocity of all masses.
//      Radius       - radius of all masses.
//      fn_Density   - user defined function controlling the density of the masses.
//                     x, y and z are evaluated in [0..1] range.
//      fn_Stiffness - user defined function controlling the stiffness of the connections.
//      fn_Damping   - user defined function controlling the damping of the connections.
//      Faces        - Boolean value controlling whether faces are generated for the surface.
//                     If true faces are generated on the outside shape.
//      Cube_Scale   - 3D vector controlling the distances in the grid. It defines the size of an elementary cell.
//      Grid_Size    - 3D vector containing the number of masses in all three directions.
//      Transf       - Transform applied to the mass positions
//      fn_Fixed     - user defined function controlling which masses are fixed.
//									   x, y and z are evaluated in [0..1] range. For function values > 0 the masses are fixed.
//      fn_Attach    - user defined function controlling which masses are attached.
//                     x, y and z are evaluated in [0..1] range. The function value determines the attachment index.
//      fn_Force     - user defined function controlling custom forces.
//                     x, y and z are evaluated in [0..1] range. The function value determines the custom force index.
//      Connect_Arr  - Array containing weights for connection stiffness and damping.
//
// =======================================================================================
#macro MechSim_Generate_Grid_Fn(Velocity, Radius, fn_Density, fn_Stiffness, fn_Damping, Faces, Cube_Scale, Grid_Size, Transf, fn_Fixed, fn_Attach, fn_Force, Connect_Arr)

	#local VE_Elements=array[1]
	#local VE_Accuracy=0;

	MechSim_Generate_Grid_X(
		Velocity, Radius, fn_Density, fn_Stiffness, fn_Damping, VE_Elements, VE_Accuracy, Faces, Cube_Scale, Grid_Size,
		Transf, fn_Fixed, fn_Attach, fn_Force, Connect_Arr
	)

#end

// =======================================================================================
//  MechSim_Generate_Grid_Fn_VE() macro
//
//  variant of MechSim_Generate_Grid_Fn() generating viscoelastic connections
//
//  Parameters:
//      Velocity     - vector defining the common starting velocity of all masses.
//      Radius       - radius of all masses.
//      fn_Density   - user defined function controlling the density of the masses.
//                     x, y and z are evaluated in [0..1] range.
//      fn_Stiffness - user defined function controlling the stiffness of the connections.
//      VE_Elements  - array with the parameters for viscoelastic connections
//      VE_Accuracy  - accuracy value for viscoelastic connection
//      Faces        - Boolean value controlling whether faces are generated for the surface.
//                     If true faces are generated on the outside shape.
//      Cube_Scale   - 3D vector controlling the distances in the grid. It defines the size of an elementary cell.
//      Grid_Size    - 3D vector containing the number of masses in all three directions.
//      Transf       - Transform applied to the mass positions
//      fn_Fixed     - user defined function controlling which masses are fixed.
//									   x, y and z are evaluated in [0..1] range. For function values > 0 the masses are fixed.
//      fn_Attach    - user defined function controlling which masses are attached.
//                     x, y and z are evaluated in [0..1] range. The function value determines the attachment index.
//      fn_Force     - user defined function controlling custom forces.
//                     x, y and z are evaluated in [0..1] range. The function value determines the custom force index.
//      Connect_Arr  - Array containing weights for connection stiffness and damping.
//
// =======================================================================================
#macro MechSim_Generate_Grid_Fn_VE(Velocity, Radius, fn_Density, fn_Stiffness, VE_Elements, VE_Accuracy, Faces, Cube_Scale, Grid_Size, Transf, fn_Fixed, fn_Attach, fn_Force, Connect_Arr)

	#local __MSIM_fn_Damping=function(x, y, z) {0}

	MechSim_Generate_Grid_X(
		Velocity, Radius, fn_Density, fn_Stiffness, __MSIM_fn_Damping, VE_Elements, VE_Accuracy, Faces, Cube_Scale, Grid_Size,
		Transf, fn_Fixed, fn_Attach, fn_Force, Connect_Arr
	)

#end

// =======================================================================================
//  MechSim_Generate_Grid() macro
//
//  topology generation macro building a 3D grid of masses connected and with optional
//  faces on the outside.  density, stiffness and damping as fixed values,
//  masses are not fixed or attached.
//
//  Parameters:
//      Velocity    - common velocity of all masses
//      Radius      - radius of the masses
//      Density     - density of the masses
//      Stiffness   - stiffness of the connections
//      Damping     - damping of the connections
//      Faces       - Boolean value controlling whether faces are generated for the
//                    surface.
//      Cube_Scale  - Grid distance vector, defining the size of an elemetary
//                    cell in the grid.
//      Grid_Size   - Vector with number of masses in x, y and z direction
//      Transf      - Transform applied to the mass positions
//      Connect_Arr - Array containing weights for connection stiffness and damping
//
// =======================================================================================
#macro MechSim_Generate_Grid(Velocity, Radius, Density, Stiffness, Damping, Faces, Cube_Scale, Grid_Size, Transf, Connect_Arr)

	#local __MSIM_fn_Density=function(x, y, z) {Density}
	#local __MSIM_fn_Stiffness=function(x, y, z) {Stiffness}
	#local __MSIM_fn_Damping=function(x, y, z) {Damping}
	#local __MSIM_fn_Fixed=function(x, y, z) {-1}
	#local __MSIM_fn_Attach=function(x, y, z) {-1}
	#local __MSIM_fn_Force=function(x, y, z) {-1}

	#local VE_Elements=array[1]
	#local VE_Accuracy=0;

	MechSim_Generate_Grid_X(
		Velocity, Radius, __MSIM_fn_Density, 
		__MSIM_fn_Stiffness, __MSIM_fn_Damping, VE_Elements, VE_Accuracy, 
		Faces, Cube_Scale, Grid_Size,
		Transf, __MSIM_fn_Fixed, __MSIM_fn_Attach, __MSIM_fn_Force, Connect_Arr
	)

#end

// =======================================================================================
//  MechSim_Generate_Grid_VE() macro
//
//  variant of MechSim_Generate_Grid() generating viscoelastic connections
//
//  Parameters:
//      Velocity    - common velocity of all masses
//      Radius      - radius of the masses
//      Density     - density of the masses
//      Stiffness   - stiffness of the connections
//      VE_Elements - array with the parameters for viscoelastic connections
//      VE_Accuracy - accuracy value for viscoelastic connection
//      Faces       - Boolean value controlling whether faces are generated for the
//                    surface.
//      Cube_Scale  - Grid distance vector, defining the size of an elemetary
//                    cell in the grid.
//      Grid_Size   - Vector with number of masses in x, y and z direction
//      Transf      - Transform applied to the mass positions
//      Connect_Arr - Array containing weights for connection stiffness and damping
//
// =======================================================================================
#macro MechSim_Generate_Grid_VE(Velocity, Radius, Density, Stiffness, VE_Elements, VE_Accuracy, Faces, Cube_Scale, Grid_Size, Transf, Connect_Arr)

	#local __MSIM_fn_Density=function(x, y, z) {Density}
	#local __MSIM_fn_Stiffness=function(x, y, z) {Stiffness}
	#local __MSIM_fn_Damping=function(x, y, z) {0}
	#local __MSIM_fn_Fixed=function(x, y, z) {-1}
	#local __MSIM_fn_Attach=function(x, y, z) {-1}
	#local __MSIM_fn_Force=function(x, y, z) {-1}

	MechSim_Generate_Grid_X(
		Velocity, Radius, __MSIM_fn_Density, 
		__MSIM_fn_Stiffness, __MSIM_fn_Damping, VE_Elements, VE_Accuracy, 
		Faces, Cube_Scale, Grid_Size,
		Transf, __MSIM_fn_Fixed, __MSIM_fn_Attach, __MSIM_fn_Force, Connect_Arr
	)

#end

// =======================================================================================
//  MechSim_Generate_Grid_Std() macro
//
//  topology generation macro building a 3D grid of masses connected and with optional
//  faces on the outside.  density, stiffness and damping as fixed values,
//  masses are not fixed or attached.
//  Instead of the connection weight array a Diagonal parameter is used
//
//  Parameters:
//      Velocity    - common velocity of all masses
//      Radius      - radius of the masses
//      Density     - density of the masses
//      Stiffness   - stiffness of the connections
//      Damping     - damping of the connections
//      Faces       - Boolean value controlling whether faces are generated for the
//                    surface.
//      Cube_Scale  - Grid distance vector, defining the size of an elemetary
//                    cell in the grid.
//      Grid_Size   - Vector with number of masses in x, y and z direction
//      Transf      - Transform applied to the mass positions
//      Diagonal   - controling which diagonal connections are generated in the grid.
//
// =======================================================================================
#macro MechSim_Generate_Grid_Std(Velocity, Radius, Density, Stiffness, Damping, Faces, Cube_Scale, Grid_Size, Transf, Diagonal)

	#local __MSIM_fn_Density=function(x, y, z) {Density}
	#local __MSIM_fn_Stiffness=function(x, y, z) {Stiffness}
	#local __MSIM_fn_Damping=function(x, y, z) {Damping}
	#local __MSIM_fn_Fixed=function(x, y, z) {-1}
	#local __MSIM_fn_Attach=function(x, y, z) {-1}
	#local __MSIM_fn_Force=function(x, y, z) {-1}

	#local VE_Elements=array[1]
	#local VE_Accuracy=0;

	#local Connect_Arr=array[max(1, Diagonal)]

	#local Cnt=0;
	#while (Cnt<max(1, Diagonal))
		#local Connect_Arr[Cnt]=1;
		#local Cnt=Cnt+1;
	#end

	#if (Diagonal=0)
		#local Connect_Arr[0]=0;
	#end

	MechSim_Generate_Grid_X(
		Velocity, Radius, __MSIM_fn_Density, 
		__MSIM_fn_Stiffness, __MSIM_fn_Damping, VE_Elements, VE_Accuracy, 
		Faces, Cube_Scale, Grid_Size,
		Transf, __MSIM_fn_Fixed, __MSIM_fn_Attach, __MSIM_fn_Force, Connect_Arr
	)

#end

// =======================================================================================
//  MechSim_Generate_Grid_Std_VE() macro
//
//  variant of MechSim_Generate_Grid_Std() generating viscoelastic connections
//
//  Parameters:
//      Velocity    - common velocity of all masses
//      Radius      - radius of the masses
//      Density     - density of the masses
//      Stiffness   - stiffness of the connections
//      VE_Elements - array with the parameters for viscoelastic connections
//      VE_Accuracy - accuracy value for viscoelastic connection
//      Faces       - Boolean value controlling whether faces are generated for the
//                    surface.
//      Cube_Scale  - Grid distance vector, defining the size of an elemetary
//                    cell in the grid.
//      Grid_Size   - Vector with number of masses in x, y and z direction
//      Transf      - Transform applied to the mass positions
//      Diagonal   - controling which diagonal connections are generated in the grid.
//
// =======================================================================================
#macro MechSim_Generate_Grid_Std_VE(Velocity, Radius, Density, Stiffness, VE_Elements, VE_Accuracy, Faces, Cube_Scale, Grid_Size, Transf, Diagonal)

	#local __MSIM_fn_Density=function(x, y, z) {Density}
	#local __MSIM_fn_Stiffness=function(x, y, z) {Stiffness}
	#local __MSIM_fn_Damping=function(x, y, z) {0}
	#local __MSIM_fn_Fixed=function(x, y, z) {-1}
	#local __MSIM_fn_Attach=function(x, y, z) {-1}
	#local __MSIM_fn_Force=function(x, y, z) {-1}

	#local Connect_Arr=array[max(1, Diagonal)]

	#local Cnt=0;
	#while (Cnt<max(1, Diagonal))
		#local Connect_Arr[Cnt]=1;
		#local Cnt=Cnt+1;
	#end

	#if (Diagonal=0)
		#local Connect_Arr[0]=0;
	#end

	MechSim_Generate_Grid_X(
		Velocity, Radius, __MSIM_fn_Density, 
		__MSIM_fn_Stiffness, __MSIM_fn_Damping, VE_Elements, VE_Accuracy, 
		Faces, Cube_Scale, Grid_Size,
		Transf, __MSIM_fn_Fixed, __MSIM_fn_Attach, __MSIM_fn_Force, Connect_Arr
	)

#end

// =======================================================================================
//  MechSim_Generate_Box() macro
//
//  topology generation macro building a 3D grid of masses connected and with optional
//  faces on the outside.  Mass of the whole body given.
//
//  Parameters:
//      Velocity   - common velocity of all masses
//      Radius     - radius of the masses
//      Mass       - mass of the whole body
//      Stiffness  - stiffness of the connections
//      Damping    - damping of the connections
//      Faces      - Boolean value controlling whether faces are generated for the
//                   surface.
//      Cube_Scale - Grid distance vector, defining the size of an elemetary
//                   cell in the grid.
//      Grid_Size  - Vector with number of masses in x, y and z direction
//      Transf     - Transform applied to the mass positions
//      Diagonal   - controling which diagonal connections are generated in the grid.
//
// =======================================================================================
#macro MechSim_Generate_Box(Velocity, Radius, Mass, Stiffness, Damping, Faces, Cube_Scale, Grid_Size, Transf, Diagonal)

	#local Density=(Mass/(Grid_Size.x*Grid_Size.y*Grid_Size.z))/((4/3)*pi*pow(Radius,3));

	#local __MSIM_fn_Density=function(x, y, z) {Density}
	#local __MSIM_fn_Stiffness=function(x, y, z) {Stiffness}
	#local __MSIM_fn_Damping=function(x, y, z) {Damping}
	#local __MSIM_fn_Fixed=function(x, y, z) {-1}
	#local __MSIM_fn_Attach=function(x, y, z) {-1}
	#local __MSIM_fn_Force=function(x, y, z) {-1}

	#local VE_Elements=array[1]
	#local VE_Accuracy=0;

	#local Connect_Arr=array[max(1, Diagonal)]

	#local Cnt=0;
	#while (Cnt<max(1, Diagonal))
		#local Connect_Arr[Cnt]=1;
		#local Cnt=Cnt+1;
	#end

	#if (Diagonal=0)
		#local Connect_Arr[0]=0;
	#end

	MechSim_Generate_Grid_X(
		Velocity, Radius, __MSIM_fn_Density, 
		__MSIM_fn_Stiffness, __MSIM_fn_Damping, VE_Elements, VE_Accuracy, 
		Faces, Cube_Scale, Grid_Size,
		Transf, __MSIM_fn_Fixed, __MSIM_fn_Attach, __MSIM_fn_Force, Connect_Arr
	)

#end

// =======================================================================================
//  MechSim_Generate_Box_VE() macro
//
//  variant of MechSim_Generate_Box() generating viscoelastic connections
//
//  Parameters:
//      Velocity   - common velocity of all masses
//      Radius     - radius of the masses
//      Mass       - mass of the whole body
//      Stiffness  - stiffness of the connections
//      VE_Elements - array with the parameters for viscoelastic connections
//      VE_Accuracy - accuracy value for viscoelastic connection
//      Faces      - Boolean value controlling whether faces are generated for the
//                   surface.
//      Cube_Scale - Grid distance vector, defining the size of an elemetary
//                   cell in the grid.
//      Grid_Size  - Vector with number of masses in x, y and z direction
//      Transf     - Transform applied to the mass positions
//      Diagonal   - controling which diagonal connections are generated in the grid.
//
// =======================================================================================
#macro MechSim_Generate_Box_VE(Velocity, Radius, Mass, Stiffness, VE_Elements, VE_Accuracy, Faces, Cube_Scale, Grid_Size, Transf, Diagonal)

	#local Density=(Mass/(Grid_Size.x*Grid_Size.y*Grid_Size.z))/((4/3)*pi*pow(Radius,3));

	#local __MSIM_fn_Density=function(x, y, z) {Density}
	#local __MSIM_fn_Stiffness=function(x, y, z) {Stiffness}
	#local __MSIM_fn_Damping=function(x, y, z) {0}
	#local __MSIM_fn_Fixed=function(x, y, z) {-1}
	#local __MSIM_fn_Attach=function(x, y, z) {-1}
	#local __MSIM_fn_Force=function(x, y, z) {-1}

	#local Connect_Arr=array[max(1, Diagonal)]

	#local Cnt=0;
	#while (Cnt<max(1, Diagonal))
		#local Connect_Arr[Cnt]=1;
		#local Cnt=Cnt+1;
	#end

	#if (Diagonal=0)
		#local Connect_Arr[0]=0;
	#end

	MechSim_Generate_Grid_X(
		Velocity, Radius, __MSIM_fn_Density, 
		__MSIM_fn_Stiffness, __MSIM_fn_Damping, VE_Elements, VE_Accuracy, 
		Faces, Cube_Scale, Grid_Size,
		Transf, __MSIM_fn_Fixed, __MSIM_fn_Attach, __MSIM_fn_Force, Connect_Arr
	)

#end

// =======================================================================================
//  MechSim_Generate_Block() macro
//
//  topology generation macro building a 3D grid of masses connected and with optional
//  faces on the outside.  Mass of the whole body given. Instead of
//  a Cube_Scale parameter two corner points are given.
//
//  Parameters:
//      Velocity   - common velocity of all masses
//      Radius     - radius of the masses
//      Mass       - mass of the whole body
//      Stiffness  - stiffness of the connections
//      Damping    - damping of the connections
//      Faces      - Boolean value controlling whether faces are generated for the
//                   surface.
//      Start, End - Corner coordinates of the grid to generate
//      Grid_Size  - Vector with number of masses in x, y and z direction
//      Transf     - Transform applied to the mass positions
//      Diagonal   - controling which diagonal connections are generated in the grid.
//
// =======================================================================================
#macro MechSim_Generate_Block(Velocity, Radius, Mass, Stiffness, Damping, Faces, Start, End, Grid_Size, Transf, Diagonal)

	#local Density=(Mass/(Grid_Size.x*Grid_Size.y*Grid_Size.z))/((4/3)*pi*pow(Radius,3));

	#local __MSIM_fn_Density=function(x, y, z) {Density}
	#local __MSIM_fn_Stiffness=function(x, y, z) {Stiffness}
	#local __MSIM_fn_Damping=function(x, y, z) {Damping}
	#local __MSIM_fn_Fixed=function(x, y, z) {-1}
	#local __MSIM_fn_Attach=function(x, y, z) {-1}
	#local __MSIM_fn_Force=function(x, y, z) {-1}

	#local VE_Elements=array[1]
	#local VE_Accuracy=0;

	#local Connect_Arr=array[max(1, Diagonal)]

	#local Cnt=0;
	#while (Cnt<max(1, Diagonal))
		#local Connect_Arr[Cnt]=1;
		#local Cnt=Cnt+1;
	#end

	#if (Diagonal=0)
		#local Connect_Arr[0]=0;
	#end

  #local Cube_Scale=<1/(Grid_Size.x-1),1/(Grid_Size.y-1),1/(Grid_Size.z-1)>;
	#local Pnt1=Start+<0,0,0>;
	#local Pnt2=End+<0,0,0>;

	#local Transf2=
		transform {
			scale (Pnt2-Pnt1)
			translate Pnt1
			transform { Transf }
		}

	MechSim_Generate_Grid_X(
		Velocity, Radius, __MSIM_fn_Density, 
		__MSIM_fn_Stiffness, __MSIM_fn_Damping, VE_Elements, VE_Accuracy, 
		Faces, Cube_Scale, Grid_Size,
		Transf2, __MSIM_fn_Fixed, __MSIM_fn_Attach, __MSIM_fn_Force, Connect_Arr
	)

#end

// =======================================================================================
//  MechSim_Generate_Block_VE() macro
//
//  variant of MechSim_Generate_Block() generating viscoelastic connections
//
//  Parameters:
//      Velocity   - common velocity of all masses
//      Radius     - radius of the masses
//      Mass       - mass of the whole body
//      Stiffness  - stiffness of the connections
//      VE_Elements - array with the parameters for viscoelastic connections
//      VE_Accuracy - accuracy value for viscoelastic connection
//      Faces      - Boolean value controlling whether faces are generated for the
//                   surface.
//      Start, End - Corner coordinates of the grid to generate
//      Grid_Size  - Vector with number of masses in x, y and z direction
//      Transf     - Transform applied to the mass positions
//      Diagonal   - controling which diagonal connections are generated in the grid.
//
// =======================================================================================
#macro MechSim_Generate_Block_VE(Velocity, Radius, Mass, Stiffness, VE_Elements, VE_Accuracy, Faces, Start, End, Grid_Size, Transf, Diagonal)

	#local Density=(Mass/(Grid_Size.x*Grid_Size.y*Grid_Size.z))/((4/3)*pi*pow(Radius,3));

	#local __MSIM_fn_Density=function(x, y, z) {Density}
	#local __MSIM_fn_Stiffness=function(x, y, z) {Stiffness}
	#local __MSIM_fn_Damping=function(x, y, z) {0}
	#local __MSIM_fn_Fixed=function(x, y, z) {-1}
	#local __MSIM_fn_Attach=function(x, y, z) {-1}
	#local __MSIM_fn_Force=function(x, y, z) {-1}

	#local Connect_Arr=array[max(1, Diagonal)]

	#local Cnt=0;
	#while (Cnt<max(1, Diagonal))
		#local Connect_Arr[Cnt]=1;
		#local Cnt=Cnt+1;
	#end

	#if (Diagonal=0)
		#local Connect_Arr[0]=0;
	#end

  #local Cube_Scale=<1/(Grid_Size.x-1),1/(Grid_Size.y-1),1/(Grid_Size.z-1)>;
	#local Pnt1=Start+<0,0,0>;
	#local Pnt2=End+<0,0,0>;

	#local Transf2=
		transform {
			scale (Pnt2-Pnt1)
			translate Pnt1
			transform { Transf }
		}

	MechSim_Generate_Grid_X(
		Velocity, Radius, __MSIM_fn_Density, 
		__MSIM_fn_Stiffness, __MSIM_fn_Damping, VE_Elements, VE_Accuracy, 
		Faces, Cube_Scale, Grid_Size,
		Transf2, __MSIM_fn_Fixed, __MSIM_fn_Attach, __MSIM_fn_Force, Connect_Arr
	)

#end

// #######################################################################################
//   Patch topology generation macros
// #######################################################################################

// =======================================================================================
//  MechSim_Generate_Patch_X() macro
//
//  basis macro for generating 2D grid (patch) topologies.
//  Do not use this but the wrapper macros below.
//
//  Parameters:
//      Velocity    - common velocity of all masses
//      Radius      - radius of the masses
//      Density     - density of the masses
//      Stiffness   - stiffness of the connections
//      Damping     - damping of the connections
//      VE_Elements - array with the parameters for viscoelastic connections
//      VE_Accuracy - accuracy value for viscoelastic connections -
//                    <= 0 means to create normal connections
//      Faces       - Boolean value controlling whether faces are generated for the
//                    surface.
//      Rect_Scale  - 2D Grid distance vector, defining the size of an elemetary
//                    rectangle in the grid.
//      Grid_Size   - 2D Vector with number of masses in x and y direction
//      Transf      - Transform applied to the mass positions
//      fn_Fixed    - user defined function controlling which masses are fixed.
//									  x and y are evaluated in [0..1] range. For function values > 0 the masses are fixed.
//      fn_Attach   - user defined function controlling which masses are fixed.
//                    x and y are evaluated in [0..1] range. The function value determines the attachment index.
//      fn_Force     - user defined function controlling custom forces.
//                    x and y are evaluated in [0..1] range. The function value determines the custom force index.
//      Connect_Arr - Array containing weights for connection stiffness and damping
//
// =======================================================================================
#macro MechSim_Generate_Patch_X(Velocity, Radius, Density, Stiffness, Damping, VE_Elements, VE_Accuracy, Faces, Rect_Scale, Grid_Size, Transf, fn_Fixed, fn_Attach, fn_Force, Connect_Arr)

	#debug "Generating Patch..."

	#local Vel=Velocity+<0,0,0>;
	#local CubeScale=Rect_Scale+<0,0,0>;
	#local GridSize=Grid_Size+<0,0,0>;

	#local EPS=0.001*CubeScale.x;

	#local StIdx=mechsim:mass_count;
	#local Count=(GridSize.x*GridSize.y);
	#local Con_Cnt=dimension_size(Connect_Arr, 1);

	#local Cnt=0;

	#while (Cnt<Count)

		#local Coord=<mod(Cnt, GridSize.x),
		              div(Cnt, GridSize.x)>;


		#local Coord2=<Coord.x*CubeScale.x,
		               Coord.y*CubeScale.y, 0>;


		#local CoordF=<Coord.x/(GridSize.x-1),
		               Coord.y/(GridSize.y-1)>;

		mass {
			vtransform(Coord2, Transf), Vel, Radius density Density

			#if ( fn_Fixed(CoordF.x, CoordF.y, 0)>0 )
				fixed on
			#else
				#local Attach=fn_Attach(CoordF.x, CoordF.y, 0);
				#if ( Attach>-0.1 )
					attach Attach
				#end
				#local Force=fn_Force(CoordF.x, CoordF.y, 0);
				#if ( Force>-0.1 )
					force Force
				#end
			#end
		}

		#local Cnt=Cnt+1;
	#end

	#if (Faces)

		#local Cnt=0;

		#while (Cnt<Count)

			#local Coord=<mod(Cnt, GridSize.x),
			              div(Cnt, GridSize.x)>;

			#local UpB=GridSize-1-EPS;

			#if ((Coord.x<UpB.x)&(Coord.y<UpB.y))

				face { StIdx+Cnt, StIdx+Cnt+1, StIdx+Cnt+GridSize.x+1 }
				face { StIdx+Cnt, StIdx+Cnt+GridSize.x, StIdx+Cnt+GridSize.x+1 }

			#end

			#local Cnt=Cnt+1;

		#end
	#end


	#if (Con_Cnt>0)

		#if (VE_Accuracy>0)
			#local VE_Elem_Cnt=dimension_size(VE_Elements, 1);
		#else
			#local VE_Elem_Cnt=0;
		#end

		#local Cnt=0;

		#while (Cnt<Count)

			#local Coord=<mod(Cnt, GridSize.x),
			              div(Cnt, GridSize.x)>;

			#local UpB=GridSize-1-EPS;

			#if (Coord.x<UpB.x)

				#if (VE_Elem_Cnt=0)
					connection {
						StIdx+Cnt, StIdx+Cnt+1
						stiffness Stiffness*Connect_Arr[0]
						damping Damping*Connect_Arr[0]
						//length CubeScale.x
					}
				#else
					viscoelastic {
						StIdx+Cnt, StIdx+Cnt+1 stiffness Stiffness*Connect_Arr[0]
						accuracy VE_Accuracy
						//length CubeScale.x

						#local ECnt=0;

						#while (ECnt<VE_Elem_Cnt)
							element { VE_Elements[ECnt][0]*Connect_Arr[0], VE_Elements[ECnt][1]*Connect_Arr[0] }
							#local ECnt=ECnt+1;
						#end
					}
				#end

			#end
			#if (Coord.y<UpB.y)

				#if (VE_Elem_Cnt=0)
					connection {
						StIdx+Cnt, StIdx+Cnt+GridSize.x
						stiffness Stiffness*Connect_Arr[0]
						damping Damping*Connect_Arr[0]
						//length CubeScale.y
					}
				#else
					viscoelastic {
						StIdx+Cnt, StIdx+Cnt+GridSize.x stiffness Stiffness*Connect_Arr[0]
						accuracy VE_Accuracy
						//length CubeScale.y

						#local ECnt=0;

						#while (ECnt<VE_Elem_Cnt)
							element { VE_Elements[ECnt][0]*Connect_Arr[0], VE_Elements[ECnt][1]*Connect_Arr[0] }
							#local ECnt=ECnt+1;
						#end
					}
				#end

			#end

			#if (Con_Cnt>1)
				#if ((Coord.x<UpB.x)&(Coord.y<UpB.y))

					#if (VE_Elem_Cnt=0)
						connection {
							StIdx+Cnt+GridSize.x, StIdx+Cnt+1
							stiffness Stiffness*Connect_Arr[1]
							damping Damping*Connect_Arr[1]
							//length sqrt(CubeScale.x*CubeScale.x + CubeScale.y*CubeScale.y)
						}
						connection {
							StIdx+Cnt, StIdx+Cnt+GridSize.x+1
							stiffness Stiffness*Connect_Arr[1]
							damping Damping*Connect_Arr[1]
							//length sqrt(CubeScale.x*CubeScale.x + CubeScale.y*CubeScale.y)
						}
					#else
						viscoelastic {
							StIdx+Cnt+GridSize.x, StIdx+Cnt+1 stiffness Stiffness*Connect_Arr[1]
							accuracy VE_Accuracy
							//length sqrt(CubeScale.x*CubeScale.x + CubeScale.y*CubeScale.y)

							#local ECnt=0;

							#while (ECnt<VE_Elem_Cnt)
								element { VE_Elements[ECnt][0]*Connect_Arr[1], VE_Elements[ECnt][1]*Connect_Arr[1] }
								#local ECnt=ECnt+1;
							#end
						}
						viscoelastic {
							StIdx+Cnt, StIdx+Cnt+GridSize.x+1 stiffness Stiffness*Connect_Arr[1]
							accuracy VE_Accuracy
							//length sqrt(CubeScale.x*CubeScale.x + CubeScale.y*CubeScale.y)

							#local ECnt=0;

							#while (ECnt<VE_Elem_Cnt)
								element { VE_Elements[ECnt][0]*Connect_Arr[1], VE_Elements[ECnt][1]*Connect_Arr[1] }
								#local ECnt=ECnt+1;
							#end
						}
					#end

				#end

				#if (Con_Cnt>2)

					#local UpB2=GridSize-2-EPS;

					#if (Coord.x<UpB2.x)
						#if (VE_Elem_Cnt=0)
							connection {
								StIdx+Cnt, StIdx+Cnt+2
								stiffness Stiffness*Connect_Arr[2]
								damping Damping*Connect_Arr[2]
								//length 2*CubeScale.x
							}
						#else
							viscoelastic {
								StIdx+Cnt, StIdx+Cnt+2 stiffness Stiffness*Connect_Arr[2]
								accuracy VE_Accuracy
								//length 2*CubeScale.x

								#local ECnt=0;

								#while (ECnt<VE_Elem_Cnt)
									element { VE_Elements[ECnt][0]*Connect_Arr[2], VE_Elements[ECnt][1]*Connect_Arr[2] }
									#local ECnt=ECnt+1;
								#end
							}
						#end
					#end
					#if (Coord.y<UpB2.y)
						#if (VE_Elem_Cnt=0)
							connection {
								StIdx+Cnt, StIdx+Cnt+GridSize.x*2
								stiffness Stiffness*Connect_Arr[2]
								damping Damping*Connect_Arr[2]
								//length 2*CubeScale.y
							}
						#else
							viscoelastic {
								StIdx+Cnt, StIdx+Cnt+GridSize.x*2 stiffness Stiffness*Connect_Arr[2]
								accuracy VE_Accuracy
								//length 2*CubeScale.y

								#local ECnt=0;

								#while (ECnt<VE_Elem_Cnt)
									element { VE_Elements[ECnt][0]*Connect_Arr[2], VE_Elements[ECnt][1]*Connect_Arr[2] }
									#local ECnt=ECnt+1;
								#end
							}
						#end
					#end

					#if (Con_Cnt>3)
						#if ((Coord.x<UpB2.x)&(Coord.y<UpB.y))
							#if (VE_Elem_Cnt=0)
								connection {
									StIdx+Cnt+GridSize.x, StIdx+Cnt+2
									stiffness Stiffness*Connect_Arr[3]
									damping Damping*Connect_Arr[3]
									//length sqrt(CubeScale.x*CubeScale.x*4 + CubeScale.y*CubeScale.y)
								}
								connection {
									StIdx+Cnt, StIdx+Cnt+GridSize.x+2
									stiffness Stiffness*Connect_Arr[3]
									damping Damping*Connect_Arr[3]
									//length sqrt(CubeScale.x*CubeScale.x*4 + CubeScale.y*CubeScale.y)
								}
							#else
								viscoelastic {
									StIdx+Cnt+GridSize.x, StIdx+Cnt+2 stiffness Stiffness*Connect_Arr[3]
									accuracy VE_Accuracy
									//length sqrt(CubeScale.x*CubeScale.x*4 + CubeScale.y*CubeScale.y)

									#local ECnt=0;

									#while (ECnt<VE_Elem_Cnt)
										element { VE_Elements[ECnt][0]*Connect_Arr[3], VE_Elements[ECnt][1]*Connect_Arr[3] }
										#local ECnt=ECnt+1;
									#end
								}
								viscoelastic {
									StIdx+Cnt, StIdx+Cnt+GridSize.x+2 stiffness Stiffness*Connect_Arr[3]
									accuracy VE_Accuracy
									//length sqrt(CubeScale.x*CubeScale.x*4 + CubeScale.y*CubeScale.y)

									#local ECnt=0;

									#while (ECnt<VE_Elem_Cnt)
										element { VE_Elements[ECnt][0]*Connect_Arr[3], VE_Elements[ECnt][1]*Connect_Arr[3] }
										#local ECnt=ECnt+1;
									#end
								}
							#end
						#end

						#if ((Coord.x<UpB.x)&(Coord.y<UpB2.y))
							#if (VE_Elem_Cnt=0)
								connection {
									StIdx+Cnt+GridSize.x*2, StIdx+Cnt+1
									stiffness Stiffness*Connect_Arr[3]
									damping Damping*Connect_Arr[3]
									//length sqrt(CubeScale.x*CubeScale.x + CubeScale.y*CubeScale.y*4)
								}
								connection {
									StIdx+Cnt, StIdx+Cnt+GridSize.x*2+1
									stiffness Stiffness*Connect_Arr[3]
									damping Damping*Connect_Arr[3]
									//length sqrt(CubeScale.x*CubeScale.x + CubeScale.y*CubeScale.y*4)
								}
							#else
								viscoelastic {
									StIdx+Cnt+GridSize.x*2, StIdx+Cnt+1 stiffness Stiffness*Connect_Arr[3]
									accuracy VE_Accuracy
									//length sqrt(CubeScale.x*CubeScale.x + CubeScale.y*CubeScale.y*4)

									#local ECnt=0;

									#while (ECnt<VE_Elem_Cnt)
										element { VE_Elements[ECnt][0]*Connect_Arr[3], VE_Elements[ECnt][1]*Connect_Arr[3] }
										#local ECnt=ECnt+1;
									#end
								}
								viscoelastic {
									StIdx+Cnt, StIdx+Cnt+GridSize.x*2+1 stiffness Stiffness*Connect_Arr[3]
									accuracy VE_Accuracy
									//length sqrt(CubeScale.x*CubeScale.x + CubeScale.y*CubeScale.y*4)

									#local ECnt=0;

									#while (ECnt<VE_Elem_Cnt)
										element { VE_Elements[ECnt][0]*Connect_Arr[3], VE_Elements[ECnt][1]*Connect_Arr[3] }
										#local ECnt=ECnt+1;
									#end
								}
							#end
						#end

						#if (Con_Cnt>4)
							#if ((Coord.x<UpB2.x)&(Coord.y<UpB2.y))
								#if (VE_Elem_Cnt=0)
									connection {
										StIdx+Cnt+GridSize.x*2, StIdx+Cnt+2
										stiffness Stiffness*Connect_Arr[4]
										damping Damping*Connect_Arr[4]
										//length 2*sqrt(CubeScale.x*CubeScale.x + CubeScale.y*CubeScale.y)
									}
									connection {
										StIdx+Cnt, StIdx+Cnt+GridSize.x*2+2
										stiffness Stiffness*Connect_Arr[4]
										damping Damping*Connect_Arr[4]
										//length 2*sqrt(CubeScale.x*CubeScale.x + CubeScale.y*CubeScale.y)
									}
								#else
									viscoelastic {
										StIdx+Cnt+GridSize.x*2, StIdx+Cnt+2 stiffness Stiffness*Connect_Arr[4]
										accuracy VE_Accuracy
										//length 2*sqrt(CubeScale.x*CubeScale.x + CubeScale.y*CubeScale.y)

										#local ECnt=0;

										#while (ECnt<VE_Elem_Cnt)
											element { VE_Elements[ECnt][0]*Connect_Arr[4], VE_Elements[ECnt][1]*Connect_Arr[4] }
											#local ECnt=ECnt+1;
										#end
									}
									viscoelastic {
										StIdx+Cnt, StIdx+Cnt+GridSize.x*2+2 stiffness Stiffness*Connect_Arr[4]
										accuracy VE_Accuracy
										//length 2*sqrt(CubeScale.x*CubeScale.x + CubeScale.y*CubeScale.y)

										#local ECnt=0;

										#while (ECnt<VE_Elem_Cnt)
											element { VE_Elements[ECnt][0]*Connect_Arr[4], VE_Elements[ECnt][1]*Connect_Arr[4] }
											#local ECnt=ECnt+1;
										#end
									}
								#end
							#end

							#if (Con_Cnt>5)

								#local UpB3=GridSize-3-EPS;

								#if ((Coord.x<UpB3.x)&(Coord.y<UpB3.y))
									#if (VE_Elem_Cnt=0)
										connection {
											StIdx+Cnt, StIdx+Cnt+3
											stiffness Stiffness*Connect_Arr[5]
											damping Damping*Connect_Arr[5]
											//length 3*CubeScale.x
										}
										connection {
											StIdx+Cnt, StIdx+Cnt+GridSize.x*3
											stiffness Stiffness*Connect_Arr[5]
											damping Damping*Connect_Arr[5]
											//length 3*CubeScale.y
										}
									#else
										viscoelastic {
											StIdx+Cnt, StIdx+Cnt+3 stiffness Stiffness*Connect_Arr[5]
											accuracy VE_Accuracy
											//length 3*CubeScale.x

											#local ECnt=0;

											#while (ECnt<VE_Elem_Cnt)
												element { VE_Elements[ECnt][0]*Connect_Arr[5], VE_Elements[ECnt][1]*Connect_Arr[5] }
												#local ECnt=ECnt+1;
											#end
										}
										viscoelastic {
											StIdx+Cnt, StIdx+Cnt+GridSize.x*3 stiffness Stiffness*Connect_Arr[5]
											accuracy VE_Accuracy
											//length 3*CubeScale.y

											#local ECnt=0;

											#while (ECnt<VE_Elem_Cnt)
												element { VE_Elements[ECnt][0]*Connect_Arr[5], VE_Elements[ECnt][1]*Connect_Arr[5] }
												#local ECnt=ECnt+1;
											#end
										}
									#end
								#end
							#end /* Connect>5 */
						#end /* Connect>4 */
					#end /* Connect>3 */
				#end /* Connect>2 */
			#end /* Connect>1 */

			#local Cnt=Cnt+1;

		#end

	#end /* Connect>0 */

	#debug "Done\n"

#end

// =======================================================================================
//  MechSim_Generate_Patch() macro
//
//  topology generation macro building a rectangular patch of masses connected and with
//  optional faces.
//
//  Parameters:
//      Velocity    - common velocity of all masses
//      Radius      - radius of the masses
//      Density     - density of the masses
//      Stiffness   - stiffness of the connections
//      Damping     - damping of the connections
//      Faces       - Boolean value controlling whether faces are generated for the
//                    surface.
//      Rect_Scale  - 2D Grid distance vector, defining the size of an elemetary
//                    rectangle in the grid.
//      Grid_Size   - 2D Vector with number of masses in x and y direction
//      Transf      - Transform applied to the mass positions
//      fn_Fixed    - user defined function controlling which masses are fixed.
//									  x and y are evaluated in [0..1] range. For function values > 0 the masses are fixed.
//      fn_Attach   - user defined function controlling which masses are fixed.
//                    x and y are evaluated in [0..1] range. The function value determines the attachment index.
//      fn_Force     - user defined function controlling custom forces.
//                    x and y are evaluated in [0..1] range. The function value determines the custom force index.
//      Connect_Arr - Array containing weights for connection stiffness and damping
//
// =======================================================================================
#macro MechSim_Generate_Patch(Velocity, Radius, Density, Stiffness, Damping, Faces, Rect_Scale, Grid_Size, Transf, fn_Fixed, fn_Attach, fn_Force, Connect_Arr)

	#local VE_Elements=array[1]
	#local VE_Accuracy=0;

  MechSim_Generate_Patch_X(
		Velocity, Radius, Density, Stiffness, Damping, VE_Elements, VE_Accuracy, Faces,
		Rect_Scale, Grid_Size, Transf, fn_Fixed, fn_Attach, fn_Force, Connect_Arr
	)

#end

// =======================================================================================
//  MechSim_Generate_Patch_VE() macro
//
//  variant of MechSim_Generate_Patch() generating viscoelastic connections
//
//  Parameters:
//      Velocity    - common velocity of all masses
//      Radius      - radius of the masses
//      Density     - density of the masses
//      Stiffness   - stiffness of the connections
//      VE_Elements - array with the parameters for viscoelastic connections
//      VE_Accuracy - accuracy value for viscoelastic connection
//      Faces       - Boolean value controlling whether faces are generated for the
//                    surface.
//      Rect_Scale  - 2D Grid distance vector, defining the size of an elemetary
//                    rectangle in the grid.
//      Grid_Size   - 2D Vector with number of masses in x and y direction
//      Transf      - Transform applied to the mass positions
//      fn_Fixed    - user defined function controlling which masses are fixed.
//									  x and y are evaluated in [0..1] range. For function values > 0 the masses are fixed.
//      fn_Attach   - user defined function controlling which masses are fixed.
//                    x and y are evaluated in [0..1] range. The function value determines the attachment index.
//      fn_Force     - user defined function controlling custom forces.
//                    x and y are evaluated in [0..1] range. The function value determines the custom force index.
//      Connect_Arr - Array containing weights for connection stiffness and damping
//
// =======================================================================================
#macro MechSim_Generate_Patch_VE(Velocity, Radius, Density, Stiffness, VE_Elements, VE_Accuracy, Faces, Rect_Scale, Grid_Size, Transf, fn_Fixed, fn_Attach, fn_Force, Connect_Arr)

  MechSim_Generate_Patch_X(
		Velocity, Radius, Density, Stiffness, 0, VE_Elements, VE_Accuracy, Faces,
		Rect_Scale, Grid_Size, Transf, fn_Fixed, fn_Attach, fn_Force, Connect_Arr
	)

#end

// =======================================================================================
//  MechSim_Generate_Patch_Std() macro
//
//  topology generation macro building a rectangular patch of masses connected and with
//  optional faces. No nodes fixed and same stiffness and damping for all connections.
//
//  Parameters:
//      Velocity    - common velocity of all masses
//      Radius      - radius of the masses
//      Density     - density of the masses
//      Stiffness   - stiffness of the connections
//      Damping     - damping of the connections
//      Faces       - Boolean value controlling whether faces are generated for the
//                    surface.
//      Rect_Scale  - 2D Grid distance vector, defining the size of an elemetary
//                    rectangle in the grid.
//      Grid_Size   - 2D Vector with number of masses in x and y direction
//      Transf      - Transform applied to the mass positions
//      Connect     - Which connections to generate
//
// =======================================================================================
#macro MechSim_Generate_Patch_Std(Velocity, Radius, Density, Stiffness, Damping, Faces, Rect_Scale, Grid_Size, Transf, Connect)

	#local __MSIM_fn_Fixed=function(x, y, z) { -1 }
	#local __MSIM_fn_Attach=function(x, y, z) { -1 }
	#local __MSIM_fn_Force=function(x, y, z) { -1 }
	#local Connect_Arr=array[Connect]

	#local Cnt=0;
	#while (Cnt<Connect)
		#local Connect_Arr[Cnt]=1;
		#local Cnt=Cnt+1;
	#end

	MechSim_Generate_Patch(
		Velocity, Radius, Density, Stiffness, Damping, Faces, Rect_Scale, Grid_Size,
		Transf, __MSIM_fn_Fixed, __MSIM_fn_Attach, __MSIM_fn_Force, Connect_Arr
	)

#end

// #######################################################################################
//   Line topology generation macros
// #######################################################################################

// =======================================================================================
//  MechSim_Generate_Line() macro
//
//  topology generation macro building a straight line of masses connected.
//
//  Parameters:
//      Velocity    - common velocity of all masses
//      Radius      - radius of the masses
//      Density     - density of the masses
//      Stiffness   - stiffness of the connections
//      Damping     - damping of the connections
//      Spacing     - Distance between the masses
//      Count       - Number of masses
//      Direction   - Direction vector of the line
//      Transf      - Transform applied to the mass positions
//      fn_Fixed    - function controlling which nodes are fixed
//									  x is evaluated in [0..1] range. For function values > 0 the masses are fixed.
//      fn_Attach   - user defined function controlling which masses are fixed.
//                    x is evaluated in [0..1] range. The function value determines the attachment index.
//      fn_Force    - user defined function controlling which masses are fixed.
//                    x is evaluated in [0..1] range. The function value determines the attachment index.
//      Connect_Arr - Array containing weights for connection stiffness and damping
//
// =======================================================================================
#macro MechSim_Generate_Line(Velocity, Radius, Density, Stiffness, Damping, Spacing, Count, Direction, Transf, fn_Fixed, fn_Attach, fn_Force, Connect_Arr)

	#debug "Generating Line..."

	#local Vel=Velocity+<0,0,0>;
	#local Dir=vnormalize(Direction);

	#local StIdx=mechsim:mass_count;
	#local Con_Cnt=dimension_size(Connect_Arr, 1);

	#if (Con_Cnt>0)

		#local Cnt=0;

		#while (Cnt<Count)

			mass {
				vtransform(Dir*Cnt*Spacing, Transf), Velocity, Radius density Density

				#if ( fn_Fixed(Cnt/(Count-1), 0, 0)>0 )
					fixed on
				#else
					#local Attach=fn_Attach(Cnt/(Count-1), 0, 0);
					#if ( Attach>-0.1 )
						attach Attach
					#end
					#local Force=fn_Force(Cnt/(Count-1), 0, 0);
					#if ( Force>-0.1 )
						force Force
					#end
				#end
			}

			#local Cnt=Cnt+1;
		#end


		#if (Con_Cnt>0)

			#local Cnt=0;

			#while (Cnt<Count-1)

				#local BCnt=0;
				#while ((BCnt<Con_Cnt) & ((Cnt+BCnt)<Count-1))

					connection {
						StIdx+Cnt,
						StIdx+Cnt+BCnt+1
						stiffness Stiffness*Connect_Arr[BCnt]
						damping Damping*Connect_Arr[BCnt]
						length Spacing*(BCnt+1)
					}

					#local BCnt=BCnt+1;
				#end

				#local Cnt=Cnt+1;
			#end

		#end

	#end

	#debug "Done\n"

#end

// =======================================================================================
//  MechSim_Generate_Line_Std() macro
//
//  topology generation macro building a straight line of masses connected.
//  Only simple connections and not fixed
//
//  Parameters:
//      Velocity    - common velocity of all masses
//      Radius      - radius of the masses
//      Density     - density of the masses
//      Stiffness   - stiffness of the connections
//      Damping     - damping of the connections
//      Spacing     - Distance between the masses
//      Count       - Number of masses
//      Direction   - Direction vector of the line
//      Transf      - Transform applied to the mass positions
//
// =======================================================================================
#macro MechSim_Generate_Line_Std(Velocity, Radius, Density, Stiffness, Damping, Spacing, Count, Direction, Transf)

	#local __MSIM_fn_Fixed=function(x, y, z) { -1 }
	#local __MSIM_fn_Attach=function(x, y, z) { -1 }
	#local __MSIM_fn_Force=function(x, y, z) { -1 }
	#local Connect_Arr=array[1]
	#local Connect_Arr[0]=1;

	MechSim_Generate_Line(
		Velocity, Radius, Density, Stiffness, Damping, Spacing, Count, Direction, 
		Transf, __MSIM_fn_Fixed, __MSIM_fn_Attach, __MSIM_fn_Force, Connect_Arr)

#end

// #######################################################################################
//   Ball topology generation macros
// #######################################################################################

// --- Icosahedron data ---

#declare Icosahedron_Vtx = array[12]

#local ZPos=1-4/(5+sqrt(5));
#local Rad=sqrt(1-ZPos*ZPos);
#local Cnt=1;
#while (Cnt<6)
	#declare Icosahedron_Vtx[  Cnt]=<Rad*cos(Cnt*2*pi/5),Rad*sin(Cnt*2*pi/5),-ZPos>;
	#declare Icosahedron_Vtx[5+Cnt]=<Rad*cos((Cnt-7.5)*2*pi/5),Rad*sin((Cnt-7.5)*2*pi/5),ZPos>;
	#declare Cnt=Cnt+1;
#end
#declare Icosahedron_Vtx[0]=<0,0,-1>;
#declare Icosahedron_Vtx[11]=<0,0,1>;

#declare Icosahedron_Face = array[20]

#declare Icosahedron_Face[ 0]=< 0, 1, 2>;
#declare Icosahedron_Face[ 1]=< 0, 2, 3>;
#declare Icosahedron_Face[ 2]=< 0, 3, 4>;
#declare Icosahedron_Face[ 3]=< 0, 4, 5>;
#declare Icosahedron_Face[ 4]=< 0, 5, 1>;
#declare Icosahedron_Face[ 5]=< 1, 2, 9>;
#declare Icosahedron_Face[ 6]=< 2, 3,10>;
#declare Icosahedron_Face[ 7]=< 3, 4, 6>;
#declare Icosahedron_Face[ 8]=< 4, 5, 7>;
#declare Icosahedron_Face[ 9]=< 5, 1, 8>;
#declare Icosahedron_Face[10]=< 1, 8, 9>;
#declare Icosahedron_Face[11]=< 9,10, 2>;
#declare Icosahedron_Face[12]=<10, 6, 3>;
#declare Icosahedron_Face[13]=< 6, 7, 4>;
#declare Icosahedron_Face[14]=< 7, 8, 5>;
#declare Icosahedron_Face[15]=<11, 6, 7>;
#declare Icosahedron_Face[16]=<11, 7, 8>;
#declare Icosahedron_Face[17]=<11, 8, 9>;
#declare Icosahedron_Face[18]=<11, 9,10>;
#declare Icosahedron_Face[19]=<11,10, 6>;

// --- Builds a triangle mesh from Vertex and Face arrays ---

#macro MechSim_Ico_Build_Mesh(Arr_V, Arr_F)

	#local Cnt_F=dimension_size(Arr_F, 1);

	#local Cnt=0;
	#while (Cnt<Cnt_F)

		triangle { Arr_V[Arr_F[Cnt].x], Arr_V[Arr_F[Cnt].y], Arr_V[Arr_F[Cnt].z] }

		#local Cnt=Cnt+1;
	#end

#end

// --- Builds a mechsim topology from Vertex and Face arrays ---

#macro MechSim_Ico_Build_Grid(Cnt_E, Arr_V, Arr_F, Velocity, Radius, Density, Stiffness, Damping, Density2, Stiffness2, Damping2, Faces, BRadius, Transf)

	#local StIdx=mechsim:mass_count;
	#local Cnt_V=dimension_size(Arr_V, 1);
	#local Cnt_F=dimension_size(Arr_F, 1);

	#local Arr_E=array[Cnt_E]
	#local Is=array[3];

	#local FCnt=0;
	#local EnCnt=0;

	#while (FCnt<Cnt_F)

		#local Cnt=0;
		#local Is[0]=false;
		#local Is[1]=false;
		#local Is[2]=false;

		#while (Cnt<EnCnt)

				#if (((Arr_E[Cnt].x=Arr_F[FCnt].x)&(Arr_E[Cnt].y=Arr_F[FCnt].y))|
					   ((Arr_E[Cnt].y=Arr_F[FCnt].x)&(Arr_E[Cnt].x=Arr_F[FCnt].y)))
					#local Is[0]=true;
				#end
				#if (((Arr_E[Cnt].x=Arr_F[FCnt].y)&(Arr_E[Cnt].y=Arr_F[FCnt].z))|
					   ((Arr_E[Cnt].y=Arr_F[FCnt].y)&(Arr_E[Cnt].x=Arr_F[FCnt].z)))
					#local Is[1]=true;
				#end
				#if (((Arr_E[Cnt].x=Arr_F[FCnt].z)&(Arr_E[Cnt].y=Arr_F[FCnt].x))|
					   ((Arr_E[Cnt].y=Arr_F[FCnt].z)&(Arr_E[Cnt].x=Arr_F[FCnt].x)))
					#local Is[2]=true;
				#end

			#local Cnt=Cnt+1;
		#end

		#if (Is[0]=false)
			#local Arr_E[EnCnt]=<Arr_F[FCnt].x, Arr_F[FCnt].y>;
			#local EnCnt=EnCnt+1;
		#end
		#if (Is[1]=false)
			#local Arr_E[EnCnt]=<Arr_F[FCnt].y, Arr_F[FCnt].z>;
			#local EnCnt=EnCnt+1;
		#end
		#if (Is[2]=false)
			#local Arr_E[EnCnt]=<Arr_F[FCnt].z, Arr_F[FCnt].x>;
			#local EnCnt=EnCnt+1;
		#end

		#local FCnt=FCnt+1;
	#end

	// center mass
	#local Center_Pos=vtransform(<0,0,0>, Transf);
	mass {
		Center_Pos, Velocity, Radius density Density2
	}

	#local Cnt=0;
	#while (Cnt<Cnt_V)

		#local MPosition=vtransform(Arr_V[Cnt]*BRadius, Transf);

		mass {
			MPosition, Velocity, Radius density Density
		}

		connection {
			StIdx, StIdx+Cnt+1 stiffness Stiffness2 damping Damping2
			length vlength(MPosition-Center_Pos)
		}

		#local Cnt=Cnt+1;
	#end

	#local Cnt=0;
	#while (Cnt<EnCnt)

		#local MPosition1=vtransform(Arr_V[Arr_E[Cnt].x]*BRadius, Transf);
		#local MPosition2=vtransform(Arr_V[Arr_E[Cnt].y]*BRadius, Transf);

		connection {
			StIdx+Arr_E[Cnt].x+1, StIdx+Arr_E[Cnt].y+1 stiffness Stiffness damping Damping
			length vlength(MPosition1-MPosition2)
		}

		#local Cnt=Cnt+1;
	#end

	#if (Faces)
		#local Cnt=0;
		#while (Cnt<Cnt_F)

			face {
				StIdx+Arr_F[Cnt].x+1,
				StIdx+Arr_F[Cnt].y+1,
				StIdx+Arr_F[Cnt].z+1
			}

			#local Cnt=Cnt+1;
		#end
	#end

#end

//  Pnt6 indices:
//
//      0
//     / \
//    5---3
//   / \ / \
//  2---4---1

#macro MechSim_Subdivide_Ico_Rec(Depth, Cnt_V, Cnt_F, Cnt_E, Arr_V, Arr_F, Velocity, Radius, Density, Stiffness, Damping, Density2, Stiffness2, Damping2, Faces, BRadius, Transf)

	#if (Depth>0)

		#local Cnt_Vn=Cnt_V+Cnt_E;
		#local Cnt_Fn=4*Cnt_F;
		#local Cnt_En=2*Cnt_E + 3*Cnt_F;

		#local Arr_Vn=array[Cnt_Vn]
		#local Arr_Fn=array[Cnt_Fn]
		#local Pnt6=array[6]

		#local FCnt=0;
		#local FnCnt=0;
		#local VnCnt=0;

		#while (FCnt<Cnt_F)

			#local Cnt=0;
			#while (Cnt<6)
				#local Pnt6[Cnt]=-1;
				#local Cnt=Cnt+1;
			#end

			#local Mid1 = vnormalize(Arr_V[Arr_F[FCnt].x]+Arr_V[Arr_F[FCnt].y]);
			#local Mid2 = vnormalize(Arr_V[Arr_F[FCnt].y]+Arr_V[Arr_F[FCnt].z]);
			#local Mid3 = vnormalize(Arr_V[Arr_F[FCnt].z]+Arr_V[Arr_F[FCnt].x]);

			#local Cnt=0;
			#while (Cnt<VnCnt)

				#if (vlength(Arr_Vn[Cnt]-Arr_V[Arr_F[FCnt].x])<1e-6)
					#local Pnt6[0]=Cnt;
				#end
				#if (vlength(Arr_Vn[Cnt]-Arr_V[Arr_F[FCnt].y])<1e-6)
					#local Pnt6[1]=Cnt;
				#end
				#if (vlength(Arr_Vn[Cnt]-Arr_V[Arr_F[FCnt].z])<1e-6)
					#local Pnt6[2]=Cnt;
				#end
				#if (vlength(Arr_Vn[Cnt]-Mid1)<1e-6)
					#local Pnt6[3]=Cnt;
				#end
				#if (vlength(Arr_Vn[Cnt]-Mid2)<1e-6)
					#local Pnt6[4]=Cnt;
				#end
				#if (vlength(Arr_Vn[Cnt]-Mid3)<1e-6)
					#local Pnt6[5]=Cnt;
				#end

				#local Cnt=Cnt+1;
			#end

			#if (Pnt6[0]<0)
				#local Arr_Vn[VnCnt]=Arr_V[Arr_F[FCnt].x];
				#local Pnt6[0]=VnCnt;
				#local VnCnt=VnCnt+1;
			#end
			#if (Pnt6[1]<0)
				#local Arr_Vn[VnCnt]=Arr_V[Arr_F[FCnt].y];
				#local Pnt6[1]=VnCnt;
				#local VnCnt=VnCnt+1;
			#end
			#if (Pnt6[2]<0)
				#local Arr_Vn[VnCnt]=Arr_V[Arr_F[FCnt].z];
				#local Pnt6[2]=VnCnt;
				#local VnCnt=VnCnt+1;
			#end
			#if (Pnt6[3]<0)
				#local Arr_Vn[VnCnt]=Mid1;
				#local Pnt6[3]=VnCnt;
				#local VnCnt=VnCnt+1;
			#end
			#if (Pnt6[4]<0)
				#local Arr_Vn[VnCnt]=Mid2;
				#local Pnt6[4]=VnCnt;
				#local VnCnt=VnCnt+1;
			#end
			#if (Pnt6[5]<0)
				#local Arr_Vn[VnCnt]=Mid3;
				#local Pnt6[5]=VnCnt;
				#local VnCnt=VnCnt+1;
			#end

			#local Arr_Fn[FnCnt]=<Pnt6[0], Pnt6[3], Pnt6[5]>;
			#local FnCnt=FnCnt+1;
			#local Arr_Fn[FnCnt]=<Pnt6[1], Pnt6[4], Pnt6[3]>;
			#local FnCnt=FnCnt+1;
			#local Arr_Fn[FnCnt]=<Pnt6[2], Pnt6[5], Pnt6[4]>;
			#local FnCnt=FnCnt+1;
			#local Arr_Fn[FnCnt]=<Pnt6[3], Pnt6[4], Pnt6[5]>;
			#local FnCnt=FnCnt+1;

			#local FCnt=FCnt+1;
		#end

		#if (Depth>1)

			MechSim_Subdivide_Ico_Rec(Depth-1, Cnt_Vn, Cnt_Fn, Cnt_En, Arr_Vn, Arr_Fn, Velocity, Radius, Density, Stiffness, Damping, Density2, Stiffness2, Damping2, Faces, BRadius, Transf)

		#else

			MechSim_Ico_Build_Grid(Cnt_En, Arr_Vn, Arr_Fn, Velocity, Radius, Density, Stiffness, Damping, Density2, Stiffness2, Damping2, Faces, BRadius, Transf)

		#end

	#end

#end

#macro MechSim_Subdivide_Ico(Depth, Velocity, Radius, Density, Stiffness, Damping, Density2, Stiffness2, Damping2, Faces, Division, BRadius, Transf)

  #local Cnt_V=12;
  #local Cnt_F=20;
  #local Cnt_E=30;

  #local Arr_V=Icosahedron_Vtx;
  #local Arr_F=Icosahedron_Face;

  MechSim_Subdivide_Ico_Rec(Division, Cnt_V, Cnt_F, Cnt_E, Arr_V, Arr_F, Velocity, Radius, Density, Stiffness, Damping, Density2, Stiffness2, Damping2, Faces, BRadius, Transf)

#end

// =======================================================================================
//  MechSim_Generate_Sphere() macro
//
//  topology generation macro building a sphere.
//  Only simple connections and not fixed
//
//  Parameters:
//      Velocity    - common velocity of all masses
//      Radius      - radius of the masses
//      Density     - density of the surface masses
//      Stiffness   - stiffness of the surface connections
//      Damping     - damping of the surface connections
//      Density2    - density of the center mass
//      Stiffness2  - stiffness of the center connections
//      Damping2    - damping of the center connections
//      Division    - Icosahedron subdivision depth
//      BRadius     - Radius of the ball
//      Transf      - Transform applied to the mass positions
//
// =======================================================================================
#macro MechSim_Generate_Sphere(Velocity, Radius, Density, Stiffness, Damping, Density2, Stiffness2, Damping2, Faces, Division, BRadius, Transf)

	#debug "Generating Sphere...\n"

	#local Vel=Velocity+<0,0,0>;

	 MechSim_Subdivide_Ico(Division, Vel, Radius, Density, Stiffness, Damping, Density2, Stiffness2, Damping2, Faces, Division, BRadius, Transf)

	#debug "Done\n"

#end


#version MECHSIM_Inc_Temp;
#end
