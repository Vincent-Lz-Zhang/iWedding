package com.idsquare.vince.iwedding.view 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.idsquare.vince.iwedding.GlobalModelManager;
	import com.idsquare.vince.iwedding.view.StickerButtonHolder;
	import com.idsquare.vince.iwedding.events.StickersShelfEvent;
	
	public class StickersShelf extends Sprite
	{
		private var START_X:int = GlobalModelManager.stickerConfig.start_x;
		private var START_Y:int = GlobalModelManager.stickerConfig.start_y;
		
		private var NUM_OF_ROW:uint = GlobalModelManager.stickerConfig.num_of_row;
		private var NUM_OF_COL:uint = GlobalModelManager.stickerConfig.num_of_col;
		
		private var TOT_PER_PAGE:uint = NUM_OF_ROW * NUM_OF_COL;
		
		private var PADDING_HOR:uint = GlobalModelManager.stickerConfig.distance_hor;
		private var PADDING_VER:uint = GlobalModelManager.stickerConfig.distance_ver;
		
		private var PAGE_WIDTH:uint = PADDING_HOR * NUM_OF_COL;
		private var PAGE_HEIGHT:uint = PADDING_VER * NUM_OF_ROW;
		
		
		/**
		 * page container
		 *
		 * @private
		 */	
		private var _pageContainer:Sprite;
		/**
		 * @private
		 */	
		private var _pages:Vector.<Sprite> = new Vector.<Sprite>();
		/**
		 * @private
		 */
		private var _pageMovement:uint;
		/**
		 * mask of page
		 *
		 * @private
		 */	
		private var _pageMask:Sprite;
	// interaction with users:	
		/**
		 * keep track of which page is present currently
		 * @private
		 */	
		private var _currentPage:uint;
		/**
		 * the right most position of the page-container, means its x property must be larger than this
		 *
		 * @private
		 */
		private var _minBoundry:Number;
		/**
		 * keep track of which album is just clicked
		 *
		 * @private
		 */
		private var _ifIntendToSelectSticker:Boolean = false;
		
		private var SENSITIVITY:int = GlobalModelManager.stickerConfig.drag_sensitivity;
		/**
		 * @private
		 */
		private var _isDragging:Boolean;
		/**
		 * the x position of mouse when it pressed
		 *
		 * @private
		 */
		private var _mouseDownPosX:Number = 0;
		/**
		 * the x position of page-container when MouseDown event occures
		 *
		 * @private
		 */
		private var _contStartX:Number = 0;
		
		
		private var _stickerButtons:Vector.<Sprite>;
		
		//private var counter:uint;
		
		public function StickersShelf() 
		{
			// do nothing
		}
		
		
		public function build():void
		{
			/*
			 * add skin
			 */
			if (GlobalModelManager.stickerConfig.skin.length > 0)
			{
				for each(var $item in GlobalModelManager.stickerConfig.skin)
				{
					var $lai:Bitmap = new Bitmap($item.bmd);
					$lai.x = $item.x;
					$lai.y = $item.y;
					
					this.addChild($lai);
				}
			}
			
			
			if (GlobalModelManager.stickerList.length == 0)
			{
				return;
			}
			
			this._stickerButtons = new Vector.<Sprite>(GlobalModelManager.stickerList.length);
			this._pageContainer = new Sprite();
			
			var $page:Sprite = new Sprite();
				
			for (var $i:int=0; $i<GlobalModelManager.stickerList.length; $i++)
			{
				/* calculate its position within page, per page */
				var $pageIndx:uint = $i % TOT_PER_PAGE;
				var $stickerBtn:StickerButtonHolder = new StickerButtonHolder(GlobalModelManager.stickerList[$i].sticker, $i);
				$stickerBtn.x = ($pageIndx % NUM_OF_COL) * PADDING_HOR;
				$stickerBtn.y = Math.floor($pageIndx / NUM_OF_COL) * PADDING_VER;
				
				//this._stickerButtons.push($stickerBtn);	// really interesting, this causes problems, 
															// since the vector is instantiated with length, 
															// push operation will append item from position '3', 
															// that will make the vector more length;
				this._stickerButtons[$i] = $stickerBtn;
				$stickerBtn.addEventListener(MouseEvent.CLICK, this.stickerButtonMouseDownHandler);
				
				/* if the previous page is full, then create a new page */
				if ( ($i > 0) && ($pageIndx == 0) )
				{
					$page = new Sprite();
					$page.x = Math.floor($i / TOT_PER_PAGE) * PAGE_WIDTH;	// 
				}
				
				$page.addChild($stickerBtn);
				
				if ($pageIndx == 0)
				{
					this._pages.push($page);
				}
			}
			
			this._pageContainer.x = START_X;
			this._pageContainer.y = START_Y;
			
			for each (var $p:Sprite in this._pages)
			{
				this._pageContainer.addChild($p);
			}
				
			/* cache it */
			//this._pageContainer.cacheAsBitmap = true;
				
			/* apply mask if there are more than one page */
			this.addChild(this._pageContainer);
			
			if (this._pages.length > 1)
			{
				this._pageMask = new Sprite();
				this._pageMask.graphics.beginFill(0x33FFFF);
				this._pageMask.graphics.drawRect(0, 0, PAGE_WIDTH, PAGE_HEIGHT);
				this._pageMask.graphics.endFill();
				this._pageMask.x = START_X; 
				this._pageMask.y = START_Y;
					
				this._pageContainer.mask = this._pageMask;
				this.addChild(this._pageMask);
				
				/* set up the interaction logics with user */
				this._currentPage = 0;	// this index indicate the rendered page currently, and it is used to calculate the position of page-container
				
				this._minBoundry = (- PAGE_WIDTH * (this._pages.length-1)) + START_X;	// 
			}
			//this.mouseChildren = false;
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}
		
		
		/**
		 * tween the page container.
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function slidePages():void
		{
			if (this._pageContainer.x < START_X && this._pageContainer.x > this._minBoundry)
			{
				var $direction:Number = this._pageContainer.x - this._contStartX;
				var $target:Number;
				var $p:int;
				if ($direction > 0)// right
				{
					$target = this._contStartX + PAGE_WIDTH;
					$p = -1;
				}
				else if ($direction < 0)// left
				{
					$target = this._contStartX - PAGE_WIDTH;
					$p = 1;
				}
				
				this.lock();
				
				TweenLite.to(
							 	this._pageContainer, 
								0.55, 
								{
									x:$target, 
									ease:Circ.easeOut,
									onComplete: this.onPagesSlided,
									onCompleteParams: [$p]
								}
							 );
			}
		}
		
		
		/**
		 * disable mouse event.
		 * 
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function lock():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		
		/**
		 * enable mouse event.
		 * 
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function unlock():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		
		
		
		
		private function addedToStageHandler($e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
			/*
			for each (var $item in this._stickerButtons)
			{
				$item.addEventListener(MouseEvent.MOUSE_DOWN, this.stickerButtonMouseDownHandler);
			}
			*/
			if (this._pages.length > 1)
			{
			
				this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
			}
		}
		
		
		private function removedFromStageHandler($e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			/*
			for each (var $item in this._stickerButtons)
			{
				$item.removeEventListener(MouseEvent.MOUSE_DOWN, this.stickerButtonMouseDownHandler);
			}
			*/
			if (this._pages.length > 1)
			{
				this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
			}
		}
		
		
		private function stickerButtonMouseDownHandler($e:MouseEvent):void
		{
			$e.stopPropagation();
			
			var $sid:int;
			var $evt:StickersShelfEvent;
			
			if (this._pages.length > 1)
			{
				if (this._ifIntendToSelectSticker)
				{
					this._ifIntendToSelectSticker = false;
					
					$sid = $e.target.sid;
					$evt = new StickersShelfEvent(StickersShelfEvent.STICKER_SELECTED, $sid);
					this.dispatchEvent($evt);
				}
				else
				{
					return;
				}	
			}
			
			/*
			 * no matter that if the user intend to do what, 
			 * there is sole one page, it must be to select a album
			 */
			else
			{
				$sid = $e.target.sid;
				$evt = new StickersShelfEvent(StickersShelfEvent.STICKER_SELECTED, $sid);
				this.dispatchEvent($evt);
			}
			
		}
		
		
		/**
		 * Event handler for the MOUSE_DOWN on page mask.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function mouseDownHandler($e:MouseEvent):void
		{
			/* reset vars */
			this._isDragging = true;
			this._mouseDownPosX = this._pageMask.mouseX;
			this._contStartX = this._pageContainer.x;
			
			/* attach listeners */
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseUpHandler);
		}
		
		
		/**
		 * Event handler for the MOUSE_MOVE on page mask.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function mouseMoveHandler($e:MouseEvent):void
		{
			var $movement:Number = this._pageMask.mouseX - this._mouseDownPosX;
			
			/* restrict the pageContainer's movement, only slide one page per one tap gesture */
			var $absMovement = Math.abs($movement);
			if ($absMovement > PAGE_WIDTH)
			{
				$movement = PAGE_WIDTH * ($absMovement / $movement);	// get direction
			}
			
			/* if the movement distance is less than 4, then we consider user might intend to select album */
			if ( Math.abs($movement) < SENSITIVITY )
			{
				return;
			}
			
			var $x:Number = this._contStartX + $movement;
			
			/* restrict the pageContainer's position, within its range */
			$x = Math.min(START_X, $x);
			$x = Math.max(this._minBoundry, $x);
			
			this._pageContainer.x = $x;
		}
		
		
		/**
		 * Event handler for the MOUSE_UP on page mask.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function mouseUpHandler($e:MouseEvent):void
		{
			this._isDragging = false;
			this.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseUpHandler);
			
			if ( Math.abs(this._pageMask.mouseX - this._mouseDownPosX) < SENSITIVITY )	// user intends to click album
			{
				/* if detect user intends to select album, then regisiter it globally, then laterly it can be processed */
				this._ifIntendToSelectSticker = true;
			}
			else	// user intends to drag pages
			{
				this._ifIntendToSelectSticker = false;
				
				if ( (this._pageContainer.x - START_X) % PAGE_WIDTH == 0 )
				{
					//trace("no need to tween");
					// set current page
					if (this._pageContainer.x > this._contStartX)
					{
						this._currentPage++; 
					}
					else
					{
						this._currentPage--;
					}
				
					this._contStartX = 0;
				}
				else
				{
					this.slidePages();
				}
			
			}
			
			this._mouseDownPosX = 0;			
		}
		
		
		
		
	// CALLBACKS:
	
		/**
		 * called at the page container be slided.
		 * 
		 * @param	$p	augment of page index	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function onPagesSlided($p:int):void
		{
			this._contStartX = 0;
			this._ifIntendToSelectSticker = false;
			this._currentPage += $p;
			this.unlock();
		}	
		

	}
	
}
