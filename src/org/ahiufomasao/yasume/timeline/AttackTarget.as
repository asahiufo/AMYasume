package org.ahiufomasao.yasume.timeline 
{
	
	/**
	 * <code>AttackTarget</code> クラスは攻撃対象を表す定数を定義します.
	 * <p>
	 * <code>AttackHitArea</code> オブジェクトへ <code>addTarget</code> により <code>AttackTarget</code> クラスの定数を登録することで、
	 * 該当するオブジェクトへの当たり判定を有効にします。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see AttackHitArea#addTarget
	 */
	public class AttackTarget 
	{
		private static const _FRIEND_STR:String              = "FRIEND";              // 味方
		private static const _ENEMY_STR:String               = "ENEMY";               // 敵
		private static const _FRIEND_SIDE_OBJECT_STR:String  = "FRIEND_SIDE_OBJECT";  // 味方側オブジェクト
		private static const _ENEMY_SIDE_OBJECT_STR:String   = "ENEMY_SIDE_OBJECT";   // 敵側オブジェクト
		private static const _ANOTHER_SIDE_OBJECT_STR:String = "ANOTHER_SIDE_OBJECT"; // 無所属オブジェクト
		
		/**
		 * 味方を対象とする定数です.
		 * <p>
		 * <code>MainTimelineFactory</code> クラスへ渡す XML データへは <code>"FRIEND"</code> を設定します。
		 * </p>
		 * @see MainTimelineFactory
		 */
		public static const FRIEND:AttackTarget = new AttackTarget();
		/**
		 * 敵を対象とする定数です.
		 * <p>
		 * <code>MainTimelineFactory</code> クラスへ渡す XML データへは <code>"ENEMY"</code> を設定します。
		 * </p>
		 * @see MainTimelineFactory
		 */
		public static const ENEMY:AttackTarget = new AttackTarget();
		/**
		 * 味方側に所属するオブジェクトを対象とする定数です.
		 * <p>
		 * <code>MainTimelineFactory</code> クラスへ渡す XML データへは <code>"FRIEND_SIDE_OBJECT"</code> を設定します。
		 * </p>
		 * @see MainTimelineFactory
		 */
		public static const FRIEND_SIDE_OBJECT:AttackTarget = new AttackTarget();
		/**
		 * 敵側に所属するオブジェクトを対象とする定数です.
		 * <p>
		 * <code>MainTimelineFactory</code> クラスへ渡す XML データへは <code>"ENEMY_SIDE_OBJECT"</code> を設定します。
		 * </p>
		 * @see MainTimelineFactory
		 */
		public static const ENEMY_SIDE_OBJECT:AttackTarget = new AttackTarget();
		/**
		 * 敵味方以外の無所属のオブジェクトを対象とする定数です.
		 * <p>
		 * <code>MainTimelineFactory</code> クラスへ渡す XML データへは <code>"ANOTHER_SIDE_OBJECT"</code> を設定します。
		 * </p>
		 * @see MainTimelineFactory
		 */
		public static const ANOTHER_SIDE_OBJECT:AttackTarget = new AttackTarget();
		
		/**
		 * @private
		 * 指定文字列が攻撃対象として正しい形式であるかどうか判定します.
		 * 
		 * @param attackTarget 攻撃対象を表す文字列です。
		 * 
		 * @return 指定文字列が攻撃対象の形式である場合 <code>true</code> を返します。
		 */
		internal static function validate(attackTarget:String):Boolean {
			switch (attackTarget)
			{
				case _FRIEND_STR:
				case _ENEMY_STR:
				case _FRIEND_SIDE_OBJECT_STR:
				case _ENEMY_SIDE_OBJECT_STR:
				case _ANOTHER_SIDE_OBJECT_STR:
					return true;
				default:
					return false;
			}
		}
		
		/**
		 * @private
		 * Enum オブジェクト取得します.
		 * 
		 * @param key 取得する Enum のキーです。
		 * 
		 * @return キーに紐付く Enum オブジェクトです。
		 */
		internal static function getEnum(key:String):AttackTarget
		{
			switch (key)
			{
				case _FRIEND_STR:
					return FRIEND;
				case _ENEMY_STR:
					return ENEMY;
				case _FRIEND_SIDE_OBJECT_STR:
					return FRIEND_SIDE_OBJECT;
				case _ENEMY_SIDE_OBJECT_STR:
					return ENEMY_SIDE_OBJECT;
				case _ANOTHER_SIDE_OBJECT_STR:
					return ANOTHER_SIDE_OBJECT;
				default:
					throw new ArgumentError("不明なキーが指定されました。[キー=" + key + "]");
			}
		}
	}
}
