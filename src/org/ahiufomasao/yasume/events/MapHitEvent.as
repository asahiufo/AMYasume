package org.ahiufomasao.yasume.events 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.ahiufomasao.yasume.map.HitSetting;
	import org.ahiufomasao.yasume.map.IMapHittable;
	import org.ahiufomasao.yasume.map.MapData;
	import org.ahiufomasao.yasume.map.MapObjectsData;
	
	/**
	 * <code>MapHitEvent</code> クラスは マップとの当たり判定を行うことによって送出されます.
	 * 
	 * @author asahiufo/AM902
	 */
	public class MapHitEvent extends Event
	{
		/**
		 * <code>MapHitEvent.HIT_RIGHT</code> 定数は、
		 * <code>type</code> プロパティ（<code>hitRight</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>mapHittable</td><td>右壁へ当たりがあったオブジェクトです。</td></tr>
		 * <tr><td>hitArea</td><td>当たりがあった時の <code>mapHittable</code> の当たり判定エリアです。</td></tr>
		 * <tr><td>hitSpeed</td><td>当たりがあった時の <code>mapHittable</code> のスピードです。</td></tr>
		 * <tr><td>hitPosition</td><td>当たった右壁の <code>x</code> 座標です。</td></tr>
		 * <tr><td>adjustmentPosition</td><td>当たり後に <code>mapHittable</code> の座標を調整する基準 <code>x</code> 座標です。</td></tr>
		 * <tr><td>hitSetting</td><td>当たった右壁の当たり設定です。</td></tr>
		 * <tr><td>mapData</td><td>当たり判定に使用したマップデータです。</td></tr>
		 * <tr><td>mapObjectsData</td><td>当たり判定に使用したマップオブジェクトデータです。</td></tr>
		 * </table>
		 * 
		 * @eventType hitRight
		 */
		public static const HIT_RIGHT:String = "hitRight";
		/**
		 * <code>MapHitEvent.LEAVE_RIGHT</code> 定数は、
		 * <code>type</code> プロパティ（<code>leaveRight</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>mapHittable</td><td>右壁への当たりが無くなったオブジェクトです。</td></tr>
		 * <tr><td>hitArea</td><td>当たりが無くなった時の <code>mapHittable</code> の当たり判定エリアです。</td></tr>
		 * <tr><td>hitSpeed</td><td>0</td></tr>
		 * <tr><td>hitPosition</td><td>0</td></tr>
		 * <tr><td>adjustmentPosition</td><td>0</td></tr>
		 * <tr><td>hitSetting</td><td><code>null</code></td></tr>
		 * <tr><td>mapData</td><td>当たり判定に使用したマップデータです。</td></tr>
		 * <tr><td>mapObjectsData</td><td>当たり判定に使用したマップオブジェクトデータです。</td></tr>
		 * </table>
		 * 
		 * @eventType leaveRight
		 */
		public static const LEAVE_RIGHT:String = "leaveRight";
		
		/**
		 * <code>MapHitEvent.HIT_LEFT</code> 定数は、
		 * <code>type</code> プロパティ（<code>hitLeft</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>mapHittable</td><td>左壁へ当たりがあったオブジェクトです。</td></tr>
		 * <tr><td>hitArea</td><td>当たりがあった時の <code>mapHittable</code> の当たり判定エリアです。</td></tr>
		 * <tr><td>hitSpeed</td><td>当たりがあった時の <code>mapHittable</code> のスピードです。</td></tr>
		 * <tr><td>hitPosition</td><td>当たった左壁の <code>x</code> 座標です。</td></tr>
		 * <tr><td>adjustmentPosition</td><td>当たり後に <code>mapHittable</code> の座標を調整する基準 <code>x</code> 座標です。</td></tr>
		 * <tr><td>hitSetting</td><td>当たった左壁の当たり設定です。</td></tr>
		 * <tr><td>mapData</td><td>当たり判定に使用したマップデータです。</td></tr>
		 * <tr><td>mapObjectsData</td><td>当たり判定に使用したマップオブジェクトデータです。</td></tr>
		 * </table>
		 * 
		 * @eventType hitLeft
		 */
		public static const HIT_LEFT:String = "hitLeft";
		/**
		 * <code>MapHitEvent.LEAVE_LEFT</code> 定数は、
		 * <code>type</code> プロパティ（<code>leaveLeft</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>mapHittable</td><td>左壁への当たりが無くなったオブジェクトです。</td></tr>
		 * <tr><td>hitArea</td><td>当たりが無くなった時の <code>mapHittable</code> の当たり判定エリアです。</td></tr>
		 * <tr><td>hitSpeed</td><td>0</td></tr>
		 * <tr><td>hitPosition</td><td>0</td></tr>
		 * <tr><td>adjustmentPosition</td><td>0</td></tr>
		 * <tr><td>hitSetting</td><td><code>null</code></td></tr>
		 * <tr><td>mapData</td><td>当たり判定に使用したマップデータです。</td></tr>
		 * <tr><td>mapObjectsData</td><td>当たり判定に使用したマップオブジェクトデータです。</td></tr>
		 * </table>
		 * 
		 * @eventType leaveLeft
		 */
		public static const LEAVE_LEFT:String = "leaveLeft";
		
		/**
		 * <code>MapHitEvent.HIT_TOP</code> 定数は、
		 * <code>type</code> プロパティ（<code>hitTop</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>mapHittable</td><td>天井へ当たりがあったオブジェクトです。</td></tr>
		 * <tr><td>hitArea</td><td>当たりがあった時の <code>mapHittable</code> の当たり判定エリアです。</td></tr>
		 * <tr><td>hitSpeed</td><td>当たりがあった時の <code>mapHittable</code> のスピードです。</td></tr>
		 * <tr><td>hitPosition</td><td>当たった天井の <code>y</code> 座標です。</td></tr>
		 * <tr><td>adjustmentPosition</td><td>当たり後に <code>mapHittable</code> の座標を調整する基準 <code>y</code> 座標です。</td></tr>
		 * <tr><td>hitSetting</td><td>当たった天井の当たり設定です。</td></tr>
		 * <tr><td>mapData</td><td>当たり判定に使用したマップデータです。</td></tr>
		 * <tr><td>mapObjectsData</td><td>当たり判定に使用したマップオブジェクトデータです。</td></tr>
		 * </table>
		 * 
		 * @eventType hitTop
		 */
		public static const HIT_TOP:String = "hitTop";
		/**
		 * <code>MapHitEvent.LEAVE_TOP</code> 定数は、
		 * <code>type</code> プロパティ（<code>leaveTop</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>mapHittable</td><td>天井への当たりが無くなったオブジェクトです。</td></tr>
		 * <tr><td>hitArea</td><td>当たりが無くなった時の <code>mapHittable</code> の当たり判定エリアです。</td></tr>
		 * <tr><td>hitSpeed</td><td>0</td></tr>
		 * <tr><td>hitPosition</td><td>0</td></tr>
		 * <tr><td>adjustmentPosition</td><td>0</td></tr>
		 * <tr><td>hitSetting</td><td><code>null</code></td></tr>
		 * <tr><td>mapData</td><td>当たり判定に使用したマップデータです。</td></tr>
		 * <tr><td>mapObjectsData</td><td>当たり判定に使用したマップオブジェクトデータです。</td></tr>
		 * </table>
		 * 
		 * @eventType leaveTop
		 */
		public static const LEAVE_TOP:String = "leaveTop";
		
		/**
		 * <code>MapHitEvent.HIT_BOTTOM</code> 定数は、
		 * <code>type</code> プロパティ（<code>hitBottom</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>mapHittable</td><td>地面へ当たりがあったオブジェクトです。</td></tr>
		 * <tr><td>hitArea</td><td>当たりがあった時の <code>mapHittable</code> の当たり判定エリアです。</td></tr>
		 * <tr><td>hitSpeed</td><td>当たりがあった時の <code>mapHittable</code> のスピードです。</td></tr>
		 * <tr><td>hitPosition</td><td>当たった地面の <code>y</code> 座標です。</td></tr>
		 * <tr><td>adjustmentPosition</td><td>当たり後に <code>mapHittable</code> の座標を調整する基準 <code>y</code> 座標です。</td></tr>
		 * <tr><td>hitSetting</td><td>当たった地面の当たり設定です。</td></tr>
		 * <tr><td>mapData</td><td>当たり判定に使用したマップデータです。</td></tr>
		 * <tr><td>mapObjectsData</td><td>当たり判定に使用したマップオブジェクトデータです。</td></tr>
		 * </table>
		 * 
		 * @eventType hitBottom
		 */
		public static const HIT_BOTTOM:String = "hitBottom";
		/**
		 * <code>MapHitEvent.LEAVE_BOTTOM</code> 定数は、
		 * <code>type</code> プロパティ（<code>leaveBottom</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>mapHittable</td><td>地面への当たりが無くなったオブジェクトです。</td></tr>
		 * <tr><td>hitArea</td><td>当たりが無くなった時の <code>mapHittable</code> の当たり判定エリアです。</td></tr>
		 * <tr><td>hitSpeed</td><td>0</td></tr>
		 * <tr><td>hitPosition</td><td>0</td></tr>
		 * <tr><td>adjustmentPosition</td><td>0</td></tr>
		 * <tr><td>hitSetting</td><td><code>null</code></td></tr>
		 * <tr><td>mapData</td><td>当たり判定に使用したマップデータです。</td></tr>
		 * <tr><td>mapObjectsData</td><td>当たり判定に使用したマップオブジェクトデータです。</td></tr>
		 * </table>
		 * 
		 * @eventType leaveBottom
		 */
		public static const LEAVE_BOTTOM:String = "leaveBottom";
		
		private var _mapHittable:IMapHittable;      // 当たったオブジェクト
		private var _hitArea:Rectangle;             // 当たったエリア
		private var _hitSpeed:Number;               // 当たった時のスピード
		private var _hitPosition:Number;            // チップに接する位置
		private var _adjustmentPosition:Number;     // 当たったことによってオブジェクトの座標調整を行う目安座標
		private var _hitSetting:HitSetting;         // 当たったオブジェクトの当たり設定
		private var _mapData:MapData;               // 判定に使用したマップデータ
		private var _mapObjectsData:MapObjectsData; // 判定に使用したマップオブジェクトデータ
		
		/**
		 * 当たったオブジェクトです.
		 */
		public function get mapHittable():IMapHittable { return _mapHittable; }
		/** @private */
		public function set mapHittable(value:IMapHittable):void { _mapHittable = value; }
		/**
		 * 当たった当たり判定エリアです.
		 */
		public function get hitArea():Rectangle { return _hitArea; }
		/** @private */
		public function set hitArea(value:Rectangle):void { _hitArea = value; }
		/**
		 * 当たったスピードです.
		 */
		public function get hitSpeed():Number { return _hitSpeed; }
		/** @private */
		public function set hitSpeed(value:Number):void { _hitSpeed = value; }
		/**
		 * 当たり先の座標です.
		 */
		public function get hitPosition():Number { return _hitPosition; }
		/** @private */
		public function set hitPosition(value:Number):void { _hitPosition = value; }
		/**
		 * 当たったことによってオブジェクトの座標調整を行う目安座標です.
		 */
		public function get adjustmentPosition():Number { return _adjustmentPosition; }
		/** @private */
		public function set adjustmentPosition(value:Number):void { _adjustmentPosition = value; }
		/**
		 * 当たったオブジェクトの当たり設定です.
		 */
		public function get hitSetting():HitSetting { return _hitSetting; }
		/** @private */
		public function set hitSetting(value:HitSetting):void { 　_hitSetting = value; 　 }
		/**
		 * 判定に使用したマップデータです.
		 */
		public function get mapData():MapData { return _mapData; }
		/** @private */
		public function set mapData(value:MapData):void { _mapData = value; }
		/**
		 * 判定に使用したマップオブジェクトデータです.
		 */
		public function get mapObjectsData():MapObjectsData { return _mapObjectsData; }
		/** @private */
		public function set mapObjectsData(value:MapObjectsData):void { _mapObjectsData = value; }
		
		/**
		 * イベントリスナーにパラメータとして渡す <code>MapHitEvent</code> オブジェクトを作成します.
		 * 
		 * @param type       <code>TaskEvent.type</code> としてアクセス可能なイベントタイプです。
		 * @param bubbles    <code>TaskEvent</code> オブジェクトがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は <code>false</code> です。
		 * @param cancelable <code>TaskEvent</code> オブジェクトがキャンセル可能かどうかを判断します。デフォルト値は <code>false</code> です。
		 */
		public function MapHitEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			
			_mapHittable        = null;
			_hitArea            = null;
			_hitSpeed           = 0;
			_hitPosition        = 0;
			_adjustmentPosition = 0;
			_hitSetting         = null;
			_mapData            = null;
			_mapObjectsData     = null;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event 
		{
			var event:MapHitEvent    = new MapHitEvent(type, bubbles, cancelable);
			event.mapHittable        = _mapHittable;
			event.hitArea            = _hitArea;
			event.hitSpeed           = _hitSpeed;
			event.hitPosition        = _hitPosition;
			event.adjustmentPosition = _adjustmentPosition;
			event.hitSetting         = _hitSetting;
			event.mapData            = _mapData;
			event.mapObjectsData     = _mapObjectsData;
			return event;
		} 
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String 
		{
			return formatToString("MapHitEvent", "type", "bubbles", "cancelable", _mapHittable, _hitArea, _hitSpeed, _hitPosition, _adjustmentPosition, _hitSetting, _mapData, _mapObjectsData, "eventPhase"); 
		}
	}
}
