package org.ahiufomasao.yasume.timeline 
{
	import flash.geom.Rectangle;
	import org.ahiufomasao.utility.net.SoundLoader;
	
	/**
	 * <code>DamageHitArea</code> クラスは、<code>ChildTimeline</code> オブジェクトへ登録するダメージ当たり判定エリアです.
	 * <p>
	 * <code>ChildTimeline</code> クラスの <code>setDamageHitArea</code> メソッドで 
	 * 対象フレームに <code>DamageHitArea</code> オブジェクトを登録することで、
	 * その対象フレームにダメージ当たり判定を与えます。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see ChildTimeline#setDamageHitArea()
	 */
	public class DamageHitArea
	{
		private var _rectangles:Vector.<Rectangle>;              // エリア矩形リスト
		private var _strongAttributes:Vector.<IAttackAttribute>; // 強い属性
		private var _weakAttributes:Vector.<IAttackAttribute>;   // 弱点属性
		private var _damageSoundEffect:SoundLoader;              // ダメージ効果音
		
		/**
		 * ダメージ当たり判定エリアとなる複数の矩形です.
		 */
		public function get rectangles():Vector.<Rectangle> { return _rectangles; }
		
		/**
		 * 強い属性のリストです.
		 * <p>
		 * このリストに登録された攻撃属性に対して耐性を持ちます。
		 * </p>
		 */
		public function get strongAttributes():Vector.<IAttackAttribute> { return _strongAttributes; }
		/**
		 * 弱点属性のリストです.
		 * <p>
		 * このリストに登録された攻撃属性が弱点となります。
		 * </p>
		 */
		public function get weakAttributes():Vector.<IAttackAttribute> { return _weakAttributes; }
		/**
		 * ダメージを受けた際の効果音です.
		 */
		public function get damageSoundEffect():SoundLoader { return _damageSoundEffect; }
		/** @private */
		public function set damageSoundEffect(value:SoundLoader):void { _damageSoundEffect = value; }
		
		/**
		 * 新しい <code>DamageHitArea</code> クラスのインスタンスを生成します.
		 */
		public function DamageHitArea() 
		{
			_rectangles        = new Vector.<Rectangle>();
			_strongAttributes  = new Vector.<IAttackAttribute>();
			_weakAttributes    = new Vector.<IAttackAttribute>();
			_damageSoundEffect = null;
		}
	}
}
