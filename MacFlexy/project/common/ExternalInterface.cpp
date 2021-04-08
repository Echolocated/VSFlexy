#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Utils.h"


using namespace macflexy;



static value macflexy_sample_method (value inputValue) {
	
	int returnValue = SampleMethod(val_int(inputValue));
	return alloc_int(returnValue);
	
}
DEFINE_PRIM (macflexy_sample_method, 1);



extern "C" void macflexy_main () {
	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (macflexy_main);



extern "C" int macflexy_register_prims () { return 0; }