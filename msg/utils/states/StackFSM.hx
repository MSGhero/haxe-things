package msg.utils.states;

/**
 * Push-down automata blah blah Finite State Machine
 * @author MSGHero
 */
class StackFSM extends FSM {

	/** The stack backing the fsm's current states. */
	var stack:Stack<String>;
	
	/** Used to keep track of newly added states, which shouldn't be update()d on the frame they're added */
	var fresh:Bool;
	
	/**
	 * Creates a new FSM based on a Stack.
	 */
	public function new() {
		super();
		
		fresh = false;
	}
	
	/**
	 * Clears the stack of states.
	 */
	override public function reset():Void {
		super.reset();
		stack = new Stack<String>();
		fresh = false;
	}
	
	/**
	 * Adds a state to the top of the stack.
	 * The current state is suspended until the new state is removed.
	 * Keep in mind that suspended states are still update()d.
	 * You should include logic in suspend() and update() to achieve the desired effect.
	 * @param	newState	Name of the state.
	 */
	public function push(newState:String):Void {
		
		var ns = stateMap.get(newState);
		
		if (current == null) {
			current = ns;
			stack.push(newState);
			current.enter();
		}
		
		else if (canSwapFrom(newState, current.name)) {
			
			next = ns;
			
			current.suspend();
			
			next = null;
			
			previous = current;
			current = ns;
			
			stack.push(newState);
			current.enter();
		}
		
		else {
			throw 'Cannot push State ${newState} onto State ${current.name}.';
		}
		
		fresh = true;
	}
	
	/**
	 * Removes the top state from the stack.
	 * The next state in the stack is revived.
	 * @return	The name of the popped state.
	 */
	public function pop():String {
		
		next = previous;
		
		current.exit();
		
		previous = current;
		next = null;
		
		var old = stack.popEntirely();
		
		current = stateMap.get(stack.peek());
		current.revive();
		
		return old;
	}
	
	/**
	 * Checks if the specified state is already on the stack.
	 * You can have more than one of a state on the stack.
	 * @param searchState 	The state to search for.
	 * @return Bool
	 */
	public function onStack(searchState:String):Bool {
		return stack.indexOf(searchState) > -1;
	}
	
	/**
	 * Pops up to, but not including, the topmost instance of the specified state.
	 * I.e. removes all states above the specified and makes it the current.
	 * @param	searchState	The state to search for and make current.
	 * @return	The number of states that were popped.
	 */
	public function popUntil(searchState:String):Int {
		
		var i = stack.indexOf(searchState);
		var o = i;
		
		if (i == -1) {
			o = 0;
		}
		
		else {
			
			i = 0;
			while (o > i++) {
				pop();
			}
		}
		
		return o;
	}
	
	/**
	 * Changes the state of the FSM if the transition is valid.
	 * This only swaps the state at the top of the stack and only checks for valid transitions with that state.
	 * @param	newState	The state to transition to.
	 */
	override public function swapStates(newState:String):Void {
		
		var ns = stateMap.get(newState);
		
		if (current == null) {
			current = ns;
			stack.push(newState);
			current.enter();
		}
		
		else if (canSwapFrom(newState, current.name)) {
			
			next = ns;
			
			current.exit();
			previous = current;
			stack.popEntirely();
			
			next = null;
			
			current = ns;
			stack.push(newState);
			current.enter();
		}
		
		else {
			throw 'Cannot switch from State ${current.name} to State ${newState}.';
		}
		
		fresh = true;
	}
	
	override function update(dt:Float) {
		
		for (state in stack) {
			
			if (fresh) {
				fresh = false;
				break;
			}
			
			stateMap.get(state).update(dt);
		}
	}
}