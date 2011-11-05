package org.ahiufomasao.yasume.map 
{
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import org.ahiufomasao.yasume.core.IHasPosition;
	import org.ahiufomasao.yasume.core.IHasSpeed;
	
	/**
	 * 右にある壁に当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.HIT_RIGHT
	 */
	[Event(name="hitRight", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	/**
	 * 左にある壁に当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.HIT_LEFT
	 */
	[Event(name="hitLeft", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	/**
	 * 天井に当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.HIT_TOP
	 */
	[Event(name="hitTop", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	/**
	 * 地面に当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.HIT_BOTTOM
	 */
	[Event(name="hitBottom", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	
	/**
	 * 右にある壁に前回当たりがあったが、今回当たりが無くなった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.LEAVE_RIGHT
	 */
	[Event(name="leaveRight", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	/**
	 * 左にある壁に前回当たりがあったが、今回当たりが無くなった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.LEAVE_LEFT
	 */
	[Event(name="leaveLeft", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	/**
	 * 天井に前回当たりがあったが、今回当たりが無くなった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.LEAVE_TOP
	 */
	[Event(name="leaveTop", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	/**
	 * 地面に前回当たりがあったが、今回当たりが無くなった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.LEAVE_BOTTOM
	 */
	[Event(name="leaveBottom", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	
	/**
	 * <code>IMapHittable</code> インターフェイスは <code>MapHitTester</code> クラスによって
	 * 当たり判定処理を行うオブジェクトによって実装されます.
	 * <p>
	 * <code>MapHitTester</code> クラスは <code>IMapHittable</code> インターフェイスによって提供される各 getter メソッドをもとに当たり判定を行い、
	 * 当たり判定があった場合に各 setter メソッドより当たり判定オブジェクトのプロパティを編集します。
	 * </p>
	 * <p>
	 * <code>IMapHittable</code> インターフェイスを実装した場合、<code>EventDispatcher</code> クラスの継承等により、
	 * <code>IEventDispatcher</code> インターフェイスによって提供されるメソッドを実装してください。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see MapHitTester
	 */
	public interface IMapHittable extends IHasPosition, IHasSpeed, IEventDispatcher
	{
		/**
		 * 判定するステージ当たり判定エリアを表す矩形です.
		 */
		function get stageHitArea():Rectangle;
		
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
		
		/**
		 * 判定に使用する当たり判定データのレイヤー番号です.
		 * <p>
		 * 1 件目のレイヤーは 0、2 件目のレイヤーは 1、・・・として指定します。
		 * </p>
		 */
		function get testTargetMapLayerIndex():uint;
		
		/**
		 * 判定保管数です.
		 * <p>
		 * 高速で移動するオブジェクトの当たり判定を正確に行うため、移動前後の座標の間でも当たり判定を行うことができます。
		 * この移動前後の座標の間で何回当たり判定を行うかを設定します。
		 * </p>
		 * <p>
		 * 0なら補完して当たり判定は行いません。
		 * </p>
		 */
		function get testComplement():uint;
		
		/**
		 * 右壁すり抜け操作状態であるなら <code>true</code> です.
		 */
		function get throughRight():Boolean;
		/**
		 * 左壁すり抜け操作状態であるなら <code>true</code> です.
		 */
		function get throughLeft():Boolean;
		/**
		 * 天井すり抜け操作状態であるなら <code>true</code> です.
		 */
		function get throughTop():Boolean;
		/**
		 * 床すり抜け操作状態であるなら <code>true</code> です.
		 */
		function get throughDown():Boolean;
		
		/**
		 * 当たり判定を行うオブジェクトにとっての天井に対して当たり判定があった場合、
		 * <code>MapHitTester</code> オブジェクトによって <code>true</code> が渡されます.
		 * <p>
		 * 天井に対する当たり判定が無い場合は <code>MapHitTester</code> オブジェクトによって <code>false</code> が設定されます。
		 * </p>
		 * 
		 * @see MapHitTester
		 */
		function get topHit():Boolean;
		/** @private */
		function set topHit(value:Boolean):void;
		
		/**
		 * 当たり判定を行うオブジェクトにとっての地面に対して当たり判定があった場合、
		 * <code>MapHitTester</code> オブジェクトによって <code>true</code> が渡されます.
		 * <p>
		 * 天井に対する当たり判定が無い場合は <code>MapHitTester</code> オブジェクトによって <code>false</code> が設定されます。
		 * </p>
		 * 
		 * @see MapHitTester
		 */
		function get bottomHit():Boolean;
		/** @private */
		function set bottomHit(value:Boolean):void;
		
		/**
		 * 当たり判定を行うオブジェクトにとっての右にある壁に対して当たり判定があった場合、
		 * <code>MapHitTester</code> オブジェクトによって <code>true</code> が渡されます.
		 * <p>
		 * 天井に対する当たり判定が無い場合は <code>MapHitTester</code> オブジェクトによって <code>false</code> が設定されます。
		 * </p>
		 * 
		 * @see MapHitTester
		 */
		function get rightHit():Boolean;
		/** @private */
		function set rightHit(value:Boolean):void;
		
		/**
		 * 当たり判定を行うオブジェクトにとっての左にある壁に対して当たり判定があった場合、
		 * <code>MapHitTester</code> オブジェクトによって <code>true</code> が渡されます.
		 * <p>
		 * 天井に対する当たり判定が無い場合は <code>MapHitTester</code> オブジェクトによって <code>false</code> が設定されます。
		 * </p>
		 * 
		 * @see MapHitTester
		 */
		function get leftHit():Boolean;
		/** @private */
		function set leftHit(value:Boolean):void;
	}
	
}
