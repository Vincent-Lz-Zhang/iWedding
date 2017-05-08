package com.idsquare.vince.iwedding.events 
{
	import flash.events.Event;
	
	/**
	 * .
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.iwedding.events.StickersShelfEvent
	 * 
	 * 
	 * edit 0
	 *
	 */
	public class StickersShelfEvent extends Event
	{
	// CONSTANTS:		
	
		public static const STICKER_SELECTED:String = "stickerSelected";
		
		public var stickerId:uint;
	
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *
		 * @param	$type	.
		 * @param	$stickerId	.
		 * @param	$bubbles	.
		 * @param	$cancelable	.
		 * 
		 */	
		public function StickersShelfEvent($type:String, $stickerId:uint, $bubbles:Boolean = true, $cancelable:Boolean = false) 
		{
			super($type, $bubbles, $cancelable);
			this.stickerId = $stickerId;
		}
		
		
	// OVERRIDES:		
	
		/**
		 * should be declared as Event or StickersShelfEvent ?
		 * 
		 * @return	The new created StickersShelfEvent instance.
		 * 
		 * @see		
		 */
		public override function clone():Event  
        {  
            return new StickersShelfEvent(this.type, this.stickerId, this.bubbles, this.cancelable);  
        }
		
		
		/**
		 * 
		 * @return	The description text.
		 * 
		 * @see		
		 */
		public override function toString():String  
        {  
            return formatToString("StickersShelfEvent", "stickerId", "type", "bubbles", "cancelable");  
        }		


	}
	
}
