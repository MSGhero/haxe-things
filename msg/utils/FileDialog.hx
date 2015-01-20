package utils;
#if flash
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import openfl.events.Event;
#elseif sys
import sys.io.File;
import systools.Dialogs;
#end

/**
 * Helper for saving and loading with systools dialogs.
 * @author MSGHero
 */
class FileDialog{

	static var cb:Callback;
	
#if flash
	static var fr:FileReference; // needs to stay in scope to work
	static var frl:FileReferenceList;
	static var fileCount:Int;
	static var saveData:String; // to keep the data referenced when saving
#end
	
#if flash
	/**
	 * Brings up the dialog to load one or multiple files.
	 * @param	descriptions	File type descriptions.
	 * @param	extensions		File extensions to filter by.
	 * @param	callback		Callback object for onCancel, onSelect, and onComplete functions.
	 */
	public static function load(descriptions:Array<String>, extensions:Array<String>, ?callback:Callback):Void {
		
		cb = callback;
		
		frl = new FileReferenceList();
		frl.addEventListener(Event.CANCEL, onCancelLoad);
		frl.addEventListener(Event.SELECT, onSelectLoad);
		
		var ff = [];
		for (i in 0...descriptions.length) {
			ff.push(new FileFilter(descriptions[i], extensions[i]));
		}
		
		frl.browse(ff);
	}
	
	/**
	 * Brings up the dialog to save text data to a file.
	 * @param	data			String data to save.
	 * @param	defaultFileName	File name to show in the dialog by default. No effect in sys.
	 * @param	callback		Callback object for onCancel, onSelect, and onComplete functions.
	 * @param	descriptions	File type descriptions. No effect in flash.
	 * @param	extensions		File extensions to filter by. No effect in flash.
	 */
	public static function save(data:String, ?defaultFileName:String, ?callback:Callback, ?descriptions:Array<String>, ?extensions:Array<String>):Void {
		
		cb = callback;
		
		fr = new FileReference();
		fr.addEventListener(Event.CANCEL, onCancelSave);
		fr.addEventListener(Event.SELECT, onSelectSave);
		
		saveData = data;
		fr.save(data, defaultFileName);
	}
	
	static function onCancelLoad(e:Event):Void {
		
		frl.removeEventListener(Event.CANCEL, onCancelLoad);
		frl.removeEventListener(Event.SELECT, onSelectLoad);
		
		if (cb != null && cb.onCancel != null) cb.onCancel();
		
		cb = null;
		frl = null;
	}
	
	static function onCancelSave(e:Event):Void {
		
		fr.removeEventListener(Event.CANCEL, onCancelSave);
		fr.removeEventListener(Event.SELECT, onSelectSave);
		
		if (cb != null && cb.onCancel != null) cb.onCancel();
		
		saveData = null;
		cb = null;
		fr = null;
	}
	
	static function onSelectLoad(e:Event):Void {
		
		frl.removeEventListener(Event.CANCEL, onCancelLoad);
		frl.removeEventListener(Event.SELECT, onSelectLoad);
		fileCount = frl.fileList.length;
		
		if (cb != null && cb.onSelect != null) cb.onSelect();
		
		for (f in frl.fileList) {
			f.addEventListener(Event.COMPLETE, onCompleteLoad);
			f.load();
		}
	}
	
	static function onSelectSave(e:Event):Void {
		
		fr.removeEventListener(Event.CANCEL, onCancelSave);
		fr.removeEventListener(Event.SELECT, onSelectSave);
		
		if (cb != null && cb.onSelect != null) cb.onSelect();
		
		fr.addEventListener(Event.COMPLETE, onCompleteSave);
	}
	
	static function onCompleteLoad(e:Event):Void {
		
		var f:FileReference = cast e.currentTarget;
		f.removeEventListener(Event.COMPLETE, onCompleteLoad);
		
		if (cb != null && cb.onComplete != null) {
			
			var fd = {
				name : f.name,
				data : f.data.toString()
			}
			
			cb.onComplete(fd);
		}
		
		if (--fileCount == 0) {
			cb = null;
			frl = null;
		}
	}
	
	static function onCompleteSave(e:Event):Void {
		
		fr.removeEventListener(Event.COMPLETE, onCompleteSave);
		
		if (cb != null && cb.onComplete != null) {
			
			var fd = {
				name : fr.name,
				data : saveData
			}
			
			cb.onComplete(fd);
		}
		
		cb = null;
		saveData = null;
		fr = null;
	}
	
#elseif sys
	/**
	 * Brings up the dialog to load one or multiple files.
	 * @param	descriptions	File type descriptions.
	 * @param	extensions		File extensions to filter by.
	 * @param	callback		Callback object for onCancel, onSelect, and onComplete functions.
	 */
	public static function load(?descriptions:Array<String>, ?extensions:Array<String>, ?callback:Callback):Void {
		
		cb = callback;
		
		var ff:FILEFILTERS = descriptions != null ? {
			count : descriptions.length,
			descriptions : descriptions,
			extensions : extensions
		} : null;
		
		var paths = Dialogs.openFile("Open File(s)...", "", ff);
		
		if (paths.length > 0) {
			
			if (cb != null && cb.onSelect != null) cb.onSelect();
			
			if (cb != null && cb.onComplete != null) {
				
				var fd:FileDetails;
				for (path in paths) {
					
					fd = {
						name : path.substr(path.lastIndexOf("\\") + 1),
						data : File.getContent(path),
						path : path
					}
					
					cb.onComplete(fd);
				}
			}
		}
		
		else if (cb != null && cb.onCancel != null) {
			cb.onCancel();
		}
		
		cb = null;
	}
	
	/**
	 * Brings up the dialog to save text data to a file.
	 * @param	data			String data to save.
	 * @param	defaultFileName	File name to show in the dialog by default. No effect in sys.
	 * @param	callback		Callback object for onCancel, onSelect, and onComplete functions.
	 * @param	descriptions	File type descriptions. No effect in flash.
	 * @param	extensions		File extensions to filter by. No effect in flash.
	 */
	public static function save(data:String, ?defaultFileName:String, ?callback:Callback, ?descriptions:Array<String>, ?extensions:Array<String>):Void {
		
		cb = callback;
		
		var ff:FILEFILTERS = descriptions != null ? {
			count : descriptions.length,
			descriptions : descriptions,
			extensions : extensions
		} : null;
		
		var path = Dialogs.saveFile("Save File...", "", Sys.getCwd(), ff);
		
		if (path == null || path.length == 0) {
			if (cb != null && cb.onCancel != null) cb.onCancel();
		}
		
		else {
			
			if (cb != null && cb.onSelect != null) cb.onSelect();
			
			File.saveContent(path, data);
			
			if (cb != null && cb.onComplete != null) {
				
				var fd:FileDetails = {
					name : path.substr(path.lastIndexOf("\\") + 1),
					data : data,
					path : path
				}
				
				cb.onComplete(fd);
			}
		}
		
		cb = null;
	}	
#end
}

/**
 * Struct of a few details about the saved or loaded file.
 * name: file name
 * data: file's data in string form
 * path: path to the file. Not available in flash.
 */
typedef FileDetails = {
	name:String,
	data:String,
	?path:String // not on flash
}

/**
 * A struct of several callbacks for the dialog.
 * onComplete: when the file has fully saved or loaded.
 * onSelect: when the file has been chosen from the dialog box.
 * onCancel: when the dialog box was closed before chosing a file.
 */
typedef Callback = {
	?onComplete:FileDetails->Void,
	?onSelect:Void->Void,
	?onCancel:Void->Void
	// error
}