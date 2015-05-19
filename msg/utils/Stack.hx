package msg.utils;

/**
 * A LIFO stack of T.
 * @author MSGHero
 */
class Stack<T>{

	/** The array backing the stack. */
	var arr:Array<T>;
	/** The maintained length of the array. */
	public var length(default, null):Int;
	
	/**
	 * Creates a new stack.
	 */
	public function new() {
		clear();
	}
	
	/**
	 * Clears out the stack, setting the length back to zero.
	 */
	public function clear():Void {
		arr = [];
		length = 0;
	}
	
	/**
	 * Adds a T to the top of the stack.
	 * @param	t	A T to add.
	 */
	public function push(t:T):Void {
		arr[length++] = t;
	}
	
	/**
	 * Pops the T at the top of the stack.
	 * References to T remain in memory, so be wary.
	 * @return	The T at the top of the stack.
	 */
	public function pop():T {
		return arr[--length];
	}
	
	/**
	 * Pops the T at the top of the stack and removes it entirely.
	 * The references to T are removed.
	 * @return	The T at the top of the stack.
	 */
	public function popEntirely():T {
		var t = arr[--length];
		arr.remove(t);
		return t;
	}
	
	/**
	 * Returns, but does not pop, the T at the top of the stack.
	 * @return	The T at the top of the stack.
	 */
	public function peek():T {
		return arr[length - 1];
	}
	
	/**
	 * Returns the location of the T in the stack.
	 * The top of the stack is index 0.
	 * @param	t			The T to search for.
	 * @param	fromIndex	Optional index to begin searching from.
	 * @return
	 */
	public function indexOf(t:T, ?fromIndex:Int):Int {
		var i = arr.indexOf(t, fromIndex);
		return i == -1 ? i : length - i - 1;
	}
	
	/**
	 * If the stack is empty.
	 * @return	"
	 */
	public function isEmpty():Bool {
		return length == 0;
	}
}