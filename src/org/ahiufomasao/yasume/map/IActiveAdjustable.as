package org.ahiufomasao.yasume.map 
{
	
	/**
	 * 無効から有効に切り替わったときに送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapObjectActiveEvent.CHANGE_ACTIVE
	 */
	[Event(name="changeActive", type="org.ahiufomasao.yasume.events.MapObjectActiveEvent")]
	/**
	 * 有効のまま変化が無いときに送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapObjectActiveEvent.ACTIVE
	 */
	[Event(name="active", type="org.ahiufomasao.yasume.events.MapObjectActiveEvent")]
	/**
	 * 有効から無効に切り替わったときに送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapObjectActiveEvent.CHANGE_INACTIVE
	 */
	[Event(name="changeInactive", type="org.ahiufomasao.yasume.events.MapObjectActiveEvent")]
	/**
	 * 無効のまま変換が無いときに送出されます.
	 * 
	 * @eventType org.ahiufomasao.yasume.events.MapObjectActiveEvent.INACTIVE
	 */
	[Event(name="inactive", type="org.ahiufomasao.yasume.events.MapObjectActiveEvent")]
	
	/**
	 * <code>IActiveAdjustable</code> インターフェイスは有効調整可能オブジェクトによって実装されます.
	 * 
	 * @author asahiufo/AM902
	 */
	public interface IActiveAdjustable extends IMapObject
	{
	}
}