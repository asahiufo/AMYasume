package org.ahiufomasao.yasume.timeline 
{
	import flash.geom.Rectangle;
	
	/**
	 * <code>PushHitArea</code> クラスは、<code>ChildTimeline</code> オブジェクトへ登録する押し当たり判定エリアです.
	 * <p>
	 * 押し当たり判定とは、オブジェクト同士で押したり押されたりする当たり判定です。
	 * </p>
	 * <p>
	 * <code>ChildTimeline</code> クラスの <code>setPushHitArea</code> メソッドで 
	 * 対象フレームに <code>PushHitArea</code> オブジェクトを登録することで、
	 * その対象フレームに押し当たり判定を与えます。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see ChildTimeline#setPushHitArea()
	 */
	public class PushHitArea
	{
		private var _rectangle:Rectangle; // エリア矩形
		
		/**
		 * 押し当たり判定エリアとなる矩形です.
		 */
		public function get rectangle():Rectangle { return _rectangle; }
		
		/**
		 * 新しい <code>PushHitArea</code> クラスのインスタンスを生成します.
		 */
		public function PushHitArea() 
		{
			_rectangle = new Rectangle();
		}
	}
}
