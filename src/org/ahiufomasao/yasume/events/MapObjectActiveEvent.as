package org.ahiufomasao.yasume.events 
{
	import flash.events.Event;
	
	/**
	 * マップオブジェクト有効イベント
	 */
	public class MapObjectActiveEvent extends Event 
	{
		/**
		 * <code>MapObjectActiveEvent.CHANGE_ACTIVE</code> 定数は、
		 * <code>type</code> プロパティ（<code>changeActive</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>x</td><td>有効になった際にマップオブジェクトを移動させる <code>x</code> 座標です。</td></tr>
		 * <tr><td>y</td><td>有効になった際にマップオブジェクトを移動させる <code>y</code> 座標です。</td></tr>
		 * </table>
		 * 
		 * @eventType changeActive
		 */
		public static const CHANGE_ACTIVE:String = "changeActive";
		/**
		 * <code>MapObjectActiveEvent.CHANGE_INACTIVE</code> 定数は、
		 * <code>type</code> プロパティ（<code>changeInactive</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>x</td><td>無効になった際にマップオブジェクトを移動させる <code>x</code> 座標です。</td></tr>
		 * <tr><td>y</td><td>無効になった際にマップオブジェクトを移動させる <code>y</code> 座標です。</td></tr>
		 * </table>
		 * 
		 * @eventType changeInactive
		 */
		public static const CHANGE_INACTIVE:String = "changeInactive";
		
		/**
		 * <code>MapObjectActiveEvent.ACTIVE</code> 定数は、
		 * <code>type</code> プロパティ（<code>active</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>x</td><td>0</td></tr>
		 * <tr><td>y</td><td>0</td></tr>
		 * </table>
		 * 
		 * @eventType active
		 */
		public static const ACTIVE:String = "active";
		/**
		 * <code>MapObjectActiveEvent.INACTIVE</code> 定数は、
		 * <code>type</code> プロパティ（<code>inactive</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>x</td><td>0</td></tr>
		 * <tr><td>y</td><td>0</td></tr>
		 * </table>
		 * 
		 * @eventType inactive
		 */
		public static const INACTIVE:String = "inactive";
		
		private var _x:Number; // 有効、無効になった際にマップオブジェクトを移動させる x 座標
		private var _y:Number; // 有効、無効になった際にマップオブジェクトを移動させる y 座標
		
		/**
		 * 有効、無効になった際にマップオブジェクトを移動させる <code>x</code> 座標です.
		 */
		public function get x():Number { return _x; }
		/** @private */
		public function set x(value:Number):void { _x = value; }
		
		/**
		 * 有効、無効になった際にマップオブジェクトを移動させる <code>y</code> 座標です.
		 */
		public function get y():Number { return _y; }
		/** @private */
		public function set y(value:Number):void { _y = value; }
		
		/**
		 * イベントリスナーにパラメータとして渡す <code>MapObjectActiveEvent</code> オブジェクトを作成します.
		 * 
		 * @param type       <code>TaskEvent.type</code> としてアクセス可能なイベントタイプです。
		 * @param bubbles    <code>TaskEvent</code> オブジェクトがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は <code>false</code> です。
		 * @param cancelable <code>TaskEvent</code> オブジェクトがキャンセル可能かどうかを判断します。デフォルト値は <code>false</code> です。
		 */
		public function MapObjectActiveEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			
			_x = 0;
			_y = 0;
		} 
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event 
		{ 
			var event:MapObjectActiveEvent = new MapObjectActiveEvent(type, bubbles, cancelable);
			event.x = _x;
			event.y = _y;
			return event;
		} 
		
		/**
		 * @inheritDoc
		 */
		public override function toString():String 
		{ 
			return formatToString("MapObjectEvent", "type", "bubbles", "cancelable", _x, _y, "eventPhase"); 
		}
	}
}
