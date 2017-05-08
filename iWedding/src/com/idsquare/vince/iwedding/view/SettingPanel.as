package com.idsquare.vince.iwedding.view 
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import com.idsquare.vince.iwedding.GlobalModelManager;
	import com.idsquare.vince.iwedding.view.Palette;
	import com.idsquare.vince.iwedding.view.Thickness;
	
	public class SettingPanel extends Sprite
	{
		private var _paletteBmd:BitmapData;
		private var _palette:Palette;
		private var _thickness:Thickness;
		private var _color:uint;
		private var _colorTransform:ColorTransform;
		
		private var _initThick:uint = GlobalModelManager.paletteConfig.thickness_Initval;
		private var _thickAugment:uint = GlobalModelManager.paletteConfig.thickness_Augment;
		private var _maxThick:uint = GlobalModelManager.paletteConfig.thickness_Max;
		
		public function SettingPanel() 
		{
			this._colorTransform = new ColorTransform();
			
			this._thickness = new Thickness();
			this._thickness.x = thicknessPanel.x;
			this._thickness.y = thicknessPanel.y;
			this._thickness.width = this._initThick;
			this._thickness.height = this._initThick;
			this.addChild(this._thickness);
			
			this._palette = new Palette();
			this._palette.x = thicknessPanel.x + thicknessPanel.width / 2 + GlobalModelManager.paletteConfig.paletteLeft;
			this._palette.y = GlobalModelManager.paletteConfig.paletteTop;
			this.addChild(this._palette);
			
			this._paletteBmd = new BitmapData(this._palette.width, this._palette.height);
			this._paletteBmd.draw(this._palette);
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}
		
		
		
	// HANDLERS:
	
		private function addedToStageHandler($e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
			this._palette.addEventListener(MouseEvent.MOUSE_UP, this.palletteMouseUpHandler);
			thicknessPanel.addEventListener(MouseEvent.MOUSE_UP, this.thicknessMouseUpHandler);
			this._thickness.addEventListener(MouseEvent.MOUSE_UP, this.thicknessMouseUpHandler);
		}
		
		
		private function removedFromStageHandler($e:Event):void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
			this._palette.removeEventListener(MouseEvent.MOUSE_UP, this.palletteMouseUpHandler);
			thicknessPanel.removeEventListener(MouseEvent.MOUSE_UP, this.thicknessMouseUpHandler);
			this._thickness.removeEventListener(MouseEvent.MOUSE_UP, this.thicknessMouseUpHandler);
		}
		
		
		private function thicknessMouseUpHandler($e:MouseEvent):void
		{
			if (this._thickness.width >= this._maxThick)
			{
				this._thickness.width = this._initThick;
				this._thickness.height = this._initThick;
			}
			else
			{
				this._thickness.width += this._thickAugment;
				this._thickness.height = this._thickness.width;
			}
		}


		private function palletteMouseUpHandler($e:MouseEvent = null):uint
		{
			this._color = this._paletteBmd.getPixel(this._palette.mouseX, this._palette.mouseY);
			
			this._colorTransform.color = this._color;
			this._thickness.transform.colorTransform = this._colorTransform;
			
			return this._color;
		}
		
		
		public function get color():uint
		{
			return this._color;
		}
		
		
		public function get thicknessVal():uint
		{
			return this._thickness.width;
		}
		

	}
	
}
