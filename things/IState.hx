package;

/**
 * State interface for FSM.
 * @author MSGHero
 */

interface IState {
	
  /**
   * Name of the state, defined internally.
   */
  var name(default, null):String;
  
  /**
   * Called when this state is transitioned to.
   */
  function enter():Void;
  
  /**
   * Called when this state is transitioned from.
   */
  function exit():Void;
  
  /**
   * Call to clear the state of references.
   */
  function destroy():Void;
  
  /**
   * Called when the state machine is updated.
   * @param	dt		Elapsed time.
   */
  function update(dt:Float):Void;
}