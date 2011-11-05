package org.ahiufomasao.yasume.utils 
{
	
	/**
	 * <code>IValidator</code> はバリデーションチェックを行うクラスによって実装されます.
	 * 
	 * @author asahiufo/AM902
	 */
	public interface IValidator 
	{
		/**
		 * 指定文字列が正しい形式であるか判定します.
		 * 
		 * @param str 判定する文字列です。
		 * 
		 * @return 正しい形式である場合 <code>true</code> が返ります。
		 */
		function validate(str:String):Boolean;
	}
}
