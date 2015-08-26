package msg.utils;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
#end

/**
 * Useful macros. A build version incrementer and a compile-time JSON parser.
 * @author MSGHero
 */
class Build {
	
#if macro
	static var ver:String; // used during macro context
	
	/**
	 * Build macro to increment a build counter located in assets/ (creates the file if nonexistent).
	 * Remember to add a haxeflag for "--macro msg.utils.Build.build()".
	 */
	public static function build() {
	#if !display
		var buildPath = FileSystem.fullPath('assets/build.txt'); // not sure if this works all the time
		var i = FileSystem.exists(buildPath) ? Std.parseInt(File.getContent(buildPath)) + 1 : 1;
		ver = Std.string(i);
		File.saveContent(buildPath, Std.string(i));
	#end
	}
#end
	
	/**
	 * Adds a "version" String to the @:build-ed class, taking its value from assets/build.txt (@see build()).
	 * @example
	 * 		@:build(Build.setBuildVersion())
	 * 		class Main extends Sprite {
	 * 	creates "version" String variable.
	 * @param	staticVar If the created var should be public static inline or just public.
	 * @return
	 */
	macro public static function setBuildVersion(staticVar:Bool = true):Array<Field> {
		
		var fields = Context.getBuildFields();
		
		var nf = {
			name : "version",
			doc : "Number of compiles in.",
			meta : [],
			access : staticVar ? [APublic, AStatic, AInline] : [APublic],
			kind : FVar(macro : String, macro $v{ver}), // pretend like I know what I'm doing
			pos : Context.currentPos()
		};
		
		fields.push(nf);
		
		return fields;
	}
	
	/**
	 * Parses all json files in a directory and subdirectories and puts them in a "json" StringMap variable.
	 * Files without a ".json" extension are ignored.
	 * Note: requires a Haxe version compiled after May 14, 2015 (after f520bf2, this is after the 3.2.0 release).
	 * @example
	 * 		@:build(Build.parseJSONFiles("assets/data/"))
	 * 		class Main extends Sprite {
	 * 	creates "json" StringMap<Dynamic> variable. The key is the relative filepath after "pathToFiles" WITHOUT the ".json", and the value is the parsed JSON.
	 * @param	pathToFiles	The path of the directory holding the json files.
	 * @param	staticVar If the created var should be public static inline or just public.
	 * @return
	 */
	macro public static function parseJSONFiles(pathToFiles:String, staticVar:Bool = true):Array<Field> {
		
		var fields = Context.getBuildFields();
		var a:Array<Expr> = [];
		
	#if !display
		if (pathToFiles.charAt(pathToFiles.length - 1) != "/") pathToFiles = pathToFiles + "/";
		var files = FileSystem.readDirectory(pathToFiles);
		
		while (files.length > 0) {
			
			var fileOrDir = files.pop();
			if (FileSystem.isDirectory(pathToFiles + fileOrDir)) {
				var newFiles = FileSystem.readDirectory(pathToFiles + fileOrDir);
				for (f in newFiles) files.push('$fileOrDir/$f');
			}
			
			else {
				if (fileOrDir.substr(fileOrDir.length - 5) != ".json") continue;
				var o = Context.parseInlineString(File.getContent(pathToFiles + fileOrDir), Context.makePosition({ min : 0, max : 0, file : pathToFiles + fileOrDir})); // shows the position within the json file on invalid json error
				a.push({ expr : EBinop(OpArrow, macro $v{fileOrDir.substr(0, -5)}, o), pos : Context.currentPos() }); // [key => val] map syntax in Expr form
			}
		}
	#end
		
		var nf:Field = {
			name : "json",
			doc : "A map of relative file paths to parsed JSON objects.",
			meta : [],
			access : staticVar ? [AStatic, APublic] : [APublic],
			kind : FVar(macro : haxe.ds.StringMap<Dynamic>, { expr : EArrayDecl(a), pos : Context.currentPos() } ),
			pos : Context.currentPos()
		};
		
		fields.push(nf);
		
		return fields;
	}

}