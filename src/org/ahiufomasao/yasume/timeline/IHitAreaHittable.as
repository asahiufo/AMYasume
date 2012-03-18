package org.ahiufomasao.yasume.timeline 
{
	import flash.events.IEventDispatcher;
	import org.ahiufomasao.yasume.core.IHasPosition2D;
	
	/**
	 * <code>HitAreaHitTester</code> オブジェクトの <code>addDefaultHitEventListener</code> メソッドを呼び出した後、
	 * <code>testPush</code> メソッドを呼び出した際、押し当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.HitAreaHitEvent.PUSH
	 * 
	 * @see HitAreaHitTester#testPush()
	 */
	[Event(name="push", type="org.ahiufomasao.yasume.events.HitAreaHitEvent")]
	/**
	 * <code>HitAreaHitTester</code> オブジェクトの <code>addDefaultHitEventListener</code> メソッドを呼び出した後、
	 * <code>testAttackHit</code> メソッドを呼び出した際、攻撃側で攻撃当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.HitAreaHitEvent.ATTACK_HIT
	 * 
	 * @see HitAreaHitTester#testAttackHit()
	 */
	[Event(name="attackHit", type="org.ahiufomasao.yasume.events.HitAreaHitEvent")]
	/**
	 * <code>HitAreaHitTester</code> オブジェクトの <code>addDefaultHitEventListener</code> メソッドを呼び出した後、
	 * <code>testAttackHit</code> メソッドを呼び出した際、攻撃を受ける側で攻撃当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.HitAreaHitEvent.DAMAGED
	 * 
	 * @see HitAreaHitTester#testAttackHit()
	 */
	[Event(name="damaged", type="org.ahiufomasao.yasume.events.HitAreaHitEvent")]
	/**
	 * <code>HitAreaHitTester</code> オブジェクトの <code>addDefaultHitEventListener</code> メソッドを呼び出した後、
	 * <code>testAttackHit</code> メソッドを呼び出した際、攻撃相殺が発生した場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.HitAreaHitEvent.COUNTERBALANCE
	 * 
	 * @see HitAreaHitTester#testAttackHit()
	 */
	[Event(name="counterbalance", type="org.ahiufomasao.yasume.events.HitAreaHitEvent")]
	
	/**
	 * <code>IHitAreaHittable</code> インターフェイスは <code>HitAreaHitTester</code> クラスによって
	 * 当たり判定処理を行うオブジェクトによって実装されます.
	 * <p>
	 * <code>HitAreaHitTester</code> クラスは <code>IHitAreaHittable</code> インターフェイスによって提供される
	 * 各 <code>getter</code> のメソッドを基に当たり判定を行います。
	 * </p>
	 * <p>
	 * <code>IHitAreaHittable</code> インターフェイスを実装した場合、<code>EventDispatcher</code> クラスの継承等により、 
	 * <code>IEventDispatcher</code> インターフェイスによって提供されるメソッドを実装してください。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see HitAreaHitTester
	 */
	public interface IHitAreaHittable extends IHasPosition2D, IEventDispatcher
	{
		/**
		 * 当たり判定処理に使用する押し当たり判定エリアです.
		 */
		function get pushHitArea():PushHitArea;
		/**
		 * 当たり判定処理に使用する攻撃当たり判定エリアです.
		 */
		function get attackHitArea():AttackHitArea;
		/**
		 * 当たり判定処理に使用するダメージ当たり判定エリアです.
		 */
		function get damageHitArea():DamageHitArea;
		
		/**
		 * <code>true</code> が設定されている場合は、当たり判定を行うオブジェクトが右を向いているものとして扱います.
		 * <p>
		 * <code>HitAreaHitTester</code> クラスは
		 * <code>true</code> が設定されている場合は判定対象オブジェクトが右を向いているものとして、
		 * 当たり判定エリアの矩形を特に調整せずに当たり判定処理を行います。
		 * <code>false</code> が設定されている場合は判定対象オブジェクトが左を向いているものとして、
		 * 当たり判定エリアの矩形を左右反転して当たり判定処理を行います。
		 * </p>
		 */
		function get right():Boolean;
	}
}
