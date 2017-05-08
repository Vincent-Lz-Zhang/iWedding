package com.idsquare.vince.iwedding.loaders 
{
	import flash.events.EventDispatcher;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import com.idsquare.vince.iwedding.GlobalModelManager;
	import com.vincentzhang.utils.BeagleLog;
	
	public class PaperTextureLoader extends EventDispatcher
	{
	// CONSTANTS:	
		public static const TEX_LOADED:String = "textureLoaded";
	// logging utilities:
		/**
		 * @private
		 */	
		private var _logger:BeagleLog = BeagleLog.getLogger();	
		/**
		 * @private
		 */	
		private var _txtrLoader:Loader;
		/**
		 * @private
		 */	
		private var _file:String = GlobalModelManager.PAPER_FOLDER + GlobalModelManager.settings.papers.textures[0].toString();
		//private var _callBack:Function;
		
		/**
		 * @private
		 */	
		private var _menuIcon_LoadingCounter:uint = 0;
		/**
		 * @private
		 */	
		private var _stkSfSkin_LoadingCounter:uint = 0;
		
		public function PaperTextureLoader($cb:Function = null) 
		{
			
		}
		
		
		public function loadTexture():void
		{
			var $req:URLRequest = new URLRequest(this._file);
			this._txtrLoader = new Loader();
			this._txtrLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.txtrLoadedHandler);
			this._txtrLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.txtrIOErrorHandler);
			this._txtrLoader.load($req);
		}
		
		
		private function loadSavingPrompt():void
		{
			var $req:URLRequest = new URLRequest("skin/" + GlobalModelManager.promptConfig.file.toString());
			this._txtrLoader = new Loader();
			this._txtrLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.svPrptLoadedHandler);
			this._txtrLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.svPrptIOErrorHandler);
			this._txtrLoader.load($req);
		}
		
		
		private function loadGreetings():void
		{
			var $req:URLRequest = new URLRequest("skin/" + GlobalModelManager.greetingsConfig.file.toString());
			this._txtrLoader = new Loader();
			this._txtrLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.greetingsLoadedHandler);
			this._txtrLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.greetingsIOErrorHandler);
			this._txtrLoader.load($req);
		}
		
		
		private function startLoadMenuIcons():void
		{
			this._menuIcon_LoadingCounter = 0;
			this.loadMenuIcon();
		}
		
		
		private function loadMenuIcon():void
		{
			var $req:URLRequest = new URLRequest("skin/" + GlobalModelManager.menuIcons[this._menuIcon_LoadingCounter].file.toString());
			this._txtrLoader = new Loader();
			this._txtrLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.menuIconLoadedHandler);
			this._txtrLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.menuIconLoadedHandler);
			this._txtrLoader.load($req);
		}
		
		
		private function startLoadStkSfSkin():void
		{
			if (GlobalModelManager.stickerConfig.skin.length == 0)
			{
				// broadcast that the paper texture is loaded
				var $evt:Event = new Event(TEX_LOADED);
				this.dispatchEvent($evt);
			}
			this._stkSfSkin_LoadingCounter = 0;
			this.loadStkSfSkin();
		}
		
		
		private function loadStkSfSkin():void
		{
			var $req:URLRequest = new URLRequest("skin/" + GlobalModelManager.stickerConfig.skin[this._stkSfSkin_LoadingCounter].file.toString());
			this._txtrLoader = new Loader();
			this._txtrLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.stkSfSkinLoadedHandler);
			this._txtrLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.stkSfSkinIOErrorHandler);
			this._txtrLoader.load($req);
		}
		
		
		
	// HANDLERS:	
		
		private function txtrLoadedHandler($e:Event):void
		{
			this._txtrLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.txtrLoadedHandler);
			this._txtrLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.txtrIOErrorHandler);
			//trace($e.target.content);	// Bitmap
			GlobalModelManager.paper = $e.target.content.bitmapData;
			
			// start loading menu icons
			this.loadSavingPrompt();
		}
		
		
		private function txtrIOErrorHandler($e:IOErrorEvent):void
		{
			this._logger.buildInError("loading texture failed...", $e.toString(), 
				"com.idsquare.vince.iwedding.loaders.PaperTextureLoader::txtrIOErrorHandler()");
			this._txtrLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.txtrLoadedHandler);
			this._txtrLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.txtrIOErrorHandler);
		}
		
		
		private function svPrptLoadedHandler($e:Event):void
		{
			this._txtrLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.svPrptLoadedHandler);
			this._txtrLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.svPrptIOErrorHandler);
			//trace($e.target.content);	// Bitmap
			GlobalModelManager.promptConfig.bmd = $e.target.content.bitmapData;
			
			// start loading menu icons
			this.loadGreetings();
		}
		
		
		private function svPrptIOErrorHandler($e:IOErrorEvent):void
		{
			this._logger.buildInError("loading saving prompt failed...", $e.toString(), 
				"com.idsquare.vince.iwedding.loaders.PaperTextureLoader::svPrptIOErrorHandler()");
			this._txtrLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.svPrptLoadedHandler);
			this._txtrLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.svPrptIOErrorHandler);
		}
		
		
		private function greetingsLoadedHandler($e:Event):void
		{
			this._txtrLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.greetingsLoadedHandler);
			this._txtrLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.greetingsIOErrorHandler);
			//trace($e.target.content);	// Bitmap
			GlobalModelManager.greetingsConfig.bmd = $e.target.content.bitmapData;
			
			// start loading menu icons
			this.startLoadMenuIcons();
		}
		
		
		private function greetingsIOErrorHandler($e:IOErrorEvent):void
		{
			this._logger.buildInError("loading greetings failed...", $e.toString(), 
				"com.idsquare.vince.iwedding.loaders.PaperTextureLoader::greetingsIOErrorHandler()");
			this._txtrLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.greetingsLoadedHandler);
			this._txtrLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.greetingsIOErrorHandler);
		}
		
		
		
		private function menuIconLoadedHandler($e:Event):void
		{
			GlobalModelManager.menuIcons[this._menuIcon_LoadingCounter].bmd = $e.target.content.bitmapData;
			
			this._menuIcon_LoadingCounter++;
			if (this._menuIcon_LoadingCounter == GlobalModelManager.menuIcons.length)
			{
				this._txtrLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.menuIconLoadedHandler);
				this._txtrLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.menuIconIOErrorHandler);
				
				// start loading sticker shelf skin pieces
				this.startLoadStkSfSkin();
			}
			else
			{
				this.loadMenuIcon();
			}
		}
		
		
		private function menuIconIOErrorHandler($e:IOErrorEvent):void
		{
			this._logger.buildInError("loading menu icon[" + this._menuIcon_LoadingCounter +"] failed...", $e.toString(), 
				"com.idsquare.vince.iwedding.loaders.PaperTextureLoader::menuIconIOErrorHandler()");
			this._txtrLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.menuIconLoadedHandler);
			this._txtrLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.menuIconIOErrorHandler);
		}
		
		
		
		private function stkSfSkinLoadedHandler($e:Event):void
		{
			GlobalModelManager.stickerConfig.skin[this._stkSfSkin_LoadingCounter].bmd = $e.target.content.bitmapData;
			
			this._stkSfSkin_LoadingCounter++;
			if (this._stkSfSkin_LoadingCounter == GlobalModelManager.stickerConfig.skin.length)
			{
				this._txtrLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.stkSfSkinLoadedHandler);
				this._txtrLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.stkSfSkinIOErrorHandler);
				
				// broadcast that the paper texture is loaded
				var $evt:Event = new Event(TEX_LOADED);
				this.dispatchEvent($evt);
			}
			else
			{
				this.loadStkSfSkin();
			}
		}
		
		
		private function stkSfSkinIOErrorHandler($e:IOErrorEvent):void
		{
			this._logger.buildInError("loading sticker shelf skin[" + this._menuIcon_LoadingCounter +"] failed...", $e.toString(), 
				"com.idsquare.vince.iwedding.loaders.PaperTextureLoader::stkSfSkinIOErrorHandler()");
			this._txtrLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.stkSfSkinLoadedHandler);
			this._txtrLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.stkSfSkinIOErrorHandler);
		}
		
		

	}
	
}
