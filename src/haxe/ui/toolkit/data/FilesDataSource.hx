package haxe.ui.toolkit.data;

#if !(flash || html5)
import sys.FileSystem;
#end

class FilesDataSource extends ArrayDataSource {
	
	public var dir(default, null):String;
	public var showParentDirectory(default, null):Bool = true;
	public var showHiddenFiles(default, null):Bool = false;
	public var showHiddenDirectories(default, null):Bool = false;
	
	public var fileFilter:EReg = null;// eg: ~/.(jpg|png|json|xml)$/i;

	
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
	
	override function _update(o:Dynamic):Bool {
		removeAll();
		return open();
	}
	
	override function _open():Bool {
		#if !(flash || html5)
		var currentIsRoot = isRoot(dir);
		if (currentIsRoot || isDir(dir)) {
			
			if (showParentDirectory) {
				if (currentIsRoot) {
					add({ icon:'assets/ui/icons/bullet_arrow_up_faded.png', text:'/', isParent:false, selectable:false});
				} else {
					add({ icon:'assets/ui/icons/bullet_arrow_up.png', text:'${dir.substring(dir.lastIndexOf("/") + 1)}', isParent:true});
				}
			}
			
			
			var files:Array<String> = FileSystem.readDirectory(dir);
			for (file in files) {
				if (isDir(dir + "/" + file)) { // add dirs first
					if (showHiddenDirectories || file.charAt(0) != '.') {
						var o = { text: file, isDir:true, icon:'assets/ui/icons/folder.png' };
						add(o);
					}
				}
			}
			
			for (file in files) {
				if (!isDir(dir + "/" + file)) {
					if (showHiddenFiles || file.charAt(0) != '.') {
						if (fileFilter == null || fileFilter.match(file)) {
							var o = { text: file, isFile:true, icon:getFileIcon(file) };
							add(o);
						}
					}
				}
			}
			
			return true;
		}
		return false;
		#end
		
		return true;
	}
	
	function getFileIcon(name:String) {
		var ext = name.substring(name.lastIndexOf('.') + 1).toLowerCase();
		
		return switch(ext) {
			case 'png', 'jpg', 'jpeg':
				'assets/ui/icons/picture.png';
				
			default:
				'assets/ui/icons/page_white.png';
		}
	}
	
	
	public function openParent():Bool {
		#if !(flash || html5)
		if (isDir(dir) && !isRoot(dir)) {
			dir = dir.substring(0, dir.lastIndexOf('/'));
			removeAll();
			_open();
			return true;
		}
		#end
		return false;
	}
	
	public function openSubdirectory(name:String):Bool {
		#if !(flash || html5)
		var path = '${dir}/${name}';
		if (isDir(path)) {
			dir = path;
			removeAll();
			_open();
			return true;
		}
		#end
		return false;
	}
	
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public override function createFromString(data:String = null, config:Dynamic = null):Void {
		if (data != null) {
			#if !(flash || html5)
			dir = fixDir(FileSystem.fullPath(data));
			#else
			dir = fixDir(data);
			#end
		}
	}
	
	public override function createFromResource(resourceId:String, config:Dynamic = null):Void {
		createFromString(resourceId, config);
	}
	
	private function isDir(dir:String):Bool { // neko throws an exception on isDirectory, so move to a safer function
		var isDir:Bool = false;
		
		#if !(flash || html5)
		try {
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
		var split = dir.split("/");
		isRoot = split.length == 1 || (split.length == 2 && split[1] == "");
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