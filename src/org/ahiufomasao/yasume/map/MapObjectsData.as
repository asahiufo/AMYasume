package org.ahiufomasao.yasume.map 
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	import org.ahiufomasao.utility.net.StringLoader;
	import org.ahiufomasao.utility.StringUtility;
	import org.ahiufomasao.utility.Validator;
	
	/**
	 * <code>setSettingsByXMLFile</code> メソッドを呼び出した後、データを受信したときに送出されます.
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 * 
	 * @see #setSettingsByXMLFile()
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * <code>setSettingsByXMLFile</code> メソッドを呼び出した後、ロードが完了した時に送出されます.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 * 
	 * @see #setSettingsByXMLFile()
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * <code>MapObjectsData</code> クラスは、マップに配置するオブジェクトのデータを保持します.
	 * <p>
	 * マップオブジェクトデータの設定は、<code>XML</code> オブジェクトや外部 XML ファイルを読み込むことにより行うことができます。
	 * <code>XML</code> オブジェクトからの設定は <code>setSettingsByXML</code> メソッドを、
	 * 外部 XML ファイルからの設定は <code>setSettingsByXMLFile</code> を使用します。
	 * </p>
	 * <p>
	 * マップに配置するオブジェクトには以下の特徴を付与することができます。
	 * </p>
	 * <ul>
	 * <li>画面内にオブジェクトが表示された時だけ行動させる「有効調整可能オブジェクト」</li>
	 * <li>マップ中に配置されているリフトや壁といった「当たりオブジェクト」</li>
	 * </ul>
	 * <p>
	 * 上記の特徴をオブジェクトへ自由に付与することができます。
	 * 逆に、特徴を何も設定しないオブジェクトを作成することもできます。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 */
	public class MapObjectsData extends EventDispatcher
	{
		private var _mapObjects:Vector.<IMapObject>;               // マップオブジェクトリスト
		private var _activeAdjustables:Vector.<IActiveAdjustable>; // 有効調整オブジェクトリスト
		private var _hitObjects:Vector.<IHitObject>;               // 当たりオブジェクトリスト
		
		private var _activeSettings:Dictionary;                    // マップオブジェクトをキーに有効設定を登録
		private var _hitSettings:Dictionary;                       // マップオブジェクトをキーに当たり設定を登録
		
		private var _factory:IMapObjectFactory;                    // マップオブジェクトファクトリー
		
		private var _settingsXML:XML;                              // 設定XML
		private var _settingsLoader:StringLoader;                  // 設定ローダー
		
		/**
		 * マップオブジェクトリストです.
		 */
		public function get mapObjects():Vector.<IMapObject> { return _mapObjects; }
		/**
		 * 有効調整可能オブジェクトリストです.
		 */
		public function get activeAdjustables():Vector.<IActiveAdjustable> { return _activeAdjustables; }
		/**
		 * 当たりオブジェクトリストです.
		 */
		public function get hitObjects():Vector.<IHitObject> { return _hitObjects; }
		
		/**
		 * <code>IMapObject</code> オブジェクトを作成する <code>IMapObjectFactory</code> オブジェクトです.
		 */
		public function get factory():IMapObjectFactory { return _factory; }
		/** @private */
		public function set factory(value:IMapObjectFactory):void { _factory = value; }
		
		/**
		 * マップオブジェクトデータファイルのロードされたバイト数です.
		 * 
		 * @see #setSettingsByXMLFile()
		 */
		public function get settingsBytesLoaded():uint { return (_settingsLoader == null ? 0 : _settingsLoader.bytesLoaded); }
		/**
		 * マップオブジェクトデータファイルのロードプロセスが成功した場合にロードされるバイトの総数です.
		 * <p>
		 * <code>setSettingsByXMLFile</code> メソッドが実行されるまでは常に 0 です。
		 * </p>
		 * 
		 * @see #setSettingsByXMLFile()
		 */
		public function get settingsBytesTotal():uint { return (_settingsLoader == null ? 0 : _settingsLoader.bytesTotal); }
		/**
		 * マップオブジェクトデータファイルのロードが完了したタイミングで <code>true</code> が設定されます.
		 * 
		 * @see #setSettingsByXMLFile()
		 */
		public function get settingsLoadComplete():Boolean { return (_settingsLoader == null ? false : _settingsLoader.complete); }
		
		/**
		 * 新しい <code>MapObjectsData</code> クラスのインスタンスを生成します.
		 */
		public function MapObjectsData() 
		{
			_mapObjects        = null;
			_activeAdjustables = null;
			_hitObjects        = null;
			_activeSettings    = null;
			_hitSettings       = null;
			
			_factory           = null;
			
			_settingsXML       = null;
			_settingsLoader    = null;
		}
		
		/**
		 * マップオブジェクトデータを <code>XML</code> オブジェクトから設定します.
		 * 
		 * @param data マップオブジェクトデータを定義した <code>XML</code> オブジェクトです。
		 * 
		 * @throws ArgumentError マップオブジェクトデータの記述形式にエラーがある場合にスローされます。
		 */
		public function setSettingsByXML(data:XML):void
		{
			var errorMessage:String = "";
			
			// object
			if (data.object == null)
			{
				errorMessage += "\"object\" タグを 1 件以上設定してください。\n";
			}
			else
			{
				for each (var objectXML:XML in data.object)
				{
					// @name
					if (objectXML.@name == undefined)
					{
						errorMessage += "\"object\" タグには \"@name\" 属性を設定します。\n";
					}
					
					// position
					if (objectXML.position == undefined)
					{
						errorMessage += "\"object.position\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
					}
					else
					{
						// x
						if (objectXML.position.x == undefined)
						{
							errorMessage += "\"object.position.x\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
						}
						else if (!Validator.validateNumber(String(objectXML.position.x)))
						{
							errorMessage += "\"object.position.x\" タグには正の数値を設定します。[@name=" + String(objectXML.@name) + "]\n";
						}
						// y
						if (objectXML.position.y == undefined)
						{
							errorMessage += "\"object.position.y\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
						}
						else if (!Validator.validateNumber(String(objectXML.position.y)))
						{
							errorMessage += "\"object.position.y\" タグには正の数値を設定します。[@name=" + String(objectXML.@name) + "]\n";
						}
					}
					
					// activeSetting
					if (objectXML.activeSetting != undefined)
					{
						// activeBorder
						if (objectXML.activeSetting.activeBorder == undefined)
						{
							errorMessage += "\"object.activeSetting.activeBorder\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
						}
						else
						{
							// x
							if (objectXML.activeSetting.activeBorder.x == undefined)
							{
								errorMessage += "\"object.activeSetting.activeBorder.x\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
							}
							else if (!Validator.validateNumber(String(objectXML.activeSetting.activeBorder.x)))
							{
								errorMessage += "\"object.activeSetting.activeBorder.x\" タグには正の数値を設定します。[@name=" + String(objectXML.@name) + "]\n";
							}
							// y
							if (objectXML.activeSetting.activeBorder.y == undefined)
							{
								errorMessage += "\"object.activeSetting.activeBorder.y\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
							}
							else if (!Validator.validateNumber(String(objectXML.activeSetting.activeBorder.y)))
							{
								errorMessage += "\"object.activeSetting.activeBorder.y\" タグには正の数値を設定します。[@name=" + String(objectXML.@name) + "]\n";
							}
						}
					}
					
					// hitSetting
					if (objectXML.hitSetting != undefined)
					{
						// rightHittable
						if (objectXML.hitSetting.rightHittable == undefined)
						{
							errorMessage += "\"object.hitSetting.rightHittable\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
						}
						else if (!Validator.validateBoolean(String(objectXML.hitSetting.rightHittable)))
						{
							errorMessage += "\"object.hitSetting.rightHittable\" タグには正の数値を設定します。[@name=" + String(objectXML.@name) + "]\n";
						}
						// leftHittable
						if (objectXML.hitSetting.leftHittable == undefined)
						{
							errorMessage += "\"object.hitSetting.leftHittable\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
						}
						else if (!Validator.validateBoolean(String(objectXML.hitSetting.leftHittable)))
						{
							errorMessage += "\"object.hitSetting.leftHittable\" タグには正の数値を設定します。[@name=" + String(objectXML.@name) + "]\n";
						}
						// topHittable
						if (objectXML.hitSetting.topHittable == undefined)
						{
							errorMessage += "\"object.hitSetting.topHittable\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
						}
						else if (!Validator.validateBoolean(String(objectXML.hitSetting.topHittable)))
						{
							errorMessage += "\"object.hitSetting.topHittable\" タグには正の数値を設定します。[@name=" + String(objectXML.@name) + "]\n";
						}
						// bottomHittable
						if (objectXML.hitSetting.bottomHittable == undefined)
						{
							errorMessage += "\"object.hitSetting.bottomHittable\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
						}
						else if (!Validator.validateBoolean(String(objectXML.hitSetting.bottomHittable)))
						{
							errorMessage += "\"object.hitSetting.bottomHittable\" タグには正の数値を設定します。[@name=" + String(objectXML.@name) + "]\n";
						}
						// throughRight
						if (objectXML.hitSetting.throughRight == undefined)
						{
							errorMessage += "\"object.hitSetting.throughRight\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
						}
						else if (!Validator.validateBoolean(String(objectXML.hitSetting.throughRight)))
						{
							errorMessage += "\"object.hitSetting.throughRight\" タグには正の数値を設定します。[@name=" + String(objectXML.@name) + "]\n";
						}
						// throughLeft
						if (objectXML.hitSetting.throughLeft == undefined)
						{
							errorMessage += "\"object.hitSetting.throughLeft\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
						}
						else if (!Validator.validateBoolean(String(objectXML.hitSetting.throughLeft)))
						{
							errorMessage += "\"object.hitSetting.throughLeft\" タグには正の数値を設定します。[@name=" + String(objectXML.@name) + "]\n";
						}
						// throughUp
						if (objectXML.hitSetting.throughUp == undefined)
						{
							errorMessage += "\"object.hitSetting.throughUp\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
						}
						else if (!Validator.validateBoolean(String(objectXML.hitSetting.throughUp)))
						{
							errorMessage += "\"object.hitSetting.throughUp\" タグには正の数値を設定します。[@name=" + String(objectXML.@name) + "]\n";
						}
						// throughDown
						if (objectXML.hitSetting.throughDown == undefined)
						{
							errorMessage += "\"object.hitSetting.throughDown\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
						}
						else if (!Validator.validateBoolean(String(objectXML.hitSetting.throughDown)))
						{
							errorMessage += "\"object.hitSetting.throughDown\" タグには正の数値を設定します。[@name=" + String(objectXML.@name) + "]\n";
						}
						// kind
						if (objectXML.hitSetting.kind == undefined)
						{
							errorMessage += "\"object.hitSetting.kind\" タグを設定してください。[@name=" + String(objectXML.@name) + "]\n";
						}
					}
				}
			}
			
			// 書式エラーがある場合
			if (errorMessage.length != 0)
			{
				throw new ArgumentError(errorMessage);
			}
			
			_settingsXML = data;
		}
		
		/**
		 * XML ファイルを読み込み、読み込んだマップオブジェクトデータを設定します.
		 * <p>
		 * <code>setSettingsByXMLFile</code> を呼び出した後、ファイルのロード状況は 
		 * <code>settingsBytesLoaded</code>、
		 * <code>settingsBytesTotal</code>、
		 * <code>settingsLoadComplete</code> プロパティにより取得できます。
		 * </p>
		 * 
		 * @param URL マップオブジェクトデータを定義した XML ファイルの URL です。
		 * 
		 * @throws IllegalOperationError ファイル読み込み中に重複して <code>setSettingsByXMLFile</code> メソッドを呼び出した場合にスローされます。
		 * 
		 * @see #settingsBytesLoaded
		 * @see #settingsBytesTotal
		 * @see #settingsLoadComplete
		 */
		public function setSettingsByXMLFile(URL:String):void
		{
			if (_settingsLoader != null)
			{
				if (!_settingsLoader.complete)
				{
					throw new IllegalOperationError("ファイル読み込み中に重複して setSettingsByXMLFile メソッドを呼び出すことはできません。");
				}
			}
			_settingsLoader = new StringLoader(URL);
			_settingsLoader.addEventListener(ProgressEvent.PROGRESS, _onProgress);
			_settingsLoader.addEventListener(Event.COMPLETE, _onSettingsLoadComplete);
			_settingsLoader.load();
		}
		
		/**
		 * @private
		 * プログレスイベントハンドラ
		 * 
		 * @param event イベント
		 */
		private function _onProgress(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * @private
		 * XML ファイル読み込み完了イベントハンドラです。
		 * 
		 * @param event イベント
		 */
		private function _onSettingsLoadComplete(event:Event):void
		{
			var data:XML = new XML(String(_settingsLoader.data));
			setSettingsByXML(data);
			
			dispatchEvent(event);
			_settingsLoader.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
			_settingsLoader.removeEventListener(Event.COMPLETE, _onSettingsLoadComplete);
		}
		
		/**
		 * マップオブジェクトデータに則って、マップオブジェクトを生成します.
		 * <p>
		 * マップオブジェクトとオブジェクトに対応付く設定を作成し、
		 * <code>MapObjectsData</code> オブジェクト内部のリストに保持します。
		 * オブジェクトは、マップオブジェクトデータの <code>object</code> タグの <code>name</code> 属性を用いて 
		 * <code>factory</code> プロパティの <code>createMapObject</code> メソッドによって作成されます。
		 * </p>
		 * <p>
		 * 作成されるオブジェクトはマップオブジェクトの設定で
		 * 有効調整設定が定義されている場合、<code>IActiveAdjustable</code> インターフェイスを実装している必要があります。
		 * また、当たり設定が定義されている場合は、<code>IHitObject</code> インターフェイスを実装している必要があります。
		 * </p>
		 * <p>
		 * 作成されたマップオブジェクトはすべて <code>mapObjects</code> プロパティへ登録されます。
		 * 有効調整設定が定義されているオブジェクトについては、<code>activeAdjustables</code> プロパティへも登録されます。
		 * また、当たり設定が定義されているオブジェクトについては、<code>hitObjects</code> プロパティへも登録されます。
		 * </p>
		 * 
		 * @see #mapObjects
		 * @see #activeAdjustables
		 * @see #hitObjects
		 */
		public function createMapObjects():void
		{
			if (_settingsXML == null)
			{
				throw new IllegalOperationError("設定データを設定してから実行してください。");
			}
			
			// ファクトリーが設定されていないならエラー
			if (_factory == null)
			{
				throw new IllegalOperationError("factory プロパティを設定してから実行してください。");
			}
			
			_mapObjects        = new Vector.<IMapObject>();
			_activeAdjustables = new Vector.<IActiveAdjustable>();
			_hitObjects        = new Vector.<IHitObject>();
			_activeSettings    = new Dictionary();
			_hitSettings       = new Dictionary();
			
			var data:XML = _settingsXML;
			
			// object
			for each (var objectXML:XML in data.object)
			{
				// @name
				var mapObject:IMapObject = _factory.createMapObject(String(objectXML.@name));
				
				// position
				mapObject.x = Number(String(objectXML.position.x));
				mapObject.y = Number(String(objectXML.position.y));
				
				var settings:Dictionary = new Dictionary();
				
				// activeSetting
				if (objectXML.activeSetting != undefined)
				{
					var activeSetting:ActiveSetting = new ActiveSetting();
					activeSetting.initX         = mapObject.x;
					activeSetting.initY         = mapObject.y;
					activeSetting.activeBorderX = Number(String(objectXML.activeSetting.activeBorder.x));
					activeSetting.activeBorderY = Number(String(objectXML.activeSetting.activeBorder.y));
					
					settings.activeSetting = activeSetting;
				}
				
				// hitSetting
				if (objectXML.hitSetting != undefined)
				{
					var hitSetting:HitSetting = new HitSetting();
					hitSetting.rightHittable  = StringUtility.convertStringToBoolean(String(objectXML.hitSetting.rightHittable));
					hitSetting.leftHittable   = StringUtility.convertStringToBoolean(String(objectXML.hitSetting.leftHittable));
					hitSetting.topHittable    = StringUtility.convertStringToBoolean(String(objectXML.hitSetting.topHittable));
					hitSetting.bottomHittable = StringUtility.convertStringToBoolean(String(objectXML.hitSetting.bottomHittable));
					hitSetting.throughRight   = StringUtility.convertStringToBoolean(String(objectXML.hitSetting.throughRight));
					hitSetting.throughLeft    = StringUtility.convertStringToBoolean(String(objectXML.hitSetting.throughLeft));
					hitSetting.throughUp      = StringUtility.convertStringToBoolean(String(objectXML.hitSetting.throughUp));
					hitSetting.throughDown    = StringUtility.convertStringToBoolean(String(objectXML.hitSetting.throughDown));
					hitSetting.kind           = String(objectXML.hitSetting.kind);
					
					settings.hitSetting = hitSetting;
				}
				
				addMapObject(mapObject, settings);
			}
		}
		
		/**
		 * マップオブジェクトを登録します.
		 * <p>
		 * マップオブジェクトと共に、マップオブジェクトの設定も指定します。
		 * </p>
		 * <p>
		 * マップオブジェクトの設定は、<code>Dictionary</code> オブジェクトを使用します。 
		 * <code>Dictionary</code> オブジェクトの <code>activeSetting</code> プロパティには有効調整設定を、
		 * <code>hitSetting</code> プロパティには当たり設定を設定します。
		 * なお、これらのプロパティは任意で省略することができます。
		 * </p>
		 * <p>
		 * <code>mapObject</code> パラメータのオブジェクトは
		 * マップオブジェクトの設定で有効調整設定が定義されている場合、<code>IActiveAdjustable</code> インターフェイスを実装している必要があります。
		 * また、当たり設定が定義されている場合は、<code>IHitObject</code> インターフェイスを実装している必要があります。
		 * </p>
		 * <p>
		 * <code>mapObject</code> パラメータのオブジェクトは必ず <code>mapObjects</code> プロパティへ登録されます。
		 * マップオブジェクトの設定で有効調整設定が定義されている場合、<code>activeAdjustables</code> プロパティへも登録されます。
		 * また、当たり設定が定義されている場合は、<code>hitObjects</code> プロパティへも登録されます。
		 * </p>
		 * 
		 * @param mapObject 登録するマップオブジェクトです。
		 * @param settings  マップオブジェクトの設定です。<code>[activeSetting:ActiveSetting, hitSetting:HitSetting]</code> という形式の <code>Dictionary</code> オブジェクトを指定します。
		 * 
		 * @return 登録したマップオブジェクトです。
		 */
		public function addMapObject(mapObject:IMapObject, settings:Dictionary = null):IMapObject
		{
			_mapObjects.push(mapObject);
			
			if (settings != null)
			{
				// 有効設定が指定されている場合
				if (settings.activeSetting != undefined)
				{
					// 有効調整オブジェクトではない場合エラー
					if (!(mapObject is IActiveAdjustable))
					{
						throw new IllegalOperationError("有効調整設定がされている場合、mapObject パラメータのオブジェクトは IActiveAdjustable インターフェイスを実装する必要があります。");
					}
					_activeAdjustables.push(IActiveAdjustable(mapObject));
					_activeSettings[mapObject] = settings.activeSetting;
				}
				// 当たり設定が指定されている場合
				if (settings.hitSetting != undefined)
				{
					// 当たりオブジェクトではない場合エラー
					if (!(mapObject is IHitObject))
					{
						throw new IllegalOperationError("当たり設定がされている場合、mapObject パラメータのオブジェクトは IHitObject インターフェイスを実装する必要があります。");
					}
					_hitObjects.push(IHitObject(mapObject));
					_hitSettings[mapObject] = settings.hitSetting;
				}
			}
			
			return mapObject;
		}
		
		/**
		 * 指定したオブジェクトと、それに紐付く設定を削除します.
		 * 
		 * @param mapObject 削除するマップオブジェクトです。
		 * 
		 * @return 削除したマップオブジェクトです.
		 */
		public function removeMapObject(mapObject:IMapObject):IMapObject
		{
			var index:int;
			
			index = _mapObjects.indexOf(mapObject);
			if (index != -1)
			{
				_mapObjects.splice(index, 1);
			}
			index = _activeAdjustables.indexOf(mapObject);
			if (index != -1)
			{
				_activeAdjustables.splice(index, 1);
			}
			index = _hitObjects.indexOf(mapObject);
			if (index != -1)
			{
				_hitObjects.splice(index, 1);
			}
			
			if (_activeSettings[mapObject] != undefined)
			{
				delete _activeSettings[mapObject];
			}
			if (_hitSettings[mapObject] != undefined)
			{
				delete _hitSettings[mapObject];
			}
			
			return mapObject;
		}
		
		/**
		 * 有効調整設定を取得します.
		 * 
		 * @param activeAdjustable 有効設定を取得する有効調整可能オブジェクトです。
		 * 
		 * @return 有効調整設定です。有効調整設定が存在しない場合 <code>null</code> です。
		 */
		public function getActiveSetting(activeAdjustable:IActiveAdjustable):ActiveSetting
		{
			if (_activeSettings[activeAdjustable] == undefined)
			{
				return null;
			}
			return ActiveSetting(_activeSettings[activeAdjustable]);
		}
		
		/**
		 * 当たり設定を取得します.
		 * 
		 * @param hitObject 当たり設定を取得する当たりオブジェクトです。
		 * 
		 * @return 当たり設定です。当たり設定が存在しない場合 <code>null</code> です。
		 */
		public function getHitSetting(hitObject:IHitObject):HitSetting
		{
			if (_hitSettings[hitObject] == undefined)
			{
				return null;
			}
			return HitSetting(_hitSettings[hitObject]);
		}
	}
}
