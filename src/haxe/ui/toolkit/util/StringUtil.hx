package haxe.ui.toolkit.util;

class StringUtil {
	public static function capitalizeFirstLetter(s:String):String {
		s = s.substr(0, 1).toUpperCase() + s.substr(1, s.length);
		return s;
	}
	
	public static function capitalizeHyphens(s:String):String {
		var r:String = s;
		var n:Int = r.indexOf("-");
		while (n != -1) {
			var before:String = r.substr(0, n);
			var after:String = r.substr(n + 1, r.length);
			r = before + capitalizeFirstLetter(after);
			n = r.indexOf("-", n + 1);
		}
		return r;
	}
}