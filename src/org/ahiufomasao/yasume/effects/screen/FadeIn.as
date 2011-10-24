package org.ahiufomasao.yasume.effects.screen 
{
	import org.ahiufomasao.utility.display.BitmapCanvas;
	import org.ahiufomasao.yasume.effects.IEffect;
	
	// TODO: テスト
	// TODO: asdoc
	/**
	 * フェードイン効果
	 * 
	 * @author asahiufo/AM902
	 */
	public class FadeIn implements IEffect 
	{
		private var _canvas:BitmapCanvas;
		
		private var _baseColor:uint; // 基本色
		private var _speed:uint;     // 効果スピード
		
		private var _alpha:int;         // 効果カウント
		private var _currentColor:uint; // 現在の色
		
		/**
		 * コンストラクタ
		 * 
		 * @param canvas    効果を適用するキャンバス
		 * @param baseColor 基本色
		 * @param speed     効果スピード
		 */
		public function FadeIn(canvas:BitmapCanvas, baseColor:uint = 0x000000, speed:uint = 20) 
		{
			_canvas = canvas;
			
			_baseColor = baseColor;
			_speed     = speed;
			
			_alpha        = 0xFF;
			_currentColor = _alpha * 0x1000000 + baseColor;
		}
		
		/**
		 * @inheritDoc
		 */
		public function initialize():void 
		{
			_alpha        = 0xFF;
			_currentColor = _alpha * 0x1000000 + _baseColor;
		}
		
		/**
		 * @inheritDoc
		 */
		public function exec():Boolean 
		{
			if (_alpha == 0x00)
			{
				return true;
			}
			
			_alpha -= _speed;
			if (_alpha < 0x00)
			{
				_alpha = 0x00;
			}
			_currentColor = _alpha * 0x1000000 + _baseColor;
			
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function draw():void 
		{
			_canvas.fill(_currentColor);
		}
		
		/**
		 * @inheritDoc
		 */
		public function terminate():void 
		{
		}
	}
}