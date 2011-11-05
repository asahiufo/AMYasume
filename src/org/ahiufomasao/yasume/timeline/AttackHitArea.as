package org.ahiufomasao.yasume.timeline 
{
	import flash.geom.Rectangle;
	import org.ahiufomasao.utility.geom.Arithmetic;
	import org.ahiufomasao.utility.MathUtility;
	import org.ahiufomasao.utility.net.SoundLoader;
	import org.ahiufomasao.yasume.effects.IEffect;
	import org.ahiufomasao.yasume.effects.IEffectFactory;
	import org.as3commons.collections.Set;
	
	/**
	 * <code>AttackHitArea</code> クラスは、<code>ChildTimeline</code> オブジェクトへ登録する攻撃当たり判定エリアです.
	 * <p>
	 * <code>ChildTimeline</code> クラスの <code>setAttackHitArea</code> メソッドで 
	 * 対象フレームに <code>AttackHitArea</code> オブジェクトを登録することで、
	 * その対象フレームに攻撃当たり判定を与えます。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see ChildTimeline#setAttackHitArea()
	 */
	public class AttackHitArea
	{
		private var _rectangles:Vector.<Rectangle>; // エリア矩形リスト
		
		private var _targets:Set;                   // 攻撃対象
		private var _attackGroup:AttackGroup;       // 攻撃グループ
		private var _power:Arithmetic;              // 攻撃力
		private var _angle:Number;                  // 攻撃の方向
		private var _damageKeepTime:uint;           // ダメージ動作維持時間
		private var _flyXSpeed:Arithmetic;          // x軸方向ぶっ飛びスピード
		private var _flyYSpeed:Arithmetic;          // y軸方向ぶっ飛びスピード
		private var _defensible:Boolean;            // 防御可能ならtrue
		private var _impact:Boolean;                // 当たった相手がぶっ飛ぶならtrue
		private var _counterbalance:Boolean;        // 相殺フラグ（これがtrue同士の攻撃は攻撃が相殺される）
		private var _hitStopTime:uint;              // ヒットストップ待ち時間
		private var _attribute:IAttackAttribute;    // 攻撃属性
		private var _effectKey:String;              // 攻撃ヒット効果
		private var _effectFactory:IEffectFactory;  // 攻撃ヒット効果ファクトリー
		private var _soundEffect:SoundLoader;       // 攻撃ヒット効果音
		
		/**
		 * この攻撃の当たり判定エリアとなる複数の矩形です.
		 */
		public function get rectangles():Vector.<Rectangle> { return _rectangles; }
		
		/**
		 * この攻撃の攻撃グループです.
		 */
		public function get attackGroup():AttackGroup { return _attackGroup; }
		/** @private */
		public function set attackGroup(value:AttackGroup):void { _attackGroup = value; }
		
		/**
		 * この攻撃の攻撃力として計算する際に使用する加算、乗算値です.
		 */
		public function get power():Arithmetic { return _power; }
		
		/**
		 * この攻撃の向きです.
		 * <p>
		 * 0 ～ 360度で設定します。
		 * 0 度が右水平方向を示し、右回転していくごとに角度は増えます。
		 * </p>
		 * @default 0
		 */
		public function get angle():Number { return _angle; }
		/** @private */
		public function set angle(value:Number):void { _angle = MathUtility.convertFrom0To360Angle(value); }
		
		/**
		 * この攻撃を当てた際の相手のダメージ動作維持時間です.
		 * <p>
		 * 時間の単位はフレーム数です。
		 * </p>
		 * @default 0
		 */
		public function get damageKeepTime():uint { return _damageKeepTime; }
		/** @private */
		public function set damageKeepTime(value:uint):void { _damageKeepTime = value; }
		
		/**
		 * この攻撃を当てた際の相手の <code>x</code> 軸方向にぶっ飛ぶスピードの計算に使用される加算、乗算値です.
		 */
		public function get flyXSpeed():Arithmetic { return _flyXSpeed; }
		/**
		 * この攻撃を当てた際の相手の <code>y</code> 軸方向にぶっ飛ぶスピードの計算に使用される加算、乗算値です.
		 */
		public function get flyYSpeed():Arithmetic { return _flyYSpeed; }
		
		/**
		 * <code>false</code> が設定されると、この攻撃は防御不可能であることを表します.
		 * @default true
		 */
		public function get defensible():Boolean { return _defensible; }
		/** @private */
		public function set defensible(value:Boolean):void { _defensible = value; }
		
		/**
		 * <code>true</code> が設定されると、この攻撃を当てた際に相手が体制を崩します.
		 * @default false
		 */
		public function get impact():Boolean { return _impact; }
		/** @private */
		public function set impact(value:Boolean):void { _impact = value; }
		
		/**
		 * このプロパティに <code>true</code> が設定されている <code>AttackHitArea</code> オブジェクト同士が当たった場合、攻撃の相殺が発生します.
		 * @default false
		 */
		public function get counterbalance():Boolean { return _counterbalance; }
		/** @private */
		public function set counterbalance(value:Boolean):void { _counterbalance = value; }
		
		/**
		 * この攻撃を当てた際のヒットストップ時間です.
		 * <p>
		 * 時間の単位はフレーム数です。
		 * </p>
		 * @default 0
		 */
		public function get hitStopTime():uint { return _hitStopTime; }
		/** @private */
		public function set hitStopTime(value:uint):void { _hitStopTime = value; }
		
		/**
		 * この攻撃の属性です.
		 * 
		 * @see IAttackAttribute
		 */
		public function get attribute():IAttackAttribute { return _attribute; }
		/** @private */
		public function set attribute(value:IAttackAttribute):void { _attribute = value; }
		
		/**
		 * この攻撃が当たった際の効果音です.
		 */
		public function get soundEffect():SoundLoader { return _soundEffect; }
		/** @private */
		public function set soundEffect(value:SoundLoader):void { _soundEffect = value; }
		
		/**
		 * 新しい <code>AttackHitArea</code> クラスのインスタンスを生成します.
		 */
		public function AttackHitArea() 
		{
			_rectangles     = new Vector.<Rectangle>();
			
			_targets        = new Set();
			_attackGroup    = null;
			_power          = new Arithmetic();
			_angle          = 0;
			_damageKeepTime = 0;
			_flyXSpeed      = new Arithmetic();
			_flyYSpeed      = new Arithmetic();
			_defensible     = true;
			_impact         = false;
			_counterbalance = false;
			_hitStopTime    = 0;
			_attribute      = null;
			_effectKey      = null;
			_effectFactory  = null;
			_soundEffect    = null;
		}
		
		/**
		 * 攻撃対象を登録します.
		 * 
		 * @param target 攻撃対象です。
		 * 
		 * @return 登録した攻撃対象です。登録済みである場合 <code>null</code>です。
		 */
		public function addTarget(target:AttackTarget):AttackTarget
		{
			if (!_targets.add(target))
			{
				return null;
			}
			return target;
		}
		
		/**
		 * 攻撃対象が登録されているかを調べます.
		 * 
		 * @param target 検索する攻撃対象です。
		 * 
		 * @return 指定した攻撃対象が存在する場合 <code>true</code>、そうでない場合 <code>false</code> です。
		 */
		public function containTarget(target:AttackTarget):Boolean
		{
			return _targets.has(target);
		}
		
		/**
		 * 登録された攻撃対象を削除します.
		 * 
		 * @param target 削除する攻撃対象です。
		 * 
		 * @return 削除された攻撃対象です。攻撃対象の削除がされなかった場合は <code>null</code> が返ります。
		 */
		public function removeTarget(target:AttackTarget):AttackTarget
		{
			if (!_targets.remove(target))
			{
				return null;
			}
			return target;
		}
		
		/**
		 * 攻撃対象をすべて削除します.
		 * <p>
		 * 攻撃対象はすべて削除され、登録を解除されます。
		 * </p>
		 */
		public function clear():void
		{
			_targets.clear();
		}
		
		/**
		 * 攻撃が当たった際のエフェクトを設定します.
		 * 
		 * @param effectKey     生成するエフェクトのキーとなる文字列です。
		 * @param effectFactory 効果を生成するために使うファクトリーオブジェクトです。
		 */
		public function setEffect(effectKey:String, effectFactory:IEffectFactory):void
		{
			_effectKey     = effectKey;
			_effectFactory = effectFactory;
		}
		
		/**
		 * 攻撃が当たった際のエフェクトを生成します.
		 * <p>
		 * <code>setEffect</code> メソッドによって設定されたエフェクトを生成します。
		 * </p>
		 * 
		 * @return 生成されたエフェクトオブジェクトです。
		 * 
		 * @see #setEffect()
		 */
		public function createEffect():IEffect
		{
			if (_effectFactory == null || _effectKey == "")
			{
				return null;
			}
			return _effectFactory.createEffect(_effectKey);
		}
	}
}
