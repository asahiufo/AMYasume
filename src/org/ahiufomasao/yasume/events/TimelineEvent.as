package org.ahiufomasao.yasume.events 
{
	import flash.events.Event;
	
	/**
	 * <code>TimelineEvent</code> クラスは <code>MainTimeline</code> クラスを操作することによって送出されます.
	 * 
	 * @author asahiufo@AM902
	 * @see MainTimeline
	 */
	public class TimelineEvent extends Event 
	{
		/**
		 * <code>TimelineEvent.CHANGE_FRAME_BEFORE</code> 定数は、
		 * <code>type</code> プロパティ（<code>changeFrameBefore</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TimelineEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元のオブジェクトです。</td></tr>
		 * </table>
		 * 
		 * @eventType changeFrameBefore
		 */
		public static const CHANGE_FRAME_BEFORE:String = "changeFrameBefore";
		/**
		 * <code>TimelineEvent.CHANGE_FRAME_AFTER</code> 定数は、
		 * <code>type</code> プロパティ（<code>changeFrameAfter</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TimelineEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元のオブジェクトです。</td></tr>
		 * </table>
		 * 
		 * @eventType changeFrameAfter
		 */
		public static const CHANGE_FRAME_AFTER:String = "changeFrameAfter";
		/**
		 * <code>TimelineEvent.ANIMATION_END</code> 定数は、
		 * <code>type</code> プロパティ（<code>animationEnd</code> イベントオブジェクト）の値を定義します.
		 * <table class="innertable">
		 * <tr><th>プロパティ</th><th>値</th></tr>
		 * <tr><td>bubbles</td><td><code>false</code></td></tr>
		 * <tr><td>cancelable</td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
		 * <tr><td>currentTarget</td><td>イベントリスナーで <code>TimelineEvent</code> オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
		 * <tr><td>target</td><td>イベントの発生元のオブジェクトです。</td></tr>
		 * </table>
		 * 
		 * @eventType animationEnd
		 */
		public static const ANIMATION_END:String = "animationEnd";
		
		/**
		 * イベントリスナーにパラメータとして渡す <code>TimelineEvent</code> オブジェクトを作成します.
		 * 
		 * @param type       <code>TimelineEvent.type</code> としてアクセス可能なイベントタイプです。
		 * @param bubbles    <code>TimelineEvent</code> オブジェクトがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は <code>false</code> です。
		 * @param cancelable <code>TimelineEvent</code> オブジェクトがキャンセル可能かどうかを判断します。デフォルト値は <code>false</code> です。
		 */
		public function TimelineEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * <code>TimelineEvent</code> オブジェクトのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します.
		 * 
		 * @return 元のオブジェクトと同じプロパティ値を含む新しい <code>TimelineEvent</code> オブジェクトです。
		 */
		public override function clone():Event 
		{ 
			return new TimelineEvent(type, bubbles, cancelable);
		} 
		
		/**
		 * <code>TimelineEvent</code> オブジェクトのすべてのプロパティを含むストリングを返します.
		 * <p>
		 * ストリングは次の形式です。
		 * </p>
		 * <p>
		 * <code>[TimelineEvent type=<em>value</em> bubbles=<em>value</em> cancelable=<em>value</em> eventPhase=<em>value</em>]</code>
		 * </p>
		 * 
		 * @return <code>TimelineEvent</code> オブジェクトのすべてのプロパティを含むストリングです。
		 */
		public override function toString():String 
		{ 
			return formatToString("TimelineEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}