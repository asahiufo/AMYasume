package org.ahiufomasao.yasume.events 
{
	import flash.events.Event;
	
	/**
	 * <code>TaskEvent</code> クラスは <code>Task</code>　クラスを操作することによって送出されます.
	 * 
	 * @author asahiufo/AM902
	 * @see Task
	 */
	public class TaskEvent extends Event 
	{
		/**
		 * <code>TaskEvent.CHANGE_EXEC_BEFORE</code> 定数は、
		 * <code>type</code> プロパティ（<code>changeExecBefore</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TaskEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>Task</code> オブジェクトです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType changeExecBefore
		 */
		public static const CHANGE_EXEC_BEFORE:String = "changeExecBefore";
		/**
		 * <code>TaskEvent.CHANGE_EXEC_AFTER</code> 定数は、
		 * <code>type</code> プロパティ（<code>changeExecAfter</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TaskEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>Task</code> オブジェクトです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType changeExecAfter
		 */
		public static const CHANGE_EXEC_AFTER:String = "changeExecAfter";
		/**
		 * <code>TaskEvent.CHANGE_DRAW_BEFORE</code> 定数は、
		 * <code>type</code> プロパティ（<code>changeDrawBefore</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TaskEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>Task</code> オブジェクトです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType changeDrawBefore
		 */
		public static const CHANGE_DRAW_BEFORE:String = "changeDrawBefore";
		/**
		 * <code>TaskEvent.CHANGE_DRAW_AFTER</code> 定数は、
		 * <code>type</code> プロパティ（<code>changeDrawAfter</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TaskEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>Task</code> オブジェクトです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType changeDrawAfter
		 */
		public static const CHANGE_DRAW_AFTER:String = "changeDrawAfter";
		/**
		 * <code>TaskEvent.ADDED_BEFORE</code> 定数は、
		 * <code>type</code> プロパティ（<code>addedBefore</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TaskEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>Task</code> オブジェクトです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType addedBefore
		 */
		public static const ADDED_BEFORE:String = "addedBefore";
		/**
		 * <code>TaskEvent.ADDED_AFTER</code> 定数は、
		 * <code>type</code> プロパティ（<code>addedAfter</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TaskEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>Task</code> オブジェクトです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType addedAfter
		 */
		public static const ADDED_AFTER:String = "addedAfter";
		/**
		 * <code>TaskEvent.REMOVED_BEFORE</code> 定数は、
		 * <code>type</code> プロパティ（<code>removedBefore</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TaskEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>Task</code> オブジェクトです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType removedBefore
		 */
		public static const REMOVED_BEFORE:String = "removedBefore";
		/**
		 * <code>TaskEvent.REMOVED_AFTER</code> 定数は、
		 * <code>type</code> プロパティ（<code>removedAfter</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TaskEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>Task</code> オブジェクトです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType removedAfter
		 */
		public static const REMOVED_AFTER:String = "removedAfter";
		/**
		 * <code>TaskEvent.EXEC_BEFORE</code> 定数は、
		 * <code>type</code> プロパティ（<code>execBefore</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TaskEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>Task</code> オブジェクトです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType execBefore
		 */
		public static const EXEC_BEFORE:String = "execBefore";
		/**
		 * <code>TaskEvent.EXEC_AFTER</code> 定数は、
		 * <code>type</code> プロパティ（<code>execAfter</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TaskEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>Task</code> オブジェクトです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType execAfter
		 */
		public static const EXEC_AFTER:String = "execAfter";
		/**
		 * <code>TaskEvent.DRAW_BEFORE</code> 定数は、
		 * <code>type</code> プロパティ（<code>drawBefore</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TaskEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>Task</code> オブジェクトです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType drawBefore
		 */
		public static const DRAW_BEFORE:String = "drawBefore";
		/**
		 * <code>TaskEvent.DRAW_AFTER</code> 定数は、
		 * <code>type</code> プロパティ（<code>drawAfter</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TaskEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元の <code>Task</code> オブジェクトです。</td></tr>
		 * <tr><td>context</td><td>実行コンテキストです。</td></tr>
		 * </table>
		 * 
		 * @eventType drawAfter
		 */
		public static const DRAW_AFTER:String = "drawAfter";
		
		private var _context:Object; // コンテキスト
		
		/**
		 * 実行コンテキストです.
		 */
		public function get context():Object { return _context; }
		/** @private */
		public function set context(value:Object):void { _context = value; }
		
		/**
		 * イベントリスナーにパラメータとして渡す <code>TaskEvent</code> オブジェクトを作成します.
		 * 
		 * @param type       <code>TaskEvent.type</code> としてアクセス可能なイベントタイプです。
		 * @param bubbles    <code>TaskEvent</code> オブジェクトがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は <code>false</code> です。
		 * @param cancelable <code>TaskEvent</code> オブジェクトがキャンセル可能かどうかを判断します。デフォルト値は <code>false</code> です。
		 */
		public function TaskEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			
			_context  = null;
		}
		
		/**
		 * <code>TaskEvent</code> オブジェクトのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します.
		 * 
		 * @return 元のオブジェクトと同じプロパティ値を含む新しい <code>TaskEvent</code> オブジェクトです。
		 */
		public override function clone():Event 
		{ 
			var event:TaskEvent = new TaskEvent(type, bubbles, cancelable);
			event.context = _context;
			return event;
		} 
		
		/**
		 * <code>TaskEvent</code> オブジェクトのすべてのプロパティを含むストリングを返します.
		 * <p>
		 * ストリングは次の形式です。
		 * </p>
		 * <p>
		 * <code>[TaskEvent type=<em>value</em> bubbles=<em>value</em> cancelable=<em>value</em> eventPhase=<em>value</em> context=<em>value</em>]</code>
		 * </p>
		 * 
		 * @return <code>TaskEvent</code> オブジェクトのすべてのプロパティを含むストリングです。
		 */
		public override function toString():String 
		{ 
			return formatToString("TaskEvent", "type", "bubbles", "cancelable", "eventPhase", "context"); 
		}
	}
}
