package org.ahiufomasao.yasume.utils 
{
	import org.ahiufomasao.yasume.events.TaskEvent;
	import org.as3commons.collections.framework.core.LinkedListIterator;
	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.LinkedList;
	import org.as3commons.collections.Set;
	
	// TODO: asdoc 見直し
	// TODO: テスト
	/**
	 * <code>TaskList</code> クラスは複数の実行オブジェクト（タスク）の実行、描画を行う実行オブジェクトリストです.
	 * <p>
	 * <code>add</code> メソッドにより、 <code>ITask</code> オブジェクトを実行優先度順に登録します。
	 * <code>exec</code>、 <code>draw</code> メソッドを呼び出すことで、登録されたタスクを実行優先度順に実行、描画します。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see #add()
	 * @see ITask
	 * @see #exec()
	 * @see #draw()
	 */
	public class TaskList implements IIterable
	{
		private var _tasks:LinkedList;
		private var _waitingTaskSet:Set;
		
		private var _execContext:Object; // 実行コンテキスト
		private var _drawContext:Object; // 描画コンテキスト
		
		private var _currentExecTask:ITask; // 現在処理中のタスク
		private var _currentDrawTask:ITask; // 現在描画中のタスク
		
		/**
		 * タスクの登録数です.
		 */
		public function get length():uint { return _tasks.size; }
		
		/**
		 * 登録タスクに連携する実行コンテキストです.
		 */
		public function get execContext():Object { return _execContext; }
		/** @private */
		public function set execContext(value:Object):void { _execContext = value; }
		/**
		 * 登録タスクに連携する描画コンテキストです.
		 */
		public function get drawContext():Object { return _drawContext; }
		/** @private */
		public function set drawContext(value:Object):void { _drawContext = value; }
		
		/**
		 * 現在実行中の <code>ITask</code> オブジェクトです.
		 * <p>
		 * <code>exec</code> メソッド実行中にのみ <code>null</code> 以外が設定され、
		 * <code>exec</code> メソッドが終了した段階では <code>null</code> が設定されています。
		 * </p>
		 */
		public function get currentExecTask():ITask { return _currentExecTask; }
		
		/**
		 * 現在描画中の <code>ITask</code> オブジェクトです.
		 * <p>
		 * <code>draw</code> メソッド実行中にのみ <code>null</code> 以外が設定され、
		 * <code>draw</code> メソッドが終了した段階では <code>null</code> が設定されています。
		 * </p>
		 */
		public function get currentDrawTask():ITask { return _currentDrawTask; }
		
		/**
		 * @inheritDoc
		 */
		public function iterator(cursor:* = null):IIterator 
		{
			return new LinkedListIterator(_tasks);
		}
		
		/**
		 * 新しい <code>TaskList</code> クラスのインスタンスを生成します.
		 * 
		 * @param execContext 登録タスクに連携する実行コンテキストです。
		 * @param drawContext 登録タスクに連携する描画コンテキストです。
		 */
		public function TaskList(execContext:Object = null, drawContext:Object = null)
		{
			_tasks          = new LinkedList();
			_waitingTaskSet = new Set();
			
			_execContext = execContext;
			_drawContext = drawContext;
			
			_currentExecTask = null;
			_currentDrawTask = null;
		}
		
		/**
		 * タスクをリストの先頭に登録します.
		 * 
		 * @param task    登録するタスクです。
		 * @param context 登録タスクに連携する実行コンテキストです。
		 * 
		 * @return 登録した ITask オブジェクトです。
		 */
		public function addFirst(task:ITask, context:Object = null):ITask
		{
			var event:TaskEvent;
			
			// 使用コンテキスト判定
			if (context == null)
			{
				context = _execContext;
			}
			
			// タスク登録前イベント実行
			event = new TaskEvent(TaskEvent.ADDED_BEFORE);
			event.context = context;
			task.dispatchEvent(event);
			
			// タスク一覧に登録
			_tasks.addFirst(task);
			
			// 処理待ち状態にしておく
			_waitingTaskSet.add(task);
			
			// タスク登録後イベント実行
			event = new TaskEvent(TaskEvent.ADDED_AFTER);
			event.context = context;
			task.dispatchEvent(event);
			
			return task;
		}
		
		/**
		 * タスクをリストの末尾に登録します.
		 * 
		 * @param task    登録するタスクです。
		 * @param context 登録タスクに連携する実行コンテキストです。
		 * 
		 * @return 登録した ITask オブジェクトです。
		 */
		public function addLast(task:ITask, context:Object = null):ITask
		{
			var event:TaskEvent;
			
			// 使用コンテキスト判定
			if (context == null)
			{
				context = _execContext;
			}
			
			// タスク登録前イベント実行
			event = new TaskEvent(TaskEvent.ADDED_BEFORE);
			event.context = context;
			task.dispatchEvent(event);
			
			// タスク一覧に登録
			_tasks.addLast(task);
			
			// 処理待ち状態にしておく
			_waitingTaskSet.add(task);
			
			// タスク登録後イベント実行
			event = new TaskEvent(TaskEvent.ADDED_AFTER);
			event.context = context;
			task.dispatchEvent(event);
			
			return task;
		}
		
		/**
		 * タスクをリストから除去します.
		 * 
		 * @param task    除去するタスクです。
		 * @param context 除去タスクに連携する実行コンテキストです。
		 * 
		 * @return 除去した ITask オブジェクトです。
		 */
		public function remove(task:ITask, context:Object = null):ITask
		{
			var event:TaskEvent;
			
			// 使用コンテキスト判定
			if (context == null)
			{
				context = _execContext;
			}
			
			// タスク除去前イベント実行
			event = new TaskEvent(TaskEvent.REMOVED_BEFORE);
			event.context = context;
			task.dispatchEvent(event);
			
			// タスク一覧から除去
			_tasks.remove(task);
			
			// タスク除去後イベント実行
			event = new TaskEvent(TaskEvent.REMOVED_AFTER);
			event.context = context;
			task.dispatchEvent(event);
			
			return task;
		}
		
		/**
		 * 全タスクをリストから削除します.
		 * 
		 * @param context イベントに渡す実行コンテキストです。省略した場合 <code>execContext</code> プロパティが使用されます。
		 */
		public function removeAll(context:Object = null):void
		{
			// 使用コンテキスト判定
			if (context == null)
			{
				context = _execContext;
			}
			
			var it:IIterator = _tasks.iterator();
			while (it.hasNext())
			{
				remove(ITask(it.next()));
			}
		}
		
		/**
		 * 登録されたタスクをすべて実行します.
		 * 
		 * @param context 実行コンテキストです。省略した場合 <code>execContext</code> プロパティが使用されます。
		 */
		public function exec(context:Object = null):void
		{
			// 使用コンテキスト判定
			if (context == null)
			{
				context = _execContext;
			}
			_execAndDrawCommon(RunKind.EXEC, context);
		}
		
		/**
		 * 登録されたタスクをすべて描画します.
		 * 
		 * @param context 描画コンテキストです。省略した場合 <code>drawContext</code> プロパティが使用されます。
		 */
		public function draw(context:Object = null):void
		{
			// 使用コンテキスト判定
			if (context == null)
			{
				context = _drawContext;
			}
			_execAndDrawCommon(RunKind.DRAW, context);
		}
		
		/**
		 * @private
		 * exec、 draw メソッドの共通関数
		 * 
		 * @param runKind 処理目的
		 * @param context コンテキスト
		 */
		private function _execAndDrawCommon(runKind:RunKind, context:Object):void
		{
			// 処理待ち状態クリア
			_waitingTaskSet.clear();
			
			var runKindExec:RunKind = RunKind.EXEC;
			var runKindDraw:RunKind = RunKind.DRAW;
			var waitingTaskSet:Set = _waitingTaskSet;
			
			var it:IIterator = _tasks.iterator();
			while (it.hasNext())
			{
				var t:ITask = ITask(it.next());
				
				// 処理待ち状態判定
				if (waitingTaskSet.has(t))
				{
					continue;
				}
				
				 // 現在の処理対象タスク更新
				if (runKind == runKindExec)
				{
					_currentExecTask = t;
					t.exec(context);
				}
				else if (runKind == runKindDraw)
				{
					_currentDrawTask = t;
					t.draw(context);
				}
			}
			
			// 処理待ち状態クリア
			_waitingTaskSet.clear();
			
			 // 現在の処理対象タスク更新
			if (runKind == runKindExec)
			{
				_currentExecTask = null;
			}
			else if (runKind == runKindDraw)
			{
				_currentDrawTask = null;
			}
		}
		
		/**
		 * <code>TaskList</code> オブジェクトのプロパティと、
		 * リストに登録されている <code>ITask</code> オブジェクトの文字列表現を含むストリングを返します.
		 * 
		 * @return <code>TaskList</code> オブジェクトのプロパティと、リストに登録されている <code>ITask</code> オブジェクトの文字列表現を含むストリングです。
		 */
		public function toString():String 
		{
			var retStr:String = "[TaskList length=" + length + "]";
			
			var it:IIterator = _tasks.iterator();
			while (it.hasNext())
			{
				var t:ITask = ITask(it.next());
				
				retStr += "\r\n + " + t;
			}
			
			return retStr;
		}
	}
}

import org.ahiufomasao.utility.core.Enum;

class RunKind extends Enum
{
	public static const EXEC:RunKind = new RunKind();
	public static const DRAW:RunKind = new RunKind();
}