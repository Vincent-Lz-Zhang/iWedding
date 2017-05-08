package com.idsquare.vince.iwedding.view 
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.filesystem.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.adobe.images.PNGEncoder;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.idsquare.vince.iwedding.GlobalModelManager;
	import com.idsquare.vince.iwedding.view.Canvas;
	import com.idsquare.vince.iwedding.view.DockMenu;
	import com.idsquare.vince.iwedding.view.SettingPanel;
	import com.idsquare.vince.iwedding.view.StickersShelf;
	import com.idsquare.vince.iwedding.events.StickersShelfEvent;
	import com.vincentzhang.utils.BeagleLog;
	
	/***
	 * Class encapsulates all iWedding functionalities.
	 * 
	 * it contains menu, and all pop windows, and canvas, it responses to clicking on all menu item, 
	 * show/hide other elements
	 *  
	 * it is responsible to write png files to local disc. 
	 *  
	 * 
	 *
	 * @author 		Vincent Zhang
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.iwedding.view.Wedding
	 * 
	 * 
	 * edit 0
	 *	 
	 */
	
	public class Wedding extends Sprite
	{
	// logging utilities:
		/**
		 * @private
		 */	
		private var _logger:BeagleLog = BeagleLog.getLogger();	
		/**
		 * @private
		 */
		public var isSaving:Boolean = false;
		/**
		 * @private
		 */
		private var _canvasCopyBmd:BitmapData;
		/**
		 * @private
		 */
		private var _canvasCopy:Bitmap;
	// visual elements:	
		/**
		 * @private
		 */
		private var _flipper:Sprite;
		/**
		 * @private
		 */
		private var _canvas:Canvas;
		/**
		 * @private
		 */
		private var _menu:DockMenu;
		/**
		 * @private
		 */
		private var _setting:SettingPanel;
		/**
		 * @private
		 */
		private var _prompt:Sprite;
		/**
		 * @private
		 */
		private var _greetings:Sprite;
		/**
		 * @private
		 */
		private var _greetingsTimer:Timer;
		/**
		 * @private
		 */
		private var _stickersShelf:StickersShelf;
	// saving utilities:
		/**
		 * @private
		 */
		private var _fs:FileStream = new FileStream();
		/**
		 * @private
		 */
		private var _imgByteArray:ByteArray;
	
	// CONSTRUCTOR:
		/**
		 * Constructor.
		 */
		public function Wedding() 
		{
			// do nothing
		}
		
		public function build($projector:DisplayObject, $promX:int, $promY:int):void
		{
			this._canvas = new Canvas();
			//this._canvas.mouseChildren = false;	// ??? why I did this at the very beginning?
			this._canvas.mouseEnabled = false;
			this.addChild(this._canvas);
			
			this._setting = new SettingPanel();
			this._setting.y = GlobalModelManager.paletteConfig.standbyY;
			
			this._menu = new DockMenu();
			this._menu.x = GlobalModelManager.floatingMenuConfig.pos.left;
			this._menu.y = GlobalModelManager.floatingMenuConfig.pos.top;
			this.addChild(this._menu);
			
			this._flipper = new Sprite();
			
			this._canvas.initDrawingBoard($projector);
			this._canvas.startBoardDrawing();
			// must call it after loading texture
			this._canvas.addTexture();
			
			this._prompt = new Sprite();
			var $pmpBm:Bitmap = new Bitmap(GlobalModelManager.promptConfig.bmd);
			$pmpBm.smoothing = true;
			$pmpBm.x = - $pmpBm.width / 2;
			$pmpBm.y = - $pmpBm.height / 2;
			this._prompt.addChild($pmpBm);
			this._prompt.x = $promX;
			this._prompt.y = $promY;
			
			
			this._stickersShelf = new StickersShelf();
			this._stickersShelf.build();
			
			this._stickersShelf.x = GlobalModelManager.stickerConfig.pos_x;
			this._stickersShelf.y = GlobalModelManager.stickerConfig.pos_y;
			
			this._greetings = new Sprite();
			var $grtBm:Bitmap = new Bitmap(GlobalModelManager.greetingsConfig.bmd);
			$grtBm.smoothing = true;
			$grtBm.x = - $grtBm.width;
			$grtBm.y = - $grtBm.height;
			this._greetings.addChild($grtBm);
			this._greetings.x = GlobalModelManager.greetingsConfig.pos_x;
			this._greetings.y = GlobalModelManager.greetingsConfig.pos_y;
			
			this._fs.addEventListener(Event.CLOSE, this.fileStreamClosedHandler);
			this._fs.addEventListener(IOErrorEvent.IO_ERROR, this.fileStreamIOErrorHandler);
			
			this._greetingsTimer = new Timer(1000);
			this._greetingsTimer.addEventListener(TimerEvent.TIMER, this.grtTimerHandler);
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}
		
		private function getCurrentTimeStamp():String
		{
			var $d:Date = new Date();
			var $tStamp:String = $d.getFullYear().toString() + 
									$d.getMonth() + $d.getDate() + $d.getHours() + $d.getMinutes() + $d.getSeconds() + $d.getMilliseconds();
			return $tStamp;
		}
		
		public function lockMenu():void
		{
			this._menu.mouseChildren = false;
		}
		
		public function unlockMenu():void
		{
			this._menu.mouseChildren = true;
		}
		
		
	// HANDLERS:
	
		private function addedToStageHandler($e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
			this._menu.submitButton.addEventListener(MouseEvent.CLICK, this.submitButtonClickedHandler);
			this._menu.clearAllButton.addEventListener(MouseEvent.CLICK, this.clearAllButtonClickedHandler);
			this._menu.settingsButton.addEventListener(MouseEvent.CLICK, this.settingsButtonClickedHandler);
			this._menu.createNewButton.addEventListener(MouseEvent.CLICK, this.createNewButtonClickedHandler);
			this._menu.eraserButton.addEventListener(MouseEvent.CLICK, this.eraserButtonClickedHandler);
			this._menu.stickerButton.addEventListener(MouseEvent.CLICK, this.stickerButtonClickedHandler);
			
			this._menu.submitButton.addEventListener(MouseEvent.MOUSE_DOWN, this.forbidPropagationHandler);
			this._menu.clearAllButton.addEventListener(MouseEvent.MOUSE_DOWN, this.forbidPropagationHandler);
			this._menu.settingsButton.addEventListener(MouseEvent.MOUSE_DOWN, this.forbidPropagationHandler);
			this._menu.createNewButton.addEventListener(MouseEvent.MOUSE_DOWN, this.forbidPropagationHandler);
			this._menu.eraserButton.addEventListener(MouseEvent.MOUSE_DOWN, this.forbidPropagationHandler);
			this._menu.stickerButton.addEventListener(MouseEvent.MOUSE_DOWN, this.forbidPropagationHandler);
		}
		
		private function removedFromStageHandler($e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this._menu.submitButton.removeEventListener(MouseEvent.CLICK, this.submitButtonClickedHandler);
			this._menu.clearAllButton.removeEventListener(MouseEvent.CLICK, this.clearAllButtonClickedHandler);
			this._menu.settingsButton.removeEventListener(MouseEvent.CLICK, this.settingsButtonClickedHandler);
			this._menu.createNewButton.removeEventListener(MouseEvent.CLICK, this.createNewButtonClickedHandler);
			this._menu.eraserButton.removeEventListener(MouseEvent.CLICK, this.eraserButtonClickedHandler);
			this._menu.stickerButton.removeEventListener(MouseEvent.CLICK, this.stickerButtonClickedHandler);
			
			this._menu.submitButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.forbidPropagationHandler);
			this._menu.clearAllButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.forbidPropagationHandler);
			this._menu.settingsButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.forbidPropagationHandler);
			this._menu.createNewButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.forbidPropagationHandler);
			this._menu.eraserButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.forbidPropagationHandler);
			this._menu.stickerButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.forbidPropagationHandler);
		}
	
	
	// floating menu event handlers:
		private function submitButtonClickedHandler($e:MouseEvent):void
		{
			if ("erasing" == this._canvas.mode)
			{
				this._canvas.stopErasing();
			}
			
			this._canvas.stopBoardDrawing();
			this.lockMenu();
			
			this._canvas.depositeDrawings();
			
			this.addChild(this._greetings);
			
			this._greetings.alpha = 0;
			this._greetings.scaleX = this._greetings.scaleY = 0.2;
			
			TweenLite.to(
						 	this._greetings, 
							0.45, 
							{
								alpha: 1,
								scaleX: 1,
								scaleY: 1,
								ease: Quad.easeOut,
								onComplete: this.onGreetingsShowed
							}
						 );
						 
		}
		
		private function clearAllButtonClickedHandler($e:MouseEvent):void
		{
			if ("erasing" == this._canvas.mode)
			{
				this._canvas.stopErasing();
			}
			
			this._canvas.clearBoard();
		}
		
		private function settingsButtonClickedHandler($e:MouseEvent):void
		{
			if ("erasing" == this._canvas.mode)
			{
				this._canvas.stopErasing();
			}
			
			this._canvas.stopBoardDrawing();
			this.lockMenu();
			
			this.addChild(this._setting);
			
			TweenLite.to(
						 	this._canvas, 
							GlobalModelManager.paletteConfig.tween_duration, 
							{
								ease: Quad.easeOut, 
								colorTransform:{brightness :0.3}
							}
						 );
			
			TweenLite.to(
						 	this._setting, 
							GlobalModelManager.paletteConfig.tween_duration, 
							{
								y: GlobalModelManager.paletteConfig.activeY, 
								ease: Quad.easeOut, 
								onComplete: this.onSettingPanelShowed
							}
						 );			
		}
		
		private function createNewButtonClickedHandler($e:MouseEvent):void
		{
			// mark the status
			this.isSaving = true;
			// forbid the drawing
			this._canvas.stopBoardDrawing();
			
			this._prompt.alpha = GlobalModelManager.promptConfig.standbyAlp;
			this._prompt.scaleX = GlobalModelManager.promptConfig.standbyScaleX;
			this._prompt.scaleY = GlobalModelManager.promptConfig.standbyScaleY;
			this.addChild(this._prompt);
			
			TweenLite.to(
						 	this._prompt,
							GlobalModelManager.promptConfig.tween_duration,
							{
								alpha: GlobalModelManager.promptConfig.targetAlp,
								scaleX: GlobalModelManager.promptConfig.targetScaleX,
								scaleY: GlobalModelManager.promptConfig.targetScaleY,
								ease: Quad.easeOut,
								onComplete: this.onPromptShowed
							}
						 );
			
		}
		
		
		private function fileStreamClosedHandler($e:Event = null):void
		{
			this._canvasCopy = new Bitmap(this._canvasCopyBmd);
			this._canvas.clearSignature();
			this._canvas.clearBoard();
			
			this._flipper.addChild(this._canvasCopy);
			var $index:int = this.getChildIndex(this._canvas);
			this.addChildAt(this._flipper, $index + 1);
			
			TweenLite.to(
						 	this._prompt,
							GlobalModelManager.promptConfig.tween_duration,
							{
								alpha: GlobalModelManager.promptConfig.standbyAlp,
								scaleX: GlobalModelManager.promptConfig.standbyScaleX,
								scaleY: GlobalModelManager.promptConfig.standbyScaleY,
								ease: Quad.easeOut,
								onComplete: this.onPromptHided
							}
						 );
		}
		
		
		private function fileStreamIOErrorHandler($e:IOErrorEvent):void
		{
			this._logger.buildInError("operating on file stream fail: ", $e.toString(),
				"com.idsquare.vince.iwedding.view.Wedding::fileStreamIOErrorHandler()");
		}
		
		
		private function eraserButtonClickedHandler($e:MouseEvent):void
		{
			if ("drawing" == this._canvas.mode)
			{
				this._canvas.startErasing();
			}
			else
			{
				this._canvas.stopErasing();
			}
		}
		
		
		private function stickerButtonClickedHandler($e:MouseEvent):void
		{
			if ("erasing" == this._canvas.mode)
			{
				this._canvas.stopErasing();
			}
			
			this._canvas.stopBoardDrawing();
			this.lockMenu();
			
			this._stickersShelf.alpha = 0;
			this.addChild(this._stickersShelf);
			
			
			TweenLite.to(
						 	this._canvas, 
							GlobalModelManager.paletteConfig.tween_duration, 
							{
								ease: Quad.easeOut, 
								colorTransform:{brightness :0.3}
							}
						 );
			
			TweenLite.to(
						 	this._stickersShelf, 
							GlobalModelManager.paletteConfig.tween_duration, 
							{
								alpha: 1, 
								ease: Quad.easeOut, 
								onComplete: this.onStickersShelfShowed
							}
						 );			
		}
		
		
	// setting panel event handlers::
	
		private function saveSettingBtnClickedHandler($e:MouseEvent):void
		{
			//this.lockMenu();	// ?
			
			// bring the stage to normal brightness
			TweenLite.to(
						 	this._canvas, 
							GlobalModelManager.paletteConfig.tween_duration, 
							{
								ease: Quad.easeOut, 
								colorTransform: {brightness :1}
							}
						 );
						 
			// hide palette setting panel
			TweenLite.to(
						 	this._setting, 
							GlobalModelManager.paletteConfig.tween_duration, 
							{
								y: GlobalModelManager.paletteConfig.dismissedY, 
								ease: Quad.easeOut, 
								onComplete: this.onSettingPanelHided
							}
						 );
			
			/*
			 * apply the user setting of color & thickness
			 * to drawing board
			 */
			this._canvas.setBoardColor(this._setting.color);
			this._canvas.setBoardThick(this._setting.thicknessVal);
		}
		
		
		private function cancelSettingBtnClickedHandler($e:MouseEvent):void
		{
			//this.lockMenu();	// ?
			
			// bring the stage to normal brightness
			TweenLite.to(
						 	this._canvas, 
							GlobalModelManager.paletteConfig.tween_duration, 
							{
								ease: Quad.easeOut, 
								colorTransform: {brightness: 1}
							}
						 );
						 
			// hide palette setting panel
			TweenLite.to(
						 	this._setting, 
							GlobalModelManager.paletteConfig.tween_duration, 
							{
								y: GlobalModelManager.paletteConfig.dismissedY, 
								ease: Quad.easeOut, 
								onComplete: this.onSettingPanelHided
							}
						 );
			
		}



		private function stickerSelectedHandler($e:StickersShelfEvent):void
		{
			// add sticker to Canvas
			this._canvas.addSticker($e.stickerId);
			
			// bring the stage to normal brightness
			TweenLite.to(
						 	this._canvas, 
							GlobalModelManager.paletteConfig.tween_duration, 
							{
								ease: Quad.easeOut, 
								colorTransform: {brightness :1}
							}
						 );
						 
			// hide palette sticker shelf
			TweenLite.to(
						 	this._stickersShelf, 
							GlobalModelManager.paletteConfig.tween_duration, 
							{
								alpha: 0, 
								ease: Quad.easeOut, 
								onComplete: this.onStickersShelfHided
							}
						 );
		}
		
		
		private function forbidPropagationHandler($e:MouseEvent):void
		{
			$e.stopPropagation();
		}
		
			
		private function grtTimerHandler($e:TimerEvent):void
		{
			this._greetingsTimer.stop();
			
			TweenLite.to(
						 	this._greetings, 
							0.25, 
							{
								alpha: 0,
								ease: Quad.easeOut,
								onComplete: this.onGreetingsHided
							}
						 );
		}

	// TWEEN ON-COMPLETEs:
	
		private function onSettingPanelShowed():void
		{
			this._setting.saveSettingBtn.addEventListener(MouseEvent.CLICK, this.saveSettingBtnClickedHandler);
			this._setting.cancelSettingBtn.addEventListener(MouseEvent.CLICK, this.cancelSettingBtnClickedHandler);
		}
		

		private function onSettingPanelHided():void
		{
			this.removeChild(this._setting);
			this._setting.saveSettingBtn.removeEventListener(MouseEvent.CLICK, this.saveSettingBtnClickedHandler);
			this._setting.cancelSettingBtn.removeEventListener(MouseEvent.CLICK, this.cancelSettingBtnClickedHandler);
			
			// recove drawing board
			this._canvas.startBoardDrawing();
			// recove floating menu
			this.unlockMenu();
		}
		
		
		private function onStickersShelfShowed():void
		{
			this._stickersShelf.addEventListener(StickersShelfEvent.STICKER_SELECTED, this.stickerSelectedHandler);
		}
		
		
		private function onStickersShelfHided():void
		{
			this.removeChild(this._stickersShelf);
			this._canvas.startBoardDrawing();
			this.unlockMenu();
		}
		
		
		
		private function onPromptShowed():void
		{
			this._canvas.drawingBoardMouseDownHandler();
			this._canvasCopyBmd = new BitmapData(this._canvas.width, this._canvas.height, true, 0x00FFFFFF);
			this._canvasCopyBmd.draw(this._canvas);
			
			// write the image file to local disc
			this._imgByteArray = PNGEncoder.encode(this._canvasCopyBmd);
			
			/*
			 * I found that, here, while AIR is writing data to a FileStream pointing locally, 
			 * you just can't count on it to do anything else simultaneously, for it is so busy.... 
			 * And the safe method is, that you operate it asynchronously, and listen to FileStream's CLOSE
			 * event, then, as responsing to that, do what you meant to do 
			 */
			var $fileName:String = GlobalModelManager.settings.imgsaving.prefixM + this.getCurrentTimeStamp() + GlobalModelManager.settings.imgsaving.ext;
			var $fl:File = new File(GlobalModelManager.settings.imgsaving.path + $fileName);
			try{
				//this._fs.open($fl,FileMode.WRITE);	// would cause other tasks crush
				this._fs.openAsync($fl,FileMode.WRITE);
				this._fs.writeBytes(this._imgByteArray);
				this._fs.close();
			}
			catch($e:Error)
			{
				this._logger.buildInError("writing png file fail: ", $e.toString(),
					"com.idsquare.vince.iwedding.view.Wedding::onPromptShowed()");
			}
		}
		
		
		private function onPromptHided():void
		{			
			this.removeChild(this._prompt);
			
			// fade out the flipper
			TweenLite.to(
						 	this._flipper, 
							GlobalModelManager.flipperConfig.tween_duration, 
							{
								scaleX: GlobalModelManager.flipperConfig.targetScaleX, 
								scaleY: GlobalModelManager.flipperConfig.targetScaleY, 
								x: GlobalModelManager.flipperConfig.targetX, 
								y: GlobalModelManager.flipperConfig.targetY, 
								alpha: GlobalModelManager.flipperConfig.targetAlp,
								ease: Quad.easeOut,
								onComplete: this.onCanvasCopyFlipped
							}
						 );
		}
		
		
		private function onCanvasCopyFlipped():void
		{
			this.removeChild(this._flipper);
			
			// recove flipper tween status
			this._flipper.x = GlobalModelManager.flipperConfig.standbyX;
			this._flipper.y = GlobalModelManager.flipperConfig.standbyY;
			this._flipper.scaleX = GlobalModelManager.flipperConfig.standbyScaleX;
			this._flipper.scaleY = GlobalModelManager.flipperConfig.standbyScaleY;
			this._flipper.alpha = GlobalModelManager.flipperConfig.standbyAlp;
			this._flipper.removeChild(this._canvasCopy);
			
			// clean up the data
			this._canvasCopy = null;
			this._canvasCopyBmd.dispose();
			this._canvasCopyBmd = null;
			
			// recove drawing board
			this._canvas.startBoardDrawing();
			
			// mark the status
			this.isSaving = false;
		}			
		
		
		
		private function onGreetingsShowed():void
		{
			this._greetingsTimer.start();
		}
		
	
	
		private function onGreetingsHided():void
		{
			this.removeChild(this._greetings);
			//
			// recove drawing board
			this._canvas.startBoardDrawing();
			this.unlockMenu();
		}
		
		
		

	}
	
}
