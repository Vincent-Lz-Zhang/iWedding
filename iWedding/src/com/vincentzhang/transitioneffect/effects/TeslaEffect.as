package com.vincentzhang.transitioneffect.effects
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import com.greensock.*;
	import com.greensock.data.TweenMaxVars;
	import com.greensock.easing.*;
	import com.greensock.plugins.TweenPlugin;  
    import com.greensock.plugins.ColorTransformPlugin; 
	
	public class TeslaEffect extends Effect
	{
		private var _imageCpy1:Sprite;
		private var _imageCpy2:Sprite;
		
		private var _squares1:Array;
		private var _squares2:Array;
		
		private var _maskContainer1:Sprite;
		private var _maskContainer2:Sprite;
		
		private var _maskTimeline1:TimelineMax;
		private var _maskTimeline2:TimelineMax;
		/*
		private var DELAY_MATRICS:Array = [
										   [12,9,17,0,13,5,12,8], 
										   [1,14,11,15,3,10,2,17], 
										   [10,5,7,8,11,14,9,1], 
										   [14,8,14,2,6,9,11,7]
										   ];
		*/	
		private var DELAY_MATRICS:Array;
		
		public function TeslaEffect($showedImage:BitmapData, $callBack:Function, $options:Object) 
		{
			super($showedImage, $callBack);
			this._settings = 
			{
				mask_width_from: 98,
				mask_height_from: 86,
				num_of_col: 4, 
				num_of_row: 8,
				mask_start_x: 1180,
				mask_width_to: 270,
				mask_height_to: 240,
				mask_scale_dur: 13,
				mask_move_dur: 8,
				mask_x_offset: 64,
				mask_moveback_dur: 5,
				image1_color_offset_from: -200,
				image1_color_offset_to: 0,
				image1_alpha_from: 0,
				image1_alpha_to: 0.5,
				image1_tween_dur: 26,
				image2_color_offset_from: -255,
				image2_color_offset_to: 0,
				image2_tween_dur: 26,
				image2_timeline_delay: 7
			};
			
			// Bitmap constructor can accept null as argument
			var $bmImg1:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy1 = new Sprite();
			this._imageCpy1.addChild($bmImg1);
			
			var $bmImg2:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy2 = new Sprite();
			this._imageCpy2.addChild($bmImg2);
			
			// merge the setting options
			if ($options)
			{
				for (var $prop:String in $options)
				{
					this._settings[$prop] = $options[$prop];
				}
			}
			
			// generate this matrics randomly, the range is [0,17]
			DELAY_MATRICS = new Array();
			
			for (var $x=0; $x<this._settings.num_of_col; $x++)
			{
				var $col:Array = new Array();
				for (var $y=0; $y<this._settings.num_of_row; $y++)
				{
					var $rand:int = Math.floor(Math.random() * 17);
					$col.push($rand);
				}
				DELAY_MATRICS.push($col);
			}
			
		}
		
		
		
		override protected function doGetReady():void
		{
			// set up mask of image1
			this._maskContainer1 = new Sprite();
			this._squares1 = new Array();
			this._maskTimeline1 = new TimelineMax({useFrames:true});
			
			for (var $x=0; $x<this._settings.num_of_col; $x++)
			{
				this._squares1[$x] = new Array();
				for (var $y=0; $y<this._settings.num_of_row; $y++)
				{
					var $square1:Sprite = new Sprite();
					$square1.graphics.beginFill(0x0000FF);
					$square1.graphics.drawRect(0, 0, this._settings.mask_width_from, this._settings.mask_height_from);
					$square1.graphics.endFill();
					$square1.x = - this._settings.mask_width_from / 2;
					$square1.y = - this._settings.mask_height_from / 2;
					
					var $maskUnit1:Sprite = new Sprite();
					$maskUnit1.addChild($square1);
					$maskUnit1.x = this._settings.mask_start_x;
					$maskUnit1.y = (this._settings.mask_height_to/2) + this._settings.mask_height_to * $y;
					
					this._maskContainer1.addChild($maskUnit1);
					this._squares1[$x].push($maskUnit1);
					
					var $target:Number = (this._settings.mask_width_to/2) + this._settings.mask_width_to * $x ;
					
					this._maskTimeline1.insert(  
                                        new TweenLite(  
                                                        $maskUnit1,  
                                                        this._settings.mask_scale_dur,  
                                                        {
															width: this._settings.mask_width_to, 
															height: this._settings.mask_height_to, 
															ease: Linear.easeNone
														}  
                                                      ) 
										 	); 
					this._maskTimeline1.insert(  
                                        new TweenLite(  
                                                        $maskUnit1,  
                                                        this._settings.mask_move_dur,  
                                                        {
															x: $target - this._settings.mask_x_offset, 
															ease: Quart.easeIn
														} 
                                                      ) ,
										DELAY_MATRICS[$x][$y]
										 	); 
					this._maskTimeline1.insert(  
                                        new TweenLite(  
                                                        $maskUnit1,  
                                                        this._settings.mask_moveback_dur,  
                                                        {
															x: $target, 
															ease: Quart.easeOut
														} 
                                                      ) ,
										this._settings.mask_move_dur + DELAY_MATRICS[$x][$y]
										 	); 
				}
			}
			
			// set up mask of image2
			this._maskContainer2 = new Sprite();
			this._squares2 = new Array();
			this._maskTimeline2 = new TimelineMax({useFrames:true});
			
			for (var $u=0; $u<this._settings.num_of_col; $u++)
			{
				this._squares2[$u] = new Array();
				for (var $v=0; $v<this._settings.num_of_row; $v++)
				{
					var $square2:Sprite = new Sprite();
					$square2.graphics.beginFill(0x0000FF);
					$square2.graphics.drawRect(0, 0, this._settings.mask_width_from, this._settings.mask_height_from);
					$square2.graphics.endFill();
					$square2.x = - this._settings.mask_width_from / 2;
					$square2.y = - this._settings.mask_height_from / 2;
					
					var $maskUnit2:Sprite = new Sprite();
					$maskUnit2.addChild($square2);
					$maskUnit2.x = this._settings.mask_start_x;
					$maskUnit2.y = (this._settings.mask_height_to/2) + this._settings.mask_height_to * $v;
					
					this._maskContainer2.addChild($maskUnit2);
					this._squares2[$u].push($maskUnit2);
					
					var $target2:Number = (this._settings.mask_width_to/2) + this._settings.mask_width_to * $u ;
					
					
					this._maskTimeline2.insert(  
                                        new TweenLite(  
                                                        $maskUnit2,  
                                                        this._settings.mask_scale_dur,  
                                                        {
															width: this._settings.mask_width_to, 
															height: this._settings.mask_height_to, 
															ease: Linear.easeNone
														}  
                                                      ) 
										 	); 
					
					this._maskTimeline2.insert(  
                                        new TweenLite(  
                                                        $maskUnit2,  
                                                        this._settings.mask_move_dur,  
                                                        {
															x: $target2 - this._settings.mask_x_offset, 
															ease: Quart.easeIn
														} 
                                                      ) ,
										DELAY_MATRICS[$u][$v]
										 	); 
					
					this._maskTimeline2.insert(  
                                        new TweenLite(  
                                                        $maskUnit2,  
                                                        this._settings.mask_moveback_dur,  
                                                        {
															x: $target2, 
															ease: Quart.easeOut
														} 
                                                      ) ,
										this._settings.mask_move_dur + DELAY_MATRICS[$u][$v]
										 	); 
				}
			}
			
			// setup image1 tween
			this._imageCpy1.mask = this._maskContainer1;
			
			var $col1:ColorTransform = this._imageCpy1.transform.colorTransform;
			$col1.redOffset = this._settings.image1_color_offset_from;
			$col1.greenOffset = this._settings.image1_color_offset_from;
			$col1.blueOffset = this._settings.image1_color_offset_from;
			this._imageCpy1.transform.colorTransform = $col1;
			
			this._imageCpy1.alpha = this._settings.image1_alpha_from;
			this._effect.addChild(this._imageCpy1);
			this._effect.addChild(this._maskContainer1);
			
			this._maskTimeline1.insert(  
                                        new TweenMax(  
                                                        this._imageCpy1,  
                                                        this._settings.image1_tween_dur,  
                                                        {colorTransform:
															{
																redOffset: this._settings.image1_color_offset_to, 
																greenOffset: this._settings.image1_color_offset_to, 
																blueOffset: this._settings.image1_color_offset_to
															}, 
														ease: Quad.easeOut
														}
                                                      ) ,
										1
										 	); 
			
			this._maskTimeline1.insert(  
                                        new TweenMax(  
                                                        this._imageCpy1,  
                                                        this._settings.image1_tween_dur,  
                                                        {
															alpha: this._settings.image1_alpha_to, 
															ease: Quad.easeOut
														}  
                                                      ) ,
										1
										 	);
			
			// set up image2 tween
			this._effect.addChild(this._imageCpy2);
			this._effect.addChild(this._maskContainer2);
			this._imageCpy2.mask = this._maskContainer2;
			
			var $col2:ColorTransform = this._imageCpy2.transform.colorTransform;
			$col2.redOffset = this._settings.image2_color_offset_from;
			$col2.greenOffset = this._settings.image2_color_offset_from;
			$col2.blueOffset = this._settings.image2_color_offset_from;
			this._imageCpy2.transform.colorTransform = $col2;
			
			this._maskTimeline2.insert(  
                                        new TweenMax(  
                                                        this._imageCpy2,  
                                                        this._settings.image2_tween_dur,  
                                                        {
															colorTransform:{
																redOffset: this._settings.image2_color_offset_to, 
																greenOffset: this._settings.image2_color_offset_to, 
																blueOffset: this._settings.image2_color_offset_to
														}, 
														ease: Quad.easeOut}  
                                                      ) ,
										1
										 	); 
			
			// set up overall timeline tween
			this._overallTimeline.gotoAndStop(1);
			this._overallTimeline.insert(this._maskTimeline1, 1);
			this._overallTimeline.insert(this._maskTimeline2, this._settings.image2_timeline_delay);
					
		}
		
		
		
		override protected function doUpdate():void
		{
			/*
			 * can't dispose for the moment
			 */
			// dispose the BitmapData 
			//var $tempBm:Bitmap = this._imageCpy1.getChildAt(0) as Bitmap;
			//$tempBm.bitmapData.dispose();	//
			
			var $bmImg1:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy1.removeChildAt(0);
			this._imageCpy1.addChild($bmImg1);
			
			//$tempBm = this._imageCpy2.getChildAt(0) as Bitmap;
			//$tempBm.bitmapData.dispose();
			
			var $bmImg2:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy2.removeChildAt(0);
			this._imageCpy2.addChild($bmImg2);
		}
		

	}
	
}
