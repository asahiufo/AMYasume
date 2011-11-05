package org.ahiufomasao.yasume.utils 
{
	import flash.geom.Rectangle;
	
	/**
	 * <code>Tester</code> クラスには、
	 * ゲームにおいての一般的な判定を行うメソッドがあります.
	 * <p>
	 * <code>Tester</code> クラスは完全な静的クラスであるため、
	 * インスタンスを作成する必要はありません。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 */
	public class Tester 
	{
		/**
		 * 矩形同士の当たり判定を行います.
		 * 
		 * @param rect1 判定矩形 1 です。
		 * @param rect2 判定矩形 2 です。
		 * 
		 * @return 指定した 2 つの矩形が重なっている場合 <code>true</code>、そうでないなら <code>false</code> を返します。
		 */
		public static function testHitRectangle(rect1:Rectangle, rect2:Rectangle):Boolean
		{
			// 判定
			if (rect1.right < rect2.left)
			{
			}
			else if (rect1.left > rect2.right)
			{
			}
			else if (rect1.bottom < rect2.top)
			{
			}
			else if (rect1.top > rect2.bottom)
			{
			}
			else
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * <code>rect1</code> の矩形のどの方向に <code>rect2</code> の矩形が重なっているかを判定します.
		 * <p>
		 * 例えば <code>rect1</code> の矩形の右の辺に <code>rect2</code> の矩形が重なっている場合、
		 * 右当たりとして <code>Tester.HIT_RIGHT</code> を返します。
		 * 右当たり、上当たりというように複数方向から当たっていると判断できる場合、
		 * 上下当たりの方が左右当たりよりも優先して当たりと判定されます。
		 * </p>
		 * 
		 * @param rect1          判定矩形 1 です。
		 * @param rect2          判定矩形 2 です。
		 * @param outHitPartArea ここに指定した <code>Rectangle</code> オブジェクトへ判定矩形の重なり合っている範囲を表す矩形情報が設定されます。
		 * 
		 * @return 以下のパターンで当たり方向の定数が返されます。
		 * <table>
		 * <tr><td>重なり合っていない</td><td><code>Tester.HIT_NONE</code></td></tr>
		 * <tr><td>判定矩形 1 の上辺に判定矩形 2 が重なっている</td><td><code>Tester.HIT_TOP</code></td></tr>
		 * <tr><td>判定矩形 1 の下辺に判定矩形 2 が重なっている</td><td><code>Tester.HIT_BOTTOM</code></td></tr>
		 * <tr><td>判定矩形 1 の左辺に判定矩形 2 が重なっている</td><td><code>Tester.HIT_LEFT</code></td></tr>
		 * <tr><td>判定矩形 1 の右辺に判定矩形 2 が重なっている</td><td><code>Tester.HIT_RIGHT</code></td></tr>
		 * </table>
		 * 
		 * @see HitDirection#NONE
		 * @see HitDirection#TOP
		 * @see HitDirection#BOTTOM
		 * @see HitDirection#LEFT
		 * @see HitDirection#RIGHT
		 */
		public static function testHitRectangleDirection(rect1:Rectangle, rect2:Rectangle, outHitPartArea:Rectangle = null):HitDirection
		{
			// 出力用矩形が指定されているなら初期化する
			if (outHitPartArea != null)
			{
				outHitPartArea.setEmpty();
			}
			
			// 矩形が重なっていないなら、判定しない
			if (!testHitRectangle(rect1, rect2))
			{
				return HitDirection.NONE;
			}
			
			var right:Number;  // 右辺位置
			var left:Number;   // 左辺位置
			var top:Number;    // 上辺位置
			var bottom:Number; // 下辺位置
			
			var x:Number;      // 矩形の重なり範囲矩形の x 座標
			var y:Number;      // 矩形の重なり範囲矩形の y 座標
			var width:Number;  // 矩形の重なり部分の横幅
			var height:Number; // 矩形の重なり部分の高さ
			
			// 右辺
			right = Math.min(rect1.right, rect2.right);
			// 左辺
			left = Math.max(rect1.left, rect2.left);
			// 上辺
			top = Math.max(rect1.top, rect2.top);
			// 下辺
			bottom = Math.min(rect1.bottom, rect2.bottom);
			
			x      = left;
			y      = top;
			width  = right - left;
			height = bottom - top;
			
			// 出力用矩形が指定されているなら設定する
			if (outHitPartArea != null)
			{
				outHitPartArea.x      = x;
				outHitPartArea.y      = y;
				outHitPartArea.width  = width;
				outHitPartArea.height = height;
			}
			
			// 横の判定である場合
			if (width < height)
			{
				// 判定対象 1 が判定対象 2 の左側に位置している場合
				if (testInLeft(rect1.x, rect2.x))
				{
					// 判定対象 1 の右の辺に判定対象 2 が当たった
					return HitDirection.RIGHT;
				}
				else
				{
					// 判定対象 1 の左の辺に判定対象 2 が当たった
					return HitDirection.LEFT;
				}
			}
			// 縦の判定である場合
			else
			{
				// 判定対象1が上側に位置している場合
				if (testInTop(rect1.y, rect2.y))
				{
					// 判定対象 1 の下の辺に判定対象 2 が当たった
					return HitDirection.BOTTOM;
				}
				else
				{
					// 判定対象 1 の上の辺に判定対象 2 が当たった
					return HitDirection.TOP;
				}
			}
		}
		
		/**
		 * <code>obj</code> が <code>target</code> より上に存在するかどうか判定します.
		 * 
		 * @param objY    <code>obj</code> の <code>y</code> 座標です。
		 * @param targetY <code>target</code> の <code>y</code> 座標です。
		 * 
		 * @return <code>obj</code> が <code>target</code> より上に存在するなら <code>true</code>、そうでないなら <code>false</code> を返します。
		 */
		public static function testInTop(objY:Number, targetY:Number):Boolean
		{
			return (objY < targetY);
		}
		
		/**
		 * <code>obj</code> が <code>target</code> より左に存在するかどうか判定します.
		 * 
		 * @param objX    <code>obj</code> の <code>x</code> 座標です。
		 * @param targetX <code>target</code> の <code>x</code> 座標です。
		 * 
		 * @return <code>obj</code> が <code>target</code> より左に存在するなら <code>true</code>、そうでないなら <code>false</code> を返します。
		 */
		public static function testInLeft(objX:Number, targetX:Number):Boolean
		{
			return (objX < targetX);
		}
		
		/**
		 * <code>obj</code> が <code>target</code> の方を向いているかどうか判定します.
		 * 
		 * @param objX     <code>obj</code> の <code>x</code> 座標です。
		 * @param objRight <code>obj</code> が右を向いているなら <code>true</code> を、左を向いているなら <code>false</code> を指定します。
		 * @param targetX  <code>target</code> の <code>x</code> 座標です。
		 * 
		 * @return <code>obj</code> が <code>target</code> の方を向いているなら <code>true</code>、そうでないなら <code>false</code> を返します。
		 */
		public static function testSeeing(objX:Number, objRight:Boolean, targetX:Number):Boolean
		{
			// obj が target より左にいる場合
			if (testInLeft(objX, targetX))
			{
				// objが右を向いている場合
				if (objRight)
				{
					// 向いている
					return true;
				}
			}
			// obj　が　target　より右にいる場合
			else
			{
				// obj が左を向いている場合
				if (!objRight)
				{
					// 向いている
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * <code>obj</code> と <code>target</code> が互いに向き合っているかどうか判定します.
		 * 
		 * @param	objX        <code>obj</code> の <code>x</code> 座標です。
		 * @param	objRight    <code>obj</code> が右を向いているなら <code>true</code> を、左を向いているなら <code>false</code> を指定します。
		 * @param	targetX     <code>target</code> の <code>x</code> 座標です。
		 * @param	targetRight <code>target</code> が右を向いているなら <code>true</code> を、左を向いているなら <code>false</code> を指定します。
		 * 
		 * @return <code>obj</code> と <code>target</code> が互いに向き合っているなら <code>true</code>、そうでないなら <code>false</code> を返します。
		 */
		public static function testOpposite(objX:Number, objRight:Boolean, targetX:Number, targetRight:Boolean):Boolean
		{
			// obj が target より左にいる場合
			if (testInLeft(objX, targetX))
			{
				// objが右を、targetが左を向いている場合
				if (objRight && !targetRight)
				{
					// 向き合っている
					return true;
				}
			}
			// obj　が　target　より右にいる場合
			else
			{
				// obj が左を向いている場合
				if (!objRight && targetRight)
				{
					// 向いている
					return true;
				}
			}
			
			return false;
		}
	}
}
