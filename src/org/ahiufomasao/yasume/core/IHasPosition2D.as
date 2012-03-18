package org.ahiufomasao.yasume.core 
{
	
	/**
	 * <code>IHasPosition2D</code> は座標情報を持つ 2D オブジェクトによって実装されます.
	 * 
	 * @author asahiufo/AM902
	 */
	public interface IHasPosition2D 
	{
		/**
		 * オブジェクトの x 座標です.
		 */
		function get x():Number;
		/** @private */
		function set x(value:Number):void;
		
		/**
		 * オブジェクトの y 座標です.
		 */
		function get y():Number;
		/** @private */
		function set y(value:Number):void;
	}
}
