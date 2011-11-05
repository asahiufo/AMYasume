package org.ahiufomasao.yasume.map 
{
	import flash.events.IEventDispatcher;
	import org.ahiufomasao.yasume.core.IHasPosition;
	
	/**
	 * <code>IMapObject</code> インターフェイスはマップに配置するオブジェクトによって実装されます.
	 * <p>
	 * <code>IMapObject</code> インターフェイスを実装した場合、<code>EventDispatcher</code> クラスの継承等により、
	 * <code>IEventDispatcher</code> インターフェイスによって提供されるメソッドを実装してください。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 */
	public interface IMapObject extends IHasPosition, IEventDispatcher
	{
	}
}
