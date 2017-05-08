package com.idsquare.vince.iwedding 
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import com.idsquare.vince.iwedding.loaders.PaperTextureLoader;
	import com.idsquare.vince.iwedding.loaders.ConfigLoader;
	import com.idsquare.vince.iwedding.loaders.StickerLoader;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	
	public class InitializationManager extends EventDispatcher
	{
		
	// CONSTANTS:	
		public static const INITIALIZED:String = "initialized";
		
		private var _papTxtrLdr:PaperTextureLoader;
		private var _confLdr:ConfigLoader;
		private var _stickerLdr:StickerLoader;
		private var _stage:Stage;
		
		public function InitializationManager() 
		{
			// constructor code
		}
		
		public function init($stage:Stage):void
		{
			// active full-screen mode
			this._stage = $stage;
			this._stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			// active GreenSocker plugin for brightness change
			TweenPlugin.activate([ColorTransformPlugin]);
			// start loading
			this.loadConfig();
		}
		
		private function loadConfig():void
		{
			this._confLdr = new ConfigLoader();
			this._confLdr.addEventListener(ConfigLoader.CONFIG_LOADED, this.confLoadedHandler);
			this._confLdr.load();
		}
		
		private function loadPaperTexture():void
		{
			this._papTxtrLdr = new PaperTextureLoader();
			this._papTxtrLdr.addEventListener(PaperTextureLoader.TEX_LOADED, this.txtrLoadedHandler);
			this._papTxtrLdr.loadTexture();
		}
		
		
		private function loadStickers():void
		{
			this._stickerLdr = new StickerLoader();
			this._stickerLdr.addEventListener(StickerLoader.STICKERS_LOADED, this.stickerLoadedHandler);
			this._stickerLdr.startLoadSticker();
		}
		
	// HANDLERS:	
		
		private function confLoadedHandler($e:Event):void
		{
			this.loadPaperTexture();
		}
		
		
		private function txtrLoadedHandler($e:Event):void
		{
			this.loadStickers();
		}
		
		
		private function stickerLoadedHandler($e:Event):void
		{
			var $evt:Event = new Event(INITIALIZED);
			this.dispatchEvent($evt);
		}
		
		
		

	}
	
}
