package org.ahiufomasao.yasume.utils
{
	import flash.events.IEventDispatcher;
	/**
	 * <code>Task</code> クラスは、実行オブジェクト（タスク）の基本クラスです.
	 * <p>
	 * 優先度を設定して <code>Task</code> クラスのインスタンスを生成します。
	 * 生成した <code>Task</code> オブジェクトを <code>TaskList</code> オブジェクトへ登録し、
	 * <code>TaskList</code> クラスの <code>exec</code>、または <code>draw</code> メソッドを呼び出すことで、
	 * 登録した <code>Task</code> オブジェクトが優先度の順に実行、または描画されます。
	 * </p>
	 * <p>
	 * <code>changeExec</code> メソッドで設定したメソッドはタスクの実行時に呼び出され、
	 * <code>changeDraw</code> メソッドで設定したメソッドはタスクの描画時に呼び出されます。
	 * これらのメソッドの形式は、呼び出し側のコンテキストを 1 つ、引数にとります。
	 * </p>
	 * @example 次のコードは <code>changeExec</code> メソッド、 <code>changeDraw</code> メソッドに渡されるメソッドの例です。
	 *   <listing version="3.0">
	 *   // 実行関数の例
	 *   public function execInit(context:Object):void
	 *   {
	 *   // 実行処理
	 *   }
	 *   
	 *     // 描画関数の例
	 *   public function drawMain(context:Object):void
	 *   {
	 *   // 描画処理
	 *   }</listing>
	 * <p>
	 * 一般に、ユーザー定義クラスがタスク機能を得る最も簡単な方法は、<code>Task</code> を拡張することです。
	 * クラスが既に別のクラスを拡張していて拡張が不可能な場合、代わりに <code>ITask</code> インターフェイスを実装し、EventDispatcher メンバーを作成して、
	 * 集約された <code>Task</code> に呼び出しをルーティングする単純なフックを記述できます。
	 * </p>
	 * @author asahiufo/AM902
	 * @see TaskList
	 * @see TaskList#exec()
	 * @see TaskList#draw()
	 * @see #changeExec()
	 * @see #changeDraw()
	 */
	public interface ITask extends IEventDispatcher
	{
		/**
		 * 現在の実行関数です.
		 */
		function get currentExecFunc():Function;

		/**
		 * 現在の描画関数です.
		 */
		function get currentDrawFunc():Function;

		/**
		 * 前の実行関数です.
		 * <p>
		 * <code>changeExec</code> メソッドにより実行関数が変更された場合に
		 * 変更前の実行関数が <code>beforeExecFunc</code> プロパティへ設定されます。
		 * </p>
		 * @see #changeExec()
		 */
		function get beforeExecFunc():Function;

		/**
		 * 前の描画関数です.
		 * <p>
		 * <code>changeDraw</code> メソッドにより描画関数が変更された場合に
		 * 変更前の描画関数が <code>beforeDrawFunc</code> プロパティへ設定されます。
		 * </p>
		 * @see #changeDraw()
		 */
		function get beforeDrawFunc():Function;

		/**
		 * 実行関数を変更します.
		 * <p>
		 * このメソッドで設定したメソッドが実行関数となり、
		 * <code>Task</code> クラスの <code>exec</code> メソッド、または <code>TaskList</code> クラスの <code>exec</code> メソッドを呼び出した際に実行されます。
		 * </p>
		 * @param execFunc 実行関数とするメソッドです。
		 * @param context  イベントへ渡す実行コンテキストです。
		 */
		function changeExec(execFunc:Function, context:Object=null):void;

		/**
		 * 描画関数を変更します.
		 * <p>
		 * このメソッドで設定したメソッドが描画関数となり、
		 * <code>Task</code> クラスの <code>draw</code> メソッド、または <code>TaskList</code> クラスの <code>draw</code> メソッドを呼び出した際に実行されます。
		 * </p>
		 * @param drawFunc 描画関数とするメソッドです。
		 * @param context  イベントへ渡す実行コンテキストです。
		 */
		function changeDraw(drawFunc:Function, context:Object=null):void;

		/**
		 * 実行関数を実行します.
		 * @param context 実行コンテキストです。
		 */
		function exec(context:Object):void;

		/**
		 * 描画関数を実行します.
		 * @param context 描画コンテキストです。
		 */
		function draw(context:Object):void;
		
		/**
		 * 何も処理を行わない実行関数です.
		 * @param context 実行コンテキストです。
		 */
		function execSleep(context:Object):void;
		/**
		 * 何も処理を行わない描画関数です.
		 * @param context 描画コンテキストです。
		 */
		function drawSleep(context:Object):void;
	}
}
