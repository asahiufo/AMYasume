package org.ahiufomasao.yasume.timeline 
{
	import flash.display.Bitmap;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.ahiufomasao.utility.ArchiveFileData;
	import org.ahiufomasao.utility.Archiver;
	import org.ahiufomasao.utility.net.ImageLoader;
	import org.ahiufomasao.utility.net.LoaderCollection;
	import org.ahiufomasao.utility.net.StringLoader;
	import org.ahiufomasao.utility.StringUtility;
	import org.ahiufomasao.utility.Validator;
	
	/**
	 * <code>setLoadSettingByXMLFile</code>、または <code>loadGraphics</code> メソッドを呼び出した後、データを受信したときに送出されます.
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 * 
	 * @see #setLoadSettingByXMLFile()
	 * @see #loadGraphics()
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * <code>setLoadSettingByXMLFile</code>、または <code>loadGraphics</code> メソッドを呼び出した後、ロードが完了した時に送出されます.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 * 
	 * @see #setLoadSettingByXMLFile()
	 * @see #loadGraphics()
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * <code>TimelineGraphicsLoader</code> クラスは、
	 * <code>TimelineGraphics</code> クラスへ登録するグラフィックデータの一括ロードを行います.
	 * <p>
	 * ロード設定を行った後、<code>loadGraphics</code> メソッドを呼び出すことで、
	 * <em>ロード設定</em>に則ったグラフィックデータのロードを行います。
	 * グラフィックデータのロードが完了した後、
	 * <code>createTimelineGraphics</code> メソッドを呼び出すことで、
	 * ロードされたグラフィックデータへの参照を保持した <code>TimelineGraphics</code> オブジェクトを生成します。
	 * </p>
	 * <p>
	 * ロード設定は、<code>XML</code> オブジェクトや外部 XML ファイルを読み込むことにより行うことができます。
	 * <code>XML</code> オブジェクトからの設定は <code>setLoadSetting</code> メソッドを、
	 * 外部 XML ファイルからの設定は <code>setLoadSettingByXMLFile</code> メソッドを使用します。
	 * </p>
	 * @example 次のコードはロード設定に使用する XML データの例です。
	 * <listing version="3.0">
	 * &lt;data&gt;
	 *     &lt;directory&gt;tests/data/org/servegame/ahiufomasao/yasume/timeline&lt;/directory&gt;
	 *     &lt;usingArchive&gt;true&lt;/usingArchive&gt;
	 *     &lt;archiveFileName&gt;testarchive.amn&lt;/archiveFileName&gt;
	 *     &lt;file frameName="standby"&gt;
	 *         &lt;subDirectory&gt;01_standby&lt;/subDirectory&gt;
	 *         &lt;baseFileName&gt;standbygr&lt;/baseFileName&gt;
	 *         &lt;extension&gt;png&lt;/extension&gt;
	 *         &lt;length&gt;4&lt;/length&gt;
	 *         &lt;centerPosition&gt;
	 *             &lt;x&gt;10&lt;/x&gt;
	 *             &lt;y&gt;11&lt;/y&gt;
	 *         &lt;/centerPosition&gt;
	 *     &lt;/file&gt;
	 *     &lt;file frameName="attack"&gt;
	 *         &lt;subDirectory&gt;02_attack&lt;/subDirectory&gt;
	 *         &lt;baseFileName&gt;attackgr&lt;/baseFileName&gt;
	 *         &lt;extension&gt;gif&lt;/extension&gt;
	 *         &lt;length&gt;11&lt;/length&gt;
	 *         &lt;centerPosition&gt;
	 *             &lt;x&gt;20&lt;/x&gt;
	 *             &lt;y&gt;21&lt;/y&gt;
	 *         &lt;/centerPosition&gt;
	 *     &lt;/file&gt;
	 * &lt;/data&gt;</listing>
	 * 
	 * @author asahiufo/AM902
	 * @see TimelineGraphics
	 * @see #loadGraphics()
	 * @see #createTimelineGraphics
	 * @see #setLoadSetting()
	 * @see #setLoadSettingByXMLFile()
	 */
	public class TimelineGraphicsLoader extends EventDispatcher
	{
		private var _loadSettingXML:XML; // ロード設定XML
		
		private var _loadSettingLoader:StringLoader;  // ロード設定ローダー
		private var _archiveLoader:StringLoader;      // アーカイブローダー
		private var _graphicsLoader:LoaderCollection; // グラフィックローダー
		
		/**
		 * <em>ロード設定</em>ファイルのロードされたバイト数です.
		 * 
		 * @see #setLoadSettingByXMLFile()
		 */
		public function get loadSettingBytesLoaded():uint { return (_loadSettingLoader == null ? 0 : _loadSettingLoader.bytesLoaded); }
		/**
		 * <em>ロード設定</em>ファイルのロードプロセスが成功した場合にロードされるバイトの総数です.
		 * <p>
		 * <code>setLoadSettingByXMLFile</code> メソッドが実行されるまでは常に 0 です。
		 * </p>
		 * 
		 * @see #setLoadSettingByXMLFile()
		 */
		public function get loadSettingBytesTotal():uint { return (_loadSettingLoader == null ? 0 : _loadSettingLoader.bytesTotal); }
		/**
		 * <em>ロード設定</em>ファイルのロードが完了したタイミングで <code>true</code> が設定されます.
		 * 
		 * @see #setLoadSettingByXMLFile()
		 */
		public function get loadSettingLoadComplete():Boolean { return (_loadSettingLoader == null ? false : _loadSettingLoader.complete); }
		
		/**
		 * グラフィックファイルのロードされたバイト数です.
		 * 
		 * @see #loadGraphics()
		 */
		public function get graphicsBytesLoaded():uint { return (_graphicsLoader == null ? 0 : _graphicsLoader.bytesLoaded); }
		/**
		 * グラフィックファイルのロードプロセスが成功した場合にロードされるバイトの総数です.
		 * <p>
		 * <code>loadGraphics</code> メソッドが実行されるまでは常に 0 です。
		 * </p>
		 * 
		 * @see #loadGraphics()
		 */
		public function get graphicsBytesTotal():uint { return (_graphicsLoader == null ? 0 : _graphicsLoader.bytesTotal); }
		/**
		 * グラフィックファイルのロードが完了したタイミングで <code>true</code> が設定されます.
		 * 
		 * @see #loadGraphics()
		 */
		public function get graphicsLoadComplete():Boolean { return (_graphicsLoader == null ? false : _graphicsLoader.complete); }
		
		/**
		 * 新しい <code>TimelineGraphicsLoader</code> クラスのインスタンスを生成します.
		 */
		public function TimelineGraphicsLoader() 
		{
			super();
			
			_loadSettingXML    = null;
			_loadSettingLoader = null;
			_archiveLoader     = null;
			_graphicsLoader    = null;
		}
		
		/**
		 * <code>XML</code> オブジェクトによりロード設定を行います.
		 * 
		 * @param data <em>ロード設定</em>を定義した <code>XML</code> オブジェクトです。
		 * 
		 * @throws ArgumentError <em>ロード設定</em>の記述形式にエラーがある場合にスローされます。
		 */
		public function setLoadSetting(data:XML):void
		{
			var errorMessage:String = "";
			
			// directory
			if (data.directory == undefined)
			{
				errorMessage += "\"directory\" タグを設定してください。\n";
			}
			// usingArchive
			if (data.usingArchive == undefined)
			{
				errorMessage += "\"usingArchive\" タグを設定してください。\n";
			}
			else if (!Validator.validateBoolean(String(data.usingArchive)))
			{
				errorMessage += "\"usingArchive\" タグには \"true\" または \"false\" を設定します。\n";
			}
			// archiveFileName
			if (String(data.usingArchive) == "true")
			{
				if (data.archiveFileName == undefined)
				{
					errorMessage += "\"archiveFileName\" タグを設定してください。\n";
				}
			}
			
			// file
			if (data.file == undefined)
			{
				errorMessage += "\"file\" タグを 1 件以上設定してください。\n";
			}
			else
			{
				for each (var fileXML:XML in data.file)
				{
					// @frameNameチェック
					if (fileXML.@frameName == undefined || fileXML.@frameName == "")
					{
						errorMessage += "\"file\" タグには \"@frameName\" 属性を設定します。\n";
					}
					else
					{
						var list:XML = XML(data.file.(@frameName == String(fileXML.@frameName)));
						if (list.length() >= 2)
						{
							errorMessage += "複数の \"file\" タグにはそれぞれ異なる \"@frameName\" 属性を設定してください。\n";
						}
					}
					
					// subDirectory
					if (fileXML.subDirectory == undefined)
					{
						errorMessage += "\"file.subDirectory\" タグを設定してください。[@frameName=" + String(fileXML.@frameName) + "]\n";
					}
					// baseFileName
					if (fileXML.baseFileName == undefined)
					{
						errorMessage += "\"file.baseFileName\" タグを設定してください。[@frameName=" + String(fileXML.@frameName) + "]\n";
					}
					// extension
					if (fileXML.extension == undefined)
					{
						errorMessage += "\"file.extension\" タグを設定してください。[@frameName=" + String(fileXML.@frameName) + "]\n";
					}
					// length
					if (fileXML.length == undefined)
					{
						errorMessage += "\"file.length\" タグを設定してください。[@frameName=" + String(fileXML.@frameName) + "]\n";
					}
					else if (!Validator.validateUint(String(fileXML.length)))
					{
						errorMessage += "\"file.length\" タグには正の整数を設定します。[@frameName=" + String(fileXML.@frameName) + "]\n";
					}
					// centerPosition
					if (fileXML.centerPosition == undefined)
					{
						errorMessage += "\"file.centerPosition\" タグを設定してください。[@frameName=" + String(fileXML.@frameName) + "]\n";
					}
					else
					{
						// x
						if (fileXML.centerPosition.x == undefined)
						{
							errorMessage += "\"file.centerPosition.x\" タグを設定してください。[@frameName=" + String(fileXML.@frameName) + "]\n";
						}
						else if (!Validator.validateNumber(String(fileXML.centerPosition.x)))
						{
							errorMessage += "\"file.centerPosition.x\" タグには数値を設定します。[@frameName=" + String(fileXML.@frameName) + "]\n";
						}
						// y
						if (fileXML.centerPosition.y == undefined)
						{
							errorMessage += "\"file.centerPosition.y\" タグを設定してください。[@frameName=" + String(fileXML.@frameName) + "]\n";
						}
						else if (!Validator.validateNumber(String(fileXML.centerPosition.y)))
						{
							errorMessage += "\"file.centerPosition.y\" タグには数値を設定します。[@frameName=" + String(fileXML.@frameName) + "]\n";
						}
					}
				}
			}
			
			// 書式エラーがある場合
			if (errorMessage.length != 0)
			{
				throw new ArgumentError(errorMessage);
			}
			
			_loadSettingXML = data;
		}
		
		/**
		 * XML ファイルを読み込み、読み込んだデータからロード設定を行います.
		 * <p>
		 * <code>setLoadSettingByXMLFile</code> を呼び出した後、ファイルのロード状況は 
		 * <code>loadSettingBytesLoaded</code>、
		 * <code>loadSettingBytesTotal</code>、
		 * <code>loadSettingLoadComplete</code> プロパティにより取得できます。
		 * </p>
		 * 
		 * @param URL <em>ロード設定</em>を定義した XML ファイルの URL です。
		 * 
		 * @throws IllegalOperationError ファイル読み込み中に重複して <code>setLoadSettingByXMLFile</code> メソッドを呼び出した場合にスローされます。
		 * 
		 * @see #loadSettingBytesLoaded
		 * @see #loadSettingBytesTotal
		 * @see #loadSettingLoadComplete
		 */
		public function setLoadSettingByXMLFile(URL:String):void
		{
			if (_loadSettingLoader != null)
			{
				if (!_loadSettingLoader.complete)
				{
					throw new IllegalOperationError("ファイル読み込み中に重複して setLoadingDataByXMLFile メソッドを呼び出すことはできません。");
				}
			}
			_loadSettingLoader = new StringLoader(URL);
			_loadSettingLoader.addEventListener(ProgressEvent.PROGRESS, _onProgress);
			_loadSettingLoader.addEventListener(Event.COMPLETE, _onLoadLoadSettingsComplete);
			_loadSettingLoader.load();
		}
		
		/**
		 * @private
		 * プログレスイベントハンドラ
		 * 
		 * @param event イベント
		 */
		private function _onProgress(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * @private
		 * ロード設定用 XML ファイル読み込み完了イベントハンドラ
		 * 
		 * @param event イベント
		 */
		private function _onLoadLoadSettingsComplete(event:Event):void
		{
			var data:XML = new XML(String(_loadSettingLoader.data));
			setLoadSetting(data);
			
			dispatchEvent(event);
			_loadSettingLoader.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
			_loadSettingLoader.removeEventListener(Event.COMPLETE, _onLoadLoadSettingsComplete);
		}
		
		/**
		 * <em>ロード設定</em>に従ってグラフィックファイルをロードします.
		 * <p>
		 * <code>loadGraphics</code> を呼び出した後、ファイルのロード状況は 
		 * <code>graphicsBytesLoaded</code>、
		 * <code>graphicsBytesTotal</code>、
		 * <code>graphicsLoadComplete</code> プロパティにより取得できます。
		 * </p>
		 * 
		 * @throws IllegalOperationError ファイル読み込み中に重複して <code>loadGraphics</code> メソッドを呼び出した場合にスローされます。
		 * 
		 * @see #graphicsBytesLoaded
		 * @see #graphicsBytesTotal
		 * @see #graphicsLoadComplete
		 */
		public function loadGraphics():void
		{
			if ((_graphicsLoader != null && !_graphicsLoader.complete) || (_archiveLoader != null && !_archiveLoader.complete))
			{
				throw new IllegalOperationError("グラフィックファイル読み込み中に重複して loadGraphics メソッドを呼び出すことはできません。");
			}
			
			var directory:String = String(_loadSettingXML.directory);
			var usingArchive:Boolean = StringUtility.convertStringToBoolean(String(_loadSettingXML.usingArchive));
			
			// グラフィックファイルを読み込む場合
			if (!usingArchive)
			{
				_graphicsLoader = new LoaderCollection();
				
				// ロード設定に沿ってファイル全件読み込み
				for each (var fileXML:XML in _loadSettingXML.file)
				{
					var childLoaders:LoaderCollection = new LoaderCollection();
					var baseFilePath:String = StringUtility.combinePath(StringUtility.combinePath(directory, String(fileXML.subDirectory)), String(fileXML.baseFileName));
					var length:uint = uint(fileXML.length);
					var extension:String = String(fileXML.extension);
					for (var i:uint = 1; i <= length; i++)
					{
						var filePath:String = baseFilePath + StringUtility.convertFromNumberToZeroString(i, 4) + "." + extension;
						childLoaders.addLoader(new ImageLoader(filePath), i);
					}
					_graphicsLoader.addLoaderCollection(childLoaders, String(fileXML.@frameName));
				}
				
				_graphicsLoader.addEventListener(ProgressEvent.PROGRESS, _onProgress);
				_graphicsLoader.addEventListener(Event.COMPLETE, _onLoadGraphicFilesComplete);
				_graphicsLoader.loadAll();
			}
			// アーカイブファイルを読み込む場合
			else
			{
				var acvFilePath:String = StringUtility.combinePath(directory, String(_loadSettingXML.archiveFileName));
				_archiveLoader = new StringLoader(acvFilePath, URLLoaderDataFormat.BINARY);
				_archiveLoader.addEventListener(ProgressEvent.PROGRESS, _onProgress);
				_archiveLoader.addEventListener(Event.COMPLETE, _onLoadArchiveComplete);
				_archiveLoader.load();
			}
		}
		
		/**
		 * @private
		 * グラフィックファイルロード完了イベントハンドラ
		 * 
		 * @param event イベント
		 */
		private function _onLoadGraphicFilesComplete(event:Event):void
		{
			dispatchEvent(event);
			_graphicsLoader.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
			_graphicsLoader.removeEventListener(Event.COMPLETE, _onLoadGraphicFilesComplete);
		}
		
		/**
		 * @private
		 * アーカイブファイルロード完了イベントハンドラ
		 * 
		 * @param event イベント
		 */
		private function _onLoadArchiveComplete(event:Event):void
		{
			// アーカイブファイル伸長
			var archiveFileDatas:Vector.<ArchiveFileData>;
			archiveFileDatas = Archiver.uncompress(ByteArray(_archiveLoader.data));
			
			// 一旦ファイルパスをキーにして画像のバイナリデータをDictionaryにブチ込む
			var archiveFilesDict:Dictionary = new Dictionary();
			var pattern:RegExp = /\\/g;
			for each (var archiveFileData:ArchiveFileData in archiveFileDatas)
			{
				// ファイルパスの区切り文字を'/'に置換して登録
				archiveFilesDict[archiveFileData.filePath.replace(pattern, "/")] = archiveFileData.bytes;
			}
			
			// 読み込んだバイナリデータをロード設定に則って画像に復元
			_graphicsLoader = new LoaderCollection();
			for each (var fileXML:XML in _loadSettingXML.file)
			{
				var childLoaders:LoaderCollection = new LoaderCollection();
				
				var baseFilePath:String = StringUtility.combinePath(String(fileXML.subDirectory), String(fileXML.baseFileName));
				var extension:String = String(fileXML.extension);
				
				var length:uint = uint(fileXML.length);
				for (var i:uint = 1; i <= length; i++)
				{
					var filePath:String = baseFilePath + StringUtility.convertFromNumberToZeroString(i, 4) + "." + extension;
					if (archiveFilesDict[filePath] == undefined)
					{
						throw new ArgumentError("ロード設定に記述されているファイルがアーカイブファイル中に存在しません。[ファイル=" + filePath + "]");
					}
					childLoaders.addLoader(new ImageLoader(ByteArray(archiveFilesDict[filePath])), i);
				}
				_graphicsLoader.addLoaderCollection(childLoaders, String(fileXML.@frameName));
			}
			
			_graphicsLoader.addEventListener(Event.COMPLETE, _onLoadGraphicFilesComplete);
			_graphicsLoader.loadAll();
			
			_archiveLoader.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
			_archiveLoader.removeEventListener(Event.COMPLETE, _onLoadArchiveComplete);
		}
		
		/**
		 * 読み込まれたグラフィックデータへの参照を保持する <code>TimelineGraphics</code> オブジェクトを生成します.
		 * 
		 * @return 生成された <code>TimelineGraphics</code> オブジェクトです。
		 * 
		 * @throws IllegalOperationError <code>loadGraphics</code> メソッド未実行により、グラフィックデータのロードが完了していない場合にスローされます。
		 * @throws IllegalOperationError <code>loadGraphics</code> メソッド実行後、グラフィックデータのロードが未完了である場合にスローされます。
		 */
		public function createTimelineGraphics():TimelineGraphics
		{
			if (_graphicsLoader == null)
			{
				throw new IllegalOperationError("グラフィックデータのロードが完了していません。loadGraphics メソッドを実行してください。");
			}
			if (!_graphicsLoader.complete)
			{
				throw new IllegalOperationError("グラフィックデータのロードが完了していません。ロードが完了するまで待ってください。");
			}
			
			var timelineGraphics:TimelineGraphics = new TimelineGraphics();
			var frameNames:Vector.<String> = Vector.<String>(_graphicsLoader.getLoaderCollectionsKeys());
			var frameNamesLength:uint = frameNames.length;
			
			var point:Point = new Point();
			
			for (var i:uint = 0; i < frameNamesLength; i++)
			{
				var frameName:String = frameNames[i];
				var fileXML:XML = XML(_loadSettingXML.file.(@frameName == frameName));
				var childLoaders:LoaderCollection = _graphicsLoader.getLoaderCollection(frameName);
				var childLoadersLength:uint = childLoaders.length;
				for (var j:uint = 1; j <= childLoadersLength; j++)
				{
					point.x = Number(fileXML.centerPosition.x);
					point.y = Number(fileXML.centerPosition.y);
					timelineGraphics.addGraphic(frameName, Bitmap(childLoaders.getLoader(j).data).bitmapData, point);
				}
			}
			
			return timelineGraphics;
		}
	}
}
