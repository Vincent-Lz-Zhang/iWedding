package com.idsquare.vince.iwedding 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.idsquare.vince.iwedding.InitializationManager;
	import com.idsquare.vince.iwedding.GlobalModelManager;
	import com.idsquare.vince.iwedding.view.preloader.Preloader;
	import com.idsquare.vince.iwedding.view.Wedding;
	import com.idsquare.vince.iwedding.advertise.PhotoSlider;
	import com.vincentzhang.utils.IdleUserWatcher;
	
	/* for testing */
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.StageDisplayState;
	
	import com.hexagonstar.util.debug.Debug;
	
	/***
	 * Document class:
	 * 
	 * it contains two children: 
	 *  1. PhotoSlider 
	 *  2. Wedding
	 *  
	 *  it has IdleUserWatcher class as member, to switch the two children.
	 * 
	 *
	 * @author 		Vincent Zhang
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.iwedding.main
	 * 
	 * 
	 * edit 0
	 *	 
	 */
	
	public class main extends MovieClip
	{
		/**
		 * @private
		 */
		private var _initMgr:InitializationManager;
		/**
		 * @private
		 */
		private var _preloader:Preloader;
		/**
		 * @private
		 */
		private var _wedd:Wedding;
		/**
		 * @private
		 */
		private var _photoSlider:PhotoSlider;
		/**
		 * @private
		 */
		private var _idleWatcher:IdleUserWatcher;
		/**
		 * @private
		 */
		private var _isWatching:Boolean = false;

	// CONSTRUCTOR:
		/**
		 * Constructor.
		 */
		public function main() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}
		
		private function build():void
		{
			this._wedd = new Wedding();
			this._wedd.build(this.stage, this.stage.stageWidth / 2, this.stage.stageHeight / 2);
			
			// fade out the _preloader
			TweenLite.to(
						 	this._preloader, 
							0.25, 
							{
								alpha: 0,
								ease: Quad.easeOut,
								onComplete: this.onPreloaderFaded
							}
						 );
						
			
			this._photoSlider = new PhotoSlider(GlobalModelManager.settings.photoslider.photoInterval);
			this._photoSlider.addEventListener(MouseEvent.MOUSE_DOWN, this.phoSliderTouchedHandler);
			
			this._idleWatcher = new IdleUserWatcher(GlobalModelManager.settings.photoslider.idlePeriod, this.stage);
			this._idleWatcher.addEventListener(IdleUserWatcher.BROADCAST_IDLE, this.idleBroadcastedHandler);
			
		}
		
	// HANDLERS:	
		
		private function addedToStageHandler($e:Event):void
		{
			this._preloader = new Preloader();
			this.addChild(this._preloader);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			// start the initialization process
			this._initMgr = new InitializationManager();
			this._initMgr.addEventListener(InitializationManager.INITIALIZED, this.initializedHandler);
			this._initMgr.init(this.stage);
			
			
			// start monitoring
			Debug.monitor(stage, 1000);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownHandler);
		}
		
		
		private function initializedHandler($e:Event):void
		{			
			this.build();
		}
		
		
		private function idleBroadcastedHandler($e:Event):void
		{		
			// check if that the wedding is saving images... actually it is impossible to reach here
			if (this._wedd.isSaving || (!this._photoSlider.isReady))
			{
				// do nothing
				return;
			}
			
			
			// switch the modules to PhotoSlider
			if( this.contains(this._wedd) )
			{
				this.removeChild(this._wedd);
			}
			
			this.addChild(this._photoSlider);
			
			this._idleWatcher.stopWatching();
		}
		
		
		private function phoSliderTouchedHandler($e:MouseEvent):void
		{
			// switch the modules to Wedding
			if( this.contains(this._photoSlider) )
			{
				this.removeChild(this._photoSlider);
			}
			
			this.addChild(this._wedd);
			
			this._idleWatcher.startWatching();
		}
		
		
	// CALL-BACKS:
	
		private function onPreloaderFaded():void
		{
			 
			this.removeChild(this._preloader);
			this._preloader = null;
			this.addChild(this._wedd);
			
			this._wedd.alpha = 0;
			
			// reveal the Wedding
			TweenLite.to(
						 	this._wedd, 
							0.45, 
							{
								alpha: 1,
								ease: Quad.easeOut,
								onComplete: this.onWeddingRevealled
							}
						 );
						 
		}
		
		
		private function onWeddingRevealled():void
		{
			// start watching idle
			this._idleWatcher.startWatching();
		}
		
		
	// methods for testing	
	
		private function onKeyDownHandler($e:KeyboardEvent):void
		{
			//trace($e.keyCode);	// 70
			//trace($e.charCode);	// 102
			
			if ($e.keyCode==Keyboard.F)
			{
				if (this.stage.displayState != StageDisplayState.FULL_SCREEN_INTERACTIVE)
				{
					this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				}
			}
		}
		

	}
	
}
