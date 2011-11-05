package org.ahiufomasao.yasume.effects 
{
	
	/**
	 * <code>IEffectFactory</code> インターフェイスは、効果オブジェクトを作成するクラスによって実装されます.
	 * 
	 * @author asahiufo/AM902
	 */
	public interface IEffectFactory 
	{
		/**
		 * キーに紐付く効果オブジェクトを作成します.
		 * 
		 * @param key 効果を表すキー文字列です。
		 * 
		 * @return 新しい効果の <code>IExecutable</code> オブジェクトです。
		 */
		function createEffect(key:String):IEffect;
	}
}
