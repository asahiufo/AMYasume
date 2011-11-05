package org.ahiufomasao.yasume.events
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.ahiufomasao.yasume.timeline.IHitAreaHittable;
	import org.ahiufomasao.yasume.utils.HitDirection;
	
	/**
	 * <code>HitAreaHitEvent</code> クラスは <code>HitAreaHitTester</code> クラスによって当たり判定を行うことによって送出されます.
	 * 
	 * @author asahiufo/AM902
	 * @see HitAreaHitTester
	 */
	public class HitAreaHitEvent extends Event 
	{
		/**
		 * <code>HitAreaHitEvent.PUSH</code> 定数は、
		 * <code>type</code> プロパティ（<code>push</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>HitAreaHitEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元のオブジェクトです。</td></tr>
		 * <tr><td>sourceHitTestable</td><td>イベントの発生元 <code>IHitAreaHittable</code> オブジェクトです。</td></tr>
		 * <tr><td>sourceHitArea</td><td><code>sourceHitTestable</code> プロパティが指すオブジェクトの、イベントが発生した時点の <code>pushHitArea</code> プロパティです。</td></tr>
		 * <tr><td>targetHitTestable</td><td>イベントの発生元オブジェクトが押した <code>IHitAreaHittable</code> オブジェクトです。</td></tr>
		 * <tr><td>targetHitArea</td><td><code>targetHitArea</code> プロパティが指すオブジェクトの、イベントが発生した時点の <code>pushHitArea</code> プロパティです。</td></tr>
		 * <tr><td>hitDirection</td><td><code>sourceHitTestable</code> プロパティのオブジェクトから見て、<code>targetHitTestable</code> プロパティのオブジェクトがどの方向から当たったかの情報です。例えばイベントが発生した時、<code>sourceHitArea</code> の右辺に <code>targetHitArea</code> が存在する場合、<code>hitDirection</code> プロパティには <code>HitDirection.RIGHT</code> が設定されます。</td></tr>
		 * <tr><td>hitPartArea</td><td><code>sourceHitArea</code> プロパティと <code>targetHitArea</code> プロパティ双方の当たり判定エリアが重なっている範囲の矩形情報です。</td></tr>
		 * </table>
		 * 
		 * @eventType push
		 */
		public static const PUSH:String = "push";
		/**
		 * <code>HitAreaHitEvent.ATTACK_HIT</code> 定数は、
		 * <code>type</code> プロパティ（<code>attackHit</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>HitAreaHitEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元のオブジェクトです。</td></tr>
		 * <tr><td>sourceHitTestable</td><td>攻撃を行っている側の <code>IHitAreaHittable</code> オブジェクトです。</td></tr>
		 * <tr><td>sourceHitArea</td><td><code>sourceHitTestable</code> プロパティが指すオブジェクトの、イベントが発生した時点の <code>attackHitArea</code> プロパティです。</td></tr>
		 * <tr><td>targetHitTestable</td><td>攻撃を受ける側の <code>IHitAreaHittable</code> オブジェクトです。</td></tr>
		 * <tr><td>targetHitArea</td><td><code>targetHitArea</code> プロパティが指すオブジェクトの、イベントが発生した時点の <code>damageHitArea</code> プロパティです。</td></tr>
		 * <tr><td>hitDirection</td><td><code>sourceHitTestable</code> プロパティのオブジェクトが、どの方向へ攻撃したことによって <code>targetHitTestable</code> プロパティのオブジェクトへ当たったかの情報です。例えばイベントが発生した時、<code>sourceHitArea</code> の右辺に <code>targetHitArea</code> が存在する場合、<code>hitDirection</code> プロパティには <code>HitDirection.RIGHT</code> が設定されます。</td></tr>
		 * <tr><td>hitPartArea</td><td><code>sourceHitArea</code> プロパティと <code>targetHitArea</code> プロパティ双方の当たり判定エリアが重なっている範囲の矩形情報です。</td></tr>
		 * </table>
		 * 
		 * @eventType attackHit
		 */
		public static const ATTACK_HIT:String = "attackHit";
		/**
		 * <code>HitAreaHitEvent.DAMAGED</code> 定数は、
		 * <code>type</code> プロパティ（<code>damaged</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>HitAreaHitEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元のオブジェクトです。</td></tr>
		 * <tr><td>sourceHitTestable</td><td>攻撃を行っている側の <code>IHitAreaHittable</code> オブジェクトです。</td></tr>
		 * <tr><td>sourceHitArea</td><td><code>sourceHitTestable</code> プロパティが指すオブジェクトの、イベントが発生した時点の <code>attackHitArea</code> プロパティです。</td></tr>
		 * <tr><td>targetHitTestable</td><td>攻撃を受ける側の <code>IHitAreaHittable</code> オブジェクトです。</td></tr>
		 * <tr><td>targetHitArea</td><td><code>targetHitArea</code> プロパティが指すオブジェクトの、イベントが発生した時点の <code>damageHitArea</code> プロパティです。</td></tr>
		 * <tr><td>hitDirection</td><td><code>targetHitTestable</code> プロパティのオブジェクトが、<code>sourceHitTestable</code> プロパティのオブジェクトから攻撃された方向の情報です。例えばイベントが発生した時、<code>targetHitArea</code> の右辺に <code>sourceHitArea</code> が存在する場合、<code>hitDirection</code> プロパティには <code>HitDirection.RIGHT</code> が設定されます。</td></tr>
		 * <tr><td>hitPartArea</td><td><code>sourceHitArea</code> プロパティと <code>targetHitArea</code> プロパティ双方の当たり判定エリアが重なっている範囲の矩形情報です。</td></tr>
		 * </table>
		 * 
		 * @eventType damaged
		 */
		public static const DAMAGED:String = "damaged";
		/**
		 * <code>HitAreaHitEvent.COUNTERBALANCE</code> 定数は、
		 * <code>type</code> プロパティ（<code>counterbalance</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>HitAreaHitEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元のオブジェクトです。</td></tr>
		 * <tr><td>sourceHitTestable</td><td>イベントの発生元 <code>IHitAreaHittable</code> オブジェクトです。</td></tr>
		 * <tr><td>sourceHitArea</td><td><code>sourceHitTestable</code> プロパティが指すオブジェクトの、イベントが発生した時点の <code>attackHitArea</code> プロパティです。</td></tr>
		 * <tr><td>targetHitTestable</td><td>イベントの発生元オブジェクトが攻撃した <code>IHitAreaHittable</code> オブジェクトです。</td></tr>
		 * <tr><td>targetHitArea</td><td><code>targetHitArea</code> プロパティが指すオブジェクトの、イベントが発生した時点の <code>attackHitArea</code> プロパティです。</td></tr>
		 * <tr><td>hitDirection</td><td><code>sourceHitTestable</code> プロパティのオブジェクトから見て、<code>targetHitTestable</code> プロパティのオブジェクトがどの方向から当たったかの情報です。例えばイベントが発生した時、<code>sourceHitArea</code> の右辺に <code>targetHitArea</code> が存在する場合、<code>hitDirection</code> プロパティには <code>HitDirection.RIGHT</code> が設定されます。</td></tr>
		 * <tr><td>hitPartArea</td><td><code>sourceHitArea</code> プロパティと <code>targetHitArea</code> プロパティ双方の当たり判定エリアが重なっている範囲の矩形情報です。</td></tr>
		 * </table>
		 * 
		 * @eventType counterbalance
		 */
		public static const COUNTERBALANCE:String = "counterbalance";
		
		private var _sourceHitTestable:IHitAreaHittable; // 押し、攻撃元のオブジェクト
		private var _sourceHitArea:Object;               // 押し、攻撃元の当たり判定エリア
		private var _targetHitTestable:IHitAreaHittable; // 受け側のオブジェクト
		private var _targetHitArea:Object;               // 受け側の当たり判定エリア
		
		private var _hitDirection:HitDirection; // どの方向から当たったか
		private var _hitPartArea:Rectangle;     // エリア同士の重なっている部分の範囲
		
		/**
		 * 押し、攻撃元のオブジェクトです.
		 */
		public function get sourceHitTestable():IHitAreaHittable { return _sourceHitTestable; }
		/** @private */
		public function set sourceHitTestable(value:IHitAreaHittable):void { _sourceHitTestable = value; }
		/**
		 * 押し、攻撃元オブジェクトの当たり判定エリアです.
		 */
		public function get sourceHitArea():Object { return _sourceHitArea; }
		/** @private */
		public function set sourceHitArea(value:Object):void { _sourceHitArea = value; }
		/**
		 * 受け側のオブジェクトです.
		 */
		public function get targetHitTestable():IHitAreaHittable { return _targetHitTestable; }
		/** @private */
		public function set targetHitTestable(value:IHitAreaHittable):void { _targetHitTestable = value; }
		/**
		 * 受け側オブジェクトの当たり判定エリアです.
		 */
		public function get targetHitArea():Object { return _targetHitArea; }
		/** @private */
		public function set targetHitArea(value:Object):void { _targetHitArea = value; }
		
		/**
		 * どの方向に当たったかの情報です.
		 */
		public function get hitDirection():HitDirection { return _hitDirection; }
		/** @private */
		public function set hitDirection(value:HitDirection):void { _hitDirection = value; }
		/**
		 * 当たり判定エリア同士の重なっている範囲の矩形です.
		 */
		public function get hitPartArea():Rectangle { return _hitPartArea; }
		/** @private */
		public function set hitPartArea(value:Rectangle):void { _hitPartArea = value; }
		
		/**
		 * イベントリスナーにパラメータとして渡す <code>HitAreaHitEvent</code> オブジェクトを作成します.
		 * 
		 * @param type       Event.type としてアクセス可能なイベントタイプです。
		 * @param bubbles    Event オブジェクトがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。
		 * @param cancelable Event オブジェクトがキャンセル可能かどうかを判断します。デフォルト値は false です。
		 */
		public function HitAreaHitEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event 
		{
			var event:HitAreaHitEvent = new HitAreaHitEvent(type, bubbles, cancelable);
			event.sourceHitTestable = _sourceHitTestable;
			event.sourceHitArea     = _sourceHitArea;
			event.targetHitTestable = _targetHitTestable;
			event.targetHitArea     = _targetHitArea;
			event.hitDirection      = _hitDirection;
			event.hitPartArea       = _hitPartArea;
			return event;
		} 
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String 
		{
			return formatToString("HitAreaHitEvent", "type", "bubbles", "cancelable", _sourceHitTestable, _sourceHitArea, _targetHitTestable, _targetHitArea, _hitDirection, _hitPartArea, "eventPhase"); 
		}
	}
}
