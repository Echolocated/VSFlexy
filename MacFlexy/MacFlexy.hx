package;


import lime.system.CFFI;
import lime.system.JNI;


class MacFlexy {
	
	
	public static function sampleMethod (inputValue:Int):Int {
		
		#if android
		
		var resultJNI = macflexy_sample_method_jni(inputValue);
		var resultNative = macflexy_sample_method(inputValue);
		
		if (resultJNI != resultNative) {
			
			throw "Fuzzy math!";
			
		}
		
		return resultNative;
		
		#else
		
		return macflexy_sample_method(inputValue);
		
		#end
		
	}
	
	
	private static var macflexy_sample_method = CFFI.load ("macflexy", "macflexy_sample_method", 1);
	
	#if android
	private static var macflexy_sample_method_jni = JNI.createStaticMethod ("org.haxe.extension.MacFlexy", "sampleMethod", "(I)I");
	#end
	
	
}