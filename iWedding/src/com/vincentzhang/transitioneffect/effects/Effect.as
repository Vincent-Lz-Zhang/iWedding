package com.vincentzhang.transitioneffect.effects
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import com.greensock.*;
	import com.greensock.data.TweenMaxVars;
	import com.greensock.plugins.TweenPlugin;  
    import com.greensock.plugins.ColorTransformPlugin; 
	
	public class Effect
	{
		protected var _effect:Sprite;
		protected var _showedImgBMD:BitmapData;
		protected var _settings:Object = {};
		protected var _callback:Function;
		protected var _overallTimeline:TimelineMax;
		
		public function Effect($showedImage:BitmapData, $callBack:Function)
		{
			TweenPlugin.activate([ColorTransformPlugin]);
			
			this._showedImgBMD = $showedImage;
			this._callback = $callBack;
			
			this._effect = new Sprite();
			this._overallTimeline = new TimelineMax({useFrames:true, onComplete:this.onEffectPlayed});
		}
		
		
		
		public function getReady():Sprite
		{
			this.doGetReady();
			return this._effect;
		}
		
		
		
		public function play():void
		{
			this._overallTimeline.restart();
			//this.doPlay();
		}
		
		
		
		public function stop():void
		{
			this._overallTimeline.gotoAndStop(1);
			//this.doStop();
		}
		
		
		
		public function update($showedImage:BitmapData):void
		{
			/*
			 * can't dispose for the moment
			 */
			//this._showedImgBMD.dispose();	// dispose previous one
			
			this._showedImgBMD = $showedImage;
			this.doUpdate();
		}
		
		
		
		protected function onEffectPlayed():void
		{
			// dispatch event
			//trace("I am done.");
			if (this._callback != null)
			{
				this._callback.call();
			}
		}
		
		protected function doPlay():void{}
		
		protected function doStop():void{}
		
		protected function doUpdate():void{}
		
		protected function doGetReady():void{}
	}
}