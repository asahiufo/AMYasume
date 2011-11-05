package org.ahiufomasao.yasume.map 
{
	
	/**
	 * <code>IMapObjectFactory</code> インターフェイスは <code>IMapObject</code> オブジェクトの作成メソッドを提供します.
	 * 
	 * @author asahiufo/AM902
	 */
	public interface IMapObjectFactory 
	{
		/**
		 * 指定された名前の <code>IMapObject</code> オブジェクトを作成します.
		 * 
		 * @param name 作成するオブジェクトの名前です。
		 * 
		 * @return 作成された <code>IMapObject</code> オブジェクトです。
		 */
		function createMapObject(name:String):IMapObject;
	}
}
