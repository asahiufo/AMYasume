package org.ahiufomasao.yasume.timeline 
{
	
	/**
	 * <code>ITimelineDrawable</code> インターフェイスは <code>MainTimeline</code> クラスの <code>draw</code> メソッドの 
	 * <code>timelineDrawable</code> パラメータとして渡すオブジェクトによって実装されます.
	 * <p>
	 * <code>ITimelineDrawable</code> インターフェイスによって提供される各 <code>getter</code> のメソッドに
	 * 描画位置、描画スケール、描画角度、反転の有無を実装することにより、描画内容をコントロールします。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see MainTimeline#draw()
	 */
	public interface ITimelineDrawable 
	{
		/**
		 * 描画位置の <code>x</code> 座標です.
		 */
		function get drawingPositionX():Number;
		/**
		 * 描画位置の <code>y</code> 座標です.
		 */
		function get drawingPositionY():Number;
		/**
		 * <code>x</code> 軸方向の描画スケールです.
		 * <p>
		 * 1.0 は縮尺 100% と同等です。 
		 * 1.0 より小さい値である場合は縮小、1.0 より大きい値である場合は拡大して描画されます。
		 * </p>
		 */
		function get drawingScaleX():Number;
		/**
		 * <code>y</code> 軸方向の描画スケールです.
		 * <p>
		 * 1.0 は縮尺 100% と同等です。 
		 * 1.0 より小さい値である場合は縮小、1.0 より大きい値である場合は拡大して描画されます。
		 * </p>
		 */
		function get drawingScaleY():Number;
		/**
		 * 描画角度です.
		 * <p>
		 * 0 を設定すると回転せずに描画されます。
		 * 角度を増やすことで、その角度分だけ右回転して描画されます。
		 * </p>
		 */
		function get drawingRotation():Number;
		/**
		 * <code>true</code> に設定されている場合、左右反転して描画されます.
		 */
		function get drawingReversing():Boolean;
	}
}
