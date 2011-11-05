package org.ahiufomasao.yasume.timeline 
{
	import org.as3commons.collections.Set;
	
	/**
	 * <code>AttackGroup</code> クラスは、
	 * <code>ChildTimeline</code> オブジェクトに設定された <code>AttackHitArea</code> オブジェクトのグループ付けを行ないます.
	 * <p>
	 * 攻撃当たり判定は <code>HitAreaHitTester</code> クラスの <code>testAttackHit</code> メソッドにより行います。
	 * その判定処理の際に、不必要な攻撃の連続ヒットを防止するために <code>AttackGroup</code> クラスを使用します。
	 * <code>ChildTimeline</code> オブジェクトに設定された <code>AttackHitArea</code> オブジェクトの 
	 * <code>attackGroup</code> プロパティへ <code>AttackGroup</code> オブジェクトを設定することで攻撃グループを設定します。
	 * </p>
	 * <p>
	 * 例えば、2 件の <code>AttackGroup</code> オブジェクト
	 * </p>
	 * <listing version="3.0">
	 * var attackGroup1:AttackGroup = new AttackGroup();
	 * var attackGroup2:AttackGroup = new AttackGroup();</listing>
	 * <p>
	 * を以下の構成で <code>AttackHitArea</code> オブジェクトへ設定した場合、
	 * </p>
	 * <pre>
	 * ChildTimeline
	 * + フレーム1 - AttackHitArea ← attackGroup1 -+
	 * + フレーム2 - AttackHitArea ← attackGroup1  | 攻撃グループ1
	 * + フレーム3 - AttackHitArea ← attackGroup1 -+
	 * + フレーム4 - AttackHitArea ← attackGroup2 -+ 攻撃グループ2
	 * + フレーム5 - AttackHitArea ← attackGroup2 -+
	 * </pre>
	 * <p>
	 * 1 攻撃グループ中で 1 度でも攻撃が当たったオブジェクトに対しては、同じ攻撃グループ中での当たり判定が無くなります。
	 * つまり、フレーム 1 ～ 3 で攻撃が当たる回数は 1 オブジェクトに対して最大 1 回、
	 * フレーム 4 ～ 5 で攻撃が当たる回数は 1 オブジェクトに対して最大 1 回として、攻撃の当たり方をコントロールできます。
	 * 攻撃グループを設定しなかった場合、上記の例では <code>AttackHitArea</code> が設定されているフレーム数分、最大 5 回攻撃が当たります。
	 * </p>
	 * <p>
	 * <code>revival</code> プロパティを <code>true</code> に設定することで、一度攻撃が当たったとして攻撃当たり判定が無くなったオブジェクトに対して、
	 * 次回攻撃が外れたタイミングで攻撃当たり判定が復活し、再び攻撃が当たるようになります。
	 * </p>
	 * <p>
	 * <code>ChildTimeline</code> オブジェクトの各 <code>AttackHitArea</code> オブジェクトに設定された <code>AttackGroup</code> オブジェクトは、
	 * <code>MainTimeline</code> クラスの <code>gotoFrame</code> メソッドを実行し、
	 * 該当 <code>ChildTimeline</code> オブジェクトが無効になるタイミングで設定がリセットされます。
	 * これにより、該当 <code>ChildTimeline</code> オブジェクトに登録されたすべての攻撃当たり判定が復活します。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see ChildTimeline
	 * @see HitAreaHitTester#testAttackHit()
	 * @see AttackHitArea#attackGroup
	 * @see #revival
	 * @see MainTimeline#gotoFrame()
	 */
	public class AttackGroup 
	{
		private var _revival:Boolean;     // 判定復活フラグ
		private var _attackHittables:Set; // すでに攻撃が当たったオブジェクトリスト
		
		/**
		 * <code>true</code> が設定されている場合、攻撃が外れたオブジェクトに対して、攻撃当たり判定が復活するようになります.
		 */
		public function get revival():Boolean { return _revival; }
		
		/**
		 * 新しい <code>AttackGroup</code> クラスのインスタンスを生成します.
		 * 
		 * @param revival <code>true</code> を設定した場合、攻撃が外れたオブジェクトに対して、攻撃当たり判定が復活するようになります。
		 */
		public function AttackGroup(revival:Boolean = false) 
		{
			_revival         = revival;
			_attackHittables = new Set();
		}
		
		/**
		 * 攻撃が当たったオブジェクトを登録します.
		 * 
		 * @param hittable 攻撃が当たったオブジェクトです。
		 * 
		 * @return 登録したオブジェクトです。登録済みである場合 <code>null</code>です。
		 */
		public function addHittable(hittable:IHitAreaHittable):IHitAreaHittable
		{
			if (!_attackHittables.add(hittable))
			{
				return null;
			}
			return hittable;
		}
		
		/**
		 * 攻撃が当たったオブジェクトが登録されているかを調べます.
		 * 
		 * @param hittable 検索するオブジェクトです。
		 * 
		 * @return 指定したオブジェクトが存在する場合 <code>true</code>、そうでない場合 <code>false</code> です。
		 */
		public function containHittable(hittable:IHitAreaHittable):Boolean
		{
			return _attackHittables.has(hittable);
		}
		
		/**
		 * 登録されたオブジェクトを削除します.
		 * 
		 * @param hittable 削除するオブジェクトです。
		 * 
		 * @return 削除されたオブジェクトです。オブジェクトの削除がされなかった場合は <code>null</code> が返ります。
		 */
		public function removeHittable(hittable:IHitAreaHittable):IHitAreaHittable
		{
			if (!_attackHittables.remove(hittable))
			{
				return null;
			}
			return hittable;
		}
		
		/**
		 * 攻撃グループをリセットします.
		 * <p>
		 * 登録されていた攻撃が当たったオブジェクトはすべて削除され、登録を解除されます。
		 * </p>
		 */
		public function reset():void
		{
			_attackHittables.clear();
		}
	}
}
