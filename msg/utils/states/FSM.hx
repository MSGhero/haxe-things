package msg.utils.states;
import haxe.ds.StringMap;

/**
 * Rinky-dink finite-state machine.
 * @author MSGHero
 */
class FSM {
	
	var previous:IState;
	var current:IState;
	var next:IState;
	
	/**
	 * Gets the previous state, if it exists.
	 * @return
	 */
	public inline function getPrev():IState { return previous; };
	
	/**
	 * Gets the current state, if it exists.
	 * @return
	 */
	public inline function getCurr():IState { return current; };
	
	/**
	 * Gets the next state, if it exists.
	 * This will only exist during state transitions.
	 * @return
	 */
	public inline function getNext():IState { return next; };
	
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
		current = previous = next = null;
	}
	
	/**
	 * Destroys the FSM entirely to ensure GC removal.
	 * Call reset() if you need to use this FSM again.
	 */
	public function destroy():Void {
		
		destroyAll();
		
		stateMap = null;
		fromMap = null;
		current = previous = next = null;
	}
	
	/**
	 * Adds a state mapping to the FSM.
	 * @param	state		An instance of the state object itself which implements IState.
	 * @param	from		An array of state names that this state can transition from.
	 * 						Empty array or null means this state can transition from any state.
	 * @return	This, for method chaining.
	 */
	public function addState(state:IState, ?from:Array<String>):FSM {
		stateMap.set(state.name, state);
		fromMap.set(state.name, from == null ? [] : from);
		return this;
	}
	
	/**
	 * Removes a state mapping from the FSM.
	 * @param	stateName	Name of the state.
	 * @return	This, for method chaining.
	 */
	public function removeState(stateName:String):FSM {
		stateMap.remove(stateName);
		fromMap.remove(stateName);
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
		if (stateMap != null) for (state in stateMap) state.destroy();
	}
	
	/**
	 * Updates the current state.
	 * @param	dt			Elapsed time.
	 */
	public function update(dt:Float):Void {
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
		/*
		else if (current.name == newState) {
			// I don't think this should be undealt with, remove?
		}
		*/
		else if (canSwapFrom(newState, current.name)) {
			next = ns;
			current.exit();
			previous = current;
			current = ns;
			next = null;
			current.enter();
		}
		
		else {
			throw 'Cannot switch from State ${current.name} to State ${newState}.';
		}
	}
}