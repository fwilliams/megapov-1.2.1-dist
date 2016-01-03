// Persistence of Vision Ray Tracer version 3.5 Include File
//
// This include file is part of MegaPOV

#ifdef(Tone_Mapping_Inc_Temp)
// do nothing
#else
#declare Tone_Mapping_Inc_Temp = version;

#ifdef(View_POV_Include_Stack)
#   debug "including tone_mapping.inc\n"
#end

#version unofficial megapov 1.2;

// =======================================================================================
//  Clip_Colors()
//
//  generates a user defined function for use in the MegaPOV
//  tone mapping patch that applies a hard clipping at 1.0
//
//  with antialiasing this results in POV-Ray 3.5 behaviour.
//
// =======================================================================================
	
#macro Clip_Colors()
	tone_mapping {
		function { min(1, x) }
	}
#end

// =======================================================================================
//  Film_Exposure()
//
//  generates a user defined function for use in the MegaPOV
//  tone mapping patch.  This function is the same as used in the
//  film exposure simulation patch
//
//  Parameters:
//      Exposure      - exponent for the exposure curve
//      Exposure_Gain - gain for the exposure curve
//
// =======================================================================================
	
#macro Film_Exposure(Exposure, Exposure_Gain)
	tone_mapping {
		function { Exposure_Gain - exp( -Exposure * x ) * Exposure_Gain }
	}
#end

// =======================================================================================
//  Film_Exposure_Invert()
//
//  like Film_Exposure() but also generates an inversion function.
//  this results in linear output like without tone mapping but applies
//  the antialiasing for the used exposure settings.
//
//  Parameters:
//      Exposure      - exponent for the exposure curve
//      Exposure_Gain - gain for the exposure curve
//
// =======================================================================================
	
#macro Film_Exposure_Invert(Exposure, Exposure_Gain)
	tone_mapping {
		function { Exposure_Gain - exp( -Exposure * x ) * Exposure_Gain }
		inverse function { - ln(1 -min(0.9999, x/Exposure_Gain)) / Exposure }
	}
#end

// =======================================================================================
//  Gamma_Correct()
//
//  generates a user defined function for use in the MegaPOV
//  tone mapping patch.  This function applies a gamma correction.
//
//  NOTE: it is not a good idea to use this as a replacement for
//  the internal gamma correction to do actual gamma correction.
//  It may however be useful for scenes that are designed for being 
//  rendered without gamma correction (like for example certain
//  older POV-Ray sample scenes).  
//
//  Parameters:
//      Gamma      - gamma correction factor
//
// =======================================================================================
	
#macro Gamma_Correct(Gamma)
	tone_mapping {
		function { pow ( x, Gamma ) }
	}
#end

// =======================================================================================
//  Brightness_Contrast()
//
//  generates a user defined function for use in the MegaPOV
//  tone mapping patch.  This function applies brightness and contrast
//  adjustments.  These are linear operations so they won't affect the
//  antialiasing quality.
//
//  Parameters:
//      Brightness  - brightness adjustment
//      Contrast    - contrast adjustment
//
// =======================================================================================
	
#macro Brightness_Contrast(Brightness, Contrast)
	tone_mapping {
		function { (x-0.5)*Contrast+0.5+Brightness }
	}
#end


#end//tone_mapping.inc

