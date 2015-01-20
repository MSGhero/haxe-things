package msg.utils.states;

/**
 * Push-down automata blah blah Finite State Machine
 * @author MSGHero
 */
class StackFSM extends FSM{

	/** The stack backing the fsm's current states. */
	var stack:Stack<String>;
	
	/**
	 * Creates a new FSM based on a Stack.
	 */
	public function new() {
		super();
		
	}
	
	/**
	 * Clears the stack of states.
	 */
	override public function reset():Void {
		super.reset();
		stack = new Stack<String>();
	}
	
	/**
	 * Adds a state to the top of the stack.
	 * The current state is suspended until the new state is removed.
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
			
			current.suspend();
			previous = current;
			current = ns;
			stack.push(newState);
			current.enter();
		}
		
		else {
			// error
		}
	}
	
	/**
	 * Removes the top state from the stack.
	 * The next state in the stack is revived.
	 * @return	The name of the popped state.
	 */
	public function pop():String {
		
		current.exit();
		previous = current;
		var old = stack.popEntirely();
		
		current = stateMap.get(stack.peek());
		current.revive();
		
		return old;
	}
	
	/**
	 * Pops up to, but not including, the specified state.
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
			current.enter();
		}
		
		else if (canSwapFrom(newState, current.name)) {
			
			current.exit();
			previous = current;
			stack.popEntirely();
			
			current = ns;
			stack.push(newState);
			current.enter();
		}
		
		else {
			// error
		}
	}
}