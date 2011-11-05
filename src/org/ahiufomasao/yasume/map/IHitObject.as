package org.ahiufomasao.yasume.map 
{
	import flash.geom.Rectangle;
	
	/**
	 * <code>IHitObject</code> インターフェイスは当たりオブジェクトによって実装されます.
	 * 
	 * @author asahiufo/AM902
	 */
	public interface IHitObject extends IMapObject
	{
		/**
		 * 当たり判定エリアとなる矩形です.
		 */
		function get hitArea():Rectangle;
		
		/**
		 * <code>true</code> が設定されている場合は、当たり判定を行うオブジェクトが右を向いているものとして扱います.
		 * <p>
		 * 当たり判定処理で、<code>right</code> プロパティに
		 * <code>false</code> が設定されている場合は判定対象オブジェクトが左を向いているとし、
		 * 当たり判定エリアの矩形を左右反転します。
		 * <code>true</code> が設定されている場合は判定対象オブジェクトが右を向いているとし、
		 * 当たり判定エリアの矩形は調整されません。
		 * </p>
		 */
		function get right():Boolean;
	}
}