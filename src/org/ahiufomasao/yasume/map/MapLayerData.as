package org.ahiufomasao.yasume.map 
{
	
	/**
	 * <code>MapLayerData</code> クラスは、マップデータの 1 レイヤー分のデータを保持します.
	 * <p>
	 * 各プロパティへ任意のデータを設定し、<code>MapData</code> オブジェクトの <code>mapLayerDatas</code> プロパティのリストへ登録することで、
	 * マップの 1 レイヤー分のデータを設定します。
	 * </p>
	 * 
	 * @author asahiufo/AM902
	 * @see MapData#mapLayerDatas
	 */
	public class MapLayerData 
	{
		private var _scrollSpeed:Number;                             // スクロールスピード
		private var _frameRate:uint;                                 // フレームレート
		private var _hitData:Vector.<Vector.<HitSetting>>;           // 当たり判定データ
		private var _frameChipDatas:Vector.<Vector.<Vector.<uint>>>; // フレームリスト
		
		/**
		 * スクロールスピードです.
		 * <p>
		 * 1 が標準スピードで、1 より小さい値を設定するとスクロールスピードが遅くなり、 
		 * 1 より大きい値を設定するとスクロールスピードが速くなります。
		 * </p>
		 * @default 1
		 */
		public function get scrollSpeed():Number { return _scrollSpeed; }
		/** @private */
		public function set scrollSpeed(value:Number):void { _scrollSpeed = value; }
		/**
		 * マップのアニメーションのフレームレートです.
		 * <p>
		 * 例えば 25 を設定すると、マップが 25 回描画されるごとに表示フレームが切り替わります。
		 * </p>
		 * @default 12
		 */
		public function get frameRate():uint { return _frameRate; }
		/** @private */
		public function set frameRate(value:uint):void { _frameRate = value; }
		/**
		 * 当たり判定データです.
		 */
		public function get hitData():Vector.<Vector.<HitSetting>> { return _hitData; }
		/** @private */
		public function set hitData(value:Vector.<Vector.<HitSetting>>):void { _hitData = value; }
		/**
		 * フレームデータリストです.
		 * <p>
		 * フレーム毎のマップチップデータを保持した <code>Vector</code> オブジェクトです。
		 * </p>
		 */
		public function get frameChipDatas():Vector.<Vector.<Vector.<uint>>> { return _frameChipDatas; }
		/** @private */
		public function set frameChipDatas(value:Vector.<Vector.<Vector.<uint>>>):void { _frameChipDatas = value; }
		
		/**
		 * 新しい <code>MapLayerData</code> クラスのインスタンスを生成します.
		 */
		public function MapLayerData() 
		{
			_scrollSpeed    = 1;
			_frameRate      = 12;
			_hitData        = null;
			_frameChipDatas = new Vector.<Vector.<Vector.<uint>>>();
		}
	}
}
