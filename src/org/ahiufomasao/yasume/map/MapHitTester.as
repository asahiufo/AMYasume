package org.ahiufomasao.yasume.map 
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.ahiufomasao.utility.RectangleUtility;
	import org.ahiufomasao.yasume.events.MapHitEvent;
	import org.ahiufomasao.yasume.utils.HitDirection;
	import org.ahiufomasao.yasume.utils.Tester;
	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IIterator;
	
	/**
	 * <code>test</code> メソッドを呼び出した際、<code>IMapHittable</code> にとっての右にある壁に当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.HIT_RIGHT
	 * 
	 * @see #test()
	 */
	[Event(name="hitRight", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	/**
	 * <code>test</code> メソッドを呼び出した際、<code>IMapHittable</code> にとっての左にある壁に当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.HIT_LEFT
	 * 
	 * @see #test()
	 */
	[Event(name="hitLeft", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	/**
	 * <code>test</code> メソッドを呼び出した際、<code>IMapHittable</code> にとっての天井に当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.HIT_TOP
	 * 
	 * @see #test()
	 */
	[Event(name="hitTop", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	/**
	 * <code>test</code> メソッドを呼び出した際、<code>IMapHittable</code> にとっての地面に当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.HIT_BOTTOM
	 * 
	 * @see #test()
	 */
	[Event(name="hitBottom", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	
	/**
	 * <code>test</code> メソッドを呼び出した際、<code>IMapHittable</code> にとっての右にある壁に前回当たりがあったが、今回当たりが無くなった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.LEAVE_RIGHT
	 * 
	 * @see #test()
	 */
	[Event(name="leaveRight", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	/**
	 * <code>test</code> メソッドを呼び出した際、<code>IMapHittable</code> にとっての左にある壁に前回当たりがあったが、今回当たりが無くなった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.LEAVE_LEFT
	 * 
	 * @see #test()
	 */
	[Event(name="leaveLeft", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	/**
	 * <code>test</code> メソッドを呼び出した際、<code>IMapHittable</code> にとっての天井に前回当たりがあったが、今回当たりが無くなった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.LEAVE_TOP
	 * 
	 * @see #test()
	 */
	[Event(name="leaveTop", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	/**
	 * <code>test</code> メソッドを呼び出した際、<code>IMapHittable</code> にとっての地面に前回当たりがあったが、今回当たりが無くなった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapHitEvent.LEAVE_BOTTOM
	 * 
	 * @see #test()
	 */
	[Event(name="leaveBottom", type="org.ahiufomasao.yasume.events.MapHitEvent")]
	
	// TODO: 平坦な地面に '00f' な当たり判定を並べると、壁扱いされて進めなくなるバグ
	/**
	 * <code>MapHitTester</code> クラスは、<code>IMapHittable</code> オブジェクトとステージとの当たり判定を行います.
	 * <p>
	 * マップチップの当たり判定データ、当たりオブジェクトに対し、<code>IMapHittable</code> オブジェクトのリストの当たり判定を行ないます。
	 * </p>
	 * <p>
	 * <code>addDefaultHitEventListener</code> メソッドを呼び出すことで、
	 * ステージ当たり判定があった場合、一般的な当たり判定処理を行う <code>MapHitEvent</code> イベントのハンドラが呼ばれるようになります。
	 * <code>removeDefaultHitEventListener</code> メソッドを呼び出すことで、上記イベントハンドラは呼び出されなくなります。
	 * </p>
	 * <p>
	 * 負の座標の位置に対しての当たり判定検出はサポートしていません。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see IMapHittable
	 * @see #addDefaultHitEventListener()
	 * @see MapHitEvent
	 * @see #removeDefaultHitEventListener()
	 */
	public class MapHitTester extends EventDispatcher
	{
		private var _eventAdded:Boolean;  // 当たり判定イベント設定済みならtrue
		private var _adjustment:Boolean;  // 当たり判定があった際に座標やスピードの調整をするならtrue
		
		private var _nowComplement:uint;  // 現在判定しているのが何番目の補完位置であるか（testHitメソッドから変更される）
		
		private var _throughState:ThroughState; // すり抜け状態
		
		private var _point1:Point;         // 汎用 Point1
		private var _point2:Point;         // 汎用 Point2
		private var _point3:Point;         // 汎用 Point3
		
		private var _rect1:Rectangle;      // 汎用矩形1
		private var _rect2:Rectangle;      // 汎用矩形2
		private var _rect3:Rectangle;      // 汎用矩形3
		
		/**
		 * 新しい <code>MapHitTester</code> クラスのインスタンスを生成します.
		 */
		public function MapHitTester() 
		{
			_eventAdded    = false;
			_adjustment    = false;
			
			_nowComplement = 0;
			
			_throughState  = new ThroughState();
			
			_point1        = new Point();
			_point2        = new Point();
			_point3        = new Point();
			
			_rect1         = new Rectangle();
			_rect2         = new Rectangle();
			_rect3         = new Rectangle();
		}
		
		/**
		 * 一般的なマップ当たり判定処理を行うイベントハンドラを定義します.
		 * 
		 * @param adjustment <code>true</code> を設定すると当たり判定があった際に当たった <code>IMapHittable</code> オブジェクトのスピードと座標の調整を行います。
		 * 
		 * @throws IllegalOperationError <code>addDefaultHitEventListener</code> メソッドによるイベントハンドラが定義済みの状態で再度 <code>addDefaultHitEventListener</code> メソッドを呼び出した場合にスローされます。
		 */
		public function addDefaultHitEventListener(adjustment:Boolean = true):void
		{
			if (_eventAdded)
			{
				throw new IllegalOperationError("すでにイベントハンドラが定義されています。");
			}
			addEventListener(MapHitEvent.HIT_RIGHT,  _onHitRight);
			addEventListener(MapHitEvent.HIT_LEFT,   _onHitLeft);
			addEventListener(MapHitEvent.HIT_TOP,    _onHitTop);
			addEventListener(MapHitEvent.HIT_BOTTOM, _onHitBottom);
			
			addEventListener(MapHitEvent.LEAVE_RIGHT,  _onLeave);
			addEventListener(MapHitEvent.LEAVE_LEFT,   _onLeave);
			addEventListener(MapHitEvent.LEAVE_TOP,    _onLeave);
			addEventListener(MapHitEvent.LEAVE_BOTTOM, _onLeave);
			
			_adjustment = adjustment;
			
			_eventAdded = true;
		}
		
		/**
		 * 一般的な当たり判定イベントハンドラを削除します.
		 * <p>
		 * <code>addDefaultHitEventListener</code> メソッドで登録したイベントハンドラを削除します。
		 * </p>
		 * 
		 * @throws IllegalOperationError <code>addDefaultHitEventListener</code> メソッドによるイベントハンドラが未定義の状態で <code>removeDefaultHitEventListener</code> メソッドを呼び出した場合にスローされます。
		 * 
		 * @see #addDefaultHitEventListener()
		 */
		public function removeDefaultHitEventListener():void
		{
			if (!_eventAdded)
			{
				throw new IllegalOperationError("イベントが登録されていません。");
			}
			removeEventListener(MapHitEvent.HIT_RIGHT,  _onHitRight);
			removeEventListener(MapHitEvent.HIT_LEFT,   _onHitLeft);
			removeEventListener(MapHitEvent.HIT_TOP,    _onHitTop);
			removeEventListener(MapHitEvent.HIT_BOTTOM, _onHitBottom);
			
			removeEventListener(MapHitEvent.LEAVE_RIGHT,  _onLeave);
			removeEventListener(MapHitEvent.LEAVE_LEFT,   _onLeave);
			removeEventListener(MapHitEvent.LEAVE_TOP,    _onLeave);
			removeEventListener(MapHitEvent.LEAVE_BOTTOM, _onLeave);
			
			_eventAdded = false;
		}
		
		/**
		 * 当たり判定を行います.
		 * 
		 * @param mapHittables   当たり判定を行う <code>IMapHittable</code> オブジェクトのリストです。
		 * @param mapData        当たり判定対象のマップデータです。
		 * @param mapObjectsData 当たり判定対象のマップオブジェクトデータです。
		 */
		public function test(mapHittables:IIterable, mapData:MapData = null, mapObjectsData:MapObjectsData = null):void
		{
			_throughState.resetTested();
			
			var it:IIterator = mapHittables.iterator();
			while (it.hasNext())
			{
				var mapHittable:IMapHittable = IMapHittable(it.next());
				
				// 処理前の当たり状況保存
				var sevedRightHit:Boolean  = mapHittable.rightHit;
				var savedLeftHit:Boolean   = mapHittable.leftHit;
				var savedTopHit:Boolean    = mapHittable.topHit;
				var savedBottomHit:Boolean = mapHittable.bottomHit;
				
				// 当たり状態リセット
				mapHittable.rightHit  = false;
				mapHittable.leftHit   = false;
				mapHittable.topHit    = false;
				mapHittable.bottomHit = false;
				
				// 当たり判定エリアが存在する場合のみ当たり判定処理を実施
				if (mapHittable.stageHitArea != null)
				{
					_testMain(mapHittable, mapData, mapObjectsData);
				}
				
				// 当たりが離れた場合のイベント
				var event:MapHitEvent;
				if (sevedRightHit && !mapHittable.rightHit)
				{
					event = new MapHitEvent(MapHitEvent.LEAVE_RIGHT);
					event.mapHittable    = mapHittable;
					event.hitArea        = mapHittable.stageHitArea;
					event.mapData        = mapData;
					event.mapObjectsData = mapObjectsData;
					dispatchEvent(event);
				}
				if (savedLeftHit && !mapHittable.leftHit)
				{
					event = new MapHitEvent(MapHitEvent.LEAVE_LEFT);
					event.mapHittable    = mapHittable;
					event.hitArea        = mapHittable.stageHitArea;
					event.mapData        = mapData;
					event.mapObjectsData = mapObjectsData;
					dispatchEvent(event);
				}
				if (savedTopHit && !mapHittable.topHit)
				{
					event = new MapHitEvent(MapHitEvent.LEAVE_TOP);
					event.mapHittable    = mapHittable;
					event.hitArea        = mapHittable.stageHitArea;
					event.mapData        = mapData;
					event.mapObjectsData = mapObjectsData;
					dispatchEvent(event);
				}
				if (savedBottomHit && !mapHittable.bottomHit)
				{
					event = new MapHitEvent(MapHitEvent.LEAVE_BOTTOM);
					event.mapHittable    = mapHittable;
					event.hitArea        = mapHittable.stageHitArea;
					event.mapData        = mapData;
					event.mapObjectsData = mapObjectsData;
					dispatchEvent(event);
				}
			}
			
			_throughState.clean();
		}
		
		/**
		 * @private
		 * 当たり判定メイン
		 * 
		 * @param mapHittable    判定対象当たり判定オブジェクト
		 * @param mapData        マップデータ
		 * @param mapObjectsData マップオブジェクトデータ
		 */
		private function _testMain(mapHittable:IMapHittable, mapData:MapData = null, mapObjectsData:MapObjectsData = null):void
		{
			var mapHittablePos:Point    = _point1; // 当たり可能オブジェクトの座標
			var befMapHittablePos:Point = _point2; // 当たり可能オブジェクトの以前の座標
			var testBefPos:Point        = _point3; // 当たり判定前座標
			var hitArea:Rectangle       = _rect1;  // 判定元当たり判定エリア
			var targetHitArea:Rectangle = _rect2;  // 判定対象当たり判定エリア
			
			var hitChipExist:Boolean = true; // マップ当たり判定対象チップが存在するならtrue
			
			var hitData:Vector.<Vector.<HitSetting>>; // 判定対象マップ当たり判定データ
			var chipWidth:uint;                       // チップ横幅
			var chipHeight:uint;                      // チップ高さ
			var hitDataWidthChip:uint;                // マップ当たり判定データのチップ単位横幅
			var hitDataHeightChip:uint;               // マップ当たり判定データのチップ単位高さ
			var hitDataWidthPx:uint;                  // マップ当たり判定データのピクセル単位横幅
			var hitDataHeightPx:uint;                 // マップ当たり判定データのピクセル単位高さ
			
			if (mapData == null)
			{
				chipWidth  = 0;
				chipHeight = 0;
			}
			else
			{
				chipWidth  = mapData.chipWidth;
				chipHeight = mapData.chipHeight;
			}
			
			// マップデータが指定されていない、または指定レイヤーがマップに存在しない場合
			if (mapData == null || mapHittable.testTargetMapLayerIndex >= mapData.mapLayerDatas.length)
			{
				// マップチップへの当たり判定無し
				hitChipExist = false;
			}
			else
			{
				hitData = mapData.mapLayerDatas[mapHittable.testTargetMapLayerIndex].hitData;
				if (hitData.length <= 0)
				{
					// マップチップへの当たり判定無し
					hitChipExist = false;
				}
				else
				{
					hitDataWidthChip  = hitData[0].length;
					hitDataHeightChip = hitData.length;
					hitDataWidthPx    = hitDataWidthChip * chipWidth;
					hitDataHeightPx   = hitDataHeightChip * chipHeight;
				}
			}
			
			// 当たり可能オブジェクトの座標
			mapHittablePos.x = mapHittable.x;
			mapHittablePos.y = mapHittable.y;
			
			// 当たり可能オブジェクトの以前の座標
			befMapHittablePos.x = mapHittable.x - mapHittable.xSpeed;
			befMapHittablePos.y = mapHittable.y - mapHittable.ySpeed;
			
			// 初期移動前座標
			testBefPos.x = befMapHittablePos.x;
			testBefPos.y = befMapHittablePos.y;
			
			// 判定元当たり判定エリアのサイズ設定
			hitArea.width  = mapHittable.stageHitArea.width;
			hitArea.height = mapHittable.stageHitArea.height;
			
			var loop:Boolean;
			if (mapData == null)
			{
				loop = false;
			}
			else
			{
				loop = mapData.loop;
			}
			var complement:uint = mapHittable.testComplement + 1;
			for (var i:uint = 1; i <= complement; i++)
			{
				_nowComplement = i;
				
				var testAftX:Number = befMapHittablePos.x + ((mapHittablePos.x - befMapHittablePos.x) * (i / complement));
				var testAftY:Number = befMapHittablePos.y + ((mapHittablePos.y - befMapHittablePos.y) * (i / complement));
				
				// 当たり判定エリアの座標設定
				if (mapHittable.right)
				{
					hitArea.x = testAftX + mapHittable.stageHitArea.x;
				}
				else
				{
					hitArea.x = testAftX + RectangleUtility.calculateReverseX(mapHittable.stageHitArea);
				}
				hitArea.y = testAftY + mapHittable.stageHitArea.y;
				
				// マップチップに対する当たり判定
				if (hitChipExist)
				{
					// 判定元判定チップのインデックス取得
					var rightChipIndex:int  = Math.floor(hitArea.right / chipWidth);
					var leftChipIndex:int   = Math.floor(hitArea.left / chipWidth);
					var topChipIndex:int    = Math.floor(hitArea.top / chipHeight);
					var bottomChipIndex:int = Math.floor(hitArea.bottom / chipHeight);
					
					// 対象当たり判定エリアのサイズ設定
					targetHitArea.width  = chipWidth;
					targetHitArea.height = chipHeight;
					
					// 左チップ～右チップ
					for (var m:int = leftChipIndex; m <= rightChipIndex; m++)
					{
						// 当たり判定外のチップは無視する
						if (m < 0 || (!loop && hitDataWidthChip <= m))
						{
							continue;
						}
						
						// 上チップ～下チップ
						for (var n:int = topChipIndex; n <= bottomChipIndex; n++)
						{
							// 当たり判定外のチップは無視する
							if (n < 0 || (!loop && hitDataHeightChip <= n))
							{
								continue;
							}
							
							var rowIndex:int = (loop ? n % hitDataHeightChip : n);
							var colIndex:int = (loop ? m % hitDataWidthChip : m);
							
							// 対象当たり判定エリアの座標設定
							targetHitArea.x = m * chipWidth;
							targetHitArea.y = n * chipHeight;
							
							// 当たり判定実行
							_testHitSetting(hitArea, mapHittable, targetHitArea, hitData[rowIndex][colIndex], mapData, mapObjectsData);
						}
					}
				}
				
				// マップオブジェクトに対する当たり判定
				if (mapObjectsData != null && mapObjectsData.hitObjects != null)
				{
					for each (var hitObject:IHitObject in mapObjectsData.hitObjects)
					{
						// 当たり判定エリア設定
						if (hitObject.right)
						{
							targetHitArea.x = hitObject.x + hitObject.hitArea.x;
						}
						else
						{
							targetHitArea.x = hitObject.x + RectangleUtility.calculateReverseX(hitObject.hitArea);
						}
						targetHitArea.y      = hitObject.y + hitObject.hitArea.y;
						targetHitArea.width  = hitObject.hitArea.width;
						targetHitArea.height = hitObject.hitArea.height;
						
						// 当たり判定実行
						_testHitSetting(hitArea, mapHittable, targetHitArea, mapObjectsData.getHitSetting(hitObject), mapData, mapObjectsData);
					}
				}
				
				testBefPos.x = testAftX;
				testBefPos.y = testAftY;
			}
		}
		
		/**
		 * @private
		 * 当たり判定実行
		 * 
		 * @param hitArea          当たり判定を行う矩形
		 * @param mapHittable      判定中当たり判定可能オブジェクト
		 * @param targetHitArea    hitAreaと当たり判定対象矩形
		 * @param targetHitSetting 当たり判定対象の当たり設定
		 * @param mapData          マップデータ
		 * @param mapObjectsData   マップオブジェクトデータ
		 */
		private function _testHitSetting(
			hitArea:Rectangle,
			mapHittable:IMapHittable,
			targetHitArea:Rectangle,
			targetHitSetting:HitSetting,
			mapData:MapData,
			mapObjectsData:MapObjectsData = null
		):void {
			// すり抜け中である場合処理しない
			if (_throughState.isThrough(mapHittable, targetHitSetting))
			{
				return;
			}
			
			// 重なり部分の矩形
			var outHitPartArea:Rectangle = _rect3;
			
			var hitDirection:HitDirection = Tester.testHitRectangleDirection(hitArea, targetHitArea, outHitPartArea);
			
			// すり抜けがある場合
			if ((hitDirection == HitDirection.RIGHT && mapHittable.throughRight) ||
			    (hitDirection == HitDirection.LEFT && mapHittable.throughLeft) ||
			    (hitDirection == HitDirection.TOP && mapHittable.throughTop) ||
			    (hitDirection == HitDirection.BOTTOM && mapHittable.throughDown)
			)
			{
				// すり抜け中として印を付けて終了
				_throughState.setThrough(mapHittable, targetHitSetting);
				return;
			}
			
			var event:MapHitEvent;
			switch (hitDirection)
			{
				// 右壁
				case HitDirection.RIGHT:
					// 左から来るオブジェクトに対して当たりが無いなら当たりとしない
					if (!targetHitSetting.leftHittable)
					{
						break;
					}
					// 右へ移動中でない場合当たりとしない
					if (mapHittable.xSpeed < 0)
					{
						break;
					}
					
					event = new MapHitEvent(MapHitEvent.HIT_RIGHT);
					event.mapHittable    = mapHittable;
					event.hitArea        = mapHittable.stageHitArea;
					event.hitSpeed       = mapHittable.xSpeed;
					event.hitPosition    = targetHitArea.left;
					_setCommonParameterOnRightHit(event);
					event.hitSetting     = targetHitSetting;
					event.mapData        = mapData;
					event.mapObjectsData = mapObjectsData;
					dispatchEvent(event);
					break;
				// 左壁
				case HitDirection.LEFT:
					// 右から来るオブジェクトに対して当たりが無いなら当たりとしない
					if (!targetHitSetting.rightHittable)
					{
						break;
					}
					// 左へ移動中でない場合当たりとしない
					if (mapHittable.xSpeed > 0)
					{
						break;
					}
					
					event = new MapHitEvent(MapHitEvent.HIT_LEFT);
					event.mapHittable    = mapHittable;
					event.hitArea        = mapHittable.stageHitArea;
					event.hitSpeed       = mapHittable.xSpeed;
					event.hitPosition    = targetHitArea.right;
					_setCommonParameterOnLeftHit(event);
					event.hitSetting     = targetHitSetting;
					event.mapData        = mapData;
					event.mapObjectsData = mapObjectsData;
					dispatchEvent(event);
					break;
				// 天井
				case HitDirection.TOP:
					// 下から来るオブジェクトに対して当たりが無いなら当たりとしない
					if (!targetHitSetting.bottomHittable)
					{
						break;
					}
					// 上へ移動中でない場合当たりとしない
					if (mapHittable.ySpeed > 0)
					{
						break;
					}
					
					event = new MapHitEvent(MapHitEvent.HIT_TOP);
					event.mapHittable    = mapHittable;
					event.hitArea        = mapHittable.stageHitArea;
					event.hitSpeed       = mapHittable.ySpeed;
					event.hitPosition    = targetHitArea.bottom;
					_setCommonParameterOnTopHit(event);
					event.hitSetting     = targetHitSetting;
					event.mapData        = mapData;
					event.mapObjectsData = mapObjectsData;
					dispatchEvent(event);
					break;
				// 地面
				case HitDirection.BOTTOM:
					// 上から来るオブジェクトに対して当たりが無いなら当たりとしない
					if (!targetHitSetting.topHittable)
					{
						break;
					}
					// 下へ移動中でない場合当たりとしない
					if (mapHittable.ySpeed < 0)
					{
						break;
					}
					
					event = new MapHitEvent(MapHitEvent.HIT_BOTTOM);
					event.mapHittable    = mapHittable;
					event.hitArea        = mapHittable.stageHitArea;
					event.hitSpeed       = mapHittable.ySpeed;
					event.hitPosition    = targetHitArea.top;
					_setCommonParameterOnBottomHit(event);
					event.hitSetting     = targetHitSetting;
					event.mapData        = mapData;
					event.mapObjectsData = mapObjectsData;
					dispatchEvent(event);
					break;
				default:
					break;
			}
		}
		
		/**
		 * @private
		 * 天井当たり共通パラメータ設定
		 * 
		 * @param event 当たりイベント
		 */
		private function _setCommonParameterOnTopHit(event:MapHitEvent):void
		{
			event.mapHittable.topHit = true;
			
			event.adjustmentPosition = event.mapHittable.y + (event.hitPosition - (event.mapHittable.y + event.hitArea.top));
		}
		
		/**
		 * @private
		 * 地面当たり共通パラメータ設定
		 * 
		 * @param event 当たりイベント
		 */
		private function _setCommonParameterOnBottomHit(event:MapHitEvent):void
		{
			event.mapHittable.bottomHit = true;
			
			event.adjustmentPosition = event.mapHittable.y + (event.hitPosition - (event.mapHittable.y + event.hitArea.bottom));
		}
		
		/**
		 * @private
		 * 右壁当たり共通パラメータ設定
		 * 
		 * @param event 当たりイベント
		 */
		private function _setCommonParameterOnRightHit(event:MapHitEvent):void
		{
			event.mapHittable.rightHit = true;
			
			event.adjustmentPosition = event.mapHittable.x + (event.hitPosition - (event.mapHittable.x + event.hitArea.right));
		}
		
		/**
		 * @private
		 * 左壁当たり共通パラメータ設定
		 * 
		 * @param event 当たりイベント
		 */
		private function _setCommonParameterOnLeftHit(event:MapHitEvent):void
		{
			event.mapHittable.leftHit = true;
			
			event.adjustmentPosition = event.mapHittable.x + (event.hitPosition - (event.mapHittable.x + event.hitArea.left));
		}
		
		/**
		 * @private
		 * 右壁当たりイベント
		 * 
		 * @param event イベント
		 */
		private function _onHitRight(event:MapHitEvent):void
		{
			var mapHittable:IMapHittable = event.mapHittable;
			
			if (_adjustment)
			{
				_setYForComplement(event.hitArea, mapHittable);
				mapHittable.xSpeed = 0;
				mapHittable.x      = event.adjustmentPosition;
			}
			
			mapHittable.dispatchEvent(event);
		}
		
		/**
		 * @private
		 * 左壁当たりイベント
		 * 
		 * @param event イベント
		 */
		private function _onHitLeft(event:MapHitEvent):void
		{
			var mapHittable:IMapHittable = event.mapHittable;
			
			if (_adjustment)
			{
				_setYForComplement(event.hitArea, mapHittable);
				mapHittable.xSpeed = 0;
				mapHittable.x      = event.adjustmentPosition;
			}
			
			mapHittable.dispatchEvent(event);
		}
		
		/**
		 * @private
		 * 天井当たりイベント
		 * 
		 * @param event イベント
		 */
		private function _onHitTop(event:MapHitEvent):void
		{
			var mapHittable:IMapHittable = event.mapHittable;
			
			if (_adjustment)
			{
				_setXForComplement(event.hitArea, mapHittable);
				mapHittable.ySpeed = 0;
				mapHittable.y      = event.adjustmentPosition;
			}
			
			mapHittable.dispatchEvent(event);
		}
		
		/**
		 * @private
		 * 地面当たりイベント
		 * 
		 * @param event イベント
		 */
		private function _onHitBottom(event:MapHitEvent):void
		{
			var mapHittable:IMapHittable = event.mapHittable;
			
			if (_adjustment)
			{
				_setXForComplement(event.hitArea, mapHittable);
				mapHittable.ySpeed = 0;
				mapHittable.y      = event.adjustmentPosition;
			}
			
			mapHittable.dispatchEvent(event);
		}
		
		/**
		 * @private
		 * 当たりが離れたときのイベントハンドラ
		 * 
		 * @param event イベント
		 */
		private function _onLeave(event:MapHitEvent):void
		{
			event.mapHittable.dispatchEvent(event);
		}
		
		/**
		 * @private
		 * 補完当たり判定があった後の x 座標調整
		 * 
		 * @param hitArea     当たり判定エリア
		 * @param mapHittable マップ当たり判定対象
		 */
		private function _setXForComplement(hitArea:Rectangle, mapHittable:IMapHittable):void
		{
			// y軸方向スピードがマップチップサイズを超えている場合に調整する
			if (Math.abs(mapHittable.ySpeed) > hitArea.height)
			{
				var rate:Number = 1 / mapHittable.testComplement;
				var num:uint = _nowComplement;
				var objX:Number = mapHittable.x - mapHittable.xSpeed;
				var moveXSpeed:Number = mapHittable.xSpeed * rate;
				
				mapHittable.x = objX + moveXSpeed * num;
			}
		}
		
		/**
		 * @private
		 * 補完当たり判定があった後の y 座標調整
		 * 
		 * @param hitArea     当たり判定エリア
		 * @param mapHittable マップ当たり判定対象
		 */
		private function _setYForComplement(hitArea:Rectangle, mapHittable:IMapHittable):void
		{
			// x軸方向スピードがマップチップサイズを超えている場合に調整する
			if (Math.abs(mapHittable.xSpeed) > hitArea.width)
			{
				var rate:Number = 1 / mapHittable.testComplement;
				var num:uint = _nowComplement;
				var objY:Number = mapHittable.y - mapHittable.ySpeed;
				var moveYSpeed:Number = mapHittable.ySpeed * rate;
				
				mapHittable.y = objY + moveYSpeed * num;
			}
		}
	}
}

import flash.utils.Dictionary;
import org.ahiufomasao.yasume.map.HitSetting;
import org.ahiufomasao.yasume.map.IMapHittable;

/**
 * @private
 * すり抜け状態
 */
class ThroughState
{
	private var _throughStatesDict:Dictionary;
	
	/**
	 * コンストラクタ
	 */
	public function ThroughState()
	{
		_throughStatesDict = new Dictionary();
	}
	
	/**
	 * すり抜け状態であると設定
	 * 
	 * @param mapHittable キーとする当たり可能オブジェクト
	 * @param hitSetting  キーとする当たり設定オブジェクト
	 */
	public function setThrough(mapHittable:IMapHittable, hitSetting:HitSetting):void
	{
		if (_throughStatesDict[mapHittable] == undefined)
		{
			_throughStatesDict[mapHittable] = new Dictionary();
		}
		if (_throughStatesDict[mapHittable][hitSetting] == undefined)
		{
			_throughStatesDict[mapHittable][hitSetting] = true;
		}
	}
	
	/**
	 * すり抜け状態であるかどうかチェック
	 * 
	 * @param mapHittable キーとする当たり可能オブジェクト
	 * @param hitSetting  キーとする当たり設定オブジェクト
	 * 
	 * @return すり抜け状態である場合 true
	 */
	public function isThrough(mapHittable:IMapHittable, hitSetting:HitSetting):Boolean
	{
		if (_throughStatesDict[mapHittable] == undefined)
		{
			return false;
		}
		if (_throughStatesDict[mapHittable][hitSetting] == undefined)
		{
			return false;
		}
		_throughStatesDict[mapHittable][hitSetting] = true;
		return true;
	}
	
	/**
	 * 当たり判定済みであるという印をリセット
	 */
	public function resetTested():void
	{
		for each (var throughStates:Dictionary in _throughStatesDict)
		{
			for (var hitSetting:Object in throughStates)
			{
				throughStates[hitSetting] = false;
			}
		}
	}
	
	/**
	 * 判定されなかったオブジェクトを削除
	 */
	public function clean():void
	{
		var throughStatesDict:Dictionary = _throughStatesDict;
		
		for (var mapHittable:Object in throughStatesDict)
		{
			var throughStates:Dictionary = throughStatesDict[mapHittable];
			
			var hitSetting:Object;
			
			// 判定処理を通っていないすり抜け状態データは削除する
			for (hitSetting in throughStates)
			{
				if (!throughStates[hitSetting])
				{
					delete throughStates[hitSetting];
				}
			}
			
			// すり抜け状態データが1件も無い場合、設定データリストを削除する
			var empty:Boolean = true;
			for (hitSetting in throughStates)
			{
				empty = false;
				break;
			}
			if (empty)
			{
				delete throughStatesDict[mapHittable];
			}
		}
	}
}