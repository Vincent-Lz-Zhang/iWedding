package com.idsquare.vince.iwedding.view.preloader
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.idsquare.vince.iwedding.view.preloader.CircleIcon;
	
	public class Preloader extends Sprite
	{
		public var mark:Boolean = false;
		private var _counter:uint;
		
		private var _timer:Timer;
		private var _iconNumber:uint;
		private var _percentage:uint;
		private var _initialPosition_X:uint;
		private var _initialPosition_Y:uint;
		
		private var _icons:Vector.<CircleIcon> = new Vector.<CircleIcon>();
		
		public function Preloader() 
		{
			this._timer = new Timer(200);
			this._timer.addEventListener(TimerEvent.TIMER, this.timerTickHandler);
			
			for (var $i:int=0; $i<20; $i++)
			{
				var $ci:CircleIcon = new CircleIcon();
				this._icons.push($ci);
			}
			
			this._percentage = 1;
			this._iconNumber = 0;
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}
		
		
		public function reportCounter():void
		{
			if (this.mark)
			{
				this._counter++;
				
				if (this._counter==20)
				{
					this.mark = false;
				}
			}
		}
		
		
		private function addIcon():void
		{
			if (this.numChildren < 20)
			{
				this.addChild(this._icons[this.numChildren]);
			}
			
			var $wayX:int = Math.random() * 10 + 1;
			var $wayY:int = Math.random() * 10 + 1;
			
			if ($wayX < 6)
			{
				this._icons[_iconNumber].x = this._initialPosition_X 
												- Math.random() * this._icons[this._iconNumber].width
												- Math.random() * this._iconNumber;
			}
			else
			{
				this._icons[_iconNumber].x = this._initialPosition_X 
												+ Math.random() * this._icons[this._iconNumber].width
												+ Math.random() * this._iconNumber;
			}
			
			if ($wayY < 6)
			{
				this._icons[_iconNumber].y = this._initialPosition_Y 
												- Math.random() * this._icons[this._iconNumber].height 
												- Math.random() * this._iconNumber;
			}
			else
			{
				this._icons[_iconNumber].y = this._initialPosition_Y 
												+ Math.random() * this._icons[this._iconNumber].height 
												+ Math.random() * this._iconNumber;
			}

			this._icons[_iconNumber].alpha = this._percentage / 100 + .5;
			
			this._icons[_iconNumber].scaleX = this._icons[_iconNumber].scaleX + this._percentage / 100;
			this._icons[_iconNumber].scaleY = this._icons[_iconNumber].scaleY + this._percentage / 100;
			
			this._icons[_iconNumber].percentageText.percentageTxt.text = this._percentage.toString();

			this._icons[_iconNumber].gotoAndPlay(1);
		}
		
		
		private function addedToStageHandler($e:Event):void
		{
			this._initialPosition_X = this.stage.stageWidth / 2;
			this._initialPosition_Y = this.stage.stageHeight / 2;
			this._timer.start();
		}
		
		
		private function timerTickHandler($e:Event):void
		{
			this.addIcon();
			
			// increase counters
			this._percentage++;
			if (this._percentage == 101)
			{
				this._percentage = 1;
				this.mark = true;
			}
			this._iconNumber++;
			if (this._iconNumber == 20)
			{
				this._iconNumber = 0;
			}
		}
		

	}
	
}
