package org.ahiufomasao.yasume.timeline 
{
	
	/**
	 * <code>IAttackAttribute</code> インターフェイスは、攻撃属性の定数を定義したクラスによって実装されます.
	 * <p>
	 * <code>IAttackAttribute</code> インターフェイスは
	 * <code>MainTimelineFactory</code> クラスへ渡す XML データ内の攻撃属性項目に設定された文字列と、
	 * 攻撃属性オブジェクトを紐付けるメソッドを提供します。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see MainTimelineFactory
	 */
	public interface IAttackAttribute 
	{
		/**
		 * 攻撃属性を表す文字列と紐付く攻撃属性オブジェクトを取得します.
		 * 
		 * @param key 攻撃属性を表す文字列です。
		 * 
		 * @return 攻撃属性オブジェクトです。
		 */
		function getAttribute(key:String):IAttackAttribute;
	}
}
