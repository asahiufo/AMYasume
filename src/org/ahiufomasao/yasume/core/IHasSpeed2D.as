package org.ahiufomasao.yasume.core 
{
	
	/**
	 * <code>IHasSpeed2D</code> はスピードを持つ 2D オブジェクトによって実装されます.
	 * 
	 * @author asahiufo/AM902
	 */
	public interface IHasSpeed2D 
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
	}
}