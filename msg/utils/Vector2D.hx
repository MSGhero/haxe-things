package msg.utils;

import openfl.Vector;

/**
 * A 2D vector backed by a 1D vector.
 * Better than Array2D when the length and number of columns never change.
 * Works out of the box for vectors of type Int, Float, Bool, and Dynamic.
 * 
 * To get a Vector2D typed to other classes, you'll have to create a new abstract class with Vector2D as the core class.
 * Then, you have to implement the new vector class, which looks like the inner classes here.
 * You can also have it type to Int/Float/Bool/etc by reimplementing the respective @:to converter.
 * 
 * @example
 * 	@:multitype(T)
 * 	@:forward
 * 	abstract MyVector<T>(Vector2D<T>) {
 * 		
 * 		public function new(length:Int, numCols:Int);
 * 		
 * 		// create a MyVector (Vector2D) of type MyClass
 * 		// MyClassV2D must be defined as Int/Float/Bool/etc are below
 *		@:to static function toMyClass<T:MyClass>(t:IV2D<T>, length:Int, numCols:Int):MyClassV2D {
 * 			return new MyClassV2D(length, numCols);
 * 		}
 * 		
 * 		// create a MyVector (Vector2D) of type Int
 *		@:to static function toInt<T:Int>(t:IV2D<T>, length:Int, numCols:Int):Vector2D<Int> {
 * 			return new Vector2D<Int>(length, numCols);
 * 		}
 * 	}
 * 
 * @author MSGHero
 */

@:multiType(T)
@:forward
abstract Vector2D<T>(IV2D<T>) {
	
	/**
	 * Creates a new Vector2D of the specified type.
	 * @param	length	The immutable length of the vector.
	 * @param	numCols	The immutable number of columns, from which the immutable number of rows is determined.
	 */
	public function new(length:Int, numCols:Int);
	
	@:to static inline function toBoolV2D<T:Bool>(t:IV2D<T>, length:Int, numCols:Int):BoolV2D {
		return new BoolV2D(length, numCols);
	}
	
	@:to static inline function toIntV2D<T:Int>(t:IV2D<T>, length:Int, numCols:Int):IntV2D {
		return new IntV2D(length, numCols);
	}
	
	@:to static inline function toFloatV2D<T:Float>(t:IV2D<T>, length:Int, numCols:Int):FloatV2D {
		return new FloatV2D(length, numCols);
	}
	
	@:to static inline function toStringV2D<T:String>(t:IV2D<T>, length:Int, numCols:Int):StringV2D {
		return new StringV2D(length, numCols);
	}
	
	@:to static inline function toObjV2D<Dynamic>(t:IV2D<Dynamic>, length:Int, numCols:Int):ObjV2D {
		return new ObjV2D(length, numCols);
	}
}

private class BoolV2D implements IV2D<Bool> {

	var _vec:Vector<Bool>;
	public var cols(default, null):Int;
	public var rows(default, null):Int;
	public var length(get, never):Int;
	inline function get_length():Int { return _vec.length; }
	
	public function new(length:Int, numCols:Int) {
		_vec = new Vector<Bool>(length, true);
		cols = numCols;
		rows = Math.ceil(length / cols);
	}
	
	public function iterator():Iterator<Bool> {
		return _vec.iterator();
	}
	
	public function fill1(t:Bool, len:Int):Void {
		
		for (i in 0...len) {
			_vec[i] = t;
		}
		
		for (i in len...length) {
			_vec[i] = false;
		}
	}
	
	public function fill2(t:Bool, numRows:Int, numCols:Int):Void {
		fill1(t, numRows * numCols);
	}
	
	public function fillAt1(t:Bool, start:Int, len:Int):Void {
		var i = 0;
		while (i++ < len) {
			_vec[start + i] = t;
		}
	}
	
	public function fillAt2(t:Bool, startRow:Int, startCol:Int, numRows:Int, numCols:Int):Void {
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				set2(t, startRow + rr, startCol + cc);
			}
		}
	}
	
	public function fillWith1(vec:Vector<Bool>, index:Int):Void {
		var i = 0;
		while (i < vec.length) set1(vec[i], index + i++);
	}
	
	public function fillWith2(vec:Vector2D<Bool>, startRow:Int, startCol:Int):Void {
		for (rr in 0...vec.rows) {
			for (cc in 0...vec.cols) {
				set2(vec.get2(rr, cc), startRow + rr, startCol + cc);
			}
		}
	}
	
	public function get1(index:Int):Bool {
		return _vec[index];
	}
	
	public function set1(t:Bool, index:Int):Bool {
		return _vec[index] = t;
	}
	
	public function get2(row:Int, col:Int):Bool {
		return _vec[row * cols + col];
	}
	
	public function set2(t:Bool, row:Int, col:Int):Bool {
		return _vec[row * cols + col] = t;
	}
	
	public function getRowOf(index:Int):Int {
		return Std.int(index / cols);
	}
	
	public function getColOf(index:Int):Int {
		return index % cols;
	}
	
	public function getIndexOf(row:Int, col:Int):Int {
		return row * cols + col;
	}
	
	public function slice1(startIndex:Int, len:Int):Vector2D<Bool> {
		var v = new Vector2D<Bool>(len, cols);
		var i = 0;
		while (i++ < len) v.set1(_vec[startIndex + i - 1], i - 1);
		return v;
	}
	
	public function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):Vector2D<Bool> {
		var v = new Vector2D<Bool>(numCols * numRows, numCols);
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				v.set2(get2(startRow + rr, startCol + cc), rr, cc);
			}
		}
		return v;
	}
	
	public function copy():IV2D<Bool> {
		var v = new BoolV2D(0, cols);
		v._vec = _vec.copy();
		v.rows = rows;
		return v;
	}
	
	public function clear():Void {
		fill1(false, length);
	}
	
	public function toString():String {
		
		var s = "";
		
		if (length > 0) {
			for (i in 0...rows) {
				s += "\n";
				for (j in 0...cols) {
					s += '${get2(i, j)},';
				}
			}
		}
		
		return s;
	}
}

private class IntV2D implements IV2D<Int> {

	var _vec:Vector<Int>;
	public var cols(default, null):Int;
	public var rows(default, null):Int;
	public var length(get, never):Int;
	inline function get_length():Int { return _vec.length; }
	
	public function new(length:Int, numCols:Int) {
		_vec = new Vector<Int>(length, true);
		cols = numCols;
		rows = Math.ceil(length / cols);
	}
	
	public function iterator():Iterator<Int> {
		return _vec.iterator();
	}
	
	public function fill1(t:Int, len:Int):Void {
		
		for (i in 0...len) {
			_vec[i] = t;
		}
		
		for (i in len...length) {
			_vec[i] = 0;
		}
	}
	
	public function fill2(t:Int, numRows:Int, numCols:Int):Void {
		fill1(t, numRows * numCols);
	}
	
	public function fillAt1(t:Int, start:Int, len:Int):Void {
		var i = 0;
		while (i++ < len) {
			_vec[start + i] = t;
		}
	}
	
	public function fillAt2(t:Int, startRow:Int, startCol:Int, numRows:Int, numCols:Int):Void {
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				set2(t, startRow + rr, startCol + cc);
			}
		}
	}
	
	public function fillWith1(vec:Vector<Int>, index:Int):Void {
		var i = 0;
		while (i < vec.length) set1(vec[i], index + i++);
	}
	
	public function fillWith2(vec:Vector2D<Int>, startRow:Int, startCol:Int):Void {
		for (rr in 0...vec.rows) {
			for (cc in 0...vec.cols) {
				set2(vec.get2(rr, cc), startRow + rr, startCol + cc);
			}
		}
	}
	
	public function get1(index:Int):Int {
		return _vec[index];
	}
	
	public function set1(t:Int, index:Int):Int {
		return _vec[index] = t;
	}
	
	public function get2(row:Int, col:Int):Int {
		return _vec[row * cols + col];
	}
	
	public function set2(t:Int, row:Int, col:Int):Int {
		return _vec[row * cols + col] = t;
	}
	
	public function getRowOf(index:Int):Int {
		return Std.int(index / cols);
	}
	
	public function getColOf(index:Int):Int {
		return index % cols;
	}
	
	public function getIndexOf(row:Int, col:Int):Int {
		return row * cols + col;
	}
	
	public function slice1(startIndex:Int, len:Int):Vector2D<Int> {
		var v = new Vector2D<Int>(len, cols);
		var i = 0;
		while (i++ < len) v.set1(_vec[startIndex + i - 1], i - 1);
		return v;
	}
	
	public function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):Vector2D<Int> {
		var v = new Vector2D<Int>(numCols * numRows, numCols);
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				v.set2(get2(startRow + rr, startCol + cc), rr, cc);
			}
		}
		return v;
	}
	
	public function copy():IV2D<Int> {
		var v = new IntV2D(0, cols);
		v._vec = _vec.copy();
		v.rows = rows;
		return v;
	}
	
	public function clear():Void {
		fill1(0, length);
	}
	
	public function toString():String {
		
		var s = "";
		
		if (length > 0) {
			for (i in 0...rows) {
				s += "\n";
				for (j in 0...cols) {
					s += '${get2(i, j)},';
				}
			}
		}
		
		return s;
	}
}

private class FloatV2D implements IV2D<Float> {

	var _vec:Vector<Float>;
	public var cols(default, null):Int;
	public var rows(default, null):Int;
	public var length(get, never):Int;
	inline function get_length():Int { return _vec.length; }
	
	public function new(length:Int, numCols:Int) {
		_vec = new Vector<Float>(length, true);
		cols = numCols;
		rows = Math.ceil(length / cols);
	}
	
	public function iterator():Iterator<Float> {
		return _vec.iterator();
	}
	
	public function fill1(t:Float, len:Int):Void {
		
		for (i in 0...len) {
			_vec[i] = t;
		}
		
		for (i in len...length) {
			_vec[i] = 0.0;
		}
	}
	
	public function fill2(t:Float, numRows:Int, numCols:Int):Void {
		fill1(t, numRows * numCols);
	}
	
	public function fillAt1(t:Float, start:Int, len:Int):Void {
		var i = 0;
		while (i++ < len) {
			_vec[start + i] = t;
		}
	}
	
	public function fillAt2(t:Float, startRow:Int, startCol:Int, numRows:Int, numCols:Int):Void {
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				set2(t, startRow + rr, startCol + cc);
			}
		}
	}
	
	public function fillWith1(vec:Vector<Float>, index:Int):Void {
		var i = 0;
		while (i < vec.length) set1(vec[i], index + i++);
	}
	
	public function fillWith2(vec:Vector2D<Float>, startRow:Int, startCol:Int):Void {
		for (rr in 0...vec.rows) {
			for (cc in 0...vec.cols) {
				set2(vec.get2(rr, cc), startRow + rr, startCol + cc);
			}
		}
	}
	
	public function get1(index:Int):Float {
		return _vec[index];
	}
	
	public function set1(t:Float, index:Int):Float {
		return _vec[index] = t;
	}
	
	public function get2(row:Int, col:Int):Float {
		return _vec[row * cols + col];
	}
	
	public function set2(t:Float, row:Int, col:Int):Float {
		return _vec[row * cols + col] = t;
	}
	
	public function getRowOf(index:Int):Int {
		return Std.int(index / cols);
	}
	
	public function getColOf(index:Int):Int {
		return index % cols;
	}
	
	public function getIndexOf(row:Int, col:Int):Int {
		return row * cols + col;
	}
	
	public function slice1(startIndex:Int, len:Int):Vector2D<Float> {
		var v = new Vector2D<Float>(len, cols);
		var i = 0;
		while (i++ < len) v.set1(_vec[startIndex + i - 1], i - 1);
		return v;
	}
	
	public function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):Vector2D<Float> {
		var v = new Vector2D<Float>(numCols * numRows, numCols);
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				v.set2(get2(startRow + rr, startCol + cc), rr, cc);
			}
		}
		return v;
	}
	
	public function copy():IV2D<Float> {
		var v = new FloatV2D(0, cols);
		v._vec = _vec.copy();
		v.rows = rows;
		return v;
	}
	
	public function clear():Void {
		fill1(0.0, length);
	}
	
	public function toString():String {
		
		var s = "";
		
		if (length > 0) {
			for (i in 0...rows) {
				s += "\n";
				for (j in 0...cols) {
					s += '${get2(i, j)},';
				}
			}
		}
		
		return s;
	}
}

private class StringV2D implements IV2D<String> {

	var _vec:Vector<String>;
	public var cols(default, null):Int;
	public var rows(default, null):Int;
	public var length(get, never):Int;
	inline function get_length():Int { return _vec.length; }
	
	public function new(length:Int, numCols:Int) {
		_vec = new Vector<String>(length, true);
		cols = numCols;
		rows = Math.ceil(length / cols);
	}
	
	public function iterator():Iterator<String> {
		return _vec.iterator();
	}
	
	public function fill1(t:String, len:Int):Void {
		
		for (i in 0...len) {
			_vec[i] = t;
		}
		
		for (i in len...length) {
			_vec[i] = null;
		}
	}
	
	public function fill2(t:String, numRows:Int, numCols:Int):Void {
		fill1(t, numRows * numCols);
	}
	
	public function fillAt1(t:String, start:Int, len:Int):Void {
		var i = 0;
		while (i++ < len) {
			_vec[start + i] = t;
		}
	}
	
	public function fillAt2(t:String, startRow:Int, startCol:Int, numRows:Int, numCols:Int):Void {
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				set2(t, startRow + rr, startCol + cc);
			}
		}
	}
	
	public function fillWith1(vec:Vector<String>, index:Int):Void {
		var i = 0;
		while (i < vec.length) set1(vec[i], index + i++);
	}
	
	public function fillWith2(vec:Vector2D<String>, startRow:Int, startCol:Int):Void {
		for (rr in 0...vec.rows) {
			for (cc in 0...vec.cols) {
				set2(vec.get2(rr, cc), startRow + rr, startCol + cc);
			}
		}
	}
	
	public function get1(index:Int):String {
		return _vec[index];
	}
	
	public function set1(t:String, index:Int):String {
		return _vec[index] = t;
	}
	
	public function get2(row:Int, col:Int):String {
		return _vec[row * cols + col];
	}
	
	public function set2(t:String, row:Int, col:Int):String {
		return _vec[row * cols + col] = t;
	}
	
	public function getRowOf(index:Int):Int {
		return Std.int(index / cols);
	}
	
	public function getColOf(index:Int):Int {
		return index % cols;
	}
	
	public function getIndexOf(row:Int, col:Int):Int {
		return row * cols + col;
	}
	
	public function slice1(startIndex:Int, len:Int):Vector2D<String> {
		var v = new Vector2D<String>(len, cols);
		var i = 0;
		while (i++ < len) v.set1(_vec[startIndex + i - 1], i - 1);
		return v;
	}
	
	public function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):Vector2D<String> {
		var v = new Vector2D<String>(numCols * numRows, numCols);
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				v.set2(get2(startRow + rr, startCol + cc), rr, cc);
			}
		}
		return v;
	}
	
	public function copy():IV2D<String> {
		var v = new StringV2D(0, cols);
		v._vec = _vec.copy();
		v.rows = rows;
		return v;
	}
	
	public function clear():Void {
		fill1(null, length);
	}
	
	public function toString():String {
		
		var s = "";
		
		if (length > 0) {
			for (i in 0...rows) {
				s += "\n";
				for (j in 0...cols) {
					s += '${get2(i, j)},';
				}
			}
		}
		
		return s;
	}
}

private class ObjV2D implements IV2D<Dynamic> {

	var _vec:Vector<Dynamic>;
	public var cols(default, null):Int;
	public var rows(default, null):Int;
	public var length(get, never):Int;
	inline function get_length():Int { return _vec.length; }
	
	public function new(length:Int, numCols:Int) {
		_vec = new Vector<Dynamic>(length, true);
		cols = numCols;
		rows = Math.ceil(length / cols);
	}
	
	public function iterator():Iterator<Dynamic> {
		return _vec.iterator();
	}
	
	public function fill1(t:Dynamic, len:Int):Void {
		
		for (i in 0...len) {
			_vec[i] = t;
		}
		
		for (i in len...length) {
			_vec[i] = null;
		}
	}
	
	public function fill2(t:Dynamic, numRows:Int, numCols:Int):Void {
		fill1(t, numRows * numCols);
	}
	
	public function fillAt1(t:Dynamic, start:Int, len:Int):Void {
		var i = 0;
		while (i++ < len) {
			_vec[start + i] = t;
		}
	}
	
	public function fillAt2(t:Dynamic, startRow:Int, startCol:Int, numRows:Int, numCols:Int):Void {
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				set2(t, startRow + rr, startCol + cc);
			}
		}
	}
	
	public function fillWith1(vec:Vector<Dynamic>, index:Int):Void {
		var i = 0;
		while (i < vec.length) set1(vec[i], index + i++);
	}
	
	public function fillWith2(vec:Vector2D<Dynamic>, startRow:Int, startCol:Int):Void {
		for (rr in 0...vec.rows) {
			for (cc in 0...vec.cols) {
				set2(vec.get2(rr, cc), startRow + rr, startCol + cc);
			}
		}
	}
	
	public function get1(index:Int):Dynamic {
		return _vec[index];
	}
	
	public function set1(t:Dynamic, index:Int):Dynamic {
		return _vec[index] = t;
	}
	
	public function get2(row:Int, col:Int):Dynamic {
		return _vec[row * cols + col];
	}
	
	public function set2(t:Dynamic, row:Int, col:Int):Dynamic {
		return _vec[row * cols + col] = t;
	}
	
	public function getRowOf(index:Int):Int {
		return Std.int(index / cols);
	}
	
	public function getColOf(index:Int):Int {
		return index % cols;
	}
	
	public function getIndexOf(row:Int, col:Int):Int {
		return row * cols + col;
	}
	
	public function slice1(startIndex:Int, len:Int):Vector2D<Dynamic> {
		var v = new Vector2D<Dynamic>(len, cols);
		var i = 0;
		while (i++ < len) v.set1(_vec[startIndex + i - 1], i - 1);
		return v;
	}
	
	public function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):Vector2D<Dynamic> {
		var v = new Vector2D<Dynamic>(numCols * numRows, numCols);
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				v.set2(get2(startRow + rr, startCol + cc), rr, cc);
			}
		}
		return v;
	}
	
	public function copy():IV2D<Dynamic> {
		var v = new ObjV2D(0, cols);
		v._vec = _vec.copy();
		v.rows = rows;
		return v;
	}
	
	public function clear():Void {
		fill1(null, length);
	}
	
	public function toString():String {
		
		var s = "";
		
		if (length > 0) {
			for (i in 0...rows) {
				s += "\n";
				for (j in 0...cols) {
					s += '${get2(i, j)},';
				}
			}
		}
		
		return s;
	}
}

private interface IV2D<T> {
	
	/** The number of columns. Readonly. **/
	var cols(default, null):Int;
	/** The number of rows. Readonly. **/
	var rows(default, null):Int;
	/** The true length of the vector, not just rows * cols. **/
	var length(get, never):Int;
	
	/**
	 * The core vector's iterator.
	 */
	function iterator():Iterator<T>;
	
	/**
	 * Clears the vector (fills with false, 0, or null) and fills it with the supplied T.
	 * @param	t	What to fill the vector with.
	 * @param	len	How many Ts to add.
	 */
	function fill1(t:T, len:Int):Void;
	
	/**
	 * Clears the vector and fills it with the supplied T. Changes the number of columns.
	 * @param	t		What to fill the vector with.
	 * @param	numRows	How many rows of Ts to add.
	 * @param	numCols	How many cols of Ts to add. The new number of columns gets set to this value.
	 */
	function fill2(t:T, numRows:Int, numCols:Int):Void;
	
	/**
	 * Fills the specified 1D range with T.
	 * @param	t		What to fill the vector with.
	 * @param	start	The starting index.
	 * @param	len		How many Ts to add.
	 */
	function fillAt1(t:T, start:Int, len:Int):Void;
	
	/**
	 * Fills the specified 2D range with T.
	 * @param	t			What to fill the vector with.
	 * @param	startRow	The starting row.
	 * @param	startCol	The starting col.
	 * @param	numRows		How many rows of Ts to add.
	 * @param	numCols		How many cols of Ts to add.
	 */
	function fillAt2(t:T, startRow:Int, startCol:Int, numRows:Int, numCols:Int):Void;
	
	/**
	 * Fills the vector with a 1D vector from the supplied index.
	 * Overwrites existing data.
	 * @param	vec		The 1D vector to overwrite data with.
	 * @param	index	The index to start copying data to.
	 */
	function fillWith1(vec:Vector<T>, index:Int):Void;
	
	/**
	 * Fills the vector with a Vector2D from the supplied row and col.
	 * @param	arr			The Vector2D to overwrite data with.
	 * @param	startRow	The row to start copying data to.
	 * @param	startCol	The col to start copying data to.
	 */
	function fillWith2(vec:Vector2D<T>, startRow:Int, startCol:Int):Void;
	
	/**
	 * Gets a value from a 1D index.
	 * @param	index	The index of the T.
	 * @return	The T at the index.
	 */
	function get1(index:Int):T;
	
	/**
	 * Sets a value from a 1D index.
	 * @param	t		What to set at the index.
	 * @param	index	The index of the T.
	 * @return	The T.
	 */
	function set1(t:T, index:Int):T;
	
	/**
	 * Gets a value from a 2D index.
	 * @param	row	The row of the T.
	 * @param	col	The col of the T.
	 * @return	The T at the index.
	 */
	function get2(row:Int, col:Int):T;
	
	/**
	 * Sets a value from a 2D index.
	 * @param	t	What to set at the index.
	 * @param	row	The row of the T.
	 * @param	col	The col of the T.
	 * @return	The T.
	 */
	function set2(t:T, row:Int, col:Int):T;
	
	/**
	 * Gets the row of a 1D index.
	 * @param	index	A 1D index.
	 * @return	The row this index is found in.
	 */
	function getRowOf(index:Int):Int;
	
	/**
	 * Gets the column of a 1D index.
	 * @param	index	A 1D index.
	 * @return	The column this index is found in.
	 */
	function getColOf(index:Int):Int;
	
	/**
	 * Gets the 1D index from a row and column.
	 * @param	row		The row of the index.
	 * @param	col		The column of the index.
	 * @return	The index of the row/column pair.
	 */
	function getIndexOf(row:Int, col:Int):Int;
	
	/**
	 * Creates a shallow copy of this Vector2D using a 1D range.
	 * The new vector has the same number of columns as this one, and its length is set to the input parameter.
	 * @param	startIndex	The starting index.
	 * @param	len			How many Ts to copy, also the length of the new Vector2D.
	 * @return	The new Vector2D.
	 */
	function slice1(startIndex:Int, len:Int):Vector2D<T>;
	
	/**
	 * Creates a shallow copy of this Vector2D using a 2D range.
	 * The number of columns in the new vector is equal to numCols, and the length is numRows * numCols.
	 * @param	startRow	The starting row.
	 * @param	startCol	The starting col.
	 * @param	numRows		How many rows to copy.
	 * @param	numCols		How many cols to copy. Also the number of cols of the output Vector2D.
	 * @return	The new Vector2D.
	 */
	function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):Vector2D<T>;
	
	/**
	 * Produces a shallow copy of the entire Vector2D with the same number of columns.
	 * @return	The new Vector2D.
	 */
	function copy():IV2D<T>;
	
	/**
	 * Fills the entire Vector2D with the appropriate default value for the type.
	 * (e.g. false, 0, null)
	 */
	function clear():Void;
	
	/**
	 * @return	The prettified string of the Vector2D.
	 */
	function toString():String;
}