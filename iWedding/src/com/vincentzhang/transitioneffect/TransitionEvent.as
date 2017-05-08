package com.vincentzhang.transitioneffect
{
	import flash.events.Event;
	
	public class TransitionEvent extends Event
	{
		public static const TRANSITION_FINISHED:String = "transitionFinished";

		public function TransitionEvent($type:String, $bubbles:Boolean = true, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
		}
		
		public override function clone():Event  
        {  
            return new TransitionEvent(this.type, this.bubbles, this.cancelable);  
        }
		
		public override function toString():String  
        {  
            return formatToString("TransitionEvent", "type", "bubbles", "cancelable");  
        }
	}
	
}
