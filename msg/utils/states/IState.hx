package msg.utils.states;

/**
 * State interface for FSM.
 * @author MSGHero
 */

interface IState {
	
  /**
   * Name of the state, defined internally.
   */
  var name(get, never):String;
  
  /**
   * Call to set up the state's initial...state.
   */
  function init():Void;
  
  /**
   * Call to clear the state of references.
   */
  function destroy():Void;
  
  /**
   * Called when this state is transitioned to.
   */
  function enter():Void;
  
  /**
   * Called when this state is transitioned from.
   */
  function exit():Void;
  
  /**
   * Called when this state is transitioned from temporarily (i.e. in a Stack FSM).
   */
  function suspend():Void;
  
  /**
   * Called when this state is transitioned back to (i.e. in a Stack FSM).
   */
  function revive():Void;
  
  /**
   * Called when the state machine is updated.
   * @param	dt		Elapsed time.
   */
  function update(dt:Float):Void;
}