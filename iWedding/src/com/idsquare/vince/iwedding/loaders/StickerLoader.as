package com.idsquare.vince.iwedding.loaders 
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.AVM1Movie;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import com.idsquare.vince.iwedding.GlobalModelManager;
	import com.vincentzhang.utils.BeagleLog;
	
	public class StickerLoader extends EventDispatcher
	{
	// CONSTANTS:	
		public static const STICKERS_LOADED:String = "stickersLoaded";
	// logging utilities:
		/**
		 * @private
		 */	
		private var _logger:BeagleLog = BeagleLog.getLogger();	
	// loading utilities:
		/**
		 * @private
		 */		
		private var _stickerLoader:Loader;
		/**
		 * @private
		 */	
		private var _loadingCounter:uint;
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */	
		public function StickerLoader() 
		{
			// constructor code
		}
		
		
		public function startLoadSticker():void
		{
			this._loadingCounter = 0;
			this.loadSticker();
		}
		
		
		private function loadSticker():void
		{
			var $req:URLRequest = new URLRequest(GlobalModelManager.STICKER_FOLDER + GlobalModelManager.stickerList[this._loadingCounter].file.toString());
			this._stickerLoader = new Loader();
			this._stickerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.stickerLoadedHandler);
			this._stickerLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.stickerIOErrorHandler);
			this._stickerLoader.load($req);
		}
		
		
		private function stickerLoadedHandler($e:Event):void
		{
			this._stickerLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.stickerLoadedHandler);
			this._stickerLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.stickerIOErrorHandler);
			
			//GlobalModelManager.stickerList[this._loadingCounter].sticker = this._stickerLoader.contentLoaderInfo.content as AVM1Movie;
			GlobalModelManager.stickerList[this._loadingCounter].sticker = this._stickerLoader.contentLoaderInfo.content as MovieClip;
			GlobalModelManager.stickerList[this._loadingCounter].sticker.scaleX = 0.4;
			GlobalModelManager.stickerList[this._loadingCounter].sticker.scaleY = 0.4;
			GlobalModelManager.stickerList[this._loadingCounter].sticker.x = GlobalModelManager.stickerList[this._loadingCounter].x;
			GlobalModelManager.stickerList[this._loadingCounter].sticker.y = GlobalModelManager.stickerList[this._loadingCounter].y;
			
			this._loadingCounter++;
			
			if (this._loadingCounter == GlobalModelManager.stickerList.length)
			{
				var $evt:Event = new Event(STICKERS_LOADED);
				this.dispatchEvent($evt);
			}
			else
			{
				this.loadSticker();
			}
		}
		
		
		private function stickerIOErrorHandler($e:IOErrorEvent):void
		{
			this._logger.buildInError("loading sticker[" + this._loadingCounter + "] failed", $e.toString(),
				"com.idsquare.vince.iwedding.loaders.StickerLoader::stickerIOErrorHandler()");
			// prompt user
			this._stickerLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.stickerLoadedHandler);
			this._stickerLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.stickerIOErrorHandler);
		}
		

	}
	
}
