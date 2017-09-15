package msg.utils;

import haxe.ds.Vector;

/**
 * A 2D vector backed by a 1D vector.
 * Better than Array2D when the length and number of rows and columns never change.
 * @author MSGHero
 */

@:multiType(T)
// @:forward or no?
abstract Vector2D<T>(IV2D<T>) {
	
	/** The number of columns. Readonly. **/
	public var cols(get, never):Int;
	inline function get_cols():Int { return this.cols; }
	
	/** The number of rows. Readonly. **/
	public var rows(get, never):Int;
	inline function get_rows():Int { return this.rows; }
	
	/** The true length of the vector, not just rows * cols. **/
	public var length(get, never):Int;
	inline function get_length():Int { return this.length; }
	
	/**
	 * Creates a new Vector2D of the specified type.
	 * @param	length	The immutable length of the vector.
	 * @param	numCols	The immutable number of columns, from which the immutable number of rows is determined.
	 */
	public function new(length:Int, numCols:Int);
	
	/**
	 * The core vector's iterator.
	 */
	public inline function iterator():Iterator<T> {
		return this.iterator();
	}
	
	/**
	 * The vector's 2D iterator.
	 * Usage:
	 * @example
	 * for (rc in myV2D.iterator2()) {
	 *     trace(rc.index, rc.row, rc.col);
	 * }
	 */
	public inline function iterator2():V2DIterator {
		return this.iterator2();
	}
	
	/**
	 * Clears the vector (fills with false, 0, or null) and fills it with the supplied T.
	 * @param	t	What to fill the vector with.
	 * @param	len	How many Ts to add.
	 */
	public inline function fill1(t:T, len:Int):Void {
		this.fill1(t, len);
	}
	
	/**
	 * Clears the vector and fills it with the supplied T. Changes the number of columns.
	 * @param	t		What to fill the vector with.
	 * @param	numRows	How many rows of Ts to add.
	 * @param	numCols	How many cols of Ts to add. The new number of columns gets set to this value.
	 */
	public inline function fill2(t:T, numRows:Int, numCols:Int):Void {
		this.fill2(t, numRows, numCols);
	}
	
	/**
	 * Fills the specified 1D range with T.
	 * @param	t		What to fill the vector with.
	 * @param	start	The starting index.
	 * @param	len		How many Ts to add.
	 */
	public inline function fillAt1(t:T, start:Int, len:Int):Void {
		this.fillAt1(t, start, len);
	}
	
	/**
	 * Fills the specified 2D range with T.
	 * @param	t			What to fill the vector with.
	 * @param	startRow	The starting row.
	 * @param	startCol	The starting col.
	 * @param	numRows		How many rows of Ts to add.
	 * @param	numCols		How many cols of Ts to add.
	 */
	public inline function fillAt2(t:T, startRow:Int, startCol:Int, numRows:Int, numCols:Int):Void {
		this.fillAt2(t, startRow, startCol, numRows, numCols);
	}
	
	/**
	 * Fills the vector with a 1D vector from the supplied index.
	 * Overwrites existing data.
	 * @param	vec		The 1D vector to overwrite data with.
	 * @param	index	The index to start copying data to.
	 */
	public inline function fillWith1(vec:Vector<T>, index:Int):Void {
		this.fillWith1(vec, index);
	}
	
	/**
	 * Fills the vector with a Vector2D from the supplied row and col.
	 * @param	vec			The Vector2D to overwrite data with.
	 * @param	startRow	The row to start copying data to.
	 * @param	startCol	The col to start copying data to.
	 */
	public inline function fillWith2(vec:Vector2D<T>, startRow:Int, startCol:Int):Void {
		this.fillWith2(cast vec, startRow, startCol);
	}
	
	/**
	 * Gets a value from a 1D index. Can also use array access.
	 * @param	index	The index of the T.
	 * @return	The T at the index.
	 */
	@:arrayAccess public inline function get1(index:Int):T {
		return this.get1(index);
	}
	
	/**
	 * Sets a value from a 1D index. Can also use array access.
	 * @param	t		What to set at the index.
	 * @param	index	The index of the T.
	 * @return	The T.
	 */
	public inline function set1(t:T, index:Int):T {
		return this.set1(t, index);
	}
	
	// the real array access setter, since parameter order matters
	@:arrayAccess inline function setWithArrayAccess(index:Int, t:T):T {
		return this.set1(t, index);
	}
	
	/**
	 * Gets a value from a 2D index.
	 * @param	row	The row of the T.
	 * @param	col	The col of the T.
	 * @return	The T at the index.
	 */
	public inline function get2(row:Int, col:Int):T {
		return this.get2(row, col);
	}
	
	/**
	 * Sets a value from a 2D index.
	 * @param	t	What to set at the index.
	 * @param	row	The row of the T.
	 * @param	col	The col of the T.
	 * @return	The T.
	 */
	public inline function set2(t:T, row:Int, col:Int):T {
		return this.set2(t, row, col);
	}
	
	/**
	 * Gets the row of a 1D index.
	 * @param	index	A 1D index.
	 * @return	The row this index is found in.
	 */
	public inline function getRowOf(index:Int):Int {
		return this.getRowOf(index);
	}
	
	/**
	 * Gets the column of a 1D index.
	 * @param	index	A 1D index.
	 * @return	The column this index is found in.
	 */
	public inline function getColOf(index:Int):Int {
		return this.getColOf(index);
	}
	
	/**
	 * Gets the 1D index from a row and column.
	 * @param	row		The row of the index.
	 * @param	col		The column of the index.
	 * @return	The index of the row/column pair.
	 */
	public inline function getIndexOf(row:Int, col:Int):Int {
		return this.getIndexOf(row, col);
	}
	
	/**
	 * Creates a shallow copy of this Vector2D using a 1D range.
	 * The new vector has the same number of columns as this one, and its length is set to the input parameter.
	 * @param	startIndex	The starting index.
	 * @param	len			How many Ts to copy, also the length of the new Vector2D.
	 * @return	The new Vector2D.
	 */
	public inline function slice1(startIndex:Int, len:Int):Vector2D<T> {
		return cast this.slice1(startIndex, len);
	}
	
	/**
	 * Creates a shallow copy of this Vector2D using a 2D range.
	 * The number of columns in the new vector is equal to numCols, and the length is numRows * numCols.
	 * @param	startRow	The starting row.
	 * @param	startCol	The starting col.
	 * @param	numRows		How many rows to copy.
	 * @param	numCols		How many cols to copy. Also the number of cols of the output Vector2D.
	 * @return	The new Vector2D.
	 */
	public inline function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):Vector2D<T> {
		return cast this.slice2(startRow, startCol, numRows, numCols);
	}
	
	/**
	 * Produces a shallow copy of the entire Vector2D with the same number of columns.
	 * @return	The new Vector2D.
	 */
	public inline function copy():Vector2D<T> {
		return cast this.copy();
	}
	
	/**
	 * Fills the entire Vector2D with the appropriate default value for the type.
	 * (e.g. false, 0, null)
	 */
	public inline function clear():Void {
		this.clear();
	}
	
	/**
	 * @return	The prettified string of the Vector2D.
	 */
	public inline function toString():String {
		return this.toString();
	}
	
	@:from static inline function fromBoolV2D<T>(t:BoolV2D):Vector2D<T> {
		return cast t;
	}
	
	@:from static inline function fromIntV2D<T>(t:IntV2D):Vector2D<T> {
		return cast t;
	}
	
	@:from static inline function fromFloatV2D<T>(t:FloatV2D):Vector2D<T> {
		return cast t;
	}
	
	@:from static inline function fromStringV2D<T>(t:StringV2D):Vector2D<T> {
		return cast t;
	}
	
	@:from static inline function fromObjV2D<T>(t:ObjV2D<T>):Vector2D<T> {
		return cast t;
	}
	
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
	
	@:to static inline function toObjV2D<T>(t:IV2D<T>, length:Int, numCols:Int):ObjV2D<T> {
		return new ObjV2D<T>(length, numCols);
	}
}

private class BoolV2D implements IV2D<Bool> {

	var _vec:Vector<Bool>;
	public var cols(default, null):Int;
	public var rows(default, null):Int;
	public var length(get, never):Int;
	inline function get_length():Int { return _vec.length; }
	
	public function new(length:Int, numCols:Int) {
		_vec = new Vector<Bool>(length);
		cols = numCols;
		rows = Math.ceil(length / cols);
	}
	
	public function iterator():Iterator<Bool> {
		return new V1DIterator(_vec);
	}
	
	public function iterator2():V2DIterator {
		return new V2DIterator(rows, cols);
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
		Vector.blit(vec, 0, _vec, index, vec.length);
	}
	
	public function fillWith2(vec:IV2D<Bool>, startRow:Int, startCol:Int):Void {
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
	
	public function slice1(startIndex:Int, len:Int):IV2D<Bool> {
		var v = new BoolV2D(len, cols);
		Vector.blit(_vec, startIndex, v._vec, 0, len);
		return v;
	}
	
	public function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):IV2D<Bool> {
		var v = new BoolV2D(numCols * numRows, numCols);
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
		_vec = new Vector<Int>(length);
		cols = numCols;
		rows = Math.ceil(length / cols);
	}
	
	public function iterator():Iterator<Int> {
		return new V1DIterator(_vec);
	}
	
	public function iterator2():V2DIterator {
		return new V2DIterator(rows, cols);
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
		Vector.blit(vec, 0, _vec, index, vec.length);
	}
	
	public function fillWith2(vec:IV2D<Int>, startRow:Int, startCol:Int):Void {
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
	
	public function slice1(startIndex:Int, len:Int):IV2D<Int> {
		var v = new IntV2D(len, cols);
		Vector.blit(_vec, startIndex, v._vec, 0, len);
		return v;
	}
	
	public function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):IV2D<Int> {
		var v = new IntV2D(numCols * numRows, numCols);
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
		_vec = new Vector<Float>(length);
		cols = numCols;
		rows = Math.ceil(length / cols);
	}
	
	public function iterator():Iterator<Float> {
		return new V1DIterator(_vec);
	}
	
	public function iterator2():V2DIterator {
		return new V2DIterator(rows, cols);
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
		Vector.blit(vec, 0, _vec, index, vec.length);
	}
	
	public function fillWith2(vec:IV2D<Float>, startRow:Int, startCol:Int):Void {
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
	
	public function slice1(startIndex:Int, len:Int):IV2D<Float> {
		var v = new FloatV2D(len, cols);
		Vector.blit(_vec, startIndex, v._vec, 0, len);
		return v;
	}
	
	public function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):IV2D<Float> {
		var v = new FloatV2D(numCols * numRows, numCols);
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
		_vec = new Vector<String>(length);
		cols = numCols;
		rows = Math.ceil(length / cols);
	}
	
	public function iterator():Iterator<String> {
		return new V1DIterator(_vec);
	}
	
	public function iterator2():V2DIterator {
		return new V2DIterator(rows, cols);
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
		Vector.blit(vec, 0, _vec, index, vec.length);
	}
	
	public function fillWith2(vec:IV2D<String>, startRow:Int, startCol:Int):Void {
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
	
	public function slice1(startIndex:Int, len:Int):IV2D<String> {
		var v = new StringV2D(len, cols);
		Vector.blit(_vec, startIndex, v._vec, 0, len);
		return v;
	}
	
	public function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):IV2D<String> {
		var v = new StringV2D(numCols * numRows, numCols);
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

private class ObjV2D<T:Dynamic> implements IV2D<T> {

	var _vec:Vector<Dynamic>;
	public var cols(default, null):Int;
	public var rows(default, null):Int;
	public var length(get, never):Int;
	inline function get_length():Int { return _vec.length; }
	
	public function new(length:Int, numCols:Int) {
		_vec = new Vector<Dynamic>(length);
		cols = numCols;
		rows = Math.ceil(length / cols);
	}
	
	public function iterator():Iterator<T> {
		return new V1DIterator(_vec);
	}
	
	public function iterator2():V2DIterator {
		return new V2DIterator(rows, cols);
	}
	
	public function fill1(t:T, len:Int):Void {
		
		for (i in 0...len) {
			_vec[i] = t;
		}
		
		for (i in len...length) {
			_vec[i] = null;
		}
	}
	
	public function fill2(t:T, numRows:Int, numCols:Int):Void {
		fill1(t, numRows * numCols);
	}
	
	public function fillAt1(t:T, start:Int, len:Int):Void {
		var i = 0;
		while (i++ < len) {
			_vec[start + i] = t;
		}
	}
	
	public function fillAt2(t:T, startRow:Int, startCol:Int, numRows:Int, numCols:Int):Void {
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				set2(t, startRow + rr, startCol + cc);
			}
		}
	}
	
	public function fillWith1(vec:Vector<T>, index:Int):Void {
		Vector.blit(vec, 0, cast _vec, index, vec.length);
	}
	
	public function fillWith2(vec:IV2D<T>, startRow:Int, startCol:Int):Void {
		for (rr in 0...vec.rows) {
			for (cc in 0...vec.cols) {
				set2(vec.get2(rr, cc), startRow + rr, startCol + cc);
			}
		}
	}
	
	public function get1(index:Int):T {
		return _vec[index];
	}
	
	public function set1(t:T, index:Int):T {
		return _vec[index] = t;
	}
	
	public function get2(row:Int, col:Int):T {
		return _vec[row * cols + col];
	}
	
	public function set2(t:T, row:Int, col:Int):T {
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
	
	public function slice1(startIndex:Int, len:Int):IV2D<T> {
		var v = new ObjV2D<T>(len, cols);
		Vector.blit(_vec, startIndex, v._vec, 0, len);
		return v;
	}
	
	public function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):IV2D<T> {
		var v = new ObjV2D<T>(numCols * numRows, numCols);
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				v.set2(get2(startRow + rr, startCol + cc), rr, cc);
			}
		}
		return v;
	}
	
	public function copy():IV2D<T> {
		var v = new ObjV2D<T>(0, cols);
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

interface IV2D<T> {
	
	var cols(default, null):Int;
	var rows(default, null):Int;
	var length(get, never):Int;
	
	function iterator():Iterator<T>;
	function iterator2():V2DIterator;
	function fill1(t:T, len:Int):Void;
	function fill2(t:T, numRows:Int, numCols:Int):Void;
	function fillAt1(t:T, start:Int, len:Int):Void;
	function fillAt2(t:T, startRow:Int, startCol:Int, numRows:Int, numCols:Int):Void;
	function fillWith1(vec:Vector<T>, index:Int):Void;
	function fillWith2(vec:IV2D<T>, startRow:Int, startCol:Int):Void;
	function get1(index:Int):T;
	function set1(t:T, index:Int):T;
	function get2(row:Int, col:Int):T;
	function set2(t:T, row:Int, col:Int):T;
	function getRowOf(index:Int):Int;
	function getColOf(index:Int):Int;
	function getIndexOf(row:Int, col:Int):Int;
	function slice1(startIndex:Int, len:Int):IV2D<T>;
	function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):IV2D<T>;
	function copy():IV2D<T>;
	function clear():Void;
	function toString():String;
}

private class V1DIterator<T> {
	
	var i:Int = 0;
	var v2:Vector<T> = null;
	
	public inline function new(v2:Vector<T>) {
		this.v2 = v2;
	}
	
	public inline function hasNext():Bool {
		return i < v2.length;
	}
	
	public inline function next():T {
		return v2[i++];
	}
}

private class V2DIterator {
	
	var rows:Int = 0;
	var cols:Int = 0;
	var i:Int = 0;
	
	public inline function new(rows:Int, cols:Int) {
		this.rows = rows;
		this.cols = cols;
	}
	
	public inline function hasNext():Bool {
		return i < rows * cols;
	}
	
	public inline function next():V2DIteratorObject {
		return new V2DIteratorObject(i++, cols);
	}
}

private class V2DIteratorObject {
	
	public var index(default, null):Int;
	public var row(default, null):Int;
	public var col(default, null):Int;
	
	public inline function new(index:Int, cols:Int) {
		this.index = index;
		row = Std.int(index / cols);
		col = index % cols;
	}
}