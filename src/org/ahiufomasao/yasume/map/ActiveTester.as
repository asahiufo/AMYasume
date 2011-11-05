package org.ahiufomasao.yasume.map 
{
	import org.ahiufomasao.yasume.events.MapObjectActiveEvent;
	
	/**
	 * <code>ActiveTester</code> クラスは有効調整可能オブジェクトが現在有効か無効かを判定します.
	 * 
	 * @author asahiufo/AM902
	 */
	public class ActiveTester 
	{
		/**
		 * 新しい <code>ActiveTester</code> クラスのインスタンスを生成します.
		 */
		public function ActiveTester() 
		{
		}
		
		/**
		 * 有効調整可能オブジェクトの有効/無効判定を行います.
		 * <p>
		 * <code>MapViewer</code> オブジェクトが現在表示している画面を基準として、
		 * 有効調整可能オブジェクトが有効であるか、無効であるかを判定します。
		 * 「<code>MapViewer</code> オブジェクトの現在表示している画面領域 + 有効調整可能オブジェクトの有効調整設定に設定された境界座標の値」を有効領域とし、
		 * 有効調整可能オブジェクトの座標が有効領域内にある場合は有効、領域外である場合は無効と判定します。
		 * </p>
		 * <p>
		 * 有効調整可能オブジェクトの状態が無効から有効に切り替わったとき、<code>MapObjectActiveEvent.CHANGE_ACTIVE</code> イベントが、
		 * 有効のまま変化が無いとき、<code>MapObjectActiveEvent.ACTIVE</code> イベントが、
		 * 有効から無効に切り替わったとき、<code>MapObjectActiveEvent.CHANGE_INACTIVE</code> イベントが、
		 * 無効のまま変換が無いとき、<code>MapObjectActiveEvent.INACTIVE</code> イベントがそれぞれ有効調整可能オブジェクトから送出されます。
		 * </p>
		 * 
		 * @param mapObjectsData  チェック対象のマップオブジェクトデータです。
		 * @param mapViewer       判定の基準とする <code>MapViewer</code> オブジェクトです。
		 * @param settingPosition <code>true</code> を設定すると有効調整可能オブジェクトが有効、無効に変わったタイミングで座標を初期位置に戻します。
		 */
		public function test(mapObjectsData:MapObjectsData, mapViewer:MapViewer, settingPosition:Boolean = true):void
		{
			var cameraX:Number = mapViewer.cameraX;
			var cameraY:Number = mapViewer.cameraY;
			var screenW:Number = mapViewer.screenWidthPx;
			var screenH:Number = mapViewer.screenHeightPx;
			
			var activeSetting:ActiveSetting;
			var event:MapObjectActiveEvent;
			
			for each (var activeAdjustable:IActiveAdjustable in mapObjectsData.activeAdjustables)
			{
				activeSetting = mapObjectsData.getActiveSetting(activeAdjustable);
				
				// マップオブジェクトが有効範囲内であるまたは
				// マップオブジェクトの基準位置が有効範囲内である場合
				if ((cameraX - activeSetting.activeBorderX <= activeAdjustable.x && activeAdjustable.x <= cameraX + screenW + activeSetting.activeBorderX &&
				     cameraY - activeSetting.activeBorderY <= activeAdjustable.y && activeAdjustable.y <= cameraY + screenH + activeSetting.activeBorderY) ||
				    (cameraX - activeSetting.activeBorderX <= activeSetting.initX && activeSetting.initX <= cameraX + screenW + activeSetting.activeBorderX &&
				     cameraY - activeSetting.activeBorderY <= activeSetting.initY && activeSetting.initY <= cameraY + screenH + activeSetting.activeBorderY))
				{
					// 前回有効でなかった場合
					if (!activeSetting.nowActive)
					{
						// 初期位置に戻す場合、座標を設定する
						if (settingPosition)
						{
							activeAdjustable.x = activeSetting.initX;
							activeAdjustable.y = activeSetting.initY;
						}
						
						activeSetting.nowActive = true;
						
						// イベント送出
						event = new MapObjectActiveEvent(MapObjectActiveEvent.CHANGE_ACTIVE);
						event.x = activeSetting.initX;
						event.y = activeSetting.initY;
						activeAdjustable.dispatchEvent(event);
					}
					// 有効状態が継続している場合
					else
					{
						activeAdjustable.dispatchEvent(new MapObjectActiveEvent(MapObjectActiveEvent.ACTIVE));
					}
				}
				// マップオブジェクトが有効範囲外である場合
				else
				{
					// 前回有効であった
					if (activeSetting.nowActive)
					{
						// 初期位置に戻す場合、座標を設定する
						if (settingPosition)
						{
							activeAdjustable.x = activeSetting.initX;
							activeAdjustable.y = activeSetting.initY;
						}
						
						activeSetting.nowActive = false;
						
						// イベント送出
						event = new MapObjectActiveEvent(MapObjectActiveEvent.CHANGE_INACTIVE);
						event.x = activeSetting.initX;
						event.y = activeSetting.initY;
						activeAdjustable.dispatchEvent(event);
					}
					// 有効状態が継続している場合
					else
					{
						activeAdjustable.dispatchEvent(new MapObjectActiveEvent(MapObjectActiveEvent.INACTIVE));
					}
				}
			}
		}
	}
}

