package com.idsquare.vince.iwedding 
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	public class GlobalModelManager 
	{
		public static var paper:BitmapData;
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */			
		public function GlobalModelManager() 
		{
			// do nothing
		}
		
		
		public static const XML_PATH:String = "xml/";
		public static const CONFIG_FILE:String = "config.xml";
		public static const STICKER_XML:String = "stickers.xml";
		public static const PHOTOLIST_XML:String = "photolist.xml";
		public static const EFFECT_MANIFEST_XML:String = "effect.xml";
		public static const STICKER_FOLDER:String = "stickers/";
		public static var PAPER_FOLDER:String = "papers/";
		public static var PHOTO_FOLDER:String = "photos/";
		
		
	// global setting variables:	
		public static var settings:Object = {};
		public static var floatingMenuConfig:Object = {};
		public static var menuIcons:Vector.<Object> = new Vector.<Object>;
		public static var paletteConfig:Object = {};
		public static var flipperConfig:Object = {};
		public static var promptConfig:Object = {};
		public static var stickerConfig:Object = {};
		public static var greetingsConfig:Object = {};
		
		public static var stickerList:Vector.<Object> = new Vector.<Object>;
	}
	
}
