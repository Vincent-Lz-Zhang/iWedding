package com.vincentzhang.transitioneffect
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.display.BitmapData;
	import flash.geom.Point;	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.vincentzhang.transitioneffect.effects.*;
	import com.vincentzhang.utils.BeagleLog;
	
	/***
	 * if call init() before createEffect(), then the parameters will be
	 * grabed from effect.xml, so there is no need to pass parameters to
	 * createEffect() any more
	 */
	
	public class TransitionEffectManager extends EventDispatcher
	{
		public static const OPTIONS_LOADED:String = "optionsLoaded";
		private var _logger:BeagleLog = BeagleLog.getLogger();
		private var _effectName:String;
		private var _extendOptions:Object;
		private var _currentAnimator:Object;
		
		private var _init:Boolean = false;
		
		public function TransitionEffectManager() 
		{
			// nothing so far
		}
		
		
		
		public function init($xmlurl:String = "effect.xml"):void
		{
			var $urlLdr:URLLoader = new URLLoader();
			var $urlReq:URLRequest = new URLRequest($xmlurl);
				$urlLdr.addEventListener(Event.COMPLETE, this.xmlLoadedHandler);
				$urlLdr.addEventListener(IOErrorEvent.IO_ERROR, this.xmlLoadingIOErrorHandler);
				$urlLdr.load($urlReq);
		}
		
		
		
		public function createEffect(
										$showedImage:BitmapData, 
										$hidedImage:BitmapData,
										$effect:String = null,
										$options:Object = null
									):Sprite

		{
			if ($effect)
			{
				this._effectName = $effect;
			}
			
			if ($options)
			{
				this._extendOptions = $options;
			}
			
			switch (this._effectName)
			{
				case "Tesla": 
					this._currentAnimator = new TeslaEffect($showedImage, this.onEffectPlayed, this._extendOptions);
					break;
					
				case "GlowingGrid": 
					this._currentAnimator = new GlowingGridEffect($showedImage, this.onEffectPlayed, this._extendOptions);
					break;
				
				case "OctCircles": 
					this._currentAnimator = new OctCirclesEffect($showedImage, this.onEffectPlayed, this._extendOptions);
					break;
					
				default:
					this._currentAnimator = new GlowingGridEffect($showedImage, this.onEffectPlayed, this._extendOptions);
					// log this problem
					this._logger.customError("the effect name is invalid...", 
						"com.vincentzhang.transitioneffect.TransitionEffectManager::createEffect()");
					break;
			}
			
			return this._currentAnimator.getReady();
		}
		
		
		
		public function playEffect():void
		{
			this._currentAnimator.play();
		}
		
		
		
		public function stopEffect():void
		{
			this._currentAnimator.stop();
		}
		
		
		
		public function updateEffectImage($showedImage:BitmapData):void
		{
			this._currentAnimator.update($showedImage);
		}
		
		
		
		// error handlers of UrlLoader 
		private function xmlLoadingIOErrorHandler($e:IOErrorEvent):void
		{
			this._logger.buildInError("loading effect manifest XML fail: ", $e.toString(),
				"com.idsquare.vince.iwedding.advertise.PhotoSlider::xmlLoadingIOErrorHandler()");
			// prompt user
			$e.target.removeEventListener(Event.COMPLETE, this.xmlLoadedHandler);
			$e.target.removeEventListener(IOErrorEvent.IO_ERROR, this.xmlLoadingIOErrorHandler);
		}
		
		private function xmlLoadedHandler($e:Event):void
		{
			$e.target.removeEventListener(Event.COMPLETE, this.xmlLoadedHandler);
			$e.target.removeEventListener(IOErrorEvent.IO_ERROR, this.xmlLoadingIOErrorHandler);
			
			var $xml:XML = new XML();
				$xml = XML($e.target.data);
				this._effectName = $xml.effectname.toString();
				
				this._extendOptions = {};
				
				var $x:XMLList = $xml.options.child("*");
				
				for each (var $opt in $x)
				{
					this._extendOptions[$opt.name().toString()] = parseFloat($opt.toString());
				}
				
			this._init = true;
			
			// dispatch
			this.dispatchEvent(new Event(OPTIONS_LOADED));
		}
		
		
		
		private function onEffectPlayed():void
		{
			var $evt:TransitionEvent = new TransitionEvent(TransitionEvent.TRANSITION_FINISHED);
			this.dispatchEvent($evt);
		}
		

	}
	
}
