package com.idsquare.vince.iwedding.view 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.idsquare.vince.iwedding.GlobalModelManager;
	import com.idsquare.vince.iwedding.view.StickerEditHandle;
	import com.idsquare.vince.iwedding.view.StickerDeleteHandle;
	
	/***
	 * StickerHolder is a container of loaded specific sticker.
	 * 
	 * it loads external swf again, and with two handles. It's also responsible to the events on the handles:
	 *  editing: scale, move, rotate;
	 *  removing:
	 * 
	 *
	 * @author 		Vincent Zhang
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.iwedding.view.StickerHolder
	 * 
	 * 
	 * edit 0
	 *	 
	 */
	
	public class StickerHolder extends Sprite
	{
		private var _ldr:Loader;
		private var _sticker:Sprite;
		private var _selectFrame:Sprite;
		private var _editHandle:StickerEditHandle;
		private var _delHandle:StickerDeleteHandle;
		
		private var _mouseDownRadian:Number;
		private var _mouseDownDistance:Number;
		private var _mouseDownScale:Number;
		
		private var _mousePrevX:Number;
		private var _mousePrevY:Number;
		
		private var SENSITIVITY:int = 4;
		
		private var _ifIntendToRemove:Boolean = false;

		public function StickerHolder($stickerIndex) 
		{
			var $req:URLRequest = new URLRequest(GlobalModelManager.STICKER_FOLDER + GlobalModelManager.stickerList[$stickerIndex].file.toString());
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.stickerLoadedHandler);
			this._ldr.load($req);
			//
		}
		
		
		public function hideHandles():void 
		{
			/**/
			if (this._editHandle)
			{
				this._editHandle.visible = false;
			}
			if (this._delHandle)
			{
				this._delHandle.visible = false;
			}
			
		}
		
		
		private function stickerLoadedHandler($e:Event):void
		{
			var $gr:MovieClip = $e.target.content as MovieClip;
			var $s:Shape = $gr.getChildAt(0) as Shape;
			
			// draw frame
			this._selectFrame = new Sprite();
			this._selectFrame.graphics.lineStyle(1, 39423);
			this._selectFrame.graphics.drawRect(0, 0, $gr.width, $gr.height);
			this._selectFrame.graphics.endFill();
			this._selectFrame.visible = false;
			this.addChild(this._selectFrame);
			this._sticker = new Sprite();
			this._sticker.addChild($s);
			this.addChild(this._sticker);
			// add handles
			this._editHandle = new StickerEditHandle();
			this._editHandle.x = this._sticker.width * 2.5;
			if (this._editHandle.x > GlobalModelManager.stickerConfig.handle_maxX)
			{
				this._editHandle.x = GlobalModelManager.stickerConfig.handle_maxX;
			}
			
			this._editHandle.y = this._sticker.height * .5;
			this._editHandle.visible = false;
			this.addChild(this._editHandle);
			
			this._delHandle = new StickerDeleteHandle();
			this._delHandle.x = - this._sticker.width * 1.5;
			if (this._delHandle.x < GlobalModelManager.stickerConfig.handle_minX)
			{
				this._delHandle.x = GlobalModelManager.stickerConfig.handle_minX;
			}
			
			this._delHandle.y = this._sticker.height * .5;
			this._delHandle.visible = false;
			this.addChild(this._delHandle);
			
			// attach event listeners
			this._sticker.addEventListener(MouseEvent.MOUSE_DOWN, this.stickerMouseDownHandler);
			this._sticker.addEventListener(MouseEvent.MOUSE_UP, this.stickerMouseUpHandler);
			
			this._editHandle.addEventListener(MouseEvent.MOUSE_DOWN, this.editHandleMouseDownHandler);
			this._editHandle.addEventListener(MouseEvent.MOUSE_UP, this.editHandleMouseUpHandler);
			this._editHandle.addEventListener(MouseEvent.ROLL_OVER, this.editHandleRollOverHandler);
			this._editHandle.addEventListener(MouseEvent.ROLL_OUT, this.editHandleMouseUpHandler);
			
			this._delHandle.addEventListener(MouseEvent.MOUSE_DOWN, this.deleteHandleMouseDownHandler);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
			
		}
		
		
		private function stickerMouseDownHandler($e:MouseEvent):void
		{
			$e.stopImmediatePropagation();
			/**/
			this._selectFrame.visible = true;
			this._editHandle.visible = true;
			this._delHandle.visible = true;
			this.startDrag();
			
		}
		
		
		private function stickerMouseUpHandler($e:MouseEvent):void
		{
			$e.stopImmediatePropagation();
			/**/
			this._selectFrame.visible = false;
			this.stopDrag();
			
		}
		
		
		
		private function deleteHandleMouseDownHandler($e:MouseEvent):void
		{
			//trace("Down");
			$e.stopImmediatePropagation();
			this._ifIntendToRemove = true;
			this.parent.removeChild(this);
		}
		
		
		
		private function editHandleMouseDownHandler($e:MouseEvent):void
		{
			//trace("Down");
			$e.stopImmediatePropagation();
			
			this._mousePrevX = this.parent.mouseX;
			this._mousePrevY = this.parent.mouseY;
			
			var $tempDisX:Number = this.parent.mouseX - this.x;
			var $tempDisY:Number = this.parent.mouseY - this.y;
			this._mouseDownRadian = Math.atan2($tempDisY, $tempDisX);
			
			this._mouseDownDistance = Math.sqrt( $tempDisY * $tempDisY + $tempDisX * $tempDisX );
			
			this._mouseDownScale = this._sticker.scaleX;
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
		}
		
		
		private function editHandleRollOverHandler($e:MouseEvent):void
		{
			
			this._mousePrevX = this.parent.mouseX;
			this._mousePrevY = this.parent.mouseY;
			
			var $tempDisX:Number = this.parent.mouseX - this.x;
			var $tempDisY:Number = this.parent.mouseY - this.y;
			this._mouseDownRadian = Math.atan2($tempDisY, $tempDisX);
			
			this._mouseDownDistance = Math.sqrt( $tempDisY * $tempDisY + $tempDisX * $tempDisX );
			
			this._mouseDownScale = this._sticker.scaleX;
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
		}
		
		
		private function mouseMoveHandler($e:MouseEvent):void
		{
			if ( (Math.abs(this._mousePrevX-this.parent.mouseX) + Math.abs(this._mousePrevY-this.parent.mouseY)) < SENSITIVITY )
			{
				this._mousePrevX = this.parent.mouseX;
				this._mousePrevY = this.parent.mouseY;
				return;
			}
			
			this._mousePrevX = this.parent.mouseX;
			this._mousePrevY = this.parent.mouseY;
			
			var $tempDisX:Number = this.parent.mouseX - this.x;
			var $tempDisY:Number = this.parent.mouseY - this.y;
			
			var $targetRadian:Number = Math.atan2($tempDisY, $tempDisX);
			var $offset:Number = $targetRadian - this._mouseDownRadian;
			this.rotation += ($offset * 180)/Math.PI;
			
			var $targetDistance:Number = Math.sqrt( $tempDisY * $tempDisY + $tempDisX * $tempDisX );
			var $ratio:Number = $targetDistance / this._mouseDownDistance;
			
			var $origWidth:Number = this._sticker.width;
			this._sticker.scaleX = this._sticker.scaleY = this._mouseDownScale * $ratio;
			this._selectFrame.scaleX = this._selectFrame..scaleY = this._sticker.scaleX;
			var $dis:Number = ($origWidth - this._sticker.width);
			this._editHandle.x -= $dis;
		}
		
		
		private function editHandleMouseUpHandler($e:MouseEvent):void
		{
			$e.stopImmediatePropagation();
			this.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
		}
		
		
		private function removedFromStageHandler($e:Event):void
		{
			// determine that if it is removed because user delete it, or just because photo slider comes out
			
			/**/
			if (this._ifIntendToRemove)
			{
				this._sticker.removeEventListener(MouseEvent.MOUSE_DOWN, this.stickerMouseDownHandler);
				this._sticker.removeEventListener(MouseEvent.MOUSE_UP, this.stickerMouseUpHandler);
				this._editHandle.removeEventListener(MouseEvent.MOUSE_DOWN, this.editHandleMouseDownHandler);
				this._editHandle.removeEventListener(MouseEvent.MOUSE_UP, this.editHandleMouseUpHandler);
				this._editHandle.removeEventListener(MouseEvent.ROLL_OVER, this.editHandleRollOverHandler);
				this._editHandle.removeEventListener(MouseEvent.ROLL_OUT, this.editHandleMouseUpHandler);
			
				this._ldr = null;
				this._sticker = null;
				this._selectFrame = null;
				this._editHandle = null;
			}
			
		}
		
		
		

	}
	
}
