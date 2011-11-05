package org.ahiufomasao.yasume.map 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.ahiufomasao.utility.net.ImageLoader;
	import org.ahiufomasao.utility.net.StringLoader;
	import org.ahiufomasao.utility.StringUtility;
	import org.ahiufomasao.utility.Validator;
	
	/**
	 * <code>setDataByXMLFile</code>、または <code>setChipGraphicsByBitmapFile</code> メソッドを呼び出した後、データを受信したときに送出されます.
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 * 
	 * @see #setDataByXMLFile()
	 * @see #setChipGraphicsByBitmapFile()
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * <code>setDataByXMLFile</code>、または <code>setChipGraphicsByBitmapFile</code> メソッドを呼び出した後、ロードが完了した時に送出されます.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 * 
	 * @see #setDataByXMLFile()
	 * @see #setChipGraphicsByBitmapFile()
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * <code>MapData</code> クラスは、マップチップで構成されたマップデータを保持します.
	 * <p>
	 * 各プロパティへ任意のデータを設定することで、マップデータを設定します。
	 * マップデータを設定した <code>MapData</code> オブジェクトを 
	 * <code>MapViewer</code> オブジェクトや <code>MapHitTester</code> オブジェクトを使用する際に渡すことで、
	 * マップを表示したり、当たり判定を行うことができます。
	 * </p>
	 * <p>
	 * マップデータの設定は、プロパティへ直接設定する方法以外に、 
	 * <code>XML</code> オブジェクトや外部 XML ファイルを読み込むことにより行うことができます。
	 * <code>XML</code> オブジェクトからの設定は <code>setDataByXML</code> メソッドを、
	 * 外部 XML ファイルからの設定は <code>setDataByXMLFile</code> を使用します。
	 * </p>
	 * <p>
	 * またマップデータの設定以外に、マップを表示する際に使用するマップチップグラフィックリストを設定する必要があります。
	 * マップチップグラフィックリストを設定するには、<code>setChipGraphicsByBitmapData</code> または　
	 * <code>setChipGraphicsByBitmapFile</code> メソッドを使用します。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see MapViewer
	 * @see MapHitTester
	 * @see #setDataByXML()
	 * @see #setDataByXMLFile()
	 * @see #setChipGraphicsByBitmapData()
	 * @see #setChipGraphicsByBitmapFile()
	 */
	public class MapData extends EventDispatcher
	{
		private var _mapWidthChip:uint;           // マップサイズ横幅（チップ単位）
		private var _mapHeightChip:uint;          // マップサイズ高さ（チップ単位）
		private var _chipWidth:uint;              // チップサイズ横幅（ピクセル単位）
		private var _chipHeight:uint;             // チップサイズ高さ（ピクセル単位）
		private var _screenWidthChip:uint;        // 描画する画面サイズ横幅（チップ単位）
		private var _screenHeightChip:uint;       // 描画する画面サイズ高さ（チップ単位）
		private var _chipGraphicsFilePath:String; // マップチップグラフィック用ファイルのパス
		
		private var _chipGraphics:Vector.<BitmapData>;    // マップチップグラフィックリスト
		
		private var _loop:Boolean;                        // ループフラグ（trueならループ表示する）
		private var _backgroundColor:uint;                // 背景色（0xAARRGGBB）
		
		private var _mapLayerDatas:Vector.<MapLayerData>; // マップレイヤーリスト
		
		private var _dataLoader:StringLoader;             // 設定データローダー
		private var _chipGraphicsLoader:ImageLoader;      // チップリストローダー
		
		/**
		 * マップ全体のチップ単位の横幅です.
		 * <p>
		 * 例えばマップ全体の横幅がチップ 16 個分のサイズである場合、 16 を設定します。
		 * </p>
		 * @default 1
		 * 
		 * @throws ArgumentError 0 以下の値を設定した場合にスローされます。
		 */
		public function get mapWidthChip():uint { return _mapWidthChip; }
		/** @private */
		public function set mapWidthChip(value:uint):void
		{
			if (value == 0)
			{
				throw new ArgumentError("マップ全体のチップ単位の横幅には 1 以上の値を設定してください。");
			}
			_mapWidthChip = value;
		}
		
		/**
		 * マップ全体のチップ単位の高さです.
		 * <p>
		 * 例えばマップ全体の高さがチップ 12 個分のサイズである場合、 12 を設定します。
		 * </p>
		 * @default 1
		 * 
		 * @throws ArgumentError 0 以下の値を設定した場合にスローされます。
		 */
		public function get mapHeightChip():uint { return _mapHeightChip; }
		/** @private */
		public function set mapHeightChip(value:uint):void
		{
			if (value == 0)
			{
				throw new ArgumentError("マップ全体のチップ単位の高さには 1 以上の値を設定してください。");
			}
			_mapHeightChip = value;
		}
		
		/**
		 * チップ 1 つ分の横幅です.
		 * <p>
		 * 単位はピクセルです。
		 * </p>
		 * @default 25
		 * 
		 * @throws ArgumentError 0 以下の値を設定した場合にスローされます。
		 */
		public function get chipWidth():uint { return _chipWidth; }
		/** @private */
		public function set chipWidth(value:uint):void
		{
			if (value == 0)
			{
				throw new ArgumentError("チップ1つ分の横幅には 1 以上の値を設定してください。");
			}
			_chipWidth = value;
		}
		
		/**
		 * チップ 1 つ分の高さです.
		 * <p>
		 * 単位はピクセルです。
		 * </p>
		 * @default 25
		 * 
		 * @throws ArgumentError 0 以下の値を設定した場合にスローされます。
		 */
		public function get chipHeight():uint { return _chipHeight; }
		/** @private */
		public function set chipHeight(value:uint):void
		{
			if (value == 0)
			{
				throw new ArgumentError("チップ1つ分の高さには 1 以上の値を設定してください。");
			}
			_chipHeight = value;
		}
		
		/**
		 * マップ全体のピクセル単位の横幅です.
		 */
		public function get mapWidthPx():uint { return (_mapWidthChip * _chipWidth); }
		/**
		 * マップ全体のピクセル単位の高さです.
		 */
		public function get mapHeightPx():uint { return (_mapHeightChip * _chipHeight); }
		
		/**
		 * マップを描画する画面のチップ単位の横幅です.
		 * <p>
		 * 例えば、マップを描画する画面の横幅がチップ 8 個分である場合、 8 を設定します。
		 * </p>
		 * @default 1
		 * 
		 * @throws ArgumentError 0 以下の値を設定した場合にスローされます。
		 */
		public function get screenWidthChip():uint { return _screenWidthChip; }
		/** @private */
		public function set screenWidthChip(value:uint):void
		{
			if (value == 0)
			{
				throw new ArgumentError("マップを描画する画面のチップ単位の横幅には 1 以上の値を設定してください。");
			}
			_screenWidthChip = value;
		}
		
		/**
		 * マップを描画する画面のチップ単位の高さです.
		 * <p>
		 * 例えば、マップを描画する画面の高さがチップ 6 個分である場合、 6 を設定します。
		 * </p>
		 * @default 1
		 * 
		 * @throws ArgumentError 0 以下の値を設定した場合にスローされます。
		 */
		public function get screenHeightChip():uint { return _screenHeightChip; }
		/** @private */
		public function set screenHeightChip(value:uint):void
		{
			if (value == 0)
			{
				throw new ArgumentError("マップを描画する画面のチップ単位の高さには 1 以上の値を設定してください。");
			}
			_screenHeightChip = value;
		}
		
		/**
		 * マップを描画する画面のピクセル単位の横幅です.
		 */
		public function get screenWidthPx():uint { return (_screenWidthChip * _chipWidth); }
		
		/**
		 * マップを描画する画面のピクセル単位の高さです.
		 */
		public function get screenHeightPx():uint { return (_screenHeightChip * _chipHeight); }
		
		/**
		 * マップチップグラフィックリスト用の画像ファイルへのパスです.
		 * <p>
		 * <code>setChipGraphicsByBitmapFile</code> メソッドを引数無しで呼び出した際にこのプロパティが参照されます。
		 * </p>
		 * @default ""
		 * 
		 * @see #setChipGraphicsByBitmapFile()
		 */
		public function get chipGraphicsFilePath():String { return _chipGraphicsFilePath; }
		/** @private */
		public function set chipGraphicsFilePath(value:String):void { _chipGraphicsFilePath = value; }
		
		/**
		 * マップチップグラフィックリストです.
		 * <p>
		 * <code>setChipGraphicsByBitmapData</code> または 
		 * <code>setChipGraphicsByBitmapFile</code> メソッドにより設定された、
		 * <code>chipWidth</code>、<code>chipHeight</code> プロパティのサイズである 
		 * <code>BitmapData</code> オブジェクトのリストです。
		 * </p>
		 * 
		 * @see #setChipGraphicsByBitmapData()
		 * @see #setChipGraphicsByBitmapFile()
		 * @see #chipWidth
		 * @see #chipHeight
		 */
		public function get chipGraphics():Vector.<BitmapData> { return _chipGraphics; }
		/** @private */
		public function set chipGraphics(value:Vector.<BitmapData>):void { _chipGraphics = value; }
		
		/**
		 * <code>true</code> が設定されている場合、マップがループしていると解釈されます.
		 * <p>
		 * マップがループしている場合、マップの描画や当たり判定も、マップがループしているものとして処理されます。
		 * </p>
		 * @default false;
		 */
		public function get loop():Boolean { return _loop; }
		/** @private */
		public function set loop(value:Boolean):void { _loop = value; }
		
		/**
		 * マップの背景色です.
		 * <p>
		 * 背景の描画に使用される ARGB カラー値です。ARGB カラー値は通常、16 進数形式 (例えば、<code>0xFF336699</code>) で指定します。
		 * </p>
		 */
		public function get backgroundColor():uint { return _backgroundColor; }
		/** @private */
		public function set backgroundColor(value:uint):void { _backgroundColor = value; }
		
		/**
		 * マップのレイヤーデータのリストです.
		 */
		public function get mapLayerDatas():Vector.<MapLayerData> { return _mapLayerDatas; }
		/** @private */
		public function set mapLayerDatas(value:Vector.<MapLayerData>):void { _mapLayerDatas = value; }
		
		/**
		 * マップデータファイルのロードされたバイト数です.
		 * 
		 * @see #setDataByXMLFile()
		 */
		public function get dataBytesLoaded():uint { return (_dataLoader == null ? 0 : _dataLoader.bytesLoaded); }
		/**
		 * マップデータファイルのロードプロセスが成功した場合にロードされるバイトの総数です.
		 * <p>
		 * <code>setDataByXMLFile</code> メソッドが実行されるまでは常に 0 です。
		 * </p>
		 * 
		 * @see #setDataByXMLFile()
		 */
		public function get dataBytesTotal():uint { return (_dataLoader == null ? 0 : _dataLoader.bytesTotal); }
		/**
		 * マップデータファイルのロードが完了したタイミングで <code>true</code> が設定されます.
		 * 
		 * @see #setDataByXMLFile()
		 */
		public function get dataLoadComplete():Boolean { return (_dataLoader == null ? false : _dataLoader.complete); }
		
		/**
		 * マップチップグラフィックリストファイルのロードされたバイト数です.
		 * 
		 * @see #setChipGraphicsByBitmapFile()
		 */
		public function get chipGraphicsBytesLoaded():uint { return (_chipGraphicsLoader == null ? 0 : _chipGraphicsLoader.bytesLoaded); }
		/**
		 * マップチップグラフィックリストファイルのロードプロセスが成功した場合にロードされるバイトの総数です.
		 * <p>
		 * <code>setChipGraphicsByBitmapFile</code> メソッドが実行されるまでは常に 0 です。
		 * </p>
		 * 
		 * @see #setChipGraphicsByBitmapFile()
		 */
		public function get chipGraphicsBytesTotal():uint { return (_chipGraphicsLoader == null ? 0 : _chipGraphicsLoader.bytesTotal); }
		/**
		 * マップチップグラフィックリストファイルのロードが完了したタイミングで <code>true</code> が設定されます.
		 * 
		 * @see #setChipGraphicsByBitmapFile()
		 */
		public function get chipGraphicsLoadComplete():Boolean { return (_chipGraphicsLoader == null ? false : _chipGraphicsLoader.complete); }
		
		/**
		 * 新しい <code>MapData</code> クラスのインスタンスを生成します.
		 */
		public function MapData() 
		{
			_mapWidthChip         = 1;
			_mapHeightChip        = 1;
			_chipWidth            = 25;
			_chipHeight           = 25;
			_screenWidthChip      = 1;
			_screenHeightChip     = 1;
			_chipGraphicsFilePath = "";
			_chipGraphics         = new Vector.<BitmapData>();
			_loop                 = false;
			_backgroundColor      = 0x00FFFFFF;
			_mapLayerDatas        = new Vector.<MapLayerData>();
			
			_dataLoader           = null;
			_chipGraphicsLoader   = null;
		}
		
		/**
		 * <code>XML</code> オブジェクトからマップデータを設定します.
		 * 
		 * @param data マップデータを定義した <code>XML</code> オブジェクトです。
		 * 
		 * @throws ArgumentError マップデータの記述形式にエラーがある場合にスローされます。
		 */
		public function setDataByXML(data:XML):void
		{
			var errorMessage:String = "";
			
			// mapSize
			if (data.mapSize != undefined)
			{
				// width
				if (data.mapSize.width != undefined)
				{
					if (!Validator.validateUint(String(data.mapSize.width)))
					{
						errorMessage += "\"mapSize.width\" タグには正の整数を設定します。\n";
					}
					else
					{
						mapWidthChip = uint(data.mapSize.width);
					}
				}
				// height
				if (data.mapSize.height != undefined)
				{
					if (!Validator.validateUint(String(data.mapSize.height)))
					{
						errorMessage += "\"mapSize.height\" タグには正の整数を設定します。\n";
					}
					else
					{
						mapHeightChip = uint(data.mapSize.height);
					}
				}
			}
			
			// chipSize
			if (data.chipSize != undefined)
			{
				// width
				if (data.chipSize.width != undefined)
				{
					if (!Validator.validateUint(String(data.chipSize.width)))
					{
						errorMessage += "\"chipSize.width\" タグには正の整数を設定します。\n";
					}
					else
					{
						chipWidth = uint(data.chipSize.width);
					}
				}
				// height
				if (data.chipSize.height != undefined)
				{
					if (!Validator.validateUint(String(data.chipSize.height)))
					{
						errorMessage += "\"chipSize.height\" タグには正の整数を設定します。\n";
					}
					else
					{
						chipHeight = uint(data.chipSize.height);
					}
				}
			}
			
			// screenSize
			if (data.screenSize != undefined)
			{
				// width
				if (data.screenSize.width != undefined)
				{
					if (!Validator.validateUint(String(data.screenSize.width)))
					{
						errorMessage += "\"screenSize.width\" タグには正の整数を設定します。\n";
					}
					else
					{
						screenWidthChip = uint(data.screenSize.width);
					}
				}
				// height
				if (data.screenSize.height != undefined)
				{
					if (!Validator.validateUint(String(data.screenSize.height)))
					{
						errorMessage += "\"screenSize.height\" タグには正の整数を設定します。\n";
					}
					else
					{
						screenHeightChip = uint(data.screenSize.height);
					}
				}
			}
			
			// chipGraphicsFilePath
			if (data.chipGraphicsFilePath != undefined)
			{
				_chipGraphicsFilePath = String(data.chipGraphicsFilePath);
			}
			
			// loop
			if (data.loop != undefined)
			{
				if (!Validator.validateBoolean(String(data.loop)))
				{
					errorMessage += "\"loop\" タグには \"true\" または \"false\" を設定します。\n";
				}
				else
				{
					_loop = StringUtility.convertStringToBoolean(String(data.loop));
				}
			}
			
			// backgroundColor
			if (data.backgroundColor != undefined)
			{
				if (!Validator.validateUint(String(data.backgroundColor)))
				{
					errorMessage += "\"backgroundColor\" タグには正の整数を設定します。\n";
				}
				else
				{
					_backgroundColor = uint(data.backgroundColor);
				}
			}
			
			// layer
			if (data.layer != undefined)
			{
				var mapLayerDatas:Vector.<MapLayerData>;
				if (_mapLayerDatas == null)
				{
					mapLayerDatas = new Vector.<MapLayerData>();
				}
				else
				{
					mapLayerDatas = _mapLayerDatas;
				}
				
				var layers:XMLList = data.layer;
				var layerLen:uint = layers.length();
				
				for (var i:uint = 0; i < layerLen; i++)
				{
					var layerData:MapLayerData = new MapLayerData();
					
					var layer:XML = layers[i];
					
					// scrollSpeed
					if (layer.scrollSpeed != undefined)
					{
						if (!Validator.validateNumber(String(layer.scrollSpeed)))
						{
							errorMessage += "\"layer.scrollSpeed\" タグには正の数値を設定します。\n";
						}
						else
						{
							layerData.scrollSpeed = Number(layer.scrollSpeed);
						}
					}
					// frameRate
					if (layer.frameRate != undefined)
					{
						if (!Validator.validateUint(String(layer.frameRate)))
						{
							errorMessage += "\"layer.frameRate\" タグには正の整数を設定します。\n";
						}
						else
						{
							layerData.frameRate = uint(layer.frameRate);
						}
					}
					
					// hitData
					if (layer.hitData != undefined)
					{
						var csvStr:String = StringUtility.deleteIndent(String(layer.hitData));
						var csvDataStr:Vector.<Vector.<String>> = StringUtility.convertFromCSVToVector(csvStr, "\t");
						
						var hitData:Vector.<Vector.<HitSetting>> = new Vector.<Vector.<HitSetting>>();
						for each (var dataRow:Vector.<String> in csvDataStr)
						{
							var hitDataRow:Vector.<HitSetting> = new Vector.<HitSetting>();
							hitData.push(hitDataRow);
							for each (var dataStr:String in dataRow)
							{
								var hitSetting:HitSetting = new HitSetting();
								hitSetting.setByHexValue(dataStr);
								hitDataRow.push(hitSetting);
							}
						}
						layerData.hitData = hitData;
					}
					
					// frame
					if (layer.frame != undefined)
					{
						if (layerData.frameChipDatas == null)
						{
							layerData.frameChipDatas = new Vector.<Vector.<Vector.<uint>>>();
						}
						
						var frames:XMLList = layer.frame;
						var frameLen:uint = frames.length();
						
						for (var j:uint = 0; j < frameLen; j++)
						{
							csvStr = StringUtility.deleteIndent(String(frames[j]));
							csvDataStr = StringUtility.convertFromCSVToVector(csvStr, "\t");
							var chipData:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>();
							var lengthY:uint = csvDataStr.length;
							for (var m:uint = 0; m < lengthY; m++)
							{
								var lengthX:uint = csvDataStr[m].length;
								chipData.push(new Vector.<uint>());
								for (var n:uint = 0; n < lengthX; n++)
								{
									chipData[m].push(uint(csvDataStr[m][n]));
								}
							}
							layerData.frameChipDatas[j] = chipData;
						}
					}
					
					mapLayerDatas[i] = layerData;
				}
				_mapLayerDatas = mapLayerDatas;
			}
			
			// 書式エラーがある場合
			if (errorMessage.length != 0)
			{
				throw new ArgumentError(errorMessage);
			}
		}
		
		/**
		 * XML ファイルを読み込み、読み込んだマップデータを設定します.
		 * <p>
		 * <code>setDataByXMLFile</code> を呼び出した後、ファイルのロード状況は 
		 * <code>dataBytesLoaded</code>、
		 * <code>dataBytesTotal</code>、
		 * <code>dataLoadComplete</code> プロパティにより取得できます。
		 * </p>
		 * 
		 * @param URL マップデータを定義した XML ファイルの URL です。
		 * 
		 * @throws IllegalOperationError ファイル読み込み中に重複して <code>setDataByXMLFile</code> メソッドを呼び出した場合にスローされます。
		 * 
		 * @see #dataBytesLoaded
		 * @see #dataBytesTotal
		 * @see #dataLoadComplete
		 */
		public function setDataByXMLFile(URL:String):void
		{
			if (_dataLoader != null)
			{
				if (!_dataLoader.complete)
				{
					throw new IllegalOperationError("設定ファイル読み込み中に重複して setDataByXMLFile を呼び出すことはできません。");
				}
			}
			_dataLoader = new StringLoader(URL);
			_dataLoader.addEventListener(ProgressEvent.PROGRESS, _onProgress);
			_dataLoader.addEventListener(Event.COMPLETE, _onDataLoadComplete);
			_dataLoader.load();
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
		 * XML ファイル読み込み完了イベントハンドラです。
		 * 
		 * @param event イベント
		 */
		private function _onDataLoadComplete(event:Event):void
		{
			// XMLファイルからデータ設定
			var data:XML = new XML(String(_dataLoader.data));
			setDataByXML(data);
			
			dispatchEvent(event);
			_dataLoader.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
			_dataLoader.removeEventListener(Event.COMPLETE, _onDataLoadComplete);
		}
		
		/**
		 * マップチップグラフィックリストを設定します.
		 * <p>
		 * 指定された <code>BitmapData</code> オブジェクトを
		 * チップサイズ（<code>chipWidth</code>、<code>chipHeight</code> プロパティ）で切り取り、
		 * <code>BitmapData</code> オブジェクトの左上から右方向へ 1, 2, 3, ・・・ と番号を付けてリストを作成します。
		 * </p>
		 * <p>
		 * 例えば横 6、縦 4 で切り取り可能な BitmapData オブジェクトを指定した場合は以下のように切り取られ、番号が付けられます。
		 * </p>
		 * <pre>
		 *  1  2  3  4  5  6
		 *  7  8  9 10 11 12
		 * 13 14 15 16 17 18
		 * 19 20 21 22 23 24
		 * </pre>
		 * 
		 * @param source マップチップグラフィックリストの元となる <code>BitmapData</code> オブジェクトです。
		 * 
		 * @return 作成されたマップチップグラフィックを、付けられた番号をインデックスとして登録した <code>Vector</code> オブジェクトです。
		 */
		public function setChipGraphicsByBitmapData(source:BitmapData):Vector.<BitmapData>
		{
			var list:Vector.<BitmapData> = new Vector.<BitmapData>();
			
			// チップ一覧ビットマップから切り取る範囲（チップ単位）
			var cutWidth:uint = Math.floor(source.width / chipWidth);
			var cutHeight:uint = Math.floor(source.height / chipHeight);
			
			// リストの0には空データを入れておく
			list.push(new BitmapData(chipWidth, chipHeight, true, 0));
			
			// チップ登録
			var chip:BitmapData;
			var rect:Rectangle = new Rectangle();
			var point:Point = new Point();
			for (var i:uint = 0; i < cutHeight; i++)
			{
				for (var j:uint = 0; j < cutWidth; j++)
				{
					// ビットマップデータの切り取り
					chip = new BitmapData(chipWidth, chipHeight, true, 0);
					rect.x = j * chipWidth;
					rect.y = i * chipHeight;
					rect.width = chipWidth;
					rect.height = chipHeight;
					chip.copyPixels(source, rect, point);
					
					list.push(chip);
				}
			}
			
			_chipGraphics = list;
			
			return list;
		}
		
		/**
		 * ビットマップファイルからマップチップグラフィックリストを設定します.
		 * <p>
		 * <code>setChipGraphicsByBitmapFile</code> を呼び出した後、ファイルのロード状況は 
		 * <code>chipGraphicsBytesLoaded</code>、
		 * <code>chipGraphicsBytesTotal</code>、
		 * <code>chipGraphicsLoadComplete</code> プロパティにより取得できます。
		 * </p>
		 * 
		 * @param URL 読み込むビットマップファイルの URL です。省略した場合、<code>chipGraphicsFilePath</code> プロパティに設定された URL を使用します。
		 * 
		 * @throws IllegalOperationError ファイル読み込み中に重複して <code>setChipGraphicsByBitmapFile</code> メソッドを呼び出した場合にスローされます。
		 * 
		 * @see #chipGraphicsBytesLoaded
		 * @see #chipGraphicsBytesTotal
		 * @see #chipGraphicsLoadComplete
		 */
		public function setChipGraphicsByBitmapFile(URL:String = ""):void
		{
			if (_chipGraphicsLoader != null)
			{
				if (!_chipGraphicsLoader.complete)
				{
					throw new IllegalOperationError("チップリストファイル読み込み中に重複して setChipListByBitmapFile を呼び出すことはできません。");
				}
			}
			
			// 引数が省略された場合
			if (URL == "")
			{
				URL = _chipGraphicsFilePath;
			}
			
			_chipGraphicsLoader = new ImageLoader(URL);
			_chipGraphicsLoader.addEventListener(ProgressEvent.PROGRESS, _onProgress);
			_chipGraphicsLoader.addEventListener(Event.COMPLETE, _onBitmapFileLoadComplete);
			_chipGraphicsLoader.load();
		}
		
		/**
		 * @private
		 * ビットマップファイル読み込み完了イベントハンドラです。
		 * 
		 * @param event イベント
		 */
		private function _onBitmapFileLoadComplete(event:Event):void
		{
			setChipGraphicsByBitmapData(Bitmap(_chipGraphicsLoader.data).bitmapData);
			
			dispatchEvent(event);
			_chipGraphicsLoader.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
			_chipGraphicsLoader.removeEventListener(Event.COMPLETE, _onBitmapFileLoadComplete);
		}
	}
}
