package org.ahiufomasao.yasume.timeline 
{
	/**
	 * <code>HitAreaDrawingSetting</code> クラスは、当たり判定エリアの描画設定を保持します.
	 * 
	 * @author asahiufo/AM902
	 */
	public class HitAreaDrawingSetting
	{
		private var _drawing:Boolean; // 描画する場合 true
		
		private var _stageHitAreaColor:uint;  // ステージ当たり判定エリアの描画色
		private var _pushHitAreaColor:uint;   // 押し当たり判定エリアの描画色
		private var _damageHitAreaColor:uint; // ダメージ当たり判定エリアの描画色
		private var _attackHitAreaColor:uint; // 攻撃当たり判定エリアの描画色
		
		/**
		 * 当たり判定エリアを描画する場合 <code>true</code> を設定します.
		 * 
		 * @default false
		 */
		public function get drawing():Boolean { return _drawing; }
		/** @private */
		public function set drawing(value:Boolean):void { _drawing = value; }
		
		/**
		 * ステージ当たり判定エリアを描画する際に使用する RGB カラー値です.
		 * 
		 * @default 0x00FF00
		 */
		public function get stageHitAreaColor():uint { return _stageHitAreaColor; }
		/** @private */
		public function set stageHitAreaColor(value:uint):void { _stageHitAreaColor = value; }
		/**
		 * 押し当たり判定エリアを描画する際に使用する RGB カラー値です.
		 * 
		 * @default 0xFFFF00
		 */
		public function get pushHitAreaColor():uint { return _pushHitAreaColor; }
		/** @private */
		public function set pushHitAreaColor(value:uint):void { _pushHitAreaColor = value; }
		/**
		 * ダメージ当たり判定エリアを描画する際に使用する RGB カラー値です.
		 * 
		 * @default 0x0000FF
		 */
		public function get damageHitAreaColor():uint { return _damageHitAreaColor; }
		/** @private */
		public function set damageHitAreaColor(value:uint):void { _damageHitAreaColor = value; }
		/**
		 * 攻撃当たり判定エリアを描画する際に使用する RGB カラー値です.
		 * 
		 * @default 0xFF0000
		 */
		public function get attackHitAreaColor():uint { return _attackHitAreaColor; }
		/** @private */
		public function set attackHitAreaColor(value:uint):void { _attackHitAreaColor = value; }
		
		/**
		 * 新しい <code>HitAreaDrawingSetting</code> クラスのインスタンスを生成します.
		 */
		public function HitAreaDrawingSetting() 
		{
			_drawing = false;
			
			_stageHitAreaColor  = 0x00FF00;
			_pushHitAreaColor   = 0xFFFF00;
			_damageHitAreaColor = 0x0000FF;
			_attackHitAreaColor = 0xFF0000;
		}
	}
}
