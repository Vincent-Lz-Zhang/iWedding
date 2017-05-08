package com.idsquare.vince.iwedding.view 
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import com.vincentzhang.utils.BeagleLog;
	
	/***
	 * DrawingBoard encapsulates all primary functionalites.
	 * 
	 * it draws curve lines as is the track of finger movement on screen,
	 * with the specified stroke thickness and color.
	 *  
	 * each time when user put finger down, it create a new Shape.
	 *
	 * @author 		Vincent Zhang
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.iwedding.view.DrawingBoard
	 * 
	 * 
	 * edit 0
	 *	 
	 */
	
	public class DrawingBoard extends Sprite 
	{
		private var _logger:BeagleLog = BeagleLog.getLogger();
		private var _activeColor:uint = 0x000000;
		private var _thickness:uint = 5;
		private var _pen:Shape;
		private var _projector:DisplayObject;
		
	// CONSTRUCTOR:
		/**
		 * Constructor.
		 */
		public function DrawingBoard() 
		{
			
		}
		
		
		public function init($projector:DisplayObject):void
		{
			this._projector = $projector;
		}
		
		public function startDrawing():void
		{
			if (null == this._projector)
			{
				//throw new Error("projector not init");
				// log this problem
				this._logger.customError("projector is not initiated...", 
					"com.idsquare.vince.iwedding.view.DrawingBoard::startDrawing()");
			}
			this._projector.addEventListener(MouseEvent.MOUSE_DOWN, this.penDownHandler);
		}
		
		public function stopDrawing():void
		{
			if (this._projector && this._projector.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				this._projector.removeEventListener(MouseEvent.MOUSE_DOWN, this.penDownHandler);
			}
		}
		
		public function clearLastStroke():void
		{
			if (this._pen)
			{
				this._pen.graphics.clear();
			}
		}
		
		public function clearContent():void
		{
			while (this.numChildren)
			{
				this.removeChildAt(0);
			}
		}
		
	// HANDLERS:
	
		private function penDownHandler($e:MouseEvent):void
		{
			this._pen = new Shape();
			this.addChild(this._pen);

			this._pen.graphics.moveTo(this.mouseX, this.mouseY);
			this._pen.graphics.lineStyle(this._thickness, this._activeColor);

			this._projector.addEventListener(MouseEvent.MOUSE_MOVE, this.penMoveHandler);
			this._projector.addEventListener(MouseEvent.MOUSE_UP, this.penUpHandler);
		}
		
		private function penMoveHandler($e:MouseEvent):void
		{
			this._pen.graphics.lineTo(this.mouseX, this.mouseY);
		}
		
		private function penUpHandler($e:MouseEvent):void
		{
			this._projector.removeEventListener(MouseEvent.MOUSE_MOVE, this.penMoveHandler);
			this._projector.removeEventListener(MouseEvent.MOUSE_UP, this.penUpHandler);
		}
		
		
		
	// ACCESSORS:	
		
		public function set activeColor($val:uint):void
		{
			if (!isNaN($val))
			{
				this._activeColor = $val;
			}
		}
		
		public function get activeColor():uint
		{
			return this._activeColor;
		}

		public function set thickness($val:uint):void
		{
			if (!isNaN($val))
			{
				this._thickness = $val;
			}
		}
		
		public function get thickness():uint
		{
			return this._thickness;
		}


	}
	
}
