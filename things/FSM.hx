package;
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
	 */
	public function addState(stateName:String, state:IState, from:Array<String>):Void {
		stateMap.set(stateName, state);
		fromMap.set(stateName, from);
	}
	
	/**
	 * Updates the current state.
	 * @param	dt			Elapsed time.
	 */
	public inline function update(dt:Float):Void {
		current.update(dt);
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
		
		else if (fromMap.get(newState).indexOf(current.name) != -1) {
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