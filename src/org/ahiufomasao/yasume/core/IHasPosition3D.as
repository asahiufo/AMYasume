package org.ahiufomasao.yasume.core 
{
	
	/**
	 * <code>IHasPosition3D</code> は座標情報を持つ 3D オブジェクトによって実装されます.
	 * 
	 * @author asahiufo/AM902
	 */
	public interface IHasPosition3D 
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
		
		/**
		 * オブジェクトの z 座標です.
		 */
		function get z():Number;
		/** @private */
		function set z(value:Number):void;
	}
}
