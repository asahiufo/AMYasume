package org.ahiufomasao.yasume.timeline 
{
	import flash.geom.Rectangle;
	
	/**
	 * <code>StageHitArea</code> クラスは、<code>ChildTimeline</code> オブジェクトへ登録するステージ当たり判定エリアです.
	 * <p>
	 * <code>ChildTimeline</code> クラスの <code>setStageHitArea</code> メソッドで 
	 * 対象フレームに <code>StageHitArea</code> オブジェクトを登録することで、
	 * その対象フレームにステージ当たり判定を与えます。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see ChildTimeline#setStageHitArea()
	 */
	public class StageHitArea
	{
		private var _rectangle:Rectangle; // エリア矩形
		
		/**
		 * 押し当たり判定エリアとなる矩形です.
		 */
		public function get rectangle():Rectangle { return _rectangle; }
		
		/**
		 * 新しい <code>StageHitArea</code> クラスのインスタンスを生成します.
		 */
		public function StageHitArea() 
		{
			_rectangle = new Rectangle();
		}
	}
}
