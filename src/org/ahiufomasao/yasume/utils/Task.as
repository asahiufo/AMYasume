package org.ahiufomasao.yasume.utils
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import org.ahiufomasao.yasume.events.TaskEvent;
	
	/**
	 * <code>changeExec</code> メソッドを呼び出した際、
	 * 実行関数が変更される直前に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.TaskEvent.CHANGE_EXEC_BEFORE
	 * 
	 * @see #changeExec()
	 */
	[Event(name="changeExecBefore", type="org.ahiufomasao.yasume.events.TaskEvent")]
	/**
	 * <code>changeExec</code> メソッドを呼び出した際、
	 * 実行関数が変更された直後に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.TaskEvent.CHANGE_EXEC_AFTER
	 * 
	 * @see #changeExec()
	 */
	[Event(name="changeExecAfter", type="org.ahiufomasao.yasume.events.TaskEvent")]
	/**
	 * <code>changeDraw</code> メソッドを呼び出した際
	 * 描画関数が変更される直前に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.TaskEvent.CHANGE_DRAW_BEFORE
	 * 
	 * @see #changeDraw()
	 */
	[Event(name="changeDrawBefore", type="org.ahiufomasao.yasume.events.TaskEvent")]
	/**
	 * <code>changeDraw</code> メソッドを呼び出した際
	 * 描画関数が変更された直後に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.TaskEvent.CHANGE_DRAW_AFTER
	 * 
	 * @see #changeDraw()
	 */
	[Event(name="changeDrawAfter", type="org.ahiufomasao.yasume.events.TaskEvent")]
	/**
	 * <code>TaskList</code> クラスの <code>addTask</code> メソッドにこのタスクを渡して実行した際、
	 * このタスクがリストに登録される直前に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.TaskEvent.ADDED_BEFORE
	 * 
	 * @see TaskList#addTask()
	 */
	[Event(name="addedBefore", type="org.ahiufomasao.yasume.events.TaskEvent")]
	/**
	 * <code>TaskList</code> クラスの <code>addTask</code> メソッドにこのタスクを渡して実行した際、
	 * このタスクがリストに登録された直後に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.TaskEvent.ADDED_AFTER
	 * 
	 * @see TaskList#addTask()
	 */
	[Event(name="addedAfter", type="org.ahiufomasao.yasume.events.TaskEvent")]
	/**
	 * <code>removeMe</code> メソッドや <code>TaskList</code> クラスの <code>removeAllTask</code> メソッドを呼び出さした際、
	 * このタスクがリストから削除される直前に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.TaskEvent.REMOVED_BEFORE
	 * 
	 * @see #removeMe()
	 * @see TaskList#removeAllTask()
	 */
	[Event(name="removedBefore", type="org.ahiufomasao.yasume.events.TaskEvent")]
	/**
	 * <code>removeMe</code> メソッドや <code>TaskList</code> クラスの <code>removeAllTask</code> メソッドを呼び出さした際、
	 * このタスクがリストから削除された直後に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.TaskEvent.REMOVED_AFTER
	 * 
	 * @see #removeMe()
	 * @see TaskList#removeAllTask()
	 */
	[Event(name="removedAfter", type="org.ahiufomasao.yasume.events.TaskEvent")]
	/**
	 * <code>exec</code> メソッドを呼び出した際、
	 * 実行関数が呼び出される直前に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.TaskEvent.EXEC_BEFORE
	 * 
	 * @see #exec()
	 */
	[Event(name="execBefore", type="org.ahiufomasao.yasume.events.TaskEvent")]
	/**
	 * <code>exec</code> メソッドを呼び出した際、
	 * 実行関数が呼び出された直後に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.TaskEvent.EXEC_AFTER
	 * 
	 * @see #exec()
	 */
	[Event(name="execAfter", type="org.ahiufomasao.yasume.events.TaskEvent")]
	/**
	 * <code>draw</code> メソッドを呼び出した際、
	 * 描画関数が呼び出される直前に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.TaskEvent.DRAW_BEFORE
	 * 
	 * @see #draw()
	 */
	[Event(name="drawBefore", type="org.ahiufomasao.yasume.events.TaskEvent")]
	/**
	 * <code>draw</code> メソッドを呼び出した際、
	 * 描画関数が呼び出された直後に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.TaskEvent.DRAW_AFTER
	 * 
	 * @see #draw()
	 */
	[Event(name="drawAfter", type="org.ahiufomasao.yasume.events.TaskEvent")]
	
	/**
	 * @inheritDoc
	 * @author asahiufo/AM902
	 */
	public class Task extends EventDispatcher implements ITask
	{
		private var _execFunc:Function;      // 実行関数
		private var _drawFunc:Function;      // 描画関数
		
		private var _beforeExecFunc:Function; // 前の実行関数
		private var _beforeDrawFunc:Function; // 前の描画関数
		
		/**
		 * @inheritDoc
		 */
		public function get currentExecFunc():Function { return _execFunc; }
		/**
		 * @inheritDoc
		 */
		public function get currentDrawFunc():Function { return _drawFunc; }
		
		/**
		 * @inheritDoc
		 */
		public function get beforeExecFunc():Function { return _beforeExecFunc; }
		/**
		 * @inheritDoc
		 */
		public function get beforeDrawFunc():Function { return _beforeDrawFunc; }
		
		/**
		 * 新しい <code>Task</code> クラスのインスタンスを生成します.
		 */
		public function Task()
		{
			super();
			
			_execFunc = execSleep;
			_drawFunc = drawSleep;
			
			_beforeExecFunc = null;
			_beforeDrawFunc = null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function changeExec(execFunc:Function, context:Object = null):void
		{
			var event:TaskEvent = null;
			
			event = new TaskEvent(TaskEvent.CHANGE_EXEC_BEFORE);
			event.context = context;
			dispatchEvent(event);
			
			_beforeExecFunc = _execFunc;
			_execFunc       = execFunc;
			
			event = new TaskEvent(TaskEvent.CHANGE_EXEC_AFTER);
			event.context = context;
			dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function changeDraw(drawFunc:Function, context:Object = null):void
		{
			var event:TaskEvent = null;
			
			event = new TaskEvent(TaskEvent.CHANGE_DRAW_BEFORE);
			event.context = context;
			dispatchEvent(event);
			
			_beforeDrawFunc = _drawFunc;
			_drawFunc       = drawFunc;
			
			event = new TaskEvent(TaskEvent.CHANGE_DRAW_AFTER);
			event.context = context;
			dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function exec(context:Object):void
		{
			if (_execFunc == null)
			{
				return;
			}
			
			var event:TaskEvent = null;
			
			event = new TaskEvent(TaskEvent.EXEC_BEFORE);
			event.context = context;
			dispatchEvent(event);
			
			_execFunc.call(this, context);
			
			event = new TaskEvent(TaskEvent.EXEC_AFTER);
			event.context = context;
			dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function draw(context:Object):void
		{
			if (_drawFunc == null)
			{
				return;
			}
			
			var event:TaskEvent = null;
			
			event = new TaskEvent(TaskEvent.DRAW_BEFORE);
			event.context = context;
			dispatchEvent(event);
			
			_drawFunc.call(this, context);
			
			event = new TaskEvent(TaskEvent.DRAW_AFTER);
			event.context = context;
			dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function execSleep(context:Object):void
		{
		}
		/**
		 * @inheritDoc
		 */
		public function drawSleep(context:Object):void
		{
		}
	}
}
