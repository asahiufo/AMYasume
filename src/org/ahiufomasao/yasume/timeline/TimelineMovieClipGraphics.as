package org.ahiufomasao.yasume.timeline 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.IBitmapDrawable;
	import flash.utils.Dictionary;
	
	/**
	 * MovieClip としてタイムライングラフィックを管理
	 * 
	 * @author asahiufo@AM902
	 */
	public class TimelineMovieClipGraphics implements ITimelineGraphics 
	{
		private var _movieClipDict:Dictionary; // データを登録するDictionary
		
		private var _point:Point; // 汎用 Point;
		
		/**
		 * コンストラクタ
		 */
		public function TimelineMovieClipGraphics() 
		{
			_movieClipDict = new Dictionary();
			
			_point = new Point();
		}
		
		/**
		 * 指定したフレームへ、グラフィックとする <code>MovieClip</code> を設定します.
		 * <p>
		 * 既に設定済みフレーム名が指定された場合は上書きします。
		 * </p>
		 * 
		 * @param frameName <code>MovieClip</code> を登録するフレームの名前です。
		 * @param mc        グラフィックとして設定する <code>MovieClip</code> オブジェクトです。
		 * 
		 * @return 設定された <code>MovieClip</code> オブジェクトです。
		 */
		public function setMovieClip(frameName:String, mc:MovieClip):MovieClip
		{
			_movieClipDict[frameName] = mc;
			
			return mc;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getGraphic(frameName:String, graphicNo:uint):IBitmapDrawable 
		{
			// まだ作られていないフレーム名である場合エラー
			if (_movieClipDict[frameName] == undefined)
			{
				throw new ArgumentError("指定したフレームは作られていません。[フレーム名 = " + frameName + "]");
			}
			
			var mc:MovieClip = MovieClip(_movieClipDict[frameName]);
			
			// 登録されていないグラフィック番号を指定した場合エラー
			if (graphicNo <= 0 || mc.totalFrames < graphicNo)
			{
				throw new ArgumentError("指定されたグラフィック番号は登録されていません。[グラフィック番号 = " + graphicNo + "]");
			}
			
			mc.gotoAndStop(graphicNo);
			
			return mc;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getCenterPosition(frameName:String, graphicNo:uint):Point 
		{
			// まだ作られていないフレーム名である場合エラー
			if (_movieClipDict[frameName] == undefined)
			{
				throw new ArgumentError("指定したフレームは作られていません。[フレーム名 = " + frameName + "]");
			}
			
			var mc:MovieClip = MovieClip(_movieClipDict[frameName]);
			
			_point.x = mc.x;
			_point.y = mc.y;
			
			return _point;
		}
	}
}