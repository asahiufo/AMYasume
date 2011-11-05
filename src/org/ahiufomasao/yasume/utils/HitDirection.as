package org.ahiufomasao.yasume.utils 
{
	/**
	 * <code>HitDirection</code> クラスには、
	 * 当たり判定において、当たった方向を表す定数があります.
	 * 
	 * @author asahiufo/AM902
	 */
	public class HitDirection
	{
		/**
		 * <code>testHitRectangleDirection</code> メソッドにおいて <em>当たり無し</em> を表す定数です.
		 * 
		 * @see #testHitRectangleDirection()
		 */
		public static const NONE:HitDirection = new HitDirection("NONE");
		/**
		 * <code>testHitRectangleDirection</code> メソッドにおいて<em>上当たり</em> を表す定数です.
		 * 
		 * @see #testHitRectangleDirection()
		 */
		public static const TOP:HitDirection = new HitDirection("TOP");
		/**
		 * <code>testHitRectangleDirection</code> メソッドにおいて <em>下当たり</em> を表す定数です.
		 * 
		 * @see #testHitRectangleDirection()
		 */
		public static const BOTTOM:HitDirection = new HitDirection("BOTTOM");
		/**
		 * <code>testHitRectangleDirection</code> メソッドにおいて <em>左当たり</em> を表す定数です.
		 * 
		 * @see #testHitRectangleDirection()
		 */
		public static const LEFT:HitDirection = new HitDirection("LEFT");
		/**
		 * <code>testHitRectangleDirection</code> メソッドにおいて <em>右当たり</em> を表す定数です.
		 * 
		 * @see #testHitRectangleDirection()
		 */
		public static const RIGHT:HitDirection = new HitDirection("RIGHT");
		
		private var _direction:String; // 方向
		
		/**
		 * 新しい <code>HitDirection</code> クラスのインスタンスを生成します.
		 * 
		 * @param direction 方向を表す文字列です。
		 */
		public function HitDirection(direction:String)
		{
			_direction = direction;
		}
		
		/**
		 * 定数が示す当たり方向の逆を表す当たり方向の定数を返します.
		 * <p>
		 * <code>RIGHT</code> なら <code>LEFT</code>、
		 * <code>TOP</code> なら <code>BOTTOM</code> というように、
		 * 当たり方向の定数を逆方向に変換します。
		 * <code>NONE</code> の場合はそのまま <code>NONE</code> が返されます。
		 * </p>
		 * 
		 * @param hitDirection 当たり方向を示す定数です。
		 * 
		 * @return 反転された当たり方向の定数です。
		 * 
		 * @throws ArgumentError <code>hitDirection</code> パラメータに <code>NONE</code>、<code>TOP</code>、 <code>BOTTOM</code>、 <code>LEFT</code>、 <code>RIGHT</code> 以外が指定された場合にスローされます。
		 * 
		 * @see #NONE
		 * @see #TOP
		 * @see #BOTTOM
		 * @see #LEFT
		 * @see #RIGHT
		 */
		public static function convertReverseHitDirection(hitDirection:HitDirection):HitDirection
		{
			switch (hitDirection)
			{
				case NONE:
					return NONE;
				case TOP:
					return BOTTOM;
				case BOTTOM:
					return TOP;
				case LEFT:
					return RIGHT;
				case RIGHT:
					return LEFT;
				default:
					throw ArgumentError("無効な当たり方向です。");
			}
		}
		
		/**
		 * <code>HitDirection</code> オブジェクトの文字列表現を返します.
		 * <p>
		 * ストリングは次の形式です。
		 * </p>
		 * <p>
		 * <code>[HitDirection direction="<em>value</em>"]</code>
		 * </p>
		 * 
		 * @return <code>HitDirection</code> オブジェクトの文字列表現を返します。
		 */
		public function toString():String
		{
			return "[HitDirection direction=\"" + _direction + "\"]";
		}
	}
}
