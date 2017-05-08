package com.idsquare.vince.iwedding.loaders 
{
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import com.idsquare.vince.iwedding.GlobalModelManager;
	import com.vincentzhang.utils.BeagleLog;
	
	/**
	 * Custom loader be responsive to load config XMLs.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.iwedding.loaders.ConfigLoader
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class ConfigLoader extends EventDispatcher
	{
	// CONSTANTS:	
		public static const CONFIG_LOADED:String = "configLoaded";
		public static const STICKER_LIST_LOADED:String = "stickerListLoaded";
	// logging utilities:
		/**
		 * @private
		 */	
		private var _logger:BeagleLog = BeagleLog.getLogger();
	// loading utilities:
		/**
		 * @private
		 */	
		private var _xmlLoader:URLLoader;	
		

	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */	
		public function ConfigLoader() 
		{
			// do nothing
		}
		
		
		/**
		 * Start the process of the chained loading action, begin at config XML.
		 *  config.
		 *
		 * @see		
		 */
		public function load():void 
		{
			var $req:URLRequest = new URLRequest(GlobalModelManager.XML_PATH + GlobalModelManager.CONFIG_FILE);
			this._xmlLoader = new URLLoader();
			this._xmlLoader.addEventListener(Event.COMPLETE, this.confLoadedHandler);
			this._xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.confIOErrorHandler);
			this._xmlLoader.load($req);
		}
		
		
	// HANDLERS:
	
		/**
		 * Event handler for the Complete event of loading config XML.
		 *  Store the data to GlobalModelManager.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function confLoadedHandler($e:Event):void
		{
			try{
				var $conf:XML = new XML($e.target.data);
				
				/* settings */
				GlobalModelManager.settings.eraser_DefThick = parseFloat( $conf.settings.eraser.@defaultthick.toString() );
				
				GlobalModelManager.settings.imgsaving = {};
				GlobalModelManager.settings.imgsaving.prefixM = $conf.settings.imgsaving.@prefixM.toString();
				GlobalModelManager.settings.imgsaving.prefixA = $conf.settings.imgsaving.@prefixA.toString();
				GlobalModelManager.settings.imgsaving.ext = $conf.settings.imgsaving.@ext.toString();
				GlobalModelManager.settings.imgsaving.path = $conf.settings.imgsaving.@path.toString();
				
				// reset the custom paper texture path
				GlobalModelManager.PAPER_FOLDER = $conf.settings.papers.@path.toString();
				
				GlobalModelManager.settings.papers = {};
				GlobalModelManager.settings.papers.textures = new Vector.<String>();
				
				var $textures = $conf.settings.papers.children();
				
				for each (var $txtr in $textures)
				{
					var $item:String = $txtr.text();
					GlobalModelManager.settings.papers.textures.push($item);
				}
				
				GlobalModelManager.settings.photoslider = {};
				GlobalModelManager.settings.photoslider.idlePeriod = parseInt( $conf.settings.photoslider.@idle_period.toString() );
				GlobalModelManager.settings.photoslider.photoInterval = parseInt( $conf.settings.photoslider.@photo_interval.toString() );
				
				
				/* floating menu */
				GlobalModelManager.floatingMenuConfig.pos = {};
				GlobalModelManager.floatingMenuConfig.pos.left = parseFloat( $conf.floatingmenu.options.pos.@left.toString() );
				GlobalModelManager.floatingMenuConfig.pos.top = parseFloat( $conf.floatingmenu.options.pos.@top.toString() );
				
				
				var $menuIcons = $conf.floatingmenu.icons.children();
				
				for each (var $icon in $menuIcons)
				{
					var $iconItem:Object = {};
					
					$iconItem.file = $icon.text();
					$iconItem.left = parseFloat( $icon.@left.toString() );
					$iconItem.top = parseFloat( $icon.@top.toString() );
					$iconItem.type = $icon.@type.toString();
					GlobalModelManager.menuIcons.push($iconItem);
				}
				
				
				/* palette */
				GlobalModelManager.paletteConfig.paletteTop = parseFloat( $conf.palette.options.palette.@top.toString() );
				GlobalModelManager.paletteConfig.paletteLeft = parseFloat( $conf.palette.options.palette.@left.toString() );
				
				/* thickness */
				GlobalModelManager.paletteConfig.thickness_Initval = parseFloat( $conf.palette.options.thickness.@initval.toString() );
				GlobalModelManager.paletteConfig.thickness_Augment = parseFloat( $conf.palette.options.thickness.@augment.toString() );
				GlobalModelManager.paletteConfig.thickness_Max = parseFloat( $conf.palette.options.thickness.@max.toString() );
				
				GlobalModelManager.paletteConfig.tween_duration = parseFloat( $conf.palette.options.tweener.@duration.toString() );
				
				GlobalModelManager.paletteConfig.standbyX = parseFloat( $conf.palette.options.tween_standby.@x.toString() );
				GlobalModelManager.paletteConfig.standbyY = parseFloat( $conf.palette.options.tween_standby.@y.toString() );
				GlobalModelManager.paletteConfig.standbyAlp = parseFloat( $conf.palette.options.tween_standby.@alpha.toString() );
				
				GlobalModelManager.paletteConfig.activeX = parseFloat( $conf.palette.options.tween_active.@x.toString() );
				GlobalModelManager.paletteConfig.activeY = parseFloat( $conf.palette.options.tween_active.@y.toString() );
				GlobalModelManager.paletteConfig.activeAlp = parseFloat( $conf.palette.options.tween_active.@alpha.toString() );
				
				GlobalModelManager.paletteConfig.dismissedX = parseFloat( $conf.palette.options.tween_dismissed.@x.toString() );
				GlobalModelManager.paletteConfig.dismissedY = parseFloat( $conf.palette.options.tween_dismissed.@y.toString() );
				GlobalModelManager.paletteConfig.dismissedAlp = parseFloat( $conf.palette.options.tween_dismissed.@alpha.toString() );
				
				/* flipper */
				GlobalModelManager.flipperConfig.tween_duration = parseFloat( $conf.flipper.options.tweener.@duration.toString() );
				
				GlobalModelManager.flipperConfig.standbyX = parseFloat( $conf.flipper.options.tween_standby.@x.toString() );
				GlobalModelManager.flipperConfig.standbyY = parseFloat( $conf.flipper.options.tween_standby.@y.toString() );
				GlobalModelManager.flipperConfig.standbyScaleX = parseFloat( $conf.flipper.options.tween_standby.@scaleX.toString() );
				GlobalModelManager.flipperConfig.standbyScaleY = parseFloat( $conf.flipper.options.tween_standby.@scaleY.toString() );
				GlobalModelManager.flipperConfig.standbyAlp = parseFloat( $conf.flipper.options.tween_standby.@alpha.toString() );
				
				GlobalModelManager.flipperConfig.targetX = parseFloat( $conf.flipper.options.tween_target.@x.toString() );
				GlobalModelManager.flipperConfig.targetY = parseFloat( $conf.flipper.options.tween_target.@y.toString() );
				GlobalModelManager.flipperConfig.targetScaleX = parseFloat( $conf.flipper.options.tween_target.@scaleX.toString() );
				GlobalModelManager.flipperConfig.targetScaleY = parseFloat( $conf.flipper.options.tween_target.@scaleY.toString() );
				GlobalModelManager.flipperConfig.targetAlp = parseFloat( $conf.flipper.options.tween_target.@alpha.toString() );
				
				/* prompt */
				GlobalModelManager.promptConfig.tween_duration = parseFloat( $conf.prompt.options.tweener.@duration.toString() );
				GlobalModelManager.promptConfig.file = $conf.prompt.options.tweener.@file.toString();
				
				GlobalModelManager.promptConfig.standbyX = parseFloat( $conf.prompt.options.tween_standby.@x.toString() );
				GlobalModelManager.promptConfig.standbyY = parseFloat( $conf.prompt.options.tween_standby.@y.toString() );
				GlobalModelManager.promptConfig.standbyScaleX = parseFloat( $conf.prompt.options.tween_standby.@scaleX.toString() );
				GlobalModelManager.promptConfig.standbyScaleY = parseFloat( $conf.prompt.options.tween_standby.@scaleY.toString() );
				GlobalModelManager.promptConfig.standbyAlp = parseFloat( $conf.prompt.options.tween_standby.@alpha.toString() );
				
				GlobalModelManager.promptConfig.targetX = parseFloat( $conf.prompt.options.tween_target.@x.toString() );
				GlobalModelManager.promptConfig.targetY = parseFloat( $conf.prompt.options.tween_target.@y.toString() );
				GlobalModelManager.promptConfig.targetScaleX = parseFloat( $conf.prompt.options.tween_target.@scaleX.toString() );
				GlobalModelManager.promptConfig.targetScaleY = parseFloat( $conf.prompt.options.tween_target.@scaleY.toString() );
				GlobalModelManager.promptConfig.targetAlp = parseFloat( $conf.prompt.options.tween_target.@alpha.toString() );
				
				/* sticker */
				GlobalModelManager.stickerConfig.start_x = parseFloat( $conf.sticker.options.shelf_layout.@start_x.toString() );
				GlobalModelManager.stickerConfig.start_y = parseFloat( $conf.sticker.options.shelf_layout.@start_y.toString() );
				GlobalModelManager.stickerConfig.num_of_col = parseFloat( $conf.sticker.options.shelf_layout.@num_of_col.toString() );
				GlobalModelManager.stickerConfig.num_of_row = parseFloat( $conf.sticker.options.shelf_layout.@num_of_row.toString() );
				GlobalModelManager.stickerConfig.distance_hor = parseFloat( $conf.sticker.options.shelf_layout.@distance_hor.toString() );
				GlobalModelManager.stickerConfig.distance_ver = parseFloat( $conf.sticker.options.shelf_layout.@distance_ver.toString() );
				GlobalModelManager.stickerConfig.drag_sensitivity = parseFloat( $conf.sticker.options.shelf_layout.@drag_sensitivity.toString() );
				
				GlobalModelManager.stickerConfig.button_width = parseFloat( $conf.sticker.options.button_holder.@width.toString() );
				GlobalModelManager.stickerConfig.button_height = parseFloat( $conf.sticker.options.button_holder.@height.toString() );
				GlobalModelManager.stickerConfig.button_bgColor = parseInt( $conf.sticker.options.button_holder.@color.toString(), 16 );
				
				GlobalModelManager.stickerConfig.pos_x = parseFloat( $conf.sticker.options.pos.@x.toString() );
				GlobalModelManager.stickerConfig.pos_y = parseFloat( $conf.sticker.options.pos.@y.toString() );
				
				GlobalModelManager.stickerConfig.handle_maxX = parseFloat( $conf.sticker.options.handle.@maxx.toString() );
				GlobalModelManager.stickerConfig.handle_minX = parseFloat( $conf.sticker.options.handle.@minx.toString() );
				
				GlobalModelManager.stickerConfig.skin = new Vector.<Object>();
				
				var $stickerShelfSkin = $conf.sticker.skin.children();
				
				for each (var $slice in $stickerShelfSkin)
				{
					var $skinPiece:Object = {};
					
					$skinPiece.file = $slice.@file.toString();
					$skinPiece.x = parseFloat( $slice.@x.toString() );
					$skinPiece.y = parseFloat( $slice.@y.toString() );
					
					GlobalModelManager.stickerConfig.skin.push($skinPiece);
				}
				
				GlobalModelManager.greetingsConfig.file = $conf.greetings.options.pos.@file.toString();
				GlobalModelManager.greetingsConfig.pos_x = parseFloat( $conf.greetings.options.pos.@x.toString() );
				GlobalModelManager.greetingsConfig.pos_y = parseFloat( $conf.greetings.options.pos.@y.toString() );
				
			}
			catch($er:Error)
			{
				this._logger.buildInError("parsing config XML failed...", $e.toString(), 
					"com.idsquare.vince.iwedding.loaders.ConfigLoader::confLoadedHandler()");
			}
			
			this._xmlLoader.removeEventListener(Event.COMPLETE, this.confLoadedHandler);
			this._xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.confIOErrorHandler);
			
			var $req:URLRequest = new URLRequest(GlobalModelManager.XML_PATH + GlobalModelManager.STICKER_XML);
			this._xmlLoader.addEventListener(Event.COMPLETE, this.stickerListLoadedHandler);
			this._xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.stickerListIOErrorHandler);
			this._xmlLoader.load($req);
		}
		
		
		/**
		 * Event handler for the IO error event of loading config XML.
		 * Log errors, and stop the application.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function confIOErrorHandler($e:IOErrorEvent):void
		{
			this._logger.buildInError("loading config XML fail: ", $e.toString(),
				"com.idsquare.vince.iwedding.loaders.ConfigLoader::confIOErrorHandler()");
			// prompt user
			this._xmlLoader.removeEventListener(Event.COMPLETE, this.confLoadedHandler);
			this._xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.confIOErrorHandler);
		}
		
		
		/**
		 * Event handler for the Complete event of loading sticker list XML.
		 *  Store the data to GlobalModelManager.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function stickerListLoadedHandler($e:Event):void
		{
			try{
				var $stickerList:XML = new XML($e.target.data);
				
				var $stickers = $stickerList.children();
				
				for each (var $st in $stickers)
				{
					var $sticker:Object = {};
					$sticker.file = $st.text();
					$sticker.x = parseFloat( $st.@st_btn_x.toString() );
					$sticker.y = parseFloat( $st.@st_btn_y.toString() );
					$sticker.scalex = parseFloat( $st.@st_btn_scale_x.toString() );
					$sticker.scaley = parseFloat( $st.@st_btn_scale_y.toString() );
					GlobalModelManager.stickerList.push($sticker);
				}
				
			}
			catch($er:Error)
			{
				this._logger.buildInError("parsing sticker XML failed...", $e.toString(), 
					"com.idsquare.vince.iwedding.loaders.ConfigLoader::stickerListLoadedHandler()");
			}
			
			this._xmlLoader.removeEventListener(Event.COMPLETE, this.stickerListLoadedHandler);
			this._xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.stickerListIOErrorHandler);
			
			var $evt:Event = new Event(CONFIG_LOADED);
			this.dispatchEvent($evt);
			
		}
				
		
		/**
		 * Event handler for the IO error event of loading sticker list XML.
		 * Log errors, and stop the application.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function stickerListIOErrorHandler($e:IOErrorEvent):void
		{
			this._logger.buildInError("loading sticker XML fail: ", $e.toString(),
				"com.idsquare.vince.iwedding.loaders.ConfigLoader::stickerListIOErrorHandler()");
			// prompt user
			this._xmlLoader.removeEventListener(Event.COMPLETE, this.stickerListLoadedHandler);
			this._xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.stickerListIOErrorHandler);
		}

	}
	
}
