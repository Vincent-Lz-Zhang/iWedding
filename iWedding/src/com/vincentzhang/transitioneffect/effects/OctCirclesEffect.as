package com.vincentzhang.transitioneffect.effects 
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import com.greensock.*;
	import com.greensock.data.TweenMaxVars;
    import com.greensock.easing.*;
	
	public class OctCirclesEffect extends Effect
	{
		private var _imageCpy1:Sprite;
		private var _imageCpy2:Sprite;
		
		private var _image3Cont:Sprite;
		private var _imageCpy3:Sprite;
		
		private var _imageCpy4:Sprite;
		
		private var _ellipses1:Array;
		private var _ellipses2:Array;
		private var _ellipses3:Array;
		
		private var _maskContainer1:Sprite;
		private var _maskContainer2:Sprite;
		private var _maskContainer3:Sprite;
		
		private var _maskTimeline1:TimelineMax;
		private var _maskTimeline2:TimelineMax;
		private var _maskTimeline3:TimelineMax;
		private var _image4Timeline:TimelineMax;
		
		private var POS_MATRICS_MASK1:Array = [
											  	[{x: 273.55, y: 234.75 }, {x: -29.1, y: 770.45 }],
												[{x: 822.15, y: 245.7 }, {x: 511.2, y: 830.4 }],
												[{x: 1426.95, y: 260.4 }, {x: 1099.35, y: 787.45 }],
												[{x: 1808.75, y: 260.4 }, {x: 1729.8, y: 751.9 }]
											   ];
		private var DELAY_MATRICS_MASK1:Array = [
											  	 [3,12], 
												 [1,10], 
												 [4,9],
												 [6,8]
											   ];
	
	
		private var POS_MATRICS_MASK2:Array = [
											  	[{x: 273.55, y: 234.75 }, {x: 185.2, y: 595.15 }],
												[{x: 822.15, y: 245.7 }, {x: 725.7, y: 655.1 }],
												[{x: 1426.95, y: 260.4 }, {x: 1227.95, y: 729.05 }],
												[{x: 1808.75, y: 260.4 }, {x: 1665.35, y: 712.95 }]
											   ];
		private var DELAY_MATRICS_MASK2:Array = [
											  	 [10,2], 
												 [8,11], 
												 [7,6],
												 [4,1]
											   ];	
	
	
		private var POS_MATRICS_MASK3:Array = [
											  	[{x: 273.55, y: 234.75 }, {x: 163.75, y: 750.95 }],
												[{x: 822.15, y: 245.7 }, {x: 618.55, y: 674.45 }],
												[{x: 1362.65, y: 279.75 }, {x: 1163.65, y: 729.05 }],
												[{x: 1808.75, y: 260.4 }, {x: 1729.65, y: 751.9 }]
											   ];
		private var DELAY_MATRICS_MASK3:Array = [
											  	 [4,11], 
												 [2,12], 
												 [5,13],
												 [7,9]
											   ];	
		

		public function OctCirclesEffect($showedImage:BitmapData, $callBack:Function, $options:Object) 
		{
			super($showedImage, $callBack);
			this._settings = 
			{
				num_of_col: 4,
				num_of_row: 2,
				
				mask_ellipse_short_radious: 847,
				mask_ellipse_long_radious: 889.56,
				mask_scale_dur_1st: 16,
				mask_scale_dur_2nd: 24,
				mask_scale_from: 0.053,
				mask_scale_intermid: 0.664,
				mask_scale_to: 1,
				
				image1_offset_y_from: 69,
				image1_offset_y_to: 0,
				image1_alpha_from: 0,
				image1_alpha_to: 0.9,
				image1_tween_dur: 34,
				
				image2_color_offset: 100,
				image2_x_offset_from: 215,
				image2_x_offset_to: 0,
				image2_tween_dur: 40,
				image2_tween_delay: 9,
				
				image3_alpha_from: 0,
				image3_alpha_to: 1,
				image3_color_offset_from: 255,
				image3_color_offset_to: 0,
				image3_x_offset_from: 173,
				image3_x_offset_to: 0,
				image3_tween_dur: 38,
				image3_tween_delay: 19,
				
				image4_alpha_from: 0,
				image4_alpha_to: 1,
				image4_tween_dur: 26,
				image4_tween_delay: 51				
			}
			
			// Bitmap constructor can accept null as argument
			var $bmImg1:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy1 = new Sprite();
			this._imageCpy1.addChild($bmImg1);
			
			var $bmImg2:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy2 = new Sprite();
			this._imageCpy2.addChild($bmImg2);
			
			var $bmImg3:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy3 = new Sprite();
			this._imageCpy3.addChild($bmImg3);
			
			var $bmImg4:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy4 = new Sprite();
			this._imageCpy4.addChild($bmImg4);

			// merge the setting options
			if ($options)
			{
				for (var $prop:String in $options)
				{
					this._settings[$prop] = $options[$prop];
				}
			}
			
		}
		
		
		override protected function doGetReady():void
		{
			/* let us draw a ellipse */
			this._ellipses1 = new Array();
			this._ellipses2 = new Array();
			this._ellipses3 = new Array();
			
			this._maskContainer1 = new Sprite();
			this._maskContainer2 = new Sprite();
			this._maskContainer3 = new Sprite();
			
			this._maskTimeline1 = new TimelineMax({useFrames:true});
			this._maskTimeline2 = new TimelineMax({useFrames:true});
			this._maskTimeline3 = new TimelineMax({useFrames:true});
			
			var $ellipse:Sprite;
			
			for (var $h:int = 0; $h < this._settings.num_of_col; $h++)
			{
				this._ellipses1[$h] = new Array();
				this._ellipses2[$h] = new Array();
				this._ellipses3[$h] = new Array();
								
				for (var $j:int = 0; $j < this._settings.num_of_row; $j++)
				{
					/* create the ellipses for mask of image copy 1 */
					$ellipse = new Sprite();
					$ellipse.graphics.beginFill(0x445577);
					$ellipse.graphics.drawEllipse( - this._settings.mask_ellipse_short_radious / 2, 
												  - this._settings.mask_ellipse_long_radious / 2, 
												  this._settings.mask_ellipse_short_radious, 
												  this._settings.mask_ellipse_long_radious);
					$ellipse.graphics.endFill();
					$ellipse.x = POS_MATRICS_MASK1[$h][$j].x;
					$ellipse.y = POS_MATRICS_MASK1[$h][$j].y;
					$ellipse.scaleX = this._settings.mask_scale_from;
					$ellipse.scaleY = this._settings.mask_scale_from;
					this._ellipses1[$h].push($ellipse);
					
					this._maskTimeline1.insert(  
                                      		  new TweenLite(  
                                                     		   $ellipse,  
                                                     		   this._settings.mask_scale_dur_1st,  
                                                     		   {
																   scaleX: this._settings.mask_scale_intermid, 
																   scaleY: this._settings.mask_scale_intermid, 
																   ease: Circ.easeIn
															   }  
                                                   		   ) ,
												DELAY_MATRICS_MASK1[$h][$j]
										 	); 
					
					this._maskTimeline1.insert(  
                                      		  new TweenLite(  
                                                     		   $ellipse,  
                                                     		   this._settings.mask_scale_dur_2nd,  
                                                     		   {
																   scaleX: this._settings.mask_scale_to, 
																   scaleY: this._settings.mask_scale_to, 
																   ease: Cubic.easeOut
															   }  
                                                   		   ) ,
												DELAY_MATRICS_MASK1[$h][$j] + this._settings.mask_scale_dur_1st + 1
										 	); 
					
					this._maskContainer1.addChild($ellipse);
					
					
					/* create the ellipses for mask of image copy 2 */
					$ellipse = new Sprite();
					$ellipse.graphics.beginFill(0x445577);
					$ellipse.graphics.drawEllipse( - this._settings.mask_ellipse_short_radious / 2, 
												  - this._settings.mask_ellipse_long_radious / 2, 
												  this._settings.mask_ellipse_short_radious, 
												  this._settings.mask_ellipse_long_radious);
					$ellipse.graphics.endFill();
					$ellipse.x = POS_MATRICS_MASK2[$h][$j].x;
					$ellipse.y = POS_MATRICS_MASK2[$h][$j].y;
					$ellipse.scaleX = this._settings.mask_scale_from;
					$ellipse.scaleY = this._settings.mask_scale_from;
					this._ellipses2[$h].push($ellipse);
					
					this._maskTimeline2.insert(  
                                      		  new TweenLite(  
                                                     		   $ellipse,  
                                                     		   this._settings.mask_scale_dur_1st,  
                                                     		   {
																   scaleX: this._settings.mask_scale_intermid, 
																   scaleY: this._settings.mask_scale_intermid, 
																   ease: Circ.easeIn
															   }  
                                                   		   ) ,
												DELAY_MATRICS_MASK2[$h][$j]
										 	); 
					
					this._maskTimeline2.insert(  
                                      		  new TweenLite(  
                                                     		   $ellipse,  
                                                     		   this._settings.mask_scale_dur_2nd,  
                                                     		   {
																   scaleX: this._settings.mask_scale_to, 
																   scaleY: this._settings.mask_scale_to, 
																   ease: Cubic.easeOut
															   }  
                                                   		   ) ,
												DELAY_MATRICS_MASK2[$h][$j] + this._settings.mask_scale_dur_1st + 1
										 	); 
					
					this._maskContainer2.addChild($ellipse);

					
					/* create the ellipses for mask of image copy 3 */
					$ellipse = new Sprite();
					$ellipse.graphics.beginFill(0x445577);
					$ellipse.graphics.drawEllipse( - this._settings.mask_ellipse_short_radious / 2, 
												  - this._settings.mask_ellipse_long_radious / 2, 
												  this._settings.mask_ellipse_short_radious, 
												  this._settings.mask_ellipse_long_radious);
					$ellipse.graphics.endFill();
					$ellipse.x = POS_MATRICS_MASK3[$h][$j].x;
					$ellipse.y = POS_MATRICS_MASK3[$h][$j].y;
					$ellipse.scaleX = this._settings.mask_scale_from;
					$ellipse.scaleY = this._settings.mask_scale_from;
					this._ellipses3[$h].push($ellipse);
					
					this._maskTimeline3.insert(  
                                      		  new TweenLite(  
                                                     		   $ellipse,  
                                                     		   this._settings.mask_scale_dur_1st,  
                                                     		   {
																   scaleX: this._settings.mask_scale_intermid, 
																   scaleY: this._settings.mask_scale_intermid, 
																   ease: Circ.easeIn
															   }  
                                                   		   ) ,
												DELAY_MATRICS_MASK3[$h][$j]
										 	); 
					
					this._maskTimeline3.insert(  
                                      		  new TweenLite(  
                                                     		   $ellipse,  
                                                     		   this._settings.mask_scale_dur_2nd,  
                                                     		   {
																   scaleX: this._settings.mask_scale_to, 
																   scaleY: this._settings.mask_scale_to, 
																   ease: Cubic.easeOut
															   }  
                                                   		   ) ,
												DELAY_MATRICS_MASK3[$h][$j] + this._settings.mask_scale_dur_1st + 1
										 	); 
					
					this._maskContainer3.addChild($ellipse);

				}
			
			}	// end of for
			
			this._imageCpy1.alpha = this._settings.image1_alpha_from;
			this._imageCpy1.y = this._settings.image1_offset_y_from;
			this._imageCpy1.mask = this._maskContainer1;
			
			this._effect.addChild(this._imageCpy1);
			this._effect.addChild(this._maskContainer1);
			
			
			this._maskTimeline1.insert(  
                                        new TweenLite(  
                                                        this._imageCpy1,  
                                                        this._settings.image1_tween_dur,  
                                                        {
															y: this._settings.image1_offset_y_to, 
															alpha: this._settings.image1_alpha_to, 
															ease: Quad.easeOut
														}  
                                                      ) 
										 	); 
			
			
			
			this._imageCpy2.x = this._settings.image2_x_offset_from;
			var $col2:ColorTransform = this._imageCpy2.transform.colorTransform;
			$col2.redOffset = this._settings.image2_color_offset;
			$col2.greenOffset = this._settings.image2_color_offset;
			$col2.blueOffset = this._settings.image2_color_offset;
			this._imageCpy2.transform.colorTransform = $col2;
			
			this._imageCpy2.mask = this._maskContainer2;
			
			this._effect.addChild(this._imageCpy2);
			this._effect.addChild(this._maskContainer2);
			
			this._maskTimeline2.insert(  
                                        new TweenLite(  
                                                        this._imageCpy2,  
                                                        this._settings.image2_tween_dur,  
                                                        {
															x: this._settings.image2_x_offset_to, 
															ease: Quad.easeOut
														}  
                                                      ) 
										 	); 
			
			
			
			this._imageCpy3.x = this._settings.image3_x_offset_from;
			this._imageCpy3.alpha = this._settings.image3_alpha_from;
			var $col3:ColorTransform = _imageCpy3.transform.colorTransform;
			$col3.redOffset = this._settings.image3_color_offset_from;
			$col3.greenOffset = this._settings.image3_color_offset_from;
			$col3.blueOffset = this._settings.image3_color_offset_from;
			this._imageCpy3.transform.colorTransform = $col3;
			this._imageCpy3.mask = this._maskContainer3;
			
			this._effect.addChild(this._imageCpy3);
			this._effect.addChild(this._maskContainer3);
			
			this._maskTimeline3.insert(  
                                        new TweenLite(  
                                                        this._imageCpy3,  
                                                        this._settings.image3_tween_dur,  
                                                        {
															x: this._settings.image3_x_offset_to, 
															alpha: this._settings.image3_alpha_to, 
															colorTransform:{
																redOffset: this._settings.image3_color_offset_to, 
																greenOffset: this._settings.image3_color_offset_to, 
																blueOffset: this._settings.image3_color_offset_to
															},
															ease: Quad.easeOut
														}  
                                                      ) 
										 	); 
			
			
			this._imageCpy4.alpha = this._settings.image4_alpha_from;
			
			this._effect.addChild(this._imageCpy4);
			
			this._image4Timeline = new TimelineMax({useFrames:true});
			
			this._image4Timeline.insert(  
                                        new TweenLite(  
                                                        this._imageCpy4,  
                                                        this._settings.image4_tween_dur,  
                                                        {
															alpha: this._settings.image4_alpha_to,
															ease: Quad.easeIn
														}  
                                                      ) 
										 	); 
			
			
			this._overallTimeline.gotoAndStop(1);
			this._overallTimeline.insert(this._maskTimeline1, 1);
			this._overallTimeline.insert(this._maskTimeline2, this._settings.image2_tween_delay);
			this._overallTimeline.insert(this._maskTimeline3, this._settings.image3_tween_delay);
			this._overallTimeline.insert(this._image4Timeline, this._settings.image4_tween_delay);
			
		}
					
		
		override protected function doUpdate():void
		{
			// dispose the BitmapData 
			/*
			 * can't dispose for the moment
			 */
			//var $tempBm:Bitmap = this._imageCpy1.getChildAt(0) as Bitmap;
			//$tempBm.bitmapData.dispose();
			
			var $bmImg1:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy1.removeChildAt(0);
			this._imageCpy1.addChild($bmImg1);
			
			var $bmImg2:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy2.removeChildAt(0);
			this._imageCpy2.addChild($bmImg2);
			
			var $bmImg3:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy3.removeChildAt(0);
			this._imageCpy3.addChild($bmImg3);
			
			var $bmImg4:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy4.removeChildAt(0);
			this._imageCpy4.addChild($bmImg4);
		}
		
		

	}
	
}
