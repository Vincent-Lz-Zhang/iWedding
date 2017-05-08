package com.idsquare.vince.iwedding.loaders 
{
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	import com.idsquare.vince.iwedding.GlobalModelManager;
	
	/**
	 * Custom loader be responsive to load config XMLs.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.iwedding.loaders.StickerListLoader
	 * 
	 * 
	 * edit 0
	 *
	 */
		
	public class StickerListLoader extends EventDispatcher
	{
	// CONSTANTS:	
		public static const STICKER_LIST_LOADED:String = "stickerListLoaded";
		
	// loading utilities:
		/**
		 * @private
		 */	
		private var _xmlLoader:URLLoader;	
		

	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */	
		public function StickerListLoader() 
		{
			// constructor code
		}
		
		
		/**
		 * Start the process of the chained loading action, begin at config XML.
		 *  config.
		 *
		 * @see		
		 */
		public function load():void 
		{
			var $req:URLRequest = new URLRequest(GlobalModelManager.XML_PATH + GlobalModelManager.STICKER_XML);
			this._xmlLoader = new URLLoader();
			this._xmlLoader.addEventListener(Event.COMPLETE, this.stkrListLoadedHandler);
			this._xmlLoader.load($req);
		}		
		
	// HANDLERS:
	
		/**
		 * Event handler for the Complete event of loading config XML.
		 *  Store the data to GlobalModelManager.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function stkrListLoadedHandler($e:Event):void
		{
			try{
				
			}
			catch($er:Error){}
			
			this._xmlLoader.removeEventListener(Event.COMPLETE, this.stkrListLoadedHandler);
			
			
			var $evt:Event = new Event(STICKER_LIST_LOADED);
			this.dispatchEvent($evt);
			
		}
		
		
	}
	
}
