package org.ahiufomasao.yasume.media 
{
	import org.ahiufomasao.utility.net.SoundLoader;
	
	/**
	 * <code>ISoundEffectCollection</code> インターフェイスは、音声データをまとめて管理するクラスによって実装されます.
	 * <p>
	 * 任意のキー文字列と音声データを紐付けるために <code>getSoundEffect</code> メソッドを実装してください。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 */
	public interface ISoundEffectCollection 
	{
		/**
		 * キーに紐付く効果音オブジェクトを取得します.
		 * 
		 * @param key 効果音を表すキー文字列です。
		 * 
		 * @return 効果音の <code>SoundLoader</code> オブジェクトです。
		 */
		function getSoundEffect(key:String):SoundLoader;
	}
}
