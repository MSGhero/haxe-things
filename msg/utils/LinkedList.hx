package msg.utils;

/**
 * A doubly linked list of ILinked Ts, to avoid "node" object creation.
 * @author MSGHero
 */
class LinkedList<T:ILinked<T>> {

	public var first(default, null):T;
	public var last(default, null):T;
	
	/** The length of the linked list. */
	public var length(default, null):Int;
	
	/** If there's anything in the list or not. */
	public var isEmpty(get, never):Bool;
	inline function get_isEmpty():Bool { return length == 0; }
	
	/**
	 * Generates a new linked list from an Iterable, like an array.
	 * @param it	The iterable object to obtain Ts from.
	 * @return	The new linked list.
	 */
	public static function fromIterable<T:ILinked<T>>(it:Iterable<T>):LinkedList<T> {
		var ll = new LinkedList<T>();
		for (i in it.iterator()) ll.push(i);
		return ll;
	}
	
	/**
	 * Generates a new linked list from a single T.
	 * @param t	The ILinked object to add.
	 * @return	The new linked list.
	 */
	public static function fromNode<T:ILinked<T>>(t:T):LinkedList<T> {
		var ll = new LinkedList<T>();
		ll.push(t);
		return ll;
	}
	
	public function new() {
		first = last = null;
		length = 0;
	}
	
	/**
	 * Returns a new forward iterator.
	 * @return "
	 */
	public function iterator():ILinkedIterator<T> {
		return new ILinkedIterator<T>(first);
	}
	
	/**
	 * Returns a new reverse iterator.
	 * @return "
	 */
	public function reverseIterator():ILinkedIteratorReverse<T> {
		return new ILinkedIteratorReverse<T>(last);
	}
	
	/**
	 * Finds the index of the supplied T, if it is in the list.
	 * @param t	The T to find.
	 * @return	The index of t, or -1 if it is not found.
	 */
	public function indexOf(t:T):Int {
		
		if (isEmpty) return -1;
		
		var count = 0;
		var head = first;
		
		while (t != head && head.next != null) {
			head = head.next;
			count++;
		}
		
		return 
			if (t != head) -1;
			else count;
	}
	
	/**
	 * Gets the t at the supplied index.
	 * @param index	The index of the T to get.
	 * @return		The T at the supplied index, or null if the index is out of bounds.
	 */
	public function at(index:Int):T {
		
		if (isEmpty || index < 0 || index >= length) return null;
		
		var count = 0;
		var head = first;
		
		while (count < index && head.next != null) {
			head = head.next;
			count++;
		}
		
		return
			if (count == index) head;
			else null;
	}
	
	/**
	 * Clears out the linked list.
	 * @return	The first T of the list, if you need it.
	 */
	public function clear():T {
		
		var head = first;
		
		var tail = last;
		while (tail != null && tail.prev != null) {
			tail.next = null;
			tail = tail.prev;
			tail.next.prev = null;
		}
		
		if (tail != null) tail.next = null; // this is == first at this point
			
		first = last = null;
		length = 0;
		
		return head;
	}
	
	/**
	 * Removes a node from the linked list.
	 * This operates on the node only. It doesn't check if it was ever in this list or not.
	 * @param t	A T to remove from the list.
	 * @return	The T that was supplied.
	 */
	public function remove(t:T):T {
		
		if (t == first) return shift();
		if (t == last) return pop();
		
		var prev = t.prev;
		var next = t.next;
		
		prev.next = next;
		next.prev = prev;
		
		length--;
		
		return t;
	}
	
	/**
	 * Adds T at the specified index.
	 * @param t		A T to add to the list.
	 * @param index	The index to add T at.
	 */
	public function insertAt(t:T, index:Int):Void {
		
		if (index == 0) unshift(t);
		else insertAfter(t, at(index - 1));
	}
	
	/**
	 * Removes a node from a specified index.
	 * @param index	The index to remove T from.
	 * @return		The T that was at that index.
	 */
	public function removeAt(index:Int):T {
		
		return 
			if (index == 0) shift();
			else remove(at(index));
	}
	
	/**
	 * Adds T to the end of the list.
	 * @param t	A T to add to the list.
	 */
	public function push(t:T):Void {
		
		if (isEmpty) {
			first = last = t;
		}
		
		else {
			last.next = t;
			t.prev = last;
			last = t;
		}
		
		length++;
	}
	
	/**
	 * Removes the T at the end of the list.
	 * @return	The T that was at the end of the list.
	 */
	public function pop():T {
		
		if (isEmpty) return null;
		if (first == last) return clear();
		
		var tail = last;
		
		last = last.prev;
		last.next = null;
		tail.prev = null;
		
		length--;
		
		return tail;
	}
	
	/**
	 * Adds T to the front of the list.
	 * @param t	A T to add to the list.
	 */
	public function unshift(t:T):Void {
		
		if (isEmpty) {
			first = last = t;
		}
		
		else {
			t.next = first;
			first.prev = t;
			first = t;
		}
		
		length++;
	}
	
	/**
	 * Removes the T at the front of the list.
	 * @return	The T that was at the front of the list.
	 */
	public function shift():T {
		
		if (isEmpty) return null;
		if (first == last) return clear();
		
		var head = first;
		
		first = first.next;
		first.prev = null;
		head.next = null;
		
		length--;
		
		return head;
	}
	
	/**
	 * Adds T after another T.
	 * @param t		A T to add to the list.
	 * @param after	The T you want to place t after.
	 */
	public function insertAfter(t:T, after:T):Void {
		
		if (after == last) push(t);
		
		else {
			
			t.next = after.next;
			t.next.prev = t;
			after.next = t;
			t.prev = after;
			
			length++;
		}
	}
	
	/**
	 * Removes the T after another T.
	 * @param after	The T before the T you want to remove.
	 */
	public function removeAfter(after:T):T {
		return remove(after.next);
	}
	
	/**
	 * Adds T before another T.
	 * @param t		A T to add to the list.
	 * @param after	The T you want to place t before.
	 */
	public function insertBefore(t:T, before:T):Void {
		
		if (before == first) unshift(t);
		
		else {
			
			t.prev = before.prev;
			t.prev.next = t;
			before.prev = t;
			t.next = before;
			
			length++;
		}
	}
	
	/**
	 * Removes the T before another T.
	 * @param before	The T after the T you want to remove.
	 */
	public function removeBefore(before:T):T {
		return remove(before.prev);
	}
	
	/**
	 * Reverses the linked list, making all `next`s `prev`s and all `prev`s `next`s.
	 */
	public function reverse():Void {
		
		if (isEmpty || first == last) return;
		
		var head = first;
		
		while (head != null) {
			head.prev = head.next;
			head = head.next;
		}
		
		var head = first;
		
		while (head.prev != null) {
			head.next.next = head;
			head = head.prev;
		}
		
		first.next = null;
		
		head = first;
		first = last;
		last = head;
	}
}

/**
 * An interface for the linked list implementation, to avoid "node" object creation.
 * @author MSGHero
 */
 interface ILinked<T> {
	var next:T;
	var prev:T;
}

/**
 * The forward iterator for the linked list implementation.
 * @author MSGHero
 */
class ILinkedIterator<T:ILinked<T>> {
	
	var head:T;
	
	public function new(head:T) {
		this.head = head;
	}
	
	public function hasNext():Bool {
		return head != null;
	}
	
	public function next():T {
		
		var ret = head;
		head = head.next;
		
		return ret;
	}
}

/**
 * The reverse iterator for the linked list implementation.
 * @author MSGHero
 */
class ILinkedIteratorReverse<T:ILinked<T>> {
	
	var tail:T;
	
	public function new(tail:T) {
		this.tail = tail;
	}
	
	public function hasNext():Bool {
		return tail.prev != null;
	}
	
	public function next():T {
		
		var ret = tail;
		tail = tail.prev;
		
		return ret;
	}
}