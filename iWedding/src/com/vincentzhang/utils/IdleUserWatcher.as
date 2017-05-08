package com.vincentzhang.utils 
{
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import com.vincentzhang.utils.BeagleLog;
	
	public class IdleUserWatcher extends EventDispatcher
	{
		public static const BROADCAST_IDLE:String = "broadcastIdle";
		private var _logger:BeagleLog = BeagleLog.getLogger();
		// actually I think this var default value does not matter
		private var _isActive:Boolean = false;
		
		private var _idleTime:uint = 5000;
		private var _timer:Timer;
		private var _stage:Stage;

		public function IdleUserWatcher($idleTime:uint, $stage:Stage) 
		{
			if ($stage == null)
			{
				// log this problem
				this._logger.customError("the stage reference passed is null...", 
					"com.vincentzhang.utils.IdleUserWatcher::IdleUserWatcher()");
			}
			
			this._stage = $stage;
			
			if ($idleTime >5000 )
			{
				this._idleTime = $idleTime;
			}
			
			
			this._timer = new Timer(this._idleTime);
			this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
		}
		
		public function startWatching():void
		{
			// should I reset _isActive to true?
			
			this._timer.start();
			this._stage.addEventListener(MouseEvent.MOUSE_DOWN, this.stageTouchedHandler);
		}
		
		public function stopWatching():void
		{
			// should I reset _isActive to false?
			
			this._timer.stop();
			
			if ( this._stage.hasEventListener(MouseEvent.MOUSE_DOWN) )
			{
				this._stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.stageTouchedHandler);
			}
		}

		private function timerHandler($e:TimerEvent):void
		{
			// if this point reached, means that 
			// long time user inactive
			this._isActive = false;
			// dispatch the event
			var $eve:Event = new Event(BROADCAST_IDLE);
			this.dispatchEvent($eve);
		}
		
		private function stageTouchedHandler($e:MouseEvent):void
		{
			this._isActive = true;
			this._timer.reset();
			this._timer.start();
		}
	
		/* accessor */
		public function get isActive():Boolean
		{
			return this._isActive;
		}
	}
	
}
