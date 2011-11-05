package org.ahiufomasao.yasume.timeline 
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import org.ahiufomasao.utility.RectangleUtility;
	import org.ahiufomasao.yasume.events.HitAreaHitEvent;
	import org.ahiufomasao.yasume.utils.HitDirection;
	import org.ahiufomasao.yasume.utils.Tester;
	
	/**
	 * <code>testPush</code> メソッドを呼び出した際、押し当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.HitAreaHitEvent.PUSH
	 * 
	 * @see #testPush()
	 */
	[Event(name="push", type="org.ahiufomasao.yasume.events.HitAreaHitEvent")]
	/**
	 * <code>testAttackHit</code> メソッドを呼び出した際、攻撃当たりがあった場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.HitAreaHitEvent.ATTACK_HIT
	 * 
	 * @see #testAttackHit()
	 */
	[Event(name="attackHit", type="org.ahiufomasao.yasume.events.HitAreaHitEvent")]
	/**
	 * <code>testAttackHit</code> メソッドを呼び出した際、攻撃相殺が発生した場合に送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.HitAreaHitEvent.COUNTERBALANCE
	 * 
	 * @see #testAttackHit()
	 */
	[Event(name="counterbalance", type="org.ahiufomasao.yasume.events.HitAreaHitEvent")]
	
	/**
	 * <code>HitAreaHitTester</code> クラスは、オブジェクト群同士の当たり判定を行います.
	 * <p>
	 * 判定対象の <code>IHitAreaHittable</code> オブジェクトを、
	 * グループ1、グループ2、グループ1所属オブジェクト、グループ2所属オブジェクト、無所属オブジェクトとして分けて当たり判定を行ないます。
	 * </p>
	 * <p>
	 * 押し当たり判定、攻撃当たり判定はそれぞれ <code>testPush</code> メソッドと <code>testAttackHit</code> メソッドを呼び出すことで行います。
	 * 押し当たり判定は、<code>IHitAreaHittable</code> オブジェクト同士の <code>pushHitArea</code> プロパティに対して行われます。
	 * 攻撃当たり判定は、攻撃側の <code>IHitAreaHittable</code> オブジェクトの <code>attackHitArea</code> プロパティが、 
	 * 攻撃を受ける側の <code>IHitAreaHittable</code> オブジェクトの <code>attackHitArea</code> プロパティと
	 * <code>damageHitArea</code> プロパティに当たっているかを判定します。
	 * 攻撃側と攻撃を受ける側オブジェクトの <code>attackHitArea</code> プロパティ同士に対しては攻撃相殺判定を行います。
	 * 攻撃相殺判定の結果、相殺が発生しない場合に攻撃を受ける側オブジェクトの <code>damageHitArea</code> プロパティを対象としたダメージ当たり判定を行います。
	 * </p>
	 * <p>
	 * <code>addDefaultHitEventListener</code> メソッドを呼び出すことで、
	 * 押しの当たり判定があった場合、押し合っている各 <code>IHitAreaHittable</code> オブジェクトの 
	 * <code>HitAreaHitEvent.PUSH</code> イベントが発生するようになります。
	 * 攻撃の当たり判定があった場合は、攻撃側 <code>IHitAreaHittable</code> オブジェクトの 
	 * <code>HitAreaHitEvent.ATTACK_HIT</code> イベントが、
	 * 攻撃を受ける側 <code>IHitAreaHittable</code> オブジェクトの 
	 * <code>HitAreaHitEvent.DAMAGED</code> イベントが発生するようになります。
	 * また攻撃相殺が発生した場合は、各 <code>IHitAreaHittable</code> オブジェクトの 
	 * <code>HitAreaHitEvent.COUNTERBALANCE</code> イベントが発生するようになります。
	 * <code>removeDefaultHitEventListener</code> メソッドを呼び出すことで、上記イベントは発生しなくなります。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see IHitAreaHittable
	 * @see #testPush
	 * @see #testAttackHit
	 * @see IHitAreaHittable#pushHitArea
	 * @see IHitAreaHittable#attackHitArea
	 * @see IHitAreaHittable#damageHitArea
	 * @see #addDefaultHitEventListener
	 * @see HitAreaHitEvent#PUSH
	 * @see HitAreaHitEvent#ATTACK_HIT
	 * @see HitAreaHitEvent#DAMAGED
	 * @see HitAreaHitEvent#COUNTERBALANCE
	 * @see #removeDefaultHitEventListener
	 */
	public class HitAreaHitTester extends EventDispatcher
	{
		private var _rect1:Rectangle; // 汎用矩形1
		private var _rect2:Rectangle; // 汎用矩形2
		
		private var _eventAdded:Boolean; // 一般的な当たり判定イベントを登録済みなら true
		
		/**
		 * 新しい <code>HitAreaHitTester</code> クラスのインスタンスを生成します.
		 */
		public function HitAreaHitTester() 
		{
			_rect1 = new Rectangle();
			_rect2 = new Rectangle();
			
			_eventAdded = false;
		}
		
		/**
		 * 一般的な当たり判定処理のイベントハンドラを定義します.
		 * <p>
		 * <code>addDefaultHitEventListener</code> メソッドを呼び出すことで、
		 * 押しの当たりがあった場合、押し合っている各 <code>IHitAreaHittable</code> オブジェクトへ 
		 * <code>HitAreaHitEvent.PUSH</code> イベントが送出されるようになります。
		 * また、攻撃の当たりがあった場合、攻撃側 <code>IHitAreaHittable</code> オブジェクトへ 
		 * <code>HitAreaHitEvent.ATTACK_HIT</code> イベントが、
		 * 攻撃を受けた側の <code>IHitAreaHittable</code> オブジェクトの 
		 * <code>HitAreaHitEvent.DAMAGED</code> イベントが送出されるようになります。
		 * 攻撃相殺が発生した場合、攻撃し合っている各 <code>IHitAreaHittable</code> オブジェクトへ 
		 * <code>HitAreaHitEvent.COUNTERBALANCE</code> イベントが送出されるようになります。
		 * </p>
		 * 
		 * @throws IllegalOperationError イベントハンドラが定義済みの状態で再度 <code>addDefaultHitEventListener</code> が呼び出された場合にスローされます。
		 * 
		 * @see #removeDefaultHitEventListener
		 */
		public function addDefaultHitEventListener():void
		{
			if (_eventAdded)
			{
				throw new IllegalOperationError("すでにイベントが定義されています。");
			}
			
			addEventListener(HitAreaHitEvent.PUSH, _onPush);
			addEventListener(HitAreaHitEvent.ATTACK_HIT, _onAttackHit);
			addEventListener(HitAreaHitEvent.COUNTERBALANCE, _onCounterbalance);
			
			_eventAdded = true;
		}
		
		/**
		 * <code>addDefaultHitEventListener</code> メソッドで定義されたイベントハンドラを削除します.
		 * 
		 * @throws IllegalOperationError イベントハンドラが未定義の状態で <code>removeDefaultHitEventListener</code> が呼び出された場合にスローされます。
		 * 
		 * @see #addDefaultHitEventListener
		 */
		public function removeDefaultHitEventListener():void
		{
			if (!_eventAdded)
			{
				throw new IllegalOperationError("イベントが定義されていません。");
			}
			
			removeEventListener(HitAreaHitEvent.PUSH, _onPush);
			removeEventListener(HitAreaHitEvent.ATTACK_HIT, _onAttackHit);
			removeEventListener(HitAreaHitEvent.COUNTERBALANCE, _onCounterbalance);
			
			_eventAdded = false;
		}
		
		/**
		 * 押し当たり判定を行います.
		 * <p>
		 * 押し当たり判定は、<code>IHitAreaHittable</code> オブジェクト同士の <code>pushHitArea</code> プロパティに対して行います。
		 * 指定された <code>Vector</code> オブジェクトに登録された全オブジェクトに対し、総当りで 1 回ずつ当たり判定を行ないます。
		 * </p>
		 * 
		 * @param group1             グループ1の判定対象群です。
		 * @param group2             グループ2の判定対象群です。
		 * @param group1SideObjects  グループ1所属のオブジェクトの判定対象群です。
		 * @param group2SideObjects  グループ2所属のオブジェクトの判定対象群です。
		 * @param anotherSideObjects 無所属のオブジェクトの判定対象群です。
		 */
		public function testPush(
		    group1:Vector.<IHitAreaHittable> = null,
		    group2:Vector.<IHitAreaHittable> = null,
		    group1SideObjects:Vector.<IHitAreaHittable> = null,
		    group2SideObjects:Vector.<IHitAreaHittable> = null,
			anotherSideObjects:Vector.<IHitAreaHittable> = null
		):void
		{
			var pushObject:IHitAreaHittable; // 判定対象
			var pushHitArea:PushHitArea;     // 判定対象エリア
			var i:uint;                      // 配列走査用
			var length:uint;                 // 配列の長さ
			
			// グループ1対
			if (group1 != null)
			{
				length = group1.length;
				for (i = 0; i < length; i++)
				{
					pushObject  = group1[i];
					pushHitArea = pushObject.pushHitArea;
					
					// 押し当たり判定エリアが無い場合判定しない
					if (pushHitArea == null)
					{
						continue;
					}
					
					// グループ1
					_testPushedSide(pushObject, pushHitArea, group1, i + 1);
					// グループ2
					_testPushedSide(pushObject, pushHitArea, group2);
					// グループ1所属のオブジェクト
					_testPushedSide(pushObject, pushHitArea, group1SideObjects);
					// グループ2所属のオブジェクト
					_testPushedSide(pushObject, pushHitArea, group2SideObjects);
					// 無所属のオブジェクト
					_testPushedSide(pushObject, pushHitArea, anotherSideObjects);
				}
			}
			
			// グループ2対
			if (group2 != null)
			{
				length = group2.length;
				for (i = 0; i < length; i++)
				{
					pushObject  = group2[i];
					pushHitArea = pushObject.pushHitArea;
					
					// 押し当たり判定エリアが無い場合判定しない
					if (pushHitArea == null)
					{
						continue;
					}
					
					// グループ2
					_testPushedSide(pushObject, pushHitArea, group2, i + 1);
					// グループ1所属のオブジェクト
					_testPushedSide(pushObject, pushHitArea, group1SideObjects);
					// グループ2所属のオブジェクト
					_testPushedSide(pushObject, pushHitArea, group2SideObjects);
					// 無所属のオブジェクト
					_testPushedSide(pushObject, pushHitArea, anotherSideObjects);
				}
			}
			
			// グループ1所属のオブジェクト対
			if (group1SideObjects != null)
			{
				length = group1SideObjects.length;
				for (i = 0; i < length; i++)
				{
					pushObject  = group1SideObjects[i];
					pushHitArea = pushObject.pushHitArea;
					
					// 押し当たり判定エリアが無い場合判定しない
					if (pushHitArea == null)
					{
						continue;
					}
					
					// グループ1所属のオブジェクト
					_testPushedSide(pushObject, pushHitArea, group1SideObjects, i + 1);
					// グループ2所属のオブジェクト
					_testPushedSide(pushObject, pushHitArea, group2SideObjects);
					// 無所属のオブジェクト
					_testPushedSide(pushObject, pushHitArea, anotherSideObjects);
				}
			}
			
			// グループ2所属のオブジェクト対
			if (group2SideObjects != null)
			{
				length = group2SideObjects.length;
				for (i = 0; i < length; i++)
				{
					pushObject  = group2SideObjects[i];
					pushHitArea = pushObject.pushHitArea;
					
					// 押し当たり判定エリアが無い場合判定しない
					if (pushHitArea == null)
					{
						continue;
					}
					
					// グループ2所属のオブジェクト
					_testPushedSide(pushObject, pushHitArea, group2SideObjects, i + 1);
					// 無所属のオブジェクト
					_testPushedSide(pushObject, pushHitArea, anotherSideObjects);
				}
			}
			
			// 無所属のオブジェクト対
			if (anotherSideObjects != null)
			{
				length = anotherSideObjects.length;
				for (i = 0; i < length; i++)
				{
					pushObject  = anotherSideObjects[i];
					pushHitArea = pushObject.pushHitArea;
					
					// 押し当たり判定エリアが無い場合判定しない
					if (pushHitArea == null)
					{
						continue;
					}
					
					// 無所属のオブジェクト
					_testPushedSide(pushObject, pushHitArea, anotherSideObjects, i + 1);
				}
			}
		}
		
		/**
		 * @private
		 * 押され側判定
		 * 
		 * @param pushObject        押す側のオブジェクト
		 * @param pushHitArea       押し当たり判定エリア
		 * @param pushedSideObjects 押される側オブジェクトのリスト
		 * @param startIndex        判定を開始する押される側オブジェクトのリストのインデックス
		 */
		private function _testPushedSide(
			pushObject:IHitAreaHittable,
			pushHitArea:PushHitArea,
			pushedSideObjects:Vector.<IHitAreaHittable>,
			startIndex:uint = 0
		):void
		{
			// 押され側オブジェクトリストが未指定なら処理しない
			if (pushedSideObjects == null)
			{
				return
			}
			
			var pushHitAreaRectangle:Rectangle = pushHitArea.rectangle; // 押し側押し当たり判定エリア
			
			var pushedObject:IHitAreaHittable;    // 押される側のオブジェクト
			var pushedHitArea:PushHitArea;        // 押される側押し当たり判定エリア
			var pushedHitAreaRectangle:Rectangle; // 押される側押し当たり判定エリア
			
			var hitEvent:HitAreaHitEvent;      // 当たり判定イベント
			var hitDirection:HitDirection;     // 当たり方向
			var hitPartArea:Rectangle;         // 判定エリアの重なり範囲
			
			var noHitDirection:HitDirection = HitDirection.NONE; // 当たり無しEnum
			
			var rect1:Rectangle = _rect1;
			var rect2:Rectangle = _rect2;
			
			// 押され側判定
			var length:uint = pushedSideObjects.length;
			for (var i:uint = startIndex; i < length; i++)
			{
				pushedObject = pushedSideObjects[i];
				// 自分自身に対する判定である場合は判定しない
				if (pushObject == pushedObject)
				{
					continue;
				}
				
				pushedHitArea = pushedObject.pushHitArea;
				// 押し当たり判定エリアが無い場合判定しない
				if (pushedHitArea == null)
				{
					continue;
				}
				
				pushedHitAreaRectangle = pushedHitArea.rectangle;
				
				// 当たり判定
				// エリア座標調整
				if (pushObject.right)
				{
					rect1.x = pushObject.x + pushHitAreaRectangle.x;
				}
				else
				{
					rect1.x = pushObject.x + RectangleUtility.calculateReverseX(pushHitAreaRectangle);
				}
				rect1.y      = pushObject.y + pushHitAreaRectangle.y;
				rect1.width  = pushHitAreaRectangle.width;
				rect1.height = pushHitAreaRectangle.height;
				
				if (pushedObject.right)
				{
					rect2.x = pushedObject.x + pushedHitAreaRectangle.x;
				}
				else
				{
					rect2.x = pushedObject.x + RectangleUtility.calculateReverseX(pushedHitAreaRectangle);
				}
				rect2.y      = pushedObject.y + pushedHitAreaRectangle.y;
				rect2.width  = pushedHitAreaRectangle.width;
				rect2.height = pushedHitAreaRectangle.height;
				
				// 押しヒット
				hitPartArea  = new Rectangle();
				hitDirection = Tester.testHitRectangleDirection(rect1, rect2, hitPartArea);
				if (hitDirection != noHitDirection)
				{
					hitEvent = new HitAreaHitEvent(HitAreaHitEvent.PUSH);
					hitEvent.sourceHitTestable = pushObject;
					hitEvent.sourceHitArea     = pushHitArea;
					hitEvent.targetHitTestable = pushedObject;
					hitEvent.targetHitArea     = pushedHitArea;
					hitEvent.hitDirection      = hitDirection;
					hitEvent.hitPartArea       = hitPartArea;
					dispatchEvent(hitEvent);
				}
			}
		}
		
		/**
		 * 攻撃当たり判定を行います.
		 * <p>
		 * 攻撃当たり判定は、攻撃側 <code>IHitAreaHittable</code> オブジェクトの <code>attackHitArea</code> プロパティと
		 * 攻撃を受ける側 <code>IHitAreaHittable</code> オブジェクトの <code>attackHitArea</code> プロパティまたは 
		 * <code>damageHitArea</code> プロパティに対して行います。
		 * 攻撃側と攻撃を受ける側オブジェクトの <code>attackHitArea</code> プロパティ同士に対して当たりがある場合、攻撃相殺処理を行ないます。
		 * 攻撃相殺が発生しない場合に攻撃を受ける側オブジェクトの <code>damageHitArea</code> プロパティを対象としたダメージ当たり判定を行います。
		 * </p>
		 * <p>
		 * パラメータに登録されたオブジェクトの当たり判定が持つ攻撃対象設定と、攻撃対象となるパラメータの対応表は以下です。
		 * </p>
		 * <p>
		 * <code>group1</code>、<code>group1SideObjects</code> パラメータ
		 * <table class="innertable">
		 * <tr><th>攻撃対象設定</th><th>攻撃対象パラメータ</th></tr>
		 * <tr><td>AttackTarget.FRIEND</td><td>group1</td></tr>
		 * <tr><td>AttackTarget.ENEMY</td><td>group2</td></tr>
		 * <tr><td>AttackTarget.FRIEND_SIDE_OBJECT</td><td>group1SideObjects</td></tr>
		 * <tr><td>AttackTarget.ENEMY_SIDE_OBJECT</td><td>group2SideObjects</td></tr>
		 * <tr><td>AttackTarget.ANOTHER_SIDE_OBJECT</td><td>anotherSideObjects</td></tr>
		 * </table>
		 * </p>
		 * <p>
		 * <code>group2</code>、<code>group2SideObjects</code> パラメータ
		 * <table class="innertable">
		 * <tr><th>攻撃対象設定</th><th>攻撃対象パラメータ</th></tr>
		 * <tr><td>AttackTarget.FRIEND</td><td>group2</td></tr>
		 * <tr><td>AttackTarget.ENEMY</td><td>group1</td></tr>
		 * <tr><td>AttackTarget.FRIEND_SIDE_OBJECT</td><td>group2SideObjects</td></tr>
		 * <tr><td>AttackTarget.ENEMY_SIDE_OBJECT</td><td>group1SideObjects</td></tr>
		 * <tr><td>AttackTarget.ANOTHER_SIDE_OBJECT</td><td>anotherSideObjects</td></tr>
		 * </table>
		 * </p>
		 * <p>
		 * <code>anotherSideObjects</code> パラメータ
		 * <table class="innertable">
		 * <tr><th>攻撃対象設定</th><th>攻撃対象パラメータ</th></tr>
		 * <tr><td>AttackTarget.FRIEND または AttackTarget.ENEMY</td><td>group1 および group2</td></tr>
		 * <tr><td>AttackTarget.FRIEND_SIDE_OBJECT または AttackTarget.ENEMY_SIDE_OBJECT</td><td>group1SideObjects および group2SideObjects</td></tr>
		 * <tr><td>AttackTarget.ANOTHER_SIDE_OBJECT</td><td>anotherSideObjects</td></tr>
		 * </table>
		 * </p>
		 * 
		 * @param group1             グループ1の判定対象群です。
		 * @param group2             グループ2の判定対象群です。
		 * @param group1SideObjects  グループ1所属のオブジェクトの判定対象群です。
		 * @param group2SideObjects  グループ2所属のオブジェクトの判定対象群です。
		 * @param anotherSideObjects 無所属のオブジェクトの判定対象群です。
		 */
		public function testAttackHit(
		    group1:Vector.<IHitAreaHittable> = null,
		    group2:Vector.<IHitAreaHittable> = null,
		    group1SideObjects:Vector.<IHitAreaHittable> = null,
		    group2SideObjects:Vector.<IHitAreaHittable> = null,
			anotherSideObjects:Vector.<IHitAreaHittable> = null
		):void
		{
			var counterbalancedPairs:CounterbalancedPairs = new CounterbalancedPairs();
			
			var attackObject:IHitAreaHittable; // 攻撃する側の戦闘オブジェクト
			var attackHitArea:AttackHitArea;   // 攻撃当たり判定エリア
			
			// 攻撃対象名
			var friendTarget:AttackTarget      = AttackTarget.FRIEND;
			var enemyTarget:AttackTarget       = AttackTarget.ENEMY;
			var friendSideTarget:AttackTarget  = AttackTarget.FRIEND_SIDE_OBJECT;
			var enemySideTarget:AttackTarget   = AttackTarget.ENEMY_SIDE_OBJECT;
			var anotherSideTarget:AttackTarget = AttackTarget.ANOTHER_SIDE_OBJECT;
			
			// グループ1対
			if (group1 != null)
			{
				for each (attackObject in group1)
				{
					attackHitArea = attackObject.attackHitArea;
					
					// 攻撃当たり判定エリアが無い場合判定しない
					if (attackHitArea == null)
					{
						continue;
					}
					
					// グループ1
					if (attackHitArea.containTarget(friendTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group1, counterbalancedPairs);
					}
					// グループ2
					if (attackHitArea.containTarget(enemyTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group2, counterbalancedPairs);
					}
					// グループ1所属のオブジェクト
					if (attackHitArea.containTarget(friendSideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group1SideObjects, counterbalancedPairs);
					}
					// グループ2所属のオブジェクト
					if (attackHitArea.containTarget(enemySideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group2SideObjects, counterbalancedPairs);
					}
					// 無所属のオブジェクト
					if (attackHitArea.containTarget(anotherSideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, anotherSideObjects, counterbalancedPairs);
					}
				}
			}
			
			// グループ2対
			if (group2 != null)
			{
				for each (attackObject in group2)
				{
					attackHitArea = attackObject.attackHitArea;
					
					// 攻撃当たり判定エリアが無い場合判定しない
					if (attackHitArea == null)
					{
						continue;
					}
					
					// グループ1
					if (attackHitArea.containTarget(enemyTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group1, counterbalancedPairs);
					}
					// グループ2
					if (attackHitArea.containTarget(friendTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group2, counterbalancedPairs);
					}
					// グループ1所属のオブジェクト
					if (attackHitArea.containTarget(enemySideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group1SideObjects, counterbalancedPairs);
					}
					// グループ2所属のオブジェクト
					if (attackHitArea.containTarget(friendSideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group2SideObjects, counterbalancedPairs);
					}
					// 無所属のオブジェクト
					if (attackHitArea.containTarget(anotherSideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, anotherSideObjects, counterbalancedPairs);
					}
				}
			}
			
			// グループ1所属のオブジェクト対
			if (group1SideObjects != null)
			{
				for each (attackObject in group1SideObjects)
				{
					attackHitArea = attackObject.attackHitArea;
					
					// 攻撃当たり判定エリアが無い場合判定しない
					if (attackHitArea == null)
					{
						continue;
					}
					
					// グループ1
					if (attackHitArea.containTarget(friendTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group1, counterbalancedPairs);
					}
					// グループ2
					if (attackHitArea.containTarget(enemyTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group2, counterbalancedPairs);
					}
					// グループ1所属のオブジェクト
					if (attackHitArea.containTarget(friendSideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group1SideObjects, counterbalancedPairs);
					}
					// グループ2所属のオブジェクト
					if (attackHitArea.containTarget(enemySideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group2SideObjects, counterbalancedPairs);
					}
					// 無所属のオブジェクト
					if (attackHitArea.containTarget(anotherSideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, anotherSideObjects, counterbalancedPairs);
					}
				}
			}
			
			// グループ2所属のオブジェクト対
			if (group2SideObjects != null)
			{
				for each (attackObject in group2SideObjects)
				{
					attackHitArea = attackObject.attackHitArea;
					
					// 攻撃当たり判定エリアが無い場合判定しない
					if (attackHitArea == null)
					{
						continue;
					}
					
					// グループ1
					if (attackHitArea.containTarget(enemyTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group1, counterbalancedPairs);
					}
					// グループ2
					if (attackHitArea.containTarget(friendTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group2, counterbalancedPairs);
					}
					// グループ1所属のオブジェクト
					if (attackHitArea.containTarget(enemySideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group1SideObjects, counterbalancedPairs);
					}
					// グループ2所属のオブジェクト
					if (attackHitArea.containTarget(friendSideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group2SideObjects, counterbalancedPairs);
					}
					// 無所属のオブジェクト
					if (attackHitArea.containTarget(anotherSideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, anotherSideObjects, counterbalancedPairs);
					}
				}
			}
			
			// 無所属のオブジェクト対
			if (anotherSideObjects != null)
			{
				for each (attackObject in anotherSideObjects)
				{
					attackHitArea = attackObject.attackHitArea;
					
					// 攻撃当たり判定エリアが無い場合判定しない
					if (attackHitArea == null)
					{
						continue;
					}
					
					// グループ1とグループ2
					if (attackHitArea.containTarget(friendTarget) || attackHitArea.containTarget(enemyTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group1, counterbalancedPairs);
						_testDamageSide(attackObject, attackHitArea, group2, counterbalancedPairs);
					}
					// グループ1所属とグループ2所属のオブジェクト
					if (attackHitArea.containTarget(friendSideTarget) || attackHitArea.containTarget(enemySideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, group1SideObjects, counterbalancedPairs);
						_testDamageSide(attackObject, attackHitArea, group2SideObjects, counterbalancedPairs);
					}
					// 無所属のオブジェクト
					if (attackHitArea.containTarget(anotherSideTarget))
					{
						_testDamageSide(attackObject, attackHitArea, anotherSideObjects, counterbalancedPairs);
					}
				}
			}
		}
		
		/**
		 * @private
		 * 防御側判定
		 * 
		 * @param attackObject         攻撃する側のオブジェクト
		 * @param attackHitArea        攻撃当たり判定エリア
		 * @param damageSideObjects    防御側のオブジェクトのリスト
		 * @param counterbalancedPairs 攻撃相殺済みペアリスト
		 */
		private function _testDamageSide(
			attackObject:IHitAreaHittable,
			attackHitArea:AttackHitArea,
			damageSideObjects:Vector.<IHitAreaHittable>,
			counterbalancedPairs:CounterbalancedPairs
		):void
		{
			// 防御側オブジェクトリストが未指定なら処理しない
			if (damageSideObjects == null)
			{
				return;
			}
			
			var testStop:Boolean = false; // 1オブジェクトに対する判定処理を中断するならtrue
			
			var attackHitAreaRectangle:Rectangle;                    // 攻撃当たり判定エリア矩形
			var attackGroup:AttackGroup = attackHitArea.attackGroup; // 攻撃グループ
			
			var damageObject:IHitAreaHittable;      // ダメージを受ける側の戦闘オブジェクト
			var attackedHitArea:AttackHitArea;      // 攻撃される側攻撃当たり判定エリア
			var attackedHitAreaRectangle:Rectangle; // 攻撃される側攻撃当たり判定エリア矩形
			var attackedGroup:AttackGroup;          // 攻撃される側攻撃グループ
			var damageHitArea:DamageHitArea;        // ダメージ当たり判定エリア
			var damageHitAreaRectangle:Rectangle;   // ダメージ当たり判定エリア矩形
			
			var counterbalanceRunnable:Boolean;   // 相殺判定実行フラグ
			
			var hitEvent:HitAreaHitEvent;         // 当たり判定イベント
			var hitDirection:HitDirection;        // 当たり方向
			var hitPartArea:Rectangle;            // 判定エリアの重なり範囲
			
			// 当たり無し
			var noHitDirection:HitDirection = HitDirection.NONE;
			
			var rect1:Rectangle = _rect1;
			var rect2:Rectangle = _rect2;
			
			// 防御側判定
			for each (damageObject in damageSideObjects)
			{
				// 自分自身に対する判定である場合は判定しない
				if (attackObject == damageObject)
				{
					continue;
				}
				
				// すでに相殺が発生している組み合わせであるなら処理しない
				if (counterbalancedPairs.exists(attackObject, damageObject))
				{
					continue;
				}
				
				testStop = false;
				
				attackedHitArea = damageObject.attackHitArea;
				
				// 攻撃を受ける側の攻撃当たり判定エリアが設定されている場合のみ攻撃相殺判定を行う
				if (attackedHitArea != null)
				{
					attackedGroup = attackedHitArea.attackGroup;
					
					// 攻撃相殺実行判定
					counterbalanceRunnable = false;
					// 攻撃する、される両方の攻撃当たり判定エリアの攻撃相殺フラグが true であるかつ
					if (attackHitArea.counterbalance && attackedHitArea.counterbalance)
					{
						// 双方攻撃グループが設定されていないなら相殺処理実行
						if (attackGroup == null && attackedGroup == null)
						{
							counterbalanceRunnable = true;
						}
						// 攻撃される側にだけ攻撃グループが設定されており、その攻撃グループに相手が設定されていないなら相殺処理実行
						else if (attackGroup == null && attackedGroup != null)
						{
							if (!attackedGroup.containHittable(attackObject))
							{
								counterbalanceRunnable = true;
							}
						}
						// 攻撃する側にだけ攻撃グループが設定されており、その攻撃グループに相手が設定されていないなら相殺処理実行
						else if (attackGroup != null && attackedGroup == null)
						{
							if (!attackGroup.containHittable(damageObject))
							{
								counterbalanceRunnable = true;
							}
						}
						// 双方の攻撃グループにお互いが登録されていない場合相殺処理実行
						else
						{
							if (!attackGroup.containHittable(damageObject) && !attackedGroup.containHittable(attackObject))
							{
								counterbalanceRunnable = true;
							}
						}
					}
					
					// 攻撃相殺実行フラグが true である場合に判定処理を行う
					if (counterbalanceRunnable)
					{
						// 攻撃側の複数矩形すべてに対して当たり判定を行う
						for each (attackHitAreaRectangle in attackHitArea.rectangles)
						{
							// 攻撃する側の攻撃当たり判定エリアの座標調整
							if (attackObject.right)
							{
								rect1.x = attackObject.x + attackHitAreaRectangle.x;
							}
							else
							{
								rect1.x = attackObject.x + RectangleUtility.calculateReverseX(attackHitAreaRectangle);
							}
							rect1.y      = attackObject.y + attackHitAreaRectangle.y;
							rect1.width  = attackHitAreaRectangle.width;
							rect1.height = attackHitAreaRectangle.height;
							
							// 攻撃される側の複数矩形すべてに対して当たり判定を行う
							for each (attackedHitAreaRectangle in attackedHitArea.rectangles)
							{
								// 攻撃される側の攻撃当たり判定エリアの座標調整
								if (damageObject.right)
								{
									rect2.x = damageObject.x + attackedHitAreaRectangle.x;
								}
								else
								{
									rect2.x = damageObject.x + RectangleUtility.calculateReverseX(attackedHitAreaRectangle);
								}
								rect2.y      = damageObject.y + attackedHitAreaRectangle.y;
								rect2.width  = attackedHitAreaRectangle.width;
								rect2.height = attackedHitAreaRectangle.height;
								
								// 判定
								hitPartArea  = new Rectangle();
								hitDirection = Tester.testHitRectangleDirection(rect1, rect2, hitPartArea);
								if (hitDirection != noHitDirection)
								{
									hitEvent = new HitAreaHitEvent(HitAreaHitEvent.COUNTERBALANCE);
									hitEvent.sourceHitTestable = attackObject;
									hitEvent.sourceHitArea     = attackHitArea;
									hitEvent.targetHitTestable = damageObject;
									hitEvent.targetHitArea     = attackedHitArea;
									hitEvent.hitDirection      = hitDirection;
									hitEvent.hitPartArea       = hitPartArea;
									dispatchEvent(hitEvent);
									
									// 攻撃する側の攻撃グループに相手オブジェクトを登録
									if (attackGroup != null)
									{
										attackGroup.addHittable(damageObject);
									}
									// 攻撃された側の攻撃グループに相手オブジェクトを登録
									if (attackedGroup != null)
									{
										attackedGroup.addHittable(attackObject);
									}
									
									// 相殺リストに登録
									counterbalancedPairs.push(attackObject, damageObject);
									
									// ダメージ当たり判定を行わず、次のオブジェクトの判定へ
									testStop = true;
									break;
								}
							}
							
							// ダメージ当たり判定を行わず、次のオブジェクトの判定へ
							if (testStop)
							{
								break;
							}
						}
					}
				}
				
				// ダメージ当たり判定を行わず、次のオブジェクトの判定へ
				if (testStop)
				{
					continue;
				}
				
				// ダメージ当たり判定
				damageHitArea = damageObject.damageHitArea;
				
				// ダメージ当たり判定エリアが無い場合判定しない
				if (damageHitArea == null)
				{
					continue;
				}
				
				// 攻撃側の複数矩形すべてに対して当たり判定を行う
				for each (attackHitAreaRectangle in attackHitArea.rectangles)
				{
					// 攻撃する側の攻撃当たり判定エリアの座標調整
					if (attackObject.right)
					{
						rect1.x = attackObject.x + attackHitAreaRectangle.x;
					}
					else
					{
						rect1.x = attackObject.x + RectangleUtility.calculateReverseX(attackHitAreaRectangle);
					}
					rect1.y      = attackObject.y + attackHitAreaRectangle.y;
					rect1.width  = attackHitAreaRectangle.width;
					rect1.height = attackHitAreaRectangle.height;
					
					// 攻撃される側の複数矩形すべてに対して当たり判定を行う
					for each (damageHitAreaRectangle in damageHitArea.rectangles)
					{
						// ダメージ当たり判定エリアの座標調整
						if (damageObject.right)
						{
							rect2.x = damageObject.x + damageHitAreaRectangle.x;
						}
						else
						{
							rect2.x = damageObject.x + RectangleUtility.calculateReverseX(damageHitAreaRectangle);
						}
						rect2.y      = damageObject.y + damageHitAreaRectangle.y;
						rect2.width  = damageHitAreaRectangle.width;
						rect2.height = damageHitAreaRectangle.height;
						
						// 攻撃ヒット
						hitPartArea  = new Rectangle();
						hitDirection = Tester.testHitRectangleDirection(rect1, rect2, hitPartArea);
						if (hitDirection != noHitDirection)
						{
							// 攻撃グループに登録済みである場合処理しない
							if (attackGroup != null)
							{
								// 攻撃グループに登録されているならヒット処理をしない
								if (attackGroup.containHittable(damageObject))
								{
									testStop = true;
									break;
								}
							}
							
							hitEvent = new HitAreaHitEvent(HitAreaHitEvent.ATTACK_HIT);
							hitEvent.sourceHitTestable = attackObject;
							hitEvent.sourceHitArea     = attackHitArea;
							hitEvent.targetHitTestable = damageObject;
							hitEvent.targetHitArea     = damageHitArea;
							hitEvent.hitDirection      = hitDirection;
							hitEvent.hitPartArea       = hitPartArea;
							dispatchEvent(hitEvent);
							
							if (attackGroup != null)
							{
								// 攻撃グループに当たったオブジェクトを登録
								attackGroup.addHittable(damageObject);
							}
						}
						// 攻撃当たらず
						else
						{
							if (attackGroup != null)
							{
								// 判定復活する場合
								if (attackGroup.revival)
								{
									// 攻撃グループから当たらなかったオブジェクトを削除
									attackGroup.removeHittable(damageObject);
								}
							}
						}
					}
					
					// ダメージ当たり判定を行わず、次のオブジェクトの判定へ
					if (testStop)
					{
						break;
					}
				}
			}
		}
		
		/**
		 * @private
		 * 押し当たりイベント
		 * 
		 * @param event イベント
		 */
		private function _onPush(event:HitAreaHitEvent):void
		{
			var hitEvent:HitAreaHitEvent;
			
			hitEvent = new HitAreaHitEvent(HitAreaHitEvent.PUSH);
			hitEvent.sourceHitTestable = event.sourceHitTestable;
			hitEvent.sourceHitArea     = event.sourceHitArea;
			hitEvent.targetHitTestable = event.targetHitTestable;
			hitEvent.targetHitArea     = event.targetHitArea;
			hitEvent.hitDirection      = event.hitDirection;
			hitEvent.hitPartArea       = event.hitPartArea;
			event.sourceHitTestable.dispatchEvent(hitEvent);
			
			hitEvent = new HitAreaHitEvent(HitAreaHitEvent.PUSH);
			hitEvent.sourceHitTestable = event.targetHitTestable;
			hitEvent.sourceHitArea     = event.targetHitArea;
			hitEvent.targetHitTestable = event.sourceHitTestable;
			hitEvent.targetHitArea     = event.sourceHitArea;
			hitEvent.hitDirection      = HitDirection.convertReverseHitDirection(event.hitDirection);
			hitEvent.hitPartArea       = event.hitPartArea;
			event.targetHitTestable.dispatchEvent(hitEvent);
		}
		
		/**
		 * @private
		 * 攻撃当たりイベント
		 * 
		 * @param event イベント
		 */
		private function _onAttackHit(event:HitAreaHitEvent):void
		{
			var hitEvent:HitAreaHitEvent;
			
			hitEvent = new HitAreaHitEvent(HitAreaHitEvent.ATTACK_HIT);
			hitEvent.sourceHitTestable = event.sourceHitTestable;
			hitEvent.sourceHitArea     = event.sourceHitArea;
			hitEvent.targetHitTestable = event.targetHitTestable;
			hitEvent.targetHitArea     = event.targetHitArea;
			hitEvent.hitDirection      = event.hitDirection;
			hitEvent.hitPartArea       = event.hitPartArea;
			event.sourceHitTestable.dispatchEvent(hitEvent);
			
			hitEvent = new HitAreaHitEvent(HitAreaHitEvent.DAMAGED);
			hitEvent.sourceHitTestable = event.sourceHitTestable;
			hitEvent.sourceHitArea     = event.sourceHitArea;
			hitEvent.targetHitTestable = event.targetHitTestable;
			hitEvent.targetHitArea     = event.targetHitArea;
			hitEvent.hitDirection      = HitDirection.convertReverseHitDirection(event.hitDirection);
			hitEvent.hitPartArea       = event.hitPartArea;
			event.targetHitTestable.dispatchEvent(hitEvent);
		}
		
		/**
		 * @private
		 * 攻撃相殺イベント
		 * 
		 * @param event イベント
		 */
		private function _onCounterbalance(event:HitAreaHitEvent):void
		{
			var hitEvent:HitAreaHitEvent;
			
			hitEvent = new HitAreaHitEvent(HitAreaHitEvent.COUNTERBALANCE);
			hitEvent.sourceHitTestable = event.targetHitTestable;
			hitEvent.sourceHitArea     = event.targetHitArea;
			hitEvent.targetHitTestable = event.sourceHitTestable;
			hitEvent.targetHitArea     = event.sourceHitArea;
			hitEvent.hitDirection      = HitDirection.convertReverseHitDirection(event.hitDirection);
			hitEvent.hitPartArea       = event.hitPartArea;
			event.sourceHitTestable.dispatchEvent(hitEvent);
			
			hitEvent = new HitAreaHitEvent(HitAreaHitEvent.COUNTERBALANCE);
			hitEvent.sourceHitTestable = event.sourceHitTestable;
			hitEvent.sourceHitArea     = event.sourceHitArea;
			hitEvent.targetHitTestable = event.targetHitTestable;
			hitEvent.targetHitArea     = event.targetHitArea;
			hitEvent.hitDirection      = event.hitDirection;
			hitEvent.hitPartArea       = event.hitPartArea;
			event.targetHitTestable.dispatchEvent(hitEvent);
		}
	}
}

import org.ahiufomasao.yasume.timeline.IHitAreaHittable;

/**
 * @private
 * 攻撃相殺済みオブジェクトのペアリスト
 */
class CounterbalancedPairs
{
	private var _pairs:Vector.<Vector.<IHitAreaHittable>>; // ペアリスト
	
	/**
	 * コンストラクタ
	 */
	public function CounterbalancedPairs()
	{
		_pairs = new Vector.<Vector.<IHitAreaHittable>>();
	}
	
	/**
	 * 相殺済みオブジェクトのペア追加
	 * 
	 * @param obj1 追加するペアのオブジェクト1
	 * @param obj2 追加するペアのオブジェクト2
	 */
	public function push(obj1:IHitAreaHittable, obj2:IHitAreaHittable):void
	{
		var pair:Vector.<IHitAreaHittable> = new Vector.<IHitAreaHittable>();
		pair.push(obj2);
		pair.push(obj1);
		_pairs.push(pair);
	}
	
	/**
	 * ペア存在判定
	 * 
	 * @param obj1 判定するペアのオブジェクト1
	 * @param obj2 判定するペアのオブジェクト2
	 * 
	 * @return ペアが追加済みである場合 true
	 */
	public function exists(obj1:IHitAreaHittable, obj2:IHitAreaHittable):Boolean
	{
		for each (var pair:Vector.<IHitAreaHittable> in _pairs)
		{
			if ((obj1 == pair[0] && obj2 == pair[1]) || (obj1 == pair[1] && obj2 == pair[0]))
			{
				return true; // ペアが存在する
			}
		}
		return false; // ペア存在せず
	}
}
