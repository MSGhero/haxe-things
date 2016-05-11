package msg.utils;

/**
 * A 2D array backed by a 1D array.
 * @author MSGHero
 */
class Array2D<T>{

	/** The underlying array. **/
	var _arr:Array<T>;
	
	/** The number of columns. This can be changed at any time. **/
	public var cols:Int;
	/** The number of rows. Readonly. **/
	@:isVar public var rows(get, never):Int;
	/** Calcs the number of rows. **/
	inline function get_rows():Int { return Math.ceil(length / cols); }
	
	/** The true length of the array, not just rows * cols. **/
	public var length(get, never):Int;
	inline function get_length():Int { return _arr.length; }
	
	// inline everything when the haxe issue is resolved
	
	/**
	 * Creates a new Array2D.
	 * @param	numCols	The number of columns.
	 */
	public function new(numCols:Int) {
		_arr = [];
		cols = numCols;
	}
	
	/**
	 * Just the core array's iterator.
	 */
	public function iterator() {
		return _arr.iterator();
	}
	
	/**
	 * Clears the array and fills it with the supplied T.
	 * @param	t	What to fill the array with.
	 * @param	len	How many Ts to add.
	 */
	public function fill1(t:T, len:Int):Void {
		clear();
		while (len-- > 0) {
			_arr[_arr.length] = t;
		}
	}
	
	/**
	 * Clears the array and fills it with the supplied T. Changes the number of columns.
	 * @param	t		What to fill the array with.
	 * @param	numRows	How many rows of Ts to add.
	 * @param	numCols	How many cols of Ts to add. The new number of columns gets set to this value.
	 */
	public function fill2(t:T, numRows:Int, numCols:Int):Void {
		cols = numCols;
		fill1(t, numRows * numCols);
	}
	
	/**
	 * Fills the specified 1D range with T.
	 * @param	t		What to fill the array with.
	 * @param	start	The starting index.
	 * @param	len		How many Ts to add.
	 */
	public function fillAt1(t:T, start:Int, len:Int):Void {
		var i = 0;
		while (i++ < len) {
			_arr[start + i] = t;
		}
	}
	
	/**
	 * Fills the specified 2D range with T.
	 * @param	t			What to fill the array with.
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
	 * Fills the array with a 1D array from the supplied index.
	 * Overwrites existing data and adds to the length as necessary.
	 * @param	arr		The 1D array to overwrite data with.
	 * @param	index	The index to start copying data to.
	 */
	public function fillWith1(arr:Array<T>, index:Int):Void {
		var i = 0;
		while (i < arr.length) set1(arr[i], index + i++);
	}
	
	/**
	 * Fills the array with an Array2D from the supplied row and col.
	 * @param	arr			The Array2D to overwrite data with.
	 * @param	startRow	The row to start copying data to.
	 * @param	startCol	The col to start copying data to.
	 */
	public function fillWith2(arr:Array2D<T>, startRow:Int, startCol:Int):Void {
		for (rr in 0...arr.rows) {
			for (cc in 0...arr.cols) {
				set2(arr.get2(rr, cc), startRow + rr, startCol + cc);
			}
		}
	}
	
	/**
	 * Gets a value from a 1D index.
	 * @param	index	The index of the T.
	 * @return	The T at the index.
	 */
	public function get1(index:Int):T {
		return _arr[index];
	}
	
	/**
	 * Sets a value from a 1D index.
	 * @param	t		What to set at the index.
	 * @param	index	The index of the T.
	 * @return	The T.
	 */
	public function set1(t:T, index:Int):T {
		return _arr[index] = t;
	}
	
	/**
	 * Gets a value from a 2D index.
	 * @param	row	The row of the T.
	 * @param	col	The col of the T.
	 * @return	The T at the index.
	 */
	public function get2(row:Int, col:Int):T {
		return _arr[row * cols + col];
	}
	
	/**
	 * Sets a value from a 2D index.
	 * @param	t	What to set at the index.
	 * @param	row	The row of the T.
	 * @param	col	The col of the T.
	 * @return	The T.
	 */
	public function set2(t:T, row:Int, col:Int):T {
		return _arr[row * cols + col] = t;
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
	 * Adds to the end of the array.
	 * @param	t	The T to add.
	 * @return	The new length of the array.
	 */
	public function push(t:T):Int {
		_arr[length] = t;
		return length;
	}
	
	/**
	 * Removes from the end of the array.
	 * @return	The removed T.
	 */
	public function pop():T {
		return _arr.pop();
	}
	
	/**
	 * Creates a shallow copy of this Array2D using a 1D range.
	 * The new array has the same number of columns as this one.
	 * @param	startIndex	The starting index.
	 * @param	len			How many Ts to copy.
	 * @return	The new Array2D.
	 */
	public function slice1(startIndex:Int, len:Int):Array2D<T> {
		var a = new Array2D<T>(cols);
		var i = 0;
		while (i++ < len) a.push(_arr[startIndex + i]);
		return a;
	}
	
	/**
	 * Creates a shallow copy of this Array2D using a 2D range.
	 * The number of columns in the new array is equal to numCols.
	 * @param	startRow	The starting row.
	 * @param	startCol	The starting col.
	 * @param	numRows		How many rows to copy.
	 * @param	numCols		How many cols to copy. Also the number of cols of the output Array2D.
	 * @return	The new Array2D.
	 */
	public function slice2(startRow:Int, startCol:Int, numRows:Int, numCols:Int):Array2D<T> {
		var a = new Array2D<T>(numCols);
		for (rr in 0...numRows) {
			for (cc in 0...numCols) {
				a.push(get2(startRow + rr, startCol + cc));
			}
		}
		return a;
	}
	
	/**
	 * Produces a shallow copy of the entire Array2D with the same number of columns.
	 * @return	The new Array2D.
	 */
	public function copy():Array2D<T> {
		var a = new Array2D<T>(cols);
		a._arr = _arr.copy();
		return a;
	}
	
	/**
	 * Creates a new Array2D of type S by applying the mapping function to each element of this Array2D of type T.
	 * @param	mapFunction		Each element of this Array2D is passed into this function, and a new Array2D is created from the returned values.
	 * @return	The mapped Array2D of type S.
	 */
	public function map<S>(mapFunction:T->S):Array2D<S> {
		var a = new Array2D<S>(cols);
		a._arr = _arr.map(mapFunction);
		return a;
	}
	
	/**
	 * Empties the entire array.
	 */
	public function clear():Void {
		_arr.splice(0, length);
	}
	
	/**
	 * Creates an Array<T> from this Array2D<T>.
	 * @return	The 1D array representation of the data.
	 */
	public function to1DArray():Array<T> {
		return _arr.copy();
	}
	
	/**
	 * Creates an Array<Array<T>> from this Array2D<T>.
	 * @return	The 2D array representation of the data.
	 */
	public function to2DArray():Array<Array<T>> {
		
		var data:Array<Array<T>> = [];
		
		for (rr in 0...rows) {
			var a:Array<T> = [];
			for (cc in 0...cols) {
				a.push(get2(rr, cc));
			}
			data.push(a);
		}
		
		return data;
	}
	
	/**
	 * Creates an Array2D<T> from the supplied Array<T>.
	 * @param	arr		The 1D array to convert.
	 * @param	cols	The number of columns the Array2D should have.
	 * @return	The Array2D representation of the data.
	 */
	public static function from1DArray<S>(arr:Array<S>, cols:Int):Array2D<S>{
		var a = new Array2D<S>(cols);
		a._arr = arr;
		return a;
	}
	
	/**
	 * Creates an Array2D<T> from the supplied Array<Array<T>>.
	 * @param	arr		The 2D array to convert.
	 * @param	cols	The number of columns the Array2D should have.
	 * @return	The Array2D representation of the data.
	 */
	public static function from2DArray<S>(arr:Array<Array<S>>, cols:Int):Array2D<S>{
		var a = new Array2D<S>(cols);
		for (r in 0...arr.length){
			var aa = arr[r];
			for (c in 0...aa.length){
				a.push(aa[c]);
			}
		}
		return a;
	}
	
	/**
	 * @return	The prettified string of the Array2D.
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