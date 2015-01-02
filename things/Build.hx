package ;
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
 * Basic build version incrementer.
 * @author MSGHero
 */
class Build {

	static var ver:String; // used during macro context
	
#if macro
	/**
	 * Build macro to increment the build counter found in assets/build.txt (creates the file if nonexistent).
	 * Remember to add a haxeflag for "--macro Build.build()"
	 */
	public static function build() {
		#if !display
		var buildPath = "./assets/build.txt";
		var i = FileSystem.exists(buildPath) ? Std.parseInt(File.getContent(buildPath)) + 1 : 1;
		ver = Std.string(i);
		File.saveContent(buildPath, Std.string(i));
		#end
	}
#end
	
	/**
	 * Adds a "version" public static inline variable to the @:build-ed class.
	 * @example
	 * 		@:build(Build.setBuildVersion())
	 * 		class Main extends Sprite {
	 * 	creates Main.version
	 * @return
	 */
	macro public static function setBuildVersion():Array<Field> {
		
		var fields = Context.getBuildFields();
		
		var nf = {
			name : "version",
			doc : "Number of compiles in.",
			meta : [],
			access : [APublic, AStatic, AInline],
			kind : FVar(macro : String, macro $v{ver}), // pretend like I know what I'm doing
			pos : Context.currentPos()
		};
		
		fields.push(nf);
		
		return fields;
	}

}