package org.ahiufomasao.yasume.utils 
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import org.ahiufomasao.yasume.events.StatusManagerEvent;
	
	/**
	 * ステータスが変更される直前（<code>terminator</code> 実行前）に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.StatusManagerEvent.CHANGE_STATUS_BEFORE
	 */
	[Event(name="changeStatusBefore", type="org.ahiufomasao.yasume.events.StatusManagerEvent")]
	/**
	 * ステータスが変更された直後（<code>initializer</code> 実行後）に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.StatusManagerEvent.CHANGE_STATUS_AFTER
	 */
	[Event(name="changeStatusAfter", type="org.ahiufomasao.yasume.events.StatusManagerEvent")]
	
	/**
	 * ステータスマネージャー
	 * 
	 * @author asahiufo/AM902
	 */
	public class StatusManager extends EventDispatcher 
	{
		/*
		<data>
			<startStatus>sample</startStatus>
			<status id="sample">
				<subObjectName>obj</subObjectName>
				<initializer />
				<executor />
				<drawer />
				<terminator />
				<condition next="nextStatus1" />
				<condition next="nextStatus2" />
			</status>
		</data>
		*/
		
		private var _statuses:Dictionary;
		
		private var _execCtx:Object;
		private var _drawCtx:Object;
		
		private var _initialized:Boolean;
		private var _currentStatus:Status;
		
		/**
		 * コンストラクタ
		 * 
		 * @param target  ステータス制御を行う対象オブジェクト
		 * @param setting ステータス設定
		 * @param execCtx 実行コンテキスト
		 * @param drawCtx 描画コンテキスト
		 */
		public function StatusManager(target:Object, setting:XML, execCtx:Object = null, drawCtx:Object = null) 
		{
			super();
			
			_statuses = new Dictionary();
			
			var errorMessage:String = "";
			
			// status
			if (setting.status != undefined)
			{
				for each (var statusXML:XML in setting.status)
				{
					// @id
					if (statusXML.@id == undefined)
					{
						errorMessage += "\"status\" タグには \"@id\" 属性を設定します。\n";
					}
					else
					{
						var statusIdlist:XML = XML(setting.status.(@id == String(statusXML.@id)));
						if (statusIdlist.length() >= 2)
						{
							errorMessage += "複数の \"status\" タグにはそれぞれ異なる \"@id\" 属性を設定してください。\n";
						}
					}
					
					var status:Status = new Status(String(statusXML.@id), target, statusXML);
					
					_statuses[String(statusXML.@id)] = status;
				}
			}
			
			// startStatus
			if (setting.startStatus == undefined)
			{
				errorMessage += "\"startStatus\" タグは必須です。\n";
			}
			else
			{
				_currentStatus = _statuses[String(setting.startStatus)] as Status;
			}
			
			if (errorMessage.length != 0)
			{
				throw new ArgumentError(errorMessage);
			}
			
			_execCtx = execCtx;
			_drawCtx = drawCtx;
			
			_initialized = false;
		}
		
		/**
		 * 実行
		 * 
		 * @param context 実行コンテキスト
		 */
		public function exec(context:Object = null):void
		{
			if (context == null)
			{
				context = _execCtx;
			}
			
			if (!_initialized)
			{
				_currentStatus.runInitializer(context);
				_initialized = true;
				
				var changeAfterEvent:StatusManagerEvent = new StatusManagerEvent(StatusManagerEvent.CHANGE_STATUS_AFTER);
				changeAfterEvent.status = _currentStatus.name;
				changeAfterEvent.context = context;
				dispatchEvent(changeAfterEvent);
			}
			
			_currentStatus.runExecutor(context);
			
			var nextStatus:String = _currentStatus.judgeCondition(context);
			if (nextStatus != "")
			{
				var changeBeforeEvent:StatusManagerEvent = new StatusManagerEvent(StatusManagerEvent.CHANGE_STATUS_BEFORE);
				changeBeforeEvent.status = _currentStatus.name;
				changeBeforeEvent.context = context;
				dispatchEvent(changeBeforeEvent);
				
				_currentStatus.runTerminator(context);
				_currentStatus = _statuses[nextStatus] as Status;
				_initialized = false;
			}
		}
		
		/**
		 * 描画
		 * 
		 * @param context 描画コンテキスト
		 */
		public function draw(context:Object = null):void
		{
			if (context == null)
			{
				context = _drawCtx;
			}
			_currentStatus.runDrawer(context);
		}
	}
}
import flash.utils.Dictionary;

class Status
{
	private var _name:String;
	
	private var _thisObject:Object;
	
	private var _initializer:Function;
	private var _executor:Function;
	private var _drawer:Function;
	private var _terminator:Function;
	
	private var _conditions:Vector.<Function>;
	private var _nextStatuses:Dictionary;
	
	/** ステータス名 */
	public function get name():String { return _name; }
	
	/**
	 * コンストラクタ
	 * 
	 * @param name   ステータス名
	 * @param target ステータス制御対象オブジェクト
	 * @param status ステータス設定データ
	 */
	public function Status(name:String, target:Object, status:XML)
	{
		_name = name;
		
		_conditions = new Vector.<Function>();
		_nextStatuses = new Dictionary();
		
		var errorMessage:String = "";
		var statusID:String = String(status.@id);
		statusID = statusID.substring(0, 1).toUpperCase() + statusID.substring(1);
		var funcName:String;
		
		// subObjectName
		if (status.subObjectName == undefined)
		{
			_thisObject = target;
		}
		else
		{
			_thisObject = target[String(status.subObjectName)] as Object;
		}
		// initializer
		if (status.initializer != undefined)
		{
			if (String(status.initializer) == "")
			{
				funcName = "init" + statusID;
			}
			else
			{
				funcName = String(status.initializer);
			}
			_initializer = _thisObject[funcName] as Function;
		}
		// executor
		if (status.executor == undefined)
		{
			errorMessage += "\"executor\" タグは必須です。\n";
		}
		else
		{
			if (String(status.executor) == "")
			{
				funcName = "exec" + statusID;
			}
			else
			{
				funcName = String(status.executor);
			}
			_executor = _thisObject[funcName] as Function;
		}
		// drawer
		if (status.drawer != undefined)
		{
			if (String(status.drawer) == "")
			{
				funcName = "draw" + statusID;
			}
			else
			{
				funcName = String(status.drawer);
			}
			_drawer = _thisObject[funcName] as Function;
		}
		// terminator
		if (status.terminator != undefined)
		{
			if (String(status.terminator) == "")
			{
				funcName = "term" + statusID;
			}
			else
			{
				funcName = String(status.terminator);
			}
			_terminator = _thisObject[funcName] as Function;
		}
		
		// condition
		if (status.condition != undefined)
		{
			for each (var conditionXML:XML in status.condition)
			{
				// @next
				if (conditionXML.@next == undefined)
				{
					errorMessage += "\"condition\" タグには \"@next\" 属性を設定します。\n";
				}
				
				if (String(conditionXML) == "")
				{
					var nextStatus:String = String(conditionXML.@next);
					nextStatus = nextStatus.substring(0, 1).toUpperCase() + nextStatus.substring(1);
					funcName = "cond" + statusID + "To" + nextStatus;
				}
				else
				{
					funcName = String(conditionXML);
				}
				
				var condition:Function = _thisObject[funcName] as Function;
				_conditions.push(condition);
				_nextStatuses[condition] = String(conditionXML.@next);
			}
		}
		
		if (errorMessage.length != 0)
		{
			throw new ArgumentError(errorMessage);
		}
	}
	
	/**
	 * 初期化関数実行
	 * 
	 * @param context 実行コンテキスト
	 */
	public function runInitializer(context:Object):void
	{
		if (_initializer == null)
		{
			return;
		}
		_initializer.call(_thisObject, context);
	}
	/**
	 * 実行関数実行
	 * 
	 * @param context 実行コンテキスト
	 */
	public function runExecutor(context:Object):void
	{
		if (_executor == null)
		{
			return;
		}
		_executor.call(_thisObject, context);
	}
	/**
	 * 描画関数実行
	 * 
	 * @param context 描画コンテキスト
	 */
	public function runDrawer(context:Object):void
	{
		if (_drawer == null)
		{
			return;
		}
		_drawer.call(_thisObject, context);
	}
	/**
	 * 終了関数実行
	 * 
	 * @param context 実行コンテキスト
	 */
	public function runTerminator(context:Object):void
	{
		if (_terminator == null)
		{
			return;
		}
		_terminator.call(_thisObject, context);
	}
	
	/**
	 * 条件関数判定
	 * 
	 * @param context 実行コンテキスト
	 * 
	 * @return 次のステータス（すべての条件が false である場合空文字列）
	 */
	public function judgeCondition(context:Object):String
	{
		for each (var condition:Function in _conditions)
		{
			if (condition.call(_thisObject, context))
			{
				return String(_nextStatuses[condition]);
			}
		}
		return "";
	}
}