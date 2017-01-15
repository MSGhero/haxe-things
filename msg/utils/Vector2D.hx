package msg.utils;
import openfl.Vector;

/**
 * A 2D vector backed by a 1D vector.
 * Better than Array2D when the length and number of columns never change.
 * @author MSGHero
 */
class Vector2D<T>{

	/** The underlying vector. **/
	var _vec:Vector<T>;
	
	/** The number of columns. Readonly. **/
	public var cols(default, null):Int;
	/** The number of rows. Readonly. **/
	public var rows(default, null):Int;
	
	/** The true length of the vector, not just rows * cols. **/
	public var length(get, never):Int;
	inline function get_length():Int { return _vec.length; }
	
	// inline everything when the haxe issue is resolved
	
	/**
	 * Creates a new Vector2D.
	 * @param	length	The immutable length of the vector.
	 * @param	numCols	The immutable number of columns.
	 */
	public function new(length:Int, numCols:Int) {
		_vec = new Vector<T>(length, true);
		cols = numCols;
		rows = Math.ceil(length / cols);
	}
	
	/**
	 * Just the core vector's iterator.
	 */
	public function iterator() {
		return _vec.iterator();
	}
	
	/**
	 * Clears the vector and fills it with the supplied T.
	 * @param	t	What to fill the vector with.
	 * @param	len	How many Ts to add.
	 */
	public function fill1(t:T, len:Int):Void {
		clear();
		while (len-- > 0) {
			_vec[len] = t;
		}
	}
	
	/**
	 * Clears the vector and fills it with the supplied T. Changes the number of columns.
	 * @param	t		What to fill the vector with.
	 * @param	numRows	How many rows of Ts to add.
	 * @param	numCols	How many cols of Ts to add. The new number of columns gets set to this value.
	 */
	public function fill2(t:T, numRows:Int, numCols:Int):Void {
		cols = numCols;
		rows = Math.ceil(length / cols);
		fill1(t, numRows * numCols);
	}
	
	/**
	 * Fills the specified 1D range with T.
	 * @param	t		What to fill the vector with.
	 * @param	start	The starting index.
	 * @param	len		How many Ts to add.
	 */
	public function fillAt1(t:T, start:Int, len:Int):Void {
		var i = 0;
		while (i++ < len) {
			_vec[start + i] = t;
		}
	}
	
	/**
	 * Fills the specified 2D range with T.
	 * @param	t			What to fill the vector with.
	 * @param	startRow	The starting row.
	 * @param	startCol	The starting col.
	 * @param	numRows		How many rows of Ts to add.
	 * @param	numCols		How many cols of Ts to add.
	 */
	public function fillAt2(t:T, startRow:Int, startCol:Int, numRows:Int, numCols:Int):Void {
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				set2(t, startRow + rr, startCol + cc);
			}
		}
	}
	
	/**
	 * Fills the vector with a 1D vector from the supplied index.
	 * Overwrites existing data.
	 * @param	vec		The 1D vector to overwrite data with.
	 * @param	index	The index to start copying data to.
	 */
	public function fillWith1(vec:Vector<T>, index:Int):Void {
		var i = 0;
		while (i < vec.length) set1(vec[i], index + i++);
	}
	
	/**
	 * Fills the vector with a Vector2D from the supplied row and col.
	 * @param	arr			The Vector2D to overwrite data with.
	 * @param	startRow	The row to start copying data to.
	 * @param	startCol	The col to start copying data to.
	 */
	public function fillWith2(vec:Vector2D<T>, startRow:Int, startCol:Int):Void {
		for (rr in 0...vec.rows) {
			for (cc in 0...vec.cols) {
				set2(vec.get2(rr, cc), startRow + rr, startCol + cc);
			}
		}
	}
	
	/**
	 * Gets a value from a 1D index.
	 * @param	index	The index of the T.
	 * @return	The T at the index.
	 */
	public function get1(index:Int):T {
		return _vec[index];
	}
	
	/**
	 * Sets a value from a 1D index.
	 * @param	t		What to set at the index.
	 * @param	index	The index of the T.
	 * @return	The T.
	 */
	public function set1(t:T, index:Int):T {
		return _vec[index] = t;
	}
	
	/**
	 * Gets a value from a 2D index.
	 * @param	row	The row of the T.
	 * @param	col	The col of the T.
	 * @return	The T at the index.
	 */
	public function get2(row:Int, col:Int):T {
		return _vec[row * cols + col];
	}
	
	/**
	 * Sets a value from a 2D index.
	 * @param	t	What to set at the index.
	 * @param	row	The row of the T.
	 * @param	col	The col of the T.
	 * @return	The T.
	 */
	public function set2(t:T, row:Int, col:Int):T {
		return _vec[row * cols + col] = t;
	}
	
	/**
	 * Gets the row of a 1D index.
	 * @param	index	A 1D index.
	 * @return	The row this index is found in.
	 */
	public function getRowOf(index:Int):Int {
		return Std.int(index / cols);
	}
	
	/**
	 * Gets the column of a 1D index.
	 * @param	index	A 1D index.
	 * @return	The column this index is found in.
	 */
	public function getColOf(index:Int):Int {
		return index % cols;
	}
	
	/**
	 * Gets the 1D index from a row and column.
	 * @param	row		The row of the index.
	 * @param	col		The column of the index.
	 * @return	The index of the row/column pair.
	 */
	public function getIndexOf(row:Int, col:Int):Int {
		return row * cols + col;
	}
	
	/**
	 * Does nothing since the vector length is fixed.
	 * @param	t	
	 * @return	The length of the vector.
	 */
	public function push(t:T):Int {
		return length;
	}
	
	/**
	 * Returns, but does not remove, the last item in the vector.
	 * @return	The last T.
	 */
	public function pop():T {
		return _vec[length - 1];
	}
	
	/**
	 * Creates a shallow copy of this Vector2D using a 1D range.
	 * The new vector has the same number of columns as this one, and its length is set to the input parameter.
	 * @param	startIndex	The starting index.
	 * @param	len			How many Ts to copy, also the length of the new Vector2D.
	 * @return	The new Vector2D.
	 */
	public function slice1(startIndex:Int, len:Int):Vector2D<T> {
		var v = new Vector2D<T>(len, cols);
		var i = 0;
		while (i++ < len) v.set1(_vec[startIndex + i - 1], i - 1);
		return v;
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
	public function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):Vector2D<T> {
		var v = new Vector2D<T>(numCols * numRows, numCols);
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				v.set2(get2(startRow + rr, startCol + cc), rr, cc);
			}
		}
		return v;
	}
	
	/**
	 * Produces a shallow copy of the entire Vector2D with the same number of columns.
	 * @return	The new Vector2D.
	 */
	public function copy():Vector2D<T> {
		var v = new Vector2D<T>(0, cols);
		v._vec = _vec.copy();
		v.rows = rows;
		return v;
	}
	
	/**
	 * Creates a new Vector2D of type S by applying the mapping function to each element of this Vector2D of type T.
	 * @param	mapFunction		Each element of this Vector2D is passed into this function, and a new Vector2D is created from the returned values.
	 * @return	The mapped Vector2D of type S.
	 */
	public function map<S>(mapFunction:T->S):Vector2D<S> {
		var v = new Vector2D<S>(length, cols);
		for (i in 0...length) v._vec[i] = mapFunction(_vec[i]);
		return v;
	}
	
	/**
	 * Does nothing since the vector length is fixed.
	 * Instead, use `fill1()` with some default value (false, 0, null, etc) over the length of this Vector2D.
	 */
	public function clear():Void { }
	
	/**
	 * Creates a Vector<T> from this Vector2D<T>.
	 * @return	The 1D vector representation of the data.
	 */
	public function to1DVector():Vector<T> {
		return _vec.copy();
	}
	
	/**
	 * Creates a Vector<Vector<T>> from this Vector2D<T>.
	 * @return	The 2D vector representation of the data.
	 */
	public function to2DVector():Vector<Vector<T>> {
		
		var data:Vector<Vector<T>> = new Vector<Vector<T>>(rows, true);
		
		for (rr in 0...rows) {
			var v:Vector<T> = new Vector<T>(cols, true);
			for (cc in 0...cols) {
				v[cc] = get2(rr, cc);
			}
			data[rr] = v;
		}
		
		return data;
	}
	
	/**
	 * Creates a Vector2D<T> from the supplied Vector<T>.
	 * @param	vec		The 1D vector to convert.
	 * @param	cols	The number of columns the Vector2D should have.
	 * @return	The Vector2D representation of the data.
	 */
	public static function from1DArray<S>(vec:Vector<S>, cols:Int):Vector2D<S>{
		var v = new Vector2D<S>(0, cols);
		v._vec = vec;
		v.rows = Math.ceil(vec.length / cols);
		return v;
	}
	
	/**
	 * Creates an Vector2D<T> from the supplied Vector<Vector<T>>.
	 * @param	arr		The 2D vector to convert.
	 * @param	cols	The number of columns the Vector2D should have.
	 * @return	The Vector2D representation of the data.
	 */
	public static function from2DVector<S>(vec:Vector<Vector<S>>, cols:Int):Vector2D<S>{
		var v = new Vector2D<S>(0, cols);
		for (r in 0...vec.length){
			var vv = vec[r];
			for (c in 0...vv.length){
				v.set2(vv[c], r, c);
			}
		}
		return v;
	}
	
	/**
	 * @return	The prettified string of the Vector2D.
	 */
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