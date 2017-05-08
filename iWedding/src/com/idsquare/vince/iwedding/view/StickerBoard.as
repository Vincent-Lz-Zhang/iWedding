package com.idsquare.vince.iwedding.view 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.idsquare.vince.iwedding.view.StickerHolder;
	
	/***
	 * StickerBoard is a container of added stickers.
	 * 
	 * it only has some basic functions to add/remove them. Besides, a proxy method to hide stickers' handles.
	 *
	 * @author 		Vincent Zhang
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.iwedding.view.StickerBoard
	 * 
	 * 
	 * edit 0
	 *	 
	 */
	
	public class StickerBoard extends Sprite
	{

		public function StickerBoard() 
		{
			//this.mouseEnabled = false;
		}
		
		
		public function clearContent():void
		{
			while (this.numChildren)
			{
				this.removeChildAt(0);
			}
		}
		
		
		public function hideStickersHandles():void
		{
			if (this.numChildren > 0)
			{
				var $i:int = 0;
				while ($i < this.numChildren)
				{
					var $chd:StickerHolder = this.getChildAt($i) as StickerHolder;
					$chd.hideHandles();
					$i++;
				}
			}
		}
		
		
		public function lock():void
		{
			this.mouseChildren = false;
		}
		
		
		public function unlock():void
		{
			this.mouseChildren = true;
		}
		

	}
	
}
