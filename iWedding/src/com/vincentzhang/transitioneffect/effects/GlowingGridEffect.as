package com.vincentzhang.transitioneffect.effects
{
	import flash.display.Sprite;
	import flash.display.BlendMode;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import com.greensock.*;
	import com.greensock.data.TweenMaxVars;
    import com.greensock.easing.*;
	
	public class GlowingGridEffect extends Effect
	{
		private var _imageCpy1:Sprite;
		private var _image1Cont:Sprite; 
		private var _imageCpy2:Sprite;
		private var _imageCpy3:Sprite;
		
		private var _squares1:Array;
		private var _squares2:Array;
		
		private var _maskContainer1:Sprite;
		private var _maskContainer2:Sprite;
		
		private var _maskTimeline1:TimelineMax;
		private var _maskTimeline2:TimelineMax;
		
		public function GlowingGridEffect($showedImage:BitmapData, $callBack:Function, $options:Object)
		{
			super($showedImage, $callBack);
			this._settings = 
			{
				mask_width_from: 1,
				mask_height_from: 1,
				num_of_col: 4, 
				num_of_row: 8, 
				mask_distance_x: 270, 
				mask_distance_y: 240,
				mask_width_to: 270,
				mask_height_to: 240,
				mask_tween_dur: 17,
				mask_tween_delay: 3,
				image_offset_x: -332,
				image_offset_y: -573,
				image_scl_x_from: 1.3,
				image_scl_y_from: 1.3,
				image1_alpha_from: 0.45,
				image1_alpha_to: 0.9,
				image1_tween_dur: 26,
				image2_color_offset_from: 255,
				image2_color_offset_to: 0,
				image2_tween_dur: 32,
				image2_tween_delay: 4,
				image3_alpha_from: 0,
				image3_tween_dur: 17,
				image3_tween_delay: 26
			};
			
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
			// draw the squares of mask 1
			this._squares1 = new Array();
			this._maskContainer1 = new Sprite();
			this._maskTimeline1 = new TimelineMax({useFrames:true});
			
			for (var $x=0; $x<this._settings.num_of_col; $x++)
			{
				this._squares1[$x] = new Array();
				for (var $y=0; $y<this._settings.num_of_row; $y++)
				{
					var $square1:Sprite = new Sprite();
					$square1.graphics.beginFill(0x0000FF);
					$square1.graphics.drawRect(0,0,this._settings.mask_width_from,this._settings.mask_height_from);
					$square1.graphics.endFill();
					$square1.x = $x * this._settings.mask_distance_x;
					$square1.y = $y * this._settings.mask_distance_y;
					this._maskContainer1.addChild($square1);
					this._squares1[$x].push($square1);
					
					this._maskTimeline1.insert(  
                                        new TweenLite(  
                                                        $square1,  
                                                        this._settings.mask_tween_dur,  
                                                        {
															width: this._settings.mask_width_to, 
															height: this._settings.mask_height_to, 
															ease: Quint.easeOut
														}  
                                                      ) ,
										(($x+$y) * this._settings.mask_tween_delay + 1)
										 	); 
				}
			}
			
			// draw the squares of mask 2
			this._squares2 = new Array();
			this._maskContainer2 = new Sprite();
			this._maskTimeline2 = new TimelineMax({useFrames:true});
			
			for (var $u=0; $u<this._settings.num_of_col; $u++)
			{
				this._squares2[$u] = new Array();
				for (var $v=0; $v<this._settings.num_of_row; $v++)
				{
					var $square2:Sprite = new Sprite();
					$square2.graphics.beginFill(0x0000FF);
					$square2.graphics.drawRect(0, 0, 
											   this._settings.mask_width_from, 
											   this._settings.mask_height_from);
					$square2.graphics.endFill();
					$square2.x = $u * this._settings.mask_distance_x;
					$square2.y = $v * this._settings.mask_distance_y;
					this._maskContainer2.addChild($square2);
					this._squares2[$u].push($square2);
					
					this._maskTimeline2.insert(  
                                        new TweenLite(  
                                                        $square2,  
                                                        this._settings.mask_tween_dur,  
                                                        {
															width: this._settings.mask_width_to, 
															height: this._settings.mask_height_to, 
															ease: Quint.easeOut
														}  
                                                      ) ,
										(($u+$v) * this._settings.mask_tween_delay + 2)
										 	); 
				}
			}
			
			// settle down the animation of image-1
			this._image1Cont = new Sprite();
			this._image1Cont.blendMode = BlendMode.OVERLAY;
			
			this._imageCpy1.x = this._settings.image_offset_x;
			this._imageCpy1.y = this._settings.image_offset_y;
			this._imageCpy1.scaleX = this._settings.image_scl_x_from;
			this._imageCpy1.scaleY = this._settings.image_scl_y_from;
			this._imageCpy1.alpha = this._settings.image1_alpha_from;
			
			this._image1Cont.addChild(this._imageCpy1);
			this._image1Cont.addChild(this._maskContainer1);
			
			this._imageCpy1.mask = this._maskContainer1;
			
			this._effect.addChild(this._image1Cont);
			
			this._maskTimeline1.insert(  
                                        new TweenLite(  
                                                        this._imageCpy1,  
                                                        this._settings.image1_tween_dur,  
                                                        {
															alpha: this._settings.image1_alpha_to, 
															ease: "linear"
														}  
                                                      ) ,
										1
										 	); 
			
			this._maskTimeline1.insert(  
                                        new TweenLite(  
                                                        this._imageCpy1,  
                                                        this._settings.image1_tween_dur,  
                                                        {
															x: 0, 
															y: 0, 
															scaleX: 1, 
															scaleY: 1, 
															ease: Quad.easeOut
														}  
                                                      ) ,
										1
										 	);
			
			// settle down the animation of image-2
			this._imageCpy2.x = this._settings.image_offset_x;
			this._imageCpy2.y = this._settings.image_offset_y;
			this._imageCpy2.scaleX = this._settings.image_scl_x_from;
			this._imageCpy2.scaleY = this._settings.image_scl_y_from;
			
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
															ease: Quad.easeOut
														}  
                                                      ) ,
										2
										 	); 
			
			this._maskTimeline2.insert(  
                                        new TweenMax(  
                                                        this._imageCpy2,  
                                                        this._settings.image2_tween_dur,  
                                                        {
															x: 0, 
															y: 0, 
															scaleX: 1, 
															scaleY: 1, 
															ease: Quad.easeOut
														}    
                                                      ) ,
										2
										 	);
			
			// set up image3 tween
			this._imageCpy3.alpha = this._settings.image3_alpha_from;
			this._effect.addChild(this._imageCpy3);
			
			// set up overall timeline tween
			this._overallTimeline.gotoAndStop(1);
			this._overallTimeline.insert(this._maskTimeline1, 1);
			this._overallTimeline.insert(this._maskTimeline2, this._settings.image2_tween_delay);
			
			this._overallTimeline.insert(  
                                        	new TweenLite(  
                                                        this._imageCpy3,  
                                                        this._settings.image3_tween_dur,  
                                                        {
															alpha:1, 
															ease: "linear"
														}
                                                      ) ,
											this._settings.image3_tween_delay
										 );
			
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
			
			//$tempBm = this._imageCpy2.getChildAt(0) as Bitmap;
			//$tempBm.bitmapData.dispose();
			
			var $bmImg2:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy2.removeChildAt(0);
			this._imageCpy2.addChild($bmImg2);
			
			//$tempBm = this._imageCpy3.getChildAt(0) as Bitmap;
			//$tempBm.bitmapData.dispose();
			
			var $bmImg3:Bitmap = new Bitmap(this._showedImgBMD);
			this._imageCpy3.removeChildAt(0);
			this._imageCpy3.addChild($bmImg3);
		}
		
		
		
	}
	
}