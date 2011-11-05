package org.ahiufomasao.yasume.core 
{
	
	/**
	 * <code>IHasPosition</code> は座標情報を持つオブジェクトによって実装されます.
	 * 
	 * @author asahiufo/AM902
	 */
	public interface IHasPosition 
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
