package msg.utils.states;
import haxe.ds.StringMap;

/**
 * Rinky-dink finite-state machine.
 * @author MSGHero
 */
class FSM{
	
	var previous:IState;
	var current:IState;
	
	/**
	 * Gets the previous state's name if it exists.
	 * @return
	 */
	public inline function getPrev():String { return previous == null ? "null" : previous.name; };
	
	/**
	 * Gets the current state's name if it exists.
	 * @return
	 */
	public inline function getCurr():String { return current == null ? "null" : current.name; };
	
	var stateMap:StringMap<IState>;
	var fromMap:StringMap<Array<String>>;
	
	/**
	 * Creates a new Finite State Machine.
	 */
	public function new() {
		reset();
	}
	
	/**
	 * Clears existing state-name mappings.
	 */
	public function reset():Void {
		stateMap = new StringMap<IState>();
		fromMap = new StringMap<Array<String>>();
		current = previous = null;
	}
	
	/**
	 * Adds a state mapping to the FSM.
	 * @param	stateName	Name of the state.
	 * @param	state		An instance of the state object itself which implements IState.
	 * @param	from		An array of state names that this state can transition from.
	 * 						Empty array or null means this state can transition from any state.
	 * @return	This, for method chaining.
	 */
	public function addState(stateName:String, state:IState, ?from:Array<String>):FSM {
		stateMap.set(stateName, state);
		fromMap.set(stateName, from == null ? [] : from);
		return this;
	}
	
	/**
	 * Calls istate.init(). Shorthand for method chaining.
	 * @param	stateName	The state to init.
	 * @return	This, for method chaining.
	 */
	public function initState(stateName:String):FSM {
		stateMap.get(stateName).init();
		return this;
	}
	
	/**
	 * Calls istate.destroy(). Shorthand for method chaining.
	 * @param	stateName	The state to destroy.
	 * @return	This, for method chaining.
	 */
	public function destroyState(stateName:String):FSM {
		stateMap.get(stateName).destroy();
		return this;
	}
	
	/**
	 * Calls init on all added states.
	 */
	public function initAll():Void {
		for (state in stateMap) state.init();
	}
	
	/**
	 * Calls destroy on all added states.
	 */
	public function destroyAll():Void {
		for (state in stateMap) state.destroy();
	}
	
	/**
	 * Updates the current state.
	 * @param	dt			Elapsed time.
	 */
	public inline function update(dt:Float):Void {
		current.update(dt);
	}
	
	/**
	 * Checks if a potential state swap is valid.
	 * @param	test		The new state to test.
	 * @param	from		The state to check the transition from.
	 * @return	If the state change is valid.
	 */
	public function canSwapFrom(test:String, from:String):Bool {
		var a = fromMap.get(test);
		return a.length == 0 || a.indexOf(from) != -1;
	}
	
	/**
	 * Changes the state of the FSM if the transition is valid.
	 * @param	newState	The state to transition to.
	 */
	public function swapStates(newState:String):Void {
		
		var ns = stateMap.get(newState);
		
		if (current == null) {
			current = ns;
			current.enter();
		}
		
		else if (current.name == newState) {
			// Lib.trace('Already in the ${current.name} state.');
		}
		
		else if (canSwapFrom(newState, current.name)) {
			current.exit();
			previous = current;
			current = ns;
			current.enter();
		}
		
		else {
			// Lib.trace('Cannot switch from ${current.name} to ${newState}.');
		}
	}
}