package org.ahiufomasao.yasume.timeline 
{
	import flash.display.IBitmapDrawable;
	import flash.geom.Point;
	
	// TODO: asdoc
	/**
	 * タイムライングラフィック
	 * 
	 * @author asahiufo@AM902
	 */
	public interface ITimelineGraphics 
	{
		
		/**
		 * グラフィックを取得します.
		 * 
		 * @param frameName 取得するグラフィックが登録されているフレームの名前です。
		 * @param graphicNo 取得するグラフィックが登録されているグラフィック番号です。1 以上を指定します。
		 * 
		 * @return 取得した <code>IBitmapDrawable</code> オブジェクトです。
		 * 
		 * @throws ArgumentError 指定された名前のフレームが存在しない場合にスローされます。
		 * @throws ArgumentError 指定されたグラフィック番号が登録されていない場合にスローされます。
		 */
		function getGraphic(frameName:String, graphicNo:uint):IBitmapDrawable;
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
		function getCenterPosition(frameName:String, graphicNo:uint):Point;
	}
}