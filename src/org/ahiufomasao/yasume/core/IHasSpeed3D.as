package org.ahiufomasao.yasume.core 
{
	
	/**
	 * <code>IHasSpeed3D</code> はスピードを持つ 3D オブジェクトによって実装されます.
	 * 
	 * @author asahiufo/AM902
	 */
	public interface IHasSpeed3D 
	{
		/**
		 * <code>x</code> 軸方向のスピードです.
		 */
		function get xSpeed():Number;
		/** @private */
		function set xSpeed(value:Number):void;
		
		/**
		 * <code>y</code> 軸方向のスピードです.
		 */
		function get ySpeed():Number;
		/** @private */
		function set ySpeed(value:Number):void;
		
		/**
		 * <code>z</code> 軸方向のスピードです.
		 */
		function get zSpeed():Number;
		/** @private */
		function set zSpeed(value:Number):void;
	}
}