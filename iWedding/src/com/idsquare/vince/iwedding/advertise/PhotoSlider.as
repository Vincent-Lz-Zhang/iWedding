package com.idsquare.vince.iwedding.advertise 
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
    import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.idsquare.vince.iwedding.GlobalModelManager;
	import com.vincentzhang.utils.BeagleLog;
	import com.vincentzhang.transitioneffect.TransitionEffectManager;
	import com.vincentzhang.transitioneffect.TransitionEvent;
	
	/***
	 * This class encapsulate the photo sliding show module
	 * 
	 * it works in this way: 
	 *  1.you should make sure when adding it to the stage, it already finished loading two XMLs, 
	 *  one of them is done by EffectMAnager--its effect config XML file, and photolist XML file;
	 *  
	 *  2.and since the PhotoSlider is not added to the stage immediately when the app run, instead it
	 *  will triggered by idle-watcher event, you can specify a period long enough that the process
	 *  of loading two XMLs would be finished;
	 * 
	 *
	 * @author 		Vincent Zhang
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.photogallery.PhotoGalleryModule
	 * 
	 * 
	 * edit 0
	 *	 
	 */	
	
	public class PhotoSlider extends Sprite
	{
		public var isReady:Boolean = false;
		private var _logger:BeagleLog = BeagleLog.getLogger();
		private var _xmlLoader:URLLoader;
		private var _loader:Loader;
		/*
		private var _medias:Vector.<String> = new <String>["6.jpg", "14.jpg", "27.jpg", "28.jpg"];
		*/												   
		private var _medias:Vector.<String> = new Vector.<String>;
		// each image stay for that long time
		private var _delay:uint = 30000;	// half one minute
		private var _timer:Timer;
		private var _currentPlayingIndex:uint = 0;
		private var _prevImage:Bitmap;
		private var _currentImage:Bitmap;
		private var _effMgr:TransitionEffectManager;
		private var _effect:Sprite;
		
		
	// CONSTRUCTOR:
	
		public function PhotoSlider($delay:uint = NaN) 
		{
			if ( (!isNaN($delay)) && ($delay > 29999) )
			{
				this._delay = $delay;
			}
			else
			{
				this._logger.customError("the passed argue $delay is invalid...", 
					"com.idsquare.vince.iwedding.advertise.PhotoSlider::PhotoSlider()");
			}
			
			this.build();
		}
		
		
		public function build():void
		{
			//trace(_medias.length);	// should load the photolist from external XML
			this._effMgr = new TransitionEffectManager();
			this._effMgr.addEventListener(TransitionEffectManager.OPTIONS_LOADED, this.effManagerInitedHandler);
			this._effMgr.init(GlobalModelManager.XML_PATH + GlobalModelManager.EFFECT_MANIFEST_XML);

			this._timer = new Timer(this._delay);
			
			this._loader = new Loader();  
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.advImageLoadedHandler);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.advImageIOErrorHandler);
				
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
		}
		
		
		private function playMedia():void
		{
			if (this._medias.length == 0)
			{
				return;
			}
			
			if ( this._currentPlayingIndex == this._medias.length)
			{
				this._currentPlayingIndex = 0;
				
				loadImageMedia();
			}
			else
			{
				loadImageMedia();
			}
		}
		
		
		private function loadImageMedia():void
		{
			var $uelReq:URLRequest = new URLRequest(GlobalModelManager.PHOTO_FOLDER + this._medias[this._currentPlayingIndex].toString());
			this._loader.load($uelReq);
		}
		
		
	// HANDLERS:
	
		/*
		 * Handler of the ADDED_TO_STAGE event
		 */
		
		private function addedToStageHandler($e:Event):void
		{
			this._currentPlayingIndex = 0;
						
			if (this._medias.length > 1)
			{
				this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
			}
			
			if (this._effMgr)
			{
				this._effMgr.addEventListener(TransitionEvent.TRANSITION_FINISHED, this.effectFinishedHandler);
			}
			
			this.playMedia();
		}
		
		
		private function removedFromStageHandler($e:Event):void
		{
			if (this._medias && this._medias.length > 1)
			{
				this._currentPlayingIndex = 0;
				this._timer.stop();
				if ( this._timer.hasEventListener(TimerEvent.TIMER) )
				{
					this._timer.removeEventListener(TimerEvent.TIMER, this.timerHandler);
				}
			}
			
			if (this._effMgr)
			{
				this._effMgr.stopEffect();
				this._effMgr.removeEventListener(TransitionEvent.TRANSITION_FINISHED, this.effectFinishedHandler);
			}
			
			// clear all children
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			
		}
		
		
		
		private function effManagerInitedHandler($e:Event):void
		{
			this._xmlLoader = new URLLoader();
			var $uelReq:URLRequest = new URLRequest(GlobalModelManager.XML_PATH + GlobalModelManager.PHOTOLIST_XML);
			this._xmlLoader.addEventListener(Event.COMPLETE, this.photolistXMLLoadedHandler);
			this._xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.photolistXMLIOErrorHandler);
			this._xmlLoader.load($uelReq);
		}
		
		
		
		private function photolistXMLLoadedHandler($e:Event):void
		{
			try{
				var $photoList:XML = new XML($e.target.data);
				var $photos = $photoList.children();
				
				for each (var $photo in $photos)
				{
					var $item:String = $photo.text();
					this._medias.push($item);
				}
			}
			catch($er:Error)
			{
				this._logger.buildInError("parsing photo list XML failed...", $e.toString(), 
					"com.idsquare.vince.iwedding.advertise.PhotoSlider::photolistXMLLoadedHandler()");
			}
			
			this._xmlLoader.removeEventListener(Event.COMPLETE, this.photolistXMLLoadedHandler);
			this._xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.photolistXMLIOErrorHandler);
			this.isReady = true;
			
			if (this.stage)
			{
				this.playMedia();
			}
		}
		
		
		private function photolistXMLIOErrorHandler($e:IOErrorEvent):void
		{
			this._logger.buildInError("loading photo list XML fail: ", $e.toString(),
				"com.idsquare.vince.iwedding.advertise.PhotoSlider::photolistXMLIOErrorHandler()");
			// prompt user
			this._xmlLoader.removeEventListener(Event.COMPLETE, this.photolistXMLLoadedHandler);
			this._xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.photolistXMLIOErrorHandler);
		}
		
		
		
		private function advImageLoadedHandler($e:Event):void
		{
			
			this._currentImage = Bitmap(this._loader.content);
			
			if (this._effect == null)
			{
				this._effect = this._effMgr.createEffect(this._currentImage.bitmapData, null);
			}
			else
			{
				this._effMgr.updateEffectImage(this._currentImage.bitmapData);
			}
			
			this._effMgr.playEffect();
			this.addChild(this._effect);
			
			// be here, _medias must bot be null
			if (this._medias.length > 1)
			{
				this._currentPlayingIndex++;
			}
			
		}
		
		
		private function advImageIOErrorHandler($e:IOErrorEvent):void
		{
			var $info:String = "loading sliding photo[" + this._currentPlayingIndex + "] failed...";
			this._logger.buildInError($info, $e.toString(), 
				"com.idsquare.vince.iwedding.advertise.PhotoSlider::advImageIOErrorHandler()");
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.advImageLoadedHandler);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.advImageIOErrorHandler);
		}
		
		
		
		private function timerHandler($e:TimerEvent):void
		{
			// be here, _medias must bot be null, and length must be greater than 1
			this._timer.stop();
			this.playMedia();
		}
		
		
		
		private function effectFinishedHandler($e:TransitionEvent):void
		{			
			if ( (this._prevImage) && (this.contains(this._prevImage)) )
			{
				this.removeChild(this._prevImage);
				this._prevImage.bitmapData.dispose();
			}
			
			this.addChild(this._currentImage);
			this.removeChild(this._effect);
			
			// now, only one image on list
			if (this._medias.length > 1)	// always check is good
			{
				this._timer.start();
			}
		}
		
		
		

	}
	
}
