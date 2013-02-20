package org.ahiufomasao.yasume.events 
{
	import flash.events.Event;
	
	/**
	 * <code>StatusManagerEvent</code> クラスは <code>StatusManager</code>　クラスを操作することによって送出されます.
	 * 
	 * @author asahiufo/AM902
	 * @see StatusManager
	 */
	public class StatusManagerEvent extends Event 
	{
		/**
		 * <code>StatusManagerEvent.CHANGE_STATUS_BEFORE</code> 定数は、
		 * <code>type</code> プロパティ（<code>changeStatusBefore</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>StatusManagerEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>StatusManager</code> オブジェクトです。</td></tr>
		 * <tr><td>status</td><td>ステータスです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType changeStatusBefore
		 */
		public static const CHANGE_STATUS_BEFORE:String = "changeStatusBefore";
		/**
		 * <code>StatusManagerEvent.CHANGE_STATUS_AFTER</code> 定数は、
		 * <code>type</code> プロパティ（<code>changeStatusAfter</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>StatusManagerEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>StatusManager</code> オブジェクトです。</td></tr>
		 * <tr><td>status</td><td>ステータスです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType changeStatusAfter
		 */
		public static const CHANGE_STATUS_AFTER:String = "changeStatusAfter";
		
		private var _status:String;  // ステータス
		private var _context:Object; // コンテキスト
		
		/**
		 * ステータスです.
		 */
		public function get status():String { return _status; }
		/** @private */
		public function set status(value:String):void { _status = value; }
		
		/**
		 * 実行コンテキストです.
		 */
		public function get context():Object { return _context; }
		/** @private */
		public function set context(value:Object):void { _context = value; }
		
		/**
		 * イベントリスナーにパラメータとして渡す <code>StatusManagerEvent</code> オブジェクトを作成します.
		 * 
		 * @param type       <code>StatusManagerEvent.type</code> としてアクセス可能なイベントタイプです。
		 * @param bubbles    <code>StatusManagerEvent</code> オブジェクトがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は <code>false</code> です。
		 * @param cancelable <code>StatusManagerEvent</code> オブジェクトがキャンセル可能かどうかを判断します。デフォルト値は <code>false</code> です。
		 */
		public function StatusManagerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			
			_status  = "";
			_context = null;
		}
		
		/**
		 * <code>StatusManagerEvent</code> オブジェクトのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します.
		 * 
		 * @return 元のオブジェクトと同じプロパティ値を含む新しい <code>StatusManagerEvent</code> オブジェクトです。
		 */
		public override function clone():Event 
		{ 
			var event:StatusManagerEvent = new StatusManagerEvent(type, bubbles, cancelable);
			event.status  = _status;
			event.context = _context;
			return event;
		} 
		
		/**
		 * <code>StatusManagerEvent</code> オブジェクトのすべてのプロパティを含むストリングを返します.
		 * <p>
		 * ストリングは次の形式です。
		 * </p>
		 * <p>
		 * <code>[StatusManagerEvent type=<em>value</em> bubbles=<em>value</em> cancelable=<em>value</em> eventPhase=<em>value</em> status=<em>value</em> context=<em>value</em>]</code>
		 * </p>
		 * 
		 * @return <code>StatusManagerEvent</code> オブジェクトのすべてのプロパティを含むストリングです。
		 */
		public override function toString():String 
		{ 
			return formatToString("StatusManagerEvent", "type", "bubbles", "cancelable", "eventPhase", "status", "context"); 
		}
	}
}
