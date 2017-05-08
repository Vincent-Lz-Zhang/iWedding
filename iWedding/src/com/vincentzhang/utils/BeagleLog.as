package com.vincentzhang.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class BeagleLog 
	{

		private const LOG_FILE_NAME:String = "error.log";
		
		private var _logFile:File = 
						new File(File.applicationDirectory.resolvePath(LOG_FILE_NAME).nativePath);
		
		private var _stream:FileStream = new FileStream();
		
		private static var _instance;
		
		public function BeagleLog() 
		{
			this._stream.addEventListener(IOErrorEvent.IO_ERROR, writeIOErrorHandler);
		}
		
		public static function getLogger():BeagleLog 
		{
			
			if (BeagleLog._instance == null) 
			{
				BeagleLog._instance = new BeagleLog();
			}
			
			return BeagleLog._instance;
		}	

		public function customError($cusMsg:String, $caller:String):void
		{
			var $date:Date = new Date();
			
			if (this._stream != null)	
			{
				this._stream.close();
			}
			
			this._stream = new FileStream();
			this._stream.openAsync(_logFile, FileMode.APPEND);
			
			var $toWrite:String = $date.toLocaleString() + ":\t" 
								+ $caller + ":\t\n"
								+ "\t" + $cusMsg + "\n";
				$toWrite = $toWrite.replace(/\r/g, "\n");
				$toWrite = $toWrite.replace(/\n/g, File.lineEnding);
				this._stream.writeUTFBytes($toWrite);
				this._stream.close();
				
		}
		
		public function customFatalError($cusMsg:String, $caller:String):void
		{
			var $date:Date = new Date();
			
			if (this._stream != null)	
			{
				this._stream.close();
			}
			
			this._stream = new FileStream();
			this._stream.openAsync(_logFile, FileMode.APPEND);
			
			var $toWrite:String = "***************\n"
										+ $date.toLocaleString() + ":\t" 
										+ $caller + ":\t\n"
										+ "\t" + $cusMsg + "\n";
				$toWrite = $toWrite.replace(/\r/g, "\n");
				$toWrite = $toWrite.replace(/\n/g, File.lineEnding);
				this._stream.writeUTFBytes($toWrite);
				this._stream.close();
				
		}
		
		public function buildInError($cusMsg:String, $errMsg:String, $caller:String):void
		{
			var $date:Date = new Date();
			
			if (this._stream != null)	
			{
				this._stream.close();
			}
			
			this._stream = new FileStream();
			this._stream.openAsync(_logFile, FileMode.APPEND);
			
			
			var $toWrite:String = $date.toLocaleString() + ":\t" 
										+ $caller + ":\t\n"
										+ "\t" + $cusMsg + "\n"
										+ "\t" + $errMsg + "\n";
				$toWrite = $toWrite.replace(/\r/g, "\n");
				$toWrite = $toWrite.replace(/\n/g, File.lineEnding);
				this._stream.writeUTFBytes($toWrite);
				this._stream.close();
		}
		
		public function fatalError($fatalMsg:String, $errMsg:String, $caller:String):void
		{
			var $date:Date = new Date();
			
			if (this._stream != null)	
			{
				this._stream.close();
			}
			
			this._stream = new FileStream();
			this._stream.openAsync(_logFile, FileMode.APPEND);
			
			var $toWrite:String = "***************\n"
										+ $date.toLocaleString() + ":\t" 
										+ $caller + ":\t\n"
										+ "\t" + $fatalMsg + "\n"
										+ "\t" + $errMsg + "\n";
				$toWrite = $toWrite.replace(/\r/g, "\n");
				$toWrite = $toWrite.replace(/\n/g, File.lineEnding);
				this._stream.writeUTFBytes($toWrite);
				this._stream.close();
		}
		
		/**
		* Handles I/O errors that may come about when writing the currentFile.
		*/
		private function writeIOErrorHandler($e:IOErrorEvent):void 
		{
			//trace($e);
			//trace("The specified currentFile cannot be saved.");
		}
		
	}
	
}
