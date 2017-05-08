package com.idsquare.vince.iwedding.view 
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import com.idsquare.vince.iwedding.view.DrawingBoard;
	import com.idsquare.vince.iwedding.view.StickerBoard;
	import com.idsquare.vince.iwedding.view.StickerHolder;
	import com.idsquare.vince.iwedding.view.Eraser;
	import com.idsquare.vince.iwedding.GlobalModelManager;
	import com.vincentzhang.utils.BeagleLog;
	
	/***
	 * Canvas encapsulates all drawing board functionalities: drawing and adding stickers.
	 * 
	 * it contains StickerBoard, DrawingBoard, and _paperTexture as background, it responses to copy all drawings and stickers, 
	 * with the previous submitted drawings together, and apply it as new submitted drawings.
	 *  
	 * it responses to erase the drawn graphics, by inserting a new copied BmD into DrawingBoard.
	 *
	 *  _______________________________
	 * |                               |    (draw composite)
	 * |    ______________________     |======================>BitmapData
	 * |   |                      |    |                          |
	 * |   |    _stickerBoard     |    |                          |
	 * |   |______________________|    |                          |
	 * |                               |                          |
	 * |    ______________________     |                          |
	 * |   |                      |    |                          |
	 * |   |    _drawingBoard     |    |                          |
	 * |   |______________________|    |                          |
	 * |                               |                          |
	 * |    ______________________     |                          |
	 * |   |                      |    |                          |
	 * |   |  _submittedSignature |<---|--------------------------|
	 * |   |______________________|    |
	 * |                               |
	 * |_______________________________|
	 *
	 *
	 *	 
	 *  _______________________________
	 * |                               |
	 * |        _paperTexture          |
	 * |_______________________________|
	 *
	 *
	 *
	 * @author 		Vincent Zhang
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.iwedding.view.Canvas
	 * 
	 * 
	 * edit 0
	 *	 
	 */
	
	public class Canvas extends Sprite
	{
		private var _logger:BeagleLog = BeagleLog.getLogger();
		private var _projector:DisplayObject;
		
		private var _drawingBoard:DrawingBoard;
		private var _paperTexture:Sprite;
		private var _composition:Sprite;
		private var _submittedSignature:Sprite;
		private var _signatureBm:Bitmap;
		
		private var _tempBm:Bitmap;
		
		// erasing functionality:
		private var _mode:String = "drawing";	// drawing or erasing
		private var _erasingMask:Sprite;
		private var _eraser:Eraser;
		/*
		 * this Bmd is used to draw the erased Bmd 
		 *
		 * @private
		 */
		private var _erasedBmd:BitmapData;
		/*
		 * this Bm is used to present the erased Bmd in DrawingBoard
		 *
		 * @private
		 */
		private var _erasedBm:Bitmap;
		
		private var _defEraserThick:uint = GlobalModelManager.settings.eraser_DefThick;
		
		// stickers:
		private var _stickerBoard:StickerBoard;
		
	// CONSTRUCTOR:
		/**
		 * Constructor.
		 */
		public function Canvas() 
		{
			this._submittedSignature = new Sprite();
			this._drawingBoard = new DrawingBoard();
			this._stickerBoard = new StickerBoard();
			
			this._composition = new Sprite();
			this._composition.addChild(this._submittedSignature);
			this._composition.addChild(this._drawingBoard);
			this._composition.addChild(this._stickerBoard);
			
			this.addChild(this._composition);
			
			this._eraser = new Eraser();
			
		}
		
	// Proxy methods of board:
	
		public function initDrawingBoard($projector:DisplayObject):void
		{
			this._projector = $projector;
			this._drawingBoard.init(this._projector);
			
		}
		
		public function startBoardDrawing():void
		{
			this._drawingBoard.startDrawing();
			this._stickerBoard.unlock();
			this._projector.addEventListener(MouseEvent.MOUSE_DOWN, this.drawingBoardMouseDownHandler);
		}
		
		public function stopBoardDrawing():void
		{
			this._drawingBoard.stopDrawing();
			this._stickerBoard.lock();
			this._projector.removeEventListener(MouseEvent.MOUSE_DOWN, this.drawingBoardMouseDownHandler);
		}
		
		public function clearBoard():void
		{
			this._drawingBoard.clearContent();
			this._stickerBoard.clearContent();
		}
		
		public function clearSignature():void
		{
			if (this._signatureBm)
			{
				this._signatureBm.bitmapData.dispose();
			}
			this._signatureBm = null;
		}
		
		
	// 	
		public function addTexture($txtr:Bitmap = null):void
		{
			this._paperTexture = new Sprite();
			var $bm:Bitmap = new Bitmap(GlobalModelManager.paper);
			this._paperTexture.addChild($bm);
			this.addChildAt(this._paperTexture, 0);
		}
		
		public function setBoardThick($thickness:uint):void
		{
			this._drawingBoard.thickness = $thickness;
		}
		
		public function setBoardColor($color:uint):void
		{
			this._drawingBoard.activeColor = $color;
		}
		
		
		public function depositeDrawings():void
		{
			this.drawingBoardMouseDownHandler();
			var $bmd:BitmapData = new BitmapData(this.width, this.height, true, 0x00FFFFFF);
			$bmd.draw(this._composition, null, null, null, null, true);
			
			if (this._signatureBm)
			{
				this._signatureBm.bitmapData.dispose();
			}
			
			this._tempBm = new Bitmap($bmd);	// this bmd is redundant in fact
			this._signatureBm = this._tempBm;
			this._submittedSignature.addChild(this._signatureBm);
			this._drawingBoard.clearContent();
			this._stickerBoard.clearContent();
			this._tempBm = null;
		}
		
		
	// erasing functionality
	
		public function startErasing():void
		{
			if (!this.stage)
			{
				// log this problem
				this._logger.customError("the Canvas is not in playlist...", 
					"com.idsquare.vince.iwedding.view.Canvas::startErasing()");
			}
			
			this._mode = "erasing";
			
			// forbid writing
			this._drawingBoard.stopDrawing();
			this._stickerBoard.lock();
			this._projector.removeEventListener(MouseEvent.MOUSE_DOWN, this.drawingBoardMouseDownHandler);
			// copy all on board 
			this._erasedBmd = new BitmapData(this.stage.stageWidth, this.stage.stageHeight, true, 0x00FFFFFF);
			this._erasedBmd.draw(this._drawingBoard, null, null, null, null, true);
			// and then clear board
			this._drawingBoard.clearContent();
			// and then add new copy to board, to erase
			this._erasedBm = new Bitmap(this._erasedBmd);
			this._erasedBm.smoothing = true;
			this._drawingBoard.addChild(this._erasedBm);
			// then clrea the var for later use
			this._erasedBm = null;
			this._erasedBmd = null;
			
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.stageMouseDownHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this.stageMouseUpHandler);
			
			this.addChild(this._eraser);
		}
		
		
		public function stopErasing():void
		{
			this._mode = "drawing";
			this.removeChild(this._eraser);
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.stageMouseDownHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stageMouseUpHandler);
			this._drawingBoard.startDrawing();
			this._stickerBoard.unlock();
			this._projector.addEventListener(MouseEvent.MOUSE_DOWN, this.drawingBoardMouseDownHandler);
		}
	
	// erasing functionality
	
		public function addSticker($stickerIndex):void
		{
			var $hdr:StickerHolder = new StickerHolder($stickerIndex);
			// add the sticker onto center of stage
			$hdr.x = this.stage.stageWidth / 2;
			$hdr.y = this.stage.stageHeight / 2;
			this._stickerBoard.addChild($hdr);
		}
		
	// HANDLERS:
	
		private function stageMouseDownHandler($e:MouseEvent):void
		{
			this._erasingMask = new Sprite();
			this._erasingMask.graphics.lineStyle(this._defEraserThick, 0x555555);
			this._erasingMask.graphics.moveTo(this.stage.mouseX, this.stage.mouseY);
			this._eraser.x = this.stage.mouseX;
			this._eraser.y = this.stage.mouseY;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stageMouseMoveHandler);
		}
		
		
		private function stageMouseMoveHandler($e:MouseEvent):void
		{
			this._eraser.x = this.stage.mouseX;
			this._eraser.y = this.stage.mouseY;
			// draw erasing strokes
			this._erasingMask.graphics.lineTo(this.stage.mouseX, this.stage.mouseY);
			
			// copy all on board 
			this._erasedBmd = new BitmapData(this.stage.stageWidth, this.stage.stageHeight, true, 0x00FFFFFF);
			this._erasedBmd.draw(this._drawingBoard, null, null, null, null, true);
			this._erasedBmd.draw(this._erasingMask, null, null, "erase", null, true); 
			// and then clear board
			this._drawingBoard.clearContent();
			
			// and then add new copy to board, to erase
			this._erasedBm = new Bitmap(this._erasedBmd);
			this._erasedBm.smoothing = true;
			this._drawingBoard.addChild(this._erasedBm);
			// then clrea the var for later use
			this._erasedBm = null;
			this._erasedBmd = null;
		}
		
		
		private function stageMouseUpHandler($e:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stageMouseMoveHandler);
		}
		
		
		public function drawingBoardMouseDownHandler($e:MouseEvent = null):void
		{
			this._stickerBoard.hideStickersHandles();
		}
		
		
	// ACCESSORS:
		
		public function get mode():String
		{
			return this._mode;
		}
		
		

	}
	
}
