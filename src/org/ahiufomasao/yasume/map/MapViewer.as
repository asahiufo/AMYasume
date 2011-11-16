package org.ahiufomasao.yasume.map 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.ahiufomasao.utility.display.BitmapCanvas;
	import org.ahiufomasao.utility.VectorUtility;
	
	/**
	 * <code>MapViewer</code> クラスは、<code>MapData</code> オブジェクトのマップデータに基づいてマップを描画します.
	 * <p>
	 * 描画の基準となる <code>MapData</code> オブジェクトを指定して <code>MapViewer</code> クラスのインスタンスを生成し、
	 * <code>draw</code> メソッドを呼び出すことでマップを描画します。
	 * </p>
	 * <p>
	 * <code>MapViewer</code> クラスのインスタンス生成後に、
	 * コンストラクタで指定した <code>MapData</code> オブジェクトの 
	 * <code>chipGraphics</code> プロパティ以外の内容を変更しても、
	 * 生成された <code>MapViewer</code> オブジェクトへは影響がありません。
	 * しかし、<code>MapData</code> オブジェクトの <code>chipGraphics</code> プロパティが指している 
	 * <code>Vector</code> オブジェクトの要素を変更すると、<code>MapViewer</code> オブジェクトの表示に影響が出ます。
	 * </p>
	 * <p>
	 * 負の座標の表示位置の描画はサポートしていません。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see MapData
	 * @see #draw()
	 * @see MapData#chipGraphics
	 */
	public class MapViewer 
	{
		private var _mapWidthChip:uint;        // マップ横幅（チップ単位）
		private var _mapHeightChip:uint;       // マップ高さ（チップ単位）
		private var _chipWidth:uint;           // チップ横幅（ピクセル単位）
		private var _chipHeight:uint;          // チップ高さ（ピクセル単位）
		private var _screenWidthChip:uint;     // 画面横幅（チップ単位）
		private var _screenHeightChip:uint;    // 画面高さ（チップ単位）
		
		private var _loop:Boolean;             // ループモード
		private var _backgroundColor:uint;     // 背景色
		
		private var _layers:Vector.<Layer>;    // レイヤーリスト
		
		private var _chipGraphics:Vector.<BitmapData>; // マップチップグラフィックリスト
		
		private var _cameraX:Number;           // カメラ位置のx座標
		private var _cameraY:Number;           // カメラ位置のy座標
		
		/**
		 * マップ全体のチップ単位の横幅です.
		 * <p>
		 * <code>MapData</code> オブジェクトの <code>mapWidthChip</code> プロパティより設定されます。
		 * </p>
		 * 
		 * @see MapData#mapWidthChip
		 */
		public function get mapWidthChip():uint { return _mapWidthChip; }
		
		/**
		 * マップ全体のチップ単位の高さです.
		 * <p>
		 * <code>MapData</code> オブジェクトの <code>mapHeightChip</code> プロパティより設定されます。
		 * </p>
		 * 
		 * @see MapData#mapHeightChip
		 */
		public function get mapHeightChip():uint { return _mapHeightChip; }
		
		/**
		 * チップ 1 つ分の横幅です.
		 * <p>
		 * <code>MapData</code> オブジェクトの <code>chipWidth</code> プロパティより設定されます。
		 * </p>
		 * 
		 * @see MapData#chipWidth
		 */
		public function get chipWidth():uint { return _chipWidth; }
		
		/**
		 * チップ 1 つ分の高さです.
		 * <p>
		 * <code>MapData</code> オブジェクトの <code>chipHeight</code> プロパティより設定されます。
		 * </p>
		 * 
		 * @see MapData#chipHeight
		 */
		public function get chipHeight():uint { return _chipHeight; }
		
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
		 * <code>MapData</code> オブジェクトの <code>screenWidthChip</code> プロパティより設定されます。
		 * </p>
		 * 
		 * @see MapData#screenWidthChip
		 */
		public function get screenWidthChip():uint { return _screenWidthChip; }
		
		/**
		 * マップを描画する画面のチップ単位の高さです.
		 * <p>
		 * <code>MapData</code> オブジェクトの <code>screenHeightChip</code> プロパティより設定されます。
		 * </p>
		 * 
		 * @see MapData#screenHeightChip
		 */
		public function get screenHeightChip():uint { return _screenHeightChip; }
		
		/**
		 * マップを描画する画面のピクセル単位の横幅です.
		 */
		public function get screenWidthPx():uint { return (_screenWidthChip * _chipWidth); }
		
		/**
		 * マップを描画する画面のピクセル単位の高さです.
		 */
		public function get screenHeightPx():uint { return (_screenHeightChip * _chipHeight); }
		
		/**
		 * <code>true</code> が設定されている場合、マップがループしていると解釈されます.
		 * <p>
		 * <code>MapData</code> オブジェクトの <code>loop</code> プロパティより設定されます。
		 * </p>
		 * 
		 * @see MapData#loop
		 */
		public function get loop():Boolean { return _loop; }
		
		/**
		 * マップの背景色です.
		 * <p>
		 * <code>MapData</code> オブジェクトの <code>backgroundColor</code> プロパティより設定されます。
		 * </p>
		 * 
		 * @see MapData#backgroundColor
		 */
		public function get backgroundColor():uint { return _backgroundColor; }
		
		/**
		 * マップに登録されているレイヤーの数です.
		 */
		public function get mapLength():uint { return _layers.length; }
		
		/**
		 * カメラ位置の <code>x</code> 座標です.
		 * <p>
		 * マップを表示する画面の表示基準位置となります。
		 * </p>
		 */
		public function get cameraX():Number { return _cameraX; }
		/** @private */
		public function set cameraX(value:Number):void { _cameraX = value; }
		/**
		 * カメラ位置の <code>y</code> 座標です.
		 * <p>
		 * マップを表示する画面の表示基準位置となります。
		 * </p>
		 */
		public function get cameraY():Number { return _cameraY; }
		/** @private */
		public function set cameraY(value:Number):void { _cameraY = value; }
		
		/**
		 * 新しい <code>MapViewer</code> クラスのインスタンスを生成します.
		 * 
		 * @param mapData 表示するマップのデータです。
		 * 
		 * @throws ArgumentError マップデータにレイヤーが1件も登録されていない場合にスローされます。
		 * @throws ArgumentError マップデータにフレームデータが1件も登録されていないレイヤーが存在する場合にスローされます。
		 * @throws ArgumentError マップデータにチップグラフィックリストが1件も設定されていない場合にスローされます。
		 */
		public function MapViewer(mapData:MapData) 
		{
			_mapWidthChip     = mapData.mapWidthChip;
			_mapHeightChip    = mapData.mapHeightChip;
			_chipWidth        = mapData.chipWidth;
			_chipHeight       = mapData.chipHeight;
			_screenWidthChip  = mapData.screenWidthChip;
			_screenHeightChip = mapData.screenHeightChip;
			_loop             = mapData.loop;
			_backgroundColor  = mapData.backgroundColor;
			
			var layer:Layer;
			var layers:Vector.<Layer> = new Vector.<Layer>();
			var mapLayerData:MapLayerData;
			var frames:Vector.<Frame>;
			var frame:Frame;
			var frameChipData:Vector.<Vector.<uint>>;
			for each (mapLayerData in mapData.mapLayerDatas)
			{
				frames = new Vector.<Frame>();
				for each (frameChipData in mapLayerData.frameChipDatas)
				{
					frames.push(new Frame(VectorUtility.copy2DVectorForUint(frameChipData)));
				}
				// フレームが1件も登録されていない場合エラー
				if (frames.length == 0)
				{
					throw new ArgumentError("レイヤーには少なくとも1件のフレームデータを登録する必要があります。");
				}
				
				layers.push(new Layer(mapLayerData.scrollSpeed, mapLayerData.frameRate, frames));
			}
			_layers = layers;
			// レイヤーが1件も登録されていない場合エラー
			if (mapLength == 0)
			{
				throw new ArgumentError("マップにはレイヤーが少なくとも1件必要です。");
			}
			
			_chipGraphics = mapData.chipGraphics;
			if (_chipGraphics == null)
			{
				throw new ArgumentError("マップを描画するには、チップグラフィックを少なくとも1件設定する必要があります。");
			}
			if (_chipGraphics.length == 0)
			{
				throw new ArgumentError("マップを描画するには、チップグラフィックを少なくとも1件設定する必要があります。");
			}
			
			_cameraX = 0;
			_cameraY = 0;
		}
		
		/**
		 * レイヤーに登録されているフレームの数を返します.
		 * 
		 * @param index フレーム数を取得するレイヤーのインデックスです。1 件目のレイヤーは 0、2 件目のレイヤーは 1、・・・ として指定します。
		 * 
		 * @return レイヤーに登録されているフレームの数です。
		 * 
		 * @throws ArgumentError 指定したインデックスのレイヤーが存在しない場合にスローされます。
		 */
		public function getLayerLength(index:uint):uint
		{
			if (!(0 <= index && index < mapLength))
			{
				throw new ArgumentError("指定したインデックスのレイヤーは存在しません。[index = " + index + "]");
			}
			return _layers[index].frames.length;
		}
		
		/**
		 * マップチップグラフィックを取得します.
		 * 
		 * @param chipNo 取得するチップグラフィックの番号です。
		 * 
		 * @return 指定された番号のチップグラフィックの <code>BitmapData</code> オブジェクトです。
		 * 
		 * @throws ArgumentError 指定された番号のチップグラフィックが存在しない場合にスローされます。
		 */
		public function getChipGraphic(chipNo:uint):BitmapData
		{
			if (!(0 <= chipNo && chipNo < _chipGraphics.length))
			{
				throw new ArgumentError("指定されたチップグラフィック番号のチップは存在しません。[chipNo = " + chipNo + "]");
			}
			return _chipGraphics[chipNo];
		}
		
		/**
		 * フレームのチップデータを取得します.
		 * 
		 * @param layerIndex 取得するフレームのチップデータが登録されているレイヤーのインデックスです。1 件目のレイヤーは 0、2 件目のレイヤーは 1、・・・ として指定します。
		 * @param frameNo    取得するチップデータを持つフレームの番号です。1 件目のフレームは 1、2 件目のフレームは 2、・・・ として指定します。
		 * 
		 * @return フレームのチップデータです。
		 * 
		 * @throws ArgumentError 指定したインデックスのレイヤーが存在しない場合にスローされます。
		 * @throws ArgumentError 指定した番号のフレームが指定した番号のレイヤー内に存在しない場合にスローされます。
		 */
		public function getFrameChipData(layerIndex:uint, frameNo:uint):Vector.<Vector.<uint>>
		{
			if (!(0 <= layerIndex && layerIndex < mapLength))
			{
				throw new ArgumentError("指定したインデックスのレイヤーは存在しません。[layerIndex = " + layerIndex + "]");
			}
			if (!(1 <= frameNo && frameNo <= _layers[layerIndex].frames.length))
			{
				throw new ArgumentError("指定したフレーム番号のフレームは存在しません。[layerIndex = " + layerIndex + ", frameNo = " + frameNo + "]");
			}
			return _layers[layerIndex].frames[frameNo - 1].chipData;
		}
		
		/**
		 * マップの背景を描画します.
		 * 
		 * @param canvas マップを描画するキャンバスです。
		 */
		public function drawBackground(canvas:BitmapCanvas):void
		{
			canvas.fill(_backgroundColor);
		}
		
		/**
		 * マップを描画します.
		 * 
		 * @param layerIndex   描画するレイヤーのインデックスです。1 件目のレイヤーは 0、2 件目のレイヤーは 1、・・・ として指定します。
		 * @param canvas       マップを描画するキャンバスです。
		 * @param drawPosition マップ描画を開始するキャンバス上の位置です。
		 * 
		 * @throws ArgumentError 指定したインデックスのレイヤーが存在しない場合にスローされます。
		 */
		public function draw(layerIndex:uint, canvas:BitmapCanvas, drawPosition:Point = null):void
		{
			if (!(0 <= layerIndex && layerIndex < mapLength))
			{
				throw new ArgumentError("指定したインデックスのレイヤーは存在しません。[layerIndex = " + layerIndex + "]");
			}
			var layer:Layer = _layers[layerIndex];
			
			layer.draw(this, canvas, drawPosition);
		}
		
		/**
		 * 表示する <code>x</code> 座標を算出します.
		 * 
		 * @param layerIndex 計算の基準にするマップのレイヤーインデックスです。1 件目のレイヤーは 0、2 件目のレイヤーは 1、・・・ として指定します。
		 * @param x          計算するオブジェクトの <code>x</code> 座標です。
		 * 
		 * @return 表示する <code>x</code> 座標です。
		 * 
		 * @throws ArgumentError 指定したインデックスのレイヤーが存在しない場合にスローされます。
		 */
		public function calculateViewXFromX(layerIndex:uint, x:Number):Number
		{
			if (!(0 <= layerIndex && layerIndex < mapLength))
			{
				throw new ArgumentError("指定したインデックスのレイヤーは存在しません。[layerIndex = " + layerIndex + "]");
			}
			return ((x - _cameraX) * _layers[layerIndex].scrollSpeed);
		}
		
		/**
		 * 表示する <code>y</code> 座標を算出します.
		 * 
		 * @param layerIndex 計算の基準にするマップのレイヤーインデックスです。1 件目のレイヤーは 0、2 件目のレイヤーは 1、・・・ として指定します。
		 * @param y          計算するオブジェクトの <code>y</code> 座標です。
		 * 
		 * @return 表示する <code>x</code> 座標です。
		 * 
		 * @throws ArgumentError 指定したインデックスのレイヤーが存在しない場合にスローされます。
		 */
		public function calculateViewYFromY(layerIndex:uint, y:Number):Number
		{
			if (!(0 <= layerIndex && layerIndex < mapLength))
			{
				throw new ArgumentError("指定したインデックスのレイヤーは存在しません。[layerIndex = " + layerIndex + "]");
			}
			return ((y - _cameraY) * _layers[layerIndex].scrollSpeed);
		}
		
		/**
		 * マップ外へ出たカメラ位置をマップ外となる境界位置へ調整します.
		 */
		public function adjustCameraPositionAtBoundary():void
		{
			if (_cameraX < 0)
			{
				_cameraX = 0;
			}
			else if (_cameraX > mapWidthPx - screenWidthPx)
			{
				_cameraX = mapWidthPx - screenWidthPx;
			}
			if (_cameraY < 0)
			{
				_cameraY = 0;
			}
			else if (_cameraY > mapHeightPx - screenHeightPx)
			{
				_cameraY = mapHeightPx - screenHeightPx;
			}
		}
	}
}

import flash.geom.Point;
import org.ahiufomasao.utility.display.BitmapCanvas;
import org.ahiufomasao.yasume.map.MapViewer;

/**
 * @private
 * レイヤー
 */
class Layer
{
	private var _scrollSpeed:Number;    // スクロールスピード
	private var _frameRate:uint;        // アニメ切り替え時間
	private var _frames:Vector.<Frame>; // フレームリスト
	
	private var _currentFrame:uint;     // 描画フレーム番号
	private var _timeCount:uint;        // アニメーション時間カウント
	
	private var _point:Point;           // 汎用ポイント
	
	/** スクロールスピード */
	public function get scrollSpeed():Number { return _scrollSpeed; }
	/** アニメ切り替え時間 */
	public function get frameRate():uint { return _frameRate; }
	/** フレームリスト */
	public function get frames():Vector.<Frame> { return _frames; }
	
	/**
	 * コンストラクタ
	 * 
	 * @param scrollSpeed スクロールスピード
	 * @param frameRate アニメ切り替え時間
	 * @param frames   フレームリスト
	 */
	public function Layer(scrollSpeed:Number, frameRate:uint, frames:Vector.<Frame>)
	{
		_scrollSpeed  = scrollSpeed;
		_frameRate    = frameRate;
		_frames       = frames;
		
		_currentFrame = 0;
		_timeCount    = 0;
		
		_point        = new Point();
	}
	
	/**
	 * 描画
	 * 
	 * @param viewer       マップビューア
	 * @param canvas       キャンバス
	 * @param drawPosition 描画位置
	 */
	public function draw(viewer:MapViewer, canvas:BitmapCanvas, drawPosition:Point):void
	{
		var sw:uint                         = viewer.screenWidthChip;        // 画面横幅（チップ単位）
		var sh:uint                         = viewer.screenHeightChip;       // 画面高さ（チップ単位）
		var swp:uint                        = sw + 1;                        // 画面横幅+1
		var shp:uint                        = sh + 1;                        // 画面高さ+1
		var cw:uint                         = viewer.chipWidth;              // チップ横幅（ピクセル単位）
		var ch:uint                         = viewer.chipHeight;             // チップ高さ（ピクセル単位）
		var loop:Boolean                    = viewer.loop;                   // ループモード
		var chipData:Vector.<Vector.<uint>> = Frame(_frames[_currentFrame]).chipData;
		var dataWidth:uint                  = chipData[0].length;            // マップデータの横幅（チップ単位）
		var dataHeight:uint                 = chipData.length;               // マップデータの高さ（チップ単位）
		var cameraX:Number                  = viewer.cameraX * _scrollSpeed; // 表示x座標位置（ピクセル単位）
		var cameraY:Number                  = viewer.cameraY * _scrollSpeed; // 表示y座標位置（ピクセル単位）
		
		// カメラが指定したマップ外なら補正
		if (cameraX < 0)
		{
			cameraX = 0;
		}
		else if (cameraX > viewer.mapWidthPx - sw * cw)
		{
			cameraX = viewer.mapWidthPx - sw * cw;
		}
		if (cameraY < 0)
		{
			cameraY = 0;
		}
		else if (cameraY > viewer.mapHeightPx - sh * ch)
		{
			cameraY = viewer.mapHeightPx - sh * ch;
		}
		
		// 表示をループさせるなら
		if (loop)
		{
			// マップからはみ出したカメラ座標をループ表示の場合の表示座標に変換
			cameraX = cameraX % (dataWidth * cw);
			cameraY = cameraY % (dataHeight * ch);
		}
		
		var cDoubleX:Number = cameraX % cw;         // 表示x座標のチップサイズ以下の補正値
		var cDoubleY:Number = cameraY % ch;         // 表示y座標のチップサイズ以下の補正値
		var i:uint;                                 // ループ用
		var j:uint;                                 // ループ用
		var dataX:uint = Math.floor(cameraX / cw);  // 描画データx座標開始点
		var saveDataX:uint = dataX;                 // x座標開始点保存
		var dataY:uint = Math.floor(cameraY / ch);  // 描画データy座標開始点
		var chipNo:uint;                           // チップ番号
		var point:Point = _point;                   // 描画位置
		
		point.x = 0;
		point.y = 0;
		
		// 描画位置
		var posX:Number;
		var posY:Number;
		if (drawPosition == null)
		{
			posX = 0;
			posY = 0;
		}
		else
		{
			posX = drawPosition.x;
			posY = drawPosition.y;
		}
		
		for (i = 0; i < shp; i++)
		{
			dataX = saveDataX;
			for (j = 0; j < swp; j++)
			{
				// チップ番号取得
				if (dataX >= dataWidth || dataY >= dataHeight)
				{
					chipNo = 0;
				}
				else
				{
					chipNo = chipData[dataY][dataX];
				}
				
				// 描画
				point.x = Math.floor(j * cw - cDoubleX) + posX;
				point.y = Math.floor(i * ch - cDoubleY) + posY;
				canvas.draw(viewer.getChipGraphic(chipNo), point);
				
				dataX++;
				// ループ表示させる場合
				if (loop)
				{
					// マップサイズ以上の表示データはループする
					if (dataX >= dataWidth)
					{
						dataX = 0;
					}
				}
			}
			
			dataY++;
			// ループ表示させる場合
			if (loop)
			{
				// マップサイズ以上の表示データはループする
				if (dataY >= dataHeight)
				{
					dataY = 0;
				}
			}
		}
		
		_animate();
	}
	
	/**
	 * アニメーション
	 */
	private function _animate():void
	{
		_timeCount++;
		
		if (_timeCount > _frameRate)
		{
			_timeCount = 0;
			_currentFrame++;
			if (_currentFrame >= _frames.length)
			{
				_currentFrame = 0;
			}
		}
	}
}

/**
 * @private
 * フレーム
 */
class Frame
{
	private var _chipData:Vector.<Vector.<uint>>; // マップデータリスト
	
	/** マップデータリスト */
	public function get chipData():Vector.<Vector.<uint>> { return _chipData; }
	
	/**
	 * コンストラクタ
	 * 
	 * @param chipData マップデータリスト
	 */
	public function Frame(chipData:Vector.<Vector.<uint>>)
	{
		_chipData = chipData;
	}
}
