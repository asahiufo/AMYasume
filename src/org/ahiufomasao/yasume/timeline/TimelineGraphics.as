package org.ahiufomasao.yasume.timeline 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * <code>TimelineGraphics</code> クラスは、<code>MainTimeline</code> クラスと同様の構造で各フレームのグラフィックデータを管理します.
	 * <p>
	 * <code>addGraphic</code>、<code>setGraphic</code> メソッドで、
	 * 指定した名前のフレームの、指定したグラフィック番号へ 
	 * <code>BitmapData</code> オブジェクトと、グラフィックの中心座標を登録します。
	 * また、<code>TimelineGraphicsLoader</code> オブジェクトに任意のデータを設定し、
	 * <code>TimelineGraphicsLoader</code> オブジェクトの <code>createTimelineGraphics</code> メソッドを呼び出すことで、
	 * 外部グラフィックファイルのグラフィックデータが設定された <code>TimelineGraphics</code> を何度でも生成できます。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see MainTimeline
	 * @see #addGraphic
	 * @see #setGraphic
	 * @see TimelineGraphicsLoader
	 * @see TimelineGraphicsLoader#createTimelineGraphics()
	 */
	public class TimelineGraphics 
	{
		private var _childTimelineGraphicsDict:Dictionary; // データを登録するDictionary
		
		/**
		 * 新しい <code>TimelineGraphics</code> クラスのインスタンスを生成します.
		 */
		public function TimelineGraphics() 
		{
			_childTimelineGraphicsDict = new Dictionary();
		}
		
		/**
		 * 指定したフレームへ、グラフィックを追加登録します.
		 * <p>
		 * フレームが存在しない場合は新規作成し、グラフィックを登録します。
		 * </p>
		 * <p>
		 * グラフィックの中心点は、グラフィックの左上角の点を原点 (0, 0) とし、
		 * x 軸方向は右へ行くほど数値が大きく、y 軸方向は下へ行くほど数値が大きくなります。
		 * </p>
		 * 
		 * @param frameName      グラフィックを登録するフレームの名前です。
		 * @param BMPData        グラフィックとして登録する <code>BitmapData</code> オブジェクトです。
		 * @param centerPosition 登録するグラフィックの中心座標です。
		 * 
		 * @return 登録された <code>BitmapData</code> オブジェクトです。
		 */
		public function addGraphic(frameName:String, BMPData:BitmapData, centerPosition:Point = null):BitmapData
		{
			var childTimelineGraphics:ChildTimelineGraphics;
			
			// まだ作られていないフレーム名である場合
			if (_childTimelineGraphicsDict[frameName] == undefined)
			{
				// タイムライン構築
				childTimelineGraphics = new ChildTimelineGraphics();
				_childTimelineGraphicsDict[frameName] = childTimelineGraphics;
			}
			else
			{
				childTimelineGraphics = ChildTimelineGraphics(_childTimelineGraphicsDict[frameName]);
			}
			
			return childTimelineGraphics.addGraphic(BMPData, centerPosition);
		}
		
		/**
		 * 指定したフレームの指定したグラフィック番号へグラフィックを登録します.
		 * <p>
		 * フレームが存在しない場合は新規作成し、グラフィックを登録します。
		 * </p>
		 * <p>
		 * 登録するグラフィック番号は、連続した値を指定する必要があります。
		 * 例えば、すでにグラフィック番号 1, 2, 3 へグラフィックが登録されている時、
		 * 4 を指定することはできますが、 5 を指定することはできません。
		 * </p>
		 * <p>
		 * グラフィックの中心点は、グラフィックの左上角の点を原点 (0, 0) とし、
		 * x 軸方向は右へ行くほど数値が大きく、 y 軸方向は下へ行くほど数値が大きくなります。
		 * </p>
		 * 
		 * @param frameName      グラフィックを登録するフレームの名前です。
		 * @param graphicNo      グラフィックを登録するグラフィック番号です。1 以上を指定します。
		 * @param BMPData        グラフィックとして登録する <code>BitmapData</code> オブジェクトです。
		 * @param centerPosition 登録するグラフィックの中心座標です。
		 * 
		 * @return 登録された <code>BitmapData</code> オブジェクトです。
		 * 
		 * @throws ArgumentError 指定されたグラフィック番号が 1 より小さい場合にスローされます。
		 * @throws ArgumentError 指定されたグラフィック番号が連続した値でない場合にスローされます。
		 */
		public function setGraphic(frameName:String, graphicNo:uint, BMPData:BitmapData, centerPosition:Point = null):BitmapData
		{
			var childTimelineGraphics:ChildTimelineGraphics;
			
			// まだ作られていないフレーム名である場合
			if (_childTimelineGraphicsDict[frameName] == undefined)
			{
				// タイムライン構築
				childTimelineGraphics = new ChildTimelineGraphics();
				_childTimelineGraphicsDict[frameName] = childTimelineGraphics;
			}
			else
			{
				childTimelineGraphics = ChildTimelineGraphics(_childTimelineGraphicsDict[frameName]);
			}
			
			return childTimelineGraphics.setGraphic(graphicNo, BMPData, centerPosition);
		}
		
		/**
		 * グラフィックを取得します.
		 * 
		 * @param frameName 取得するグラフィックが登録されているフレームの名前です。
		 * @param graphicNo 取得するグラフィックが登録されているグラフィック番号です。1 以上を指定します。
		 * 
		 * @return 取得した <code>BitmapData</code> オブジェクトです。
		 * 
		 * @throws ArgumentError 指定された名前のフレームが存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたグラフィック番号が登録されていない場合にスローされます。
		 */
		public function getGraphic(frameName:String, graphicNo:uint):BitmapData
		{
			// まだ作られていないフレーム名である場合エラー
			if (_childTimelineGraphicsDict[frameName] == undefined)
			{
				throw new ArgumentError("指定したフレームは作られていません。[フレーム名 = " + frameName + "]");
			}
			
			return ChildTimelineGraphics(_childTimelineGraphicsDict[frameName]).getGraphic(graphicNo);
		}
		
		/**
		 * グラフィックの中心座標を取得します.
		 * 
		 * @param frameName 取得する中心点が登録されているフレームの名前です。
		 * @param graphicNo 取得する中心点が登録されているグラフィック番号です。1 以上を指定します。
		 * 
		 * @return 取得した中心座標です。
		 * 
		 * @throws ArgumentError 指定された名前のフレームが存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたグラフィック番号が登録されていない場合にスローされます。
		 */
		public function getCenterPosition(frameName:String, graphicNo:uint):Point
		{
			// まだ作られていないフレーム名である場合エラー
			if (_childTimelineGraphicsDict[frameName] == undefined)
			{
				throw new ArgumentError("指定したフレームは作られていません。[フレーム名 = " + frameName + "]");
			}
			
			return ChildTimelineGraphics(_childTimelineGraphicsDict[frameName]).getCenterPosition(graphicNo);
		}
		
		/**
		 * 指定されたフレームのグラフィックの登録数を取得します。
		 * 
		 * @param frameName グラフィックの登録数を取得するフレームの名前です。
		 * 
		 * @return グラフィックの登録数です。
		 * 
		 * @throws ArgumentError 指定された名前のフレームが存在しない場合にスローされます。
		 */
		public function getLength(frameName:String):uint
		{
			// まだ作られていないフレーム名である場合エラー
			if (_childTimelineGraphicsDict[frameName] == undefined)
			{
				throw new ArgumentError("指定したフレームは作られていません。[フレーム名 = " + frameName + "]");
			}
			
			return ChildTimelineGraphics(_childTimelineGraphicsDict[frameName]).length;
		}
	}
}

import flash.display.BitmapData;
import flash.geom.Point;

/**
 * @private
 * フレームグラフィック
 */
class ChildTimelineGraphics
{
	private var _graphics:Vector.<BitmapData>;   // グラフィックリスト
	private var _centerPositions:Vector.<Point>; // グラフィックの中心座標リスト
	
	/**
	 * 登録数
	 */
	public function get length():uint { return _graphics.length; }
	
	/**
	 * コンストラクタ
	 */
	public function ChildTimelineGraphics()
	{
		_graphics        = new Vector.<BitmapData>();
		_centerPositions = new Vector.<Point>();
	}
	
	/**
	 * 指定したフレームへ、グラフィックを追加登録します。
	 * <p>
	 * フレームが存在しない場合は、新規作成します。
	 * </p>
	 * <p>
	 * グラフィックの中心点は、グラフィックの左上角の点を原点 (0, 0) とし、
	 * x 軸方向は右へ行くほど数値が大きく、 y 軸方向は下へ行くほど数値が大きくなります。
	 * </p>
	 * 
	 * @param BMPData        グラフィックとして登録する BitmapData オブジェクトです。
	 * @param centerPosition 登録するグラフィックの中心点とする座標です。
	 * 
	 * @return 登録された BitmapData オブジェクトです。
	 */
	public function addGraphic(BMPData:BitmapData, centerPosition:Point = null):BitmapData
	{
		return setGraphic(length + 1, BMPData, centerPosition);
	}
	
	/**
	 * 指定したフレームのグラフィック番号へグラフィックを登録します。
	 * <p>
	 * フレームが存在しない場合は、新規作成します。
	 * 登録するグラフィック番号は、連続した値を指定する必要があります。
	 * 例えば、すでにグラフィック番号 1, 2, 3 へグラフィックが登録されている時、
	 * 4 を指定することはできますが、 5 を指定することはできません。
	 * </p>
	 * <p>
	 * グラフィックの中心点は、グラフィックの左上角の点を原点 (0, 0) とし、
	 * x 軸方向は右へ行くほど数値が大きく、 y 軸方向は下へ行くほど数値が大きくなります。
	 * </p>
	 * 
	 * @param graphicNo      グラフィックを登録するグラフィック番号です。 1 以上を指定します。
	 * @param BMPData        グラフィックとして登録する BitmapData オブジェクトです。
	 * @param centerPosition 登録するグラフィックの中心点とする座標です。
	 * 
	 * @return 登録された BitmapData オブジェクトです。
	 * 
	 * @throws ArgumentError 指定されたグラフィック番号が 1 より小さい場合にスローされます。
	 * @throws ArgumentError 指定されたグラフィック番号が連続した値でない場合にスローされます。
	 */
	public function setGraphic(graphicNo:uint, BMPData:BitmapData, centerPosition:Point = null):BitmapData
	{
		// グラフィック番号が1より小さい場合エラー
		if (graphicNo < 1)
		{
			throw new ArgumentError("グラフィック番号は1以上である必要があります。[グラフィック番号 = " + graphicNo + "]");
		}
		
		// 連続したグラフィック番号が指定されていない場合エラー
		var length:uint = _graphics.length;
		if (graphicNo > length + 1)
		{
			throw new ArgumentError("グラフィック番号は連続した値である必要があります。指定されたフレームの登録数は " + length + " 件なので、グラフィック番号は " + (length + 1) + " 以下を指定してください。");
		}
		
		_graphics[graphicNo - 1] = BMPData;
		
		var point:Point = new Point();
		if (centerPosition == null)
		{
			point.x = 0;
			point.y = 0;
		}
		else
		{
			point.x = centerPosition.x;
			point.y = centerPosition.y;
		}
		_centerPositions[graphicNo - 1] = point;
		
		return BMPData;
	}
	
	/**
	 * グラフィックを取得します。
	 * 
	 * @param graphicNo 取得するグラフィックが登録されているグラフィック番号です。 1 以上を指定します。
	 * 
	 * @return 取得した BitmapData オブジェクトです。
	 * 
	 * @throws ArgumentError 指定されたグラフィック番号が登録されていない場合にスローされます。
	 */
	public function getGraphic(graphicNo:uint):BitmapData
	{
		// 登録されていないグラフィック番号を指定した場合エラー
		if (graphicNo <= 0 || _graphics.length < graphicNo)
		{
			throw new ArgumentError("指定されたグラフィック番号は登録されていません。[グラフィック番号 = " + graphicNo + "]");
		}
		
		return _graphics[graphicNo - 1];
	}
	
	/**
	 * グラフィックの中心点の座標を取得します。
	 * 
	 * @param graphicNo 取得する中心点が登録されているグラフィック番号です。 1 以上を指定します。
	 * 
	 * @return 取得した中心点の x 座標です。
	 * 
	 * @throws ArgumentError 指定されたグラフィック番号が登録されていない場合にスローされます。
	 */
	public function getCenterPosition(graphicNo:uint):Point
	{
		// 登録されていないグラフィック番号を指定した場合エラー
		if (graphicNo <= 0 || _graphics.length < graphicNo)
		{
			throw new ArgumentError("指定されたグラフィック番号は登録されていません。[グラフィック番号 = " + graphicNo + "]");
		}
		
		var point:Point = _centerPositions[graphicNo - 1];
		
		return new Point(point.x, point.y);
	}
}
