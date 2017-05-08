package com.idsquare.vince.iwedding.view 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import com.idsquare.vince.iwedding.GlobalModelManager;
	import com.vincentzhang.utils.BeagleLog;
	
	public class DockMenu extends Sprite
	{
		
	// BUTTONS:
		private var _logger:BeagleLog = BeagleLog.getLogger();
		
		public var submitButton:Sprite;
		public var clearAllButton:Sprite;
		public var settingsButton:Sprite;
		public var createNewButton:Sprite;
		public var eraserButton:Sprite;
		public var stickerButton:Sprite;
		
	// CONSTRUCTOR:
	
		public function DockMenu() 
		{
			if (GlobalModelManager.menuIcons.length == 0)
			{
				// log this problem
				this._logger.customError("there is no menu icon...", 
					"com.idsquare.vince.iwedding.view.DockMenu::DockMenu()");
				return;
			}
			
			var $filter:BitmapFilter = this.getBitmapFilter();
			var $myFilters:Array = new Array();
			$myFilters.push($filter);
			
			
			for each (var $item in GlobalModelManager.menuIcons)
			{
				switch ($item.type)
				{
					case "submit":
						this.submitButton = new Sprite();
						var $sbm:Bitmap = new Bitmap($item.bmd);
						this.submitButton.addChild($sbm);
						this.submitButton.x = $item.left;
						this.submitButton.y = $item.top;
						this.submitButton.filters = $myFilters;
						this.addChild(this.submitButton);
						break;
					case "clearall":
						this.clearAllButton = new Sprite();
						var $cabm:Bitmap = new Bitmap($item.bmd);
						this.clearAllButton.addChild($cabm);
						this.clearAllButton.x = $item.left;
						this.clearAllButton.y = $item.top;
						this.clearAllButton.filters = $myFilters;
						this.addChild(this.clearAllButton);
						break;
					case "strokesetting":
						this.settingsButton = new Sprite();
						var $ssbm:Bitmap = new Bitmap($item.bmd);
						this.settingsButton.addChild($ssbm);
						this.settingsButton.x = $item.left;
						this.settingsButton.y = $item.top;
						this.settingsButton.filters = $myFilters;
						this.addChild(this.settingsButton);
						break;
					case "newpage":
						this.createNewButton = new Sprite();
						var $cnbm:Bitmap = new Bitmap($item.bmd);
						this.createNewButton.addChild($cnbm);
						this.createNewButton.x = $item.left;
						this.createNewButton.y = $item.top;
						this.createNewButton.filters = $myFilters;
						this.addChild(this.createNewButton);
						break;
					case "eraser":
						this.eraserButton = new Sprite();
						var $ebm:Bitmap = new Bitmap($item.bmd);
						this.eraserButton.addChild($ebm);
						this.eraserButton.x = $item.left;
						this.eraserButton.y = $item.top;
						this.eraserButton.filters = $myFilters;
						this.addChild(this.eraserButton);
						break;
					case "sticker":
						this.stickerButton = new Sprite();
						var $stbm:Bitmap = new Bitmap($item.bmd);
						this.stickerButton.addChild($stbm);
						this.stickerButton.x = $item.left;
						this.stickerButton.y = $item.top;
						this.stickerButton.filters = $myFilters;
						this.addChild(this.stickerButton);
						break;	
					default:
						this._logger.customError("menu icon type invalid...", 
							"com.idsquare.vince.iwedding.view.DockMenu::DockMenu()");
						break;
				}
				
				
			}
			
		}
		
		
		private function getBitmapFilter():BitmapFilter {
			var $color:Number = 0x000000;
			var $angle:Number = 45;
			var $alpha:Number = 0.6;
			var $blurX:Number = 8;
			var $blurY:Number = 8;
			var $distance:Number = 4;
			var $strength:Number = 0.65;
			var $inner:Boolean = false;
			var $knockout:Boolean = false;
			var $quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter($distance,
										$angle,
										$color,
										$alpha,
										$blurX,
										$blurY,
										$strength,
										$quality,
										$inner,
										$knockout);
		}
		

	}
	
}
