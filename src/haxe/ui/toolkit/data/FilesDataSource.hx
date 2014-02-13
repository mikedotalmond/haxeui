package haxe.ui.toolkit.data;

#if !(flash || html5)
import sys.FileSystem;
#end

class FilesDataSource extends ArrayDataSource {
	private var _dir:String;
	
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function create(config:Xml = null):Void {
		//super.create(config);
		if (config == null) {
			return;
		}
		
		_id = config.get("id");
		
		var resource:String = config.get("resource");
		if (resource != null) {
			createFromString(resource);
		}
	}
	
	private override function _open():Bool {
		#if !(flash || html5)
		if (isDir(_dir)) {
			
			if (!isRoot(_dir)) {
				add({ text: '^', isParent:true});
			} else {
				
			}
			
			var files:Array<String> = FileSystem.readDirectory(_dir);
			
			for (file in files) {
				if (isDir(_dir + "/" + file)) { // add dirs first
					var o = { text: file, isDir:true };
					add(o);
				}
			}
			
			for (file in files) {
				if (!isDir(_dir + "/" + file)) {
					var o = { text: file, isFile:true };
					add(o);
				}
			}
		}
		#end
		return true;
	}
	
	
	public function openParent():Bool {
		#if !(flash || html5)
		if (isDir(_dir) && !isRoot(_dir)) {
			_dir = _dir.substring(0, _dir.lastIndexOf('/'));
			removeAll();
			_open();
			return true;
		}
		#end
		return false;
	}
	
	public function openSubdirectory(name:String):Bool {
		#if !(flash || html5)
		if (isDir(_dir)) {
			var path = '${_dir}/${name}';
			if (isDir(path)) {
				_dir = path;
				removeAll();
				_open();
				return true;
			}
		}
		#end
		return false;
	}
	
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public override function createFromString(data:String = null, config:Dynamic = null):Void {
		if (data != null) {
			_dir = fixDir(FileSystem.fullPath(data));
		}
	}
	
	public override function createFromResource(resourceId:String, config:Dynamic = null):Void {
		createFromString(resourceId, config);
	}
	
	private function isDir(dir:String):Bool { // neko throws an exception on isDirectory, so move to a safer function
		var isDir:Bool = false;
		
		#if !(flash || html5)
		try {
			if (isRoot(dir)) {
				dir += "/";
			}
			isDir = FileSystem.isDirectory(dir);
		} catch (ex:Dynamic) {
			isDir = false;
		}
		#end
		
		return isDir;
	}

	private function isRoot(dir:String):Bool {
		var isRoot:Bool = false;
		
		#if !(flash || html5)
		isRoot = dir.split("/").length == 1;
		#end
		
		return isRoot;
	}
	
	private function fixDir(dir:String):String {
		if (dir == null) {
			return "";
		}
		
		var fixedDir:String = dir;
		fixedDir = StringTools.replace(fixedDir, "\\", "/");
		
		if (fixedDir.lastIndexOf("/") == fixedDir.length-1 || fixedDir.lastIndexOf("\\") == fixedDir.length-1) {
			fixedDir = fixedDir.substr(0, fixedDir.length - 1);
		}
		
		return fixedDir;
	}
}