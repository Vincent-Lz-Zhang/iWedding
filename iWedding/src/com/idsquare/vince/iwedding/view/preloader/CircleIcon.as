package com.idsquare.vince.iwedding.view.preloader
{
	import flash.display.MovieClip;
	import com.idsquare.vince.iwedding.view.preloader.Preloader;
	
	public class CircleIcon extends MovieClip
	{

		public function CircleIcon() 
		{
			this.addFrameScript(53,lastFrameFunction);
		}
		
		
		private function lastFrameFunction():void
		{
			if (!this.parent)
			{
				return;
			}
			
			var $pre:Preloader = this.parent as Preloader;
			
			if ($pre.mark)
			{
				this.scaleX = 1;
				this.scaleY = 1;
				$pre.reportCounter();
			}
			
			this.stop ();
		}

	}
	
}
