package utils;

/**
 * Object pool for classes with parameterless constructors.
 * Uses pure array access for fast pooling. No pushing, popping, or splicing needed.
 * Extend this and override get/preAllocate if your class's constructor has required parameters (or for other reasons).
 * @author MSGHero
 */
class Pool<T> {
	
	/** The active and inactive portions of this pool. */
	var _pool:Array<T>;
	
	/** The class type of this pool. */
	var _class:Class<T>;
	
	/** Length of the active portion of the pool. */
	public var length(default, null):Int;

	/**
	 * Creates a new pool. Looks like: "var pool = new Pool<MyClass>(MyClass);"
	 * @param	classObj	Class with a parameterless (or optional parameter) constructor.
	 */
	public function new(classObj:Class<T>) {
		_pool = [];
		_class = classObj;
		length = 0;
	}

	/**
	 * Gets a T from the pool.
	 * Be sure to reset the object's properties afterwards as their values may not be the defaults.
	 * @return	A new or recycled T.
	 */
	public function get():T {
		if (length == 0) return Type.createInstance(_class, []);
		return _pool[--length]; // splicing is expensive, faking the pool length is not
	}

	/**
	 * Puts a T into the pool unsafely. Faster than putSafely().
	 * Putting the same object into the pool twice will probably give you issues, be careful!
	 * Be wary of references in the object's properties as those will persist.
	 * @param	obj	A T to recycle.
	 */
	public function put(obj:T):Void {
		_pool[length++] = obj;
	}
	
	/**
	 * Puts a T into the pool safely. Slower than put().
	 * This isn't needed if your pooling is properly managed, but it's here for you just in case.
	 * Be wary of references in the object's properties as those will persist.
	 * @param	obj	A T to recycle.
	 */
	public function putSafely(obj:T):Void {
		var i = _pool.indexOf(obj);
		if (i == -1 || i >= length) _pool[length++] = obj; // anything on or after length isn't part of the active pool
	}

	/**
	 * Fills or adds to the pool ahead of time.
	 * @param	numObjects	Number of Ts to add.
	 */
	public function preAllocate(numObjects:Int):Void {
		while (numObjects-- > 0) _pool[length++] = Type.createInstance(_class, []);
	}

	/**
	 * Clears and returns the entire (active + inactive) pool.
	 * Keep track of the length beforehand if you plan on doing something with the active pool.
	 * @return	The old pool.
	 */
	public function clear():Array<T> {
		length = 0;
		var oldPool = _pool;
		_pool = [];
		return oldPool;
	}
}