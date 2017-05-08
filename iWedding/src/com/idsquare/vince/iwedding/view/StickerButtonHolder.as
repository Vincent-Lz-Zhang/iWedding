package com.idsquare.vince.iwedding.view 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.AVM1Movie;
	import com.idsquare.vince.iwedding.GlobalModelManager;
	
	public class StickerButtonHolder extends Sprite
	{
		public var sid:uint;
		
		private var HOLDER_WIDTH:int = GlobalModelManager.stickerConfig.button_width;
		private var HOLDER_HEIGHT:int = GlobalModelManager.stickerConfig.button_height;
		
		private var _graphic:MovieClip;
		
		public function StickerButtonHolder($graphic:MovieClip, $index:uint) 
		{
			this._graphic = $graphic;
			this.sid = $index;
			
			//this,graphics.beginFill(0x00FF0000);	// red
			this,graphics.beginFill(GlobalModelManager.stickerConfig.button_bgColor);	// pink
			this.graphics.drawRect(0, 0, HOLDER_WIDTH, HOLDER_HEIGHT);
			this.graphics.endFill();
			
			this._graphic.x = GlobalModelManager.stickerList[this.sid].x;
			this._graphic.y = GlobalModelManager.stickerList[this.sid].y;
			this._graphic.scaleX = GlobalModelManager.stickerList[this.sid].scalex;
			this._graphic.scaleY = GlobalModelManager.stickerList[this.sid].scaley;
			
			this.addChild(this._graphic);
			this.mouseChildren = false;
		}

	}
	
}
