package org.ahiufomasao.yasume.map 
{
	import flash.geom.Point;
	
	/**
	 * <code>ActiveSetting</code> クラスは有効調整設定を保持します.
	 * 
	 * @author asahiufo/AM902
	 */
	public class ActiveSetting
	{
		private var _initX:Number;         // 無効になったときにオブジェクトを戻す x 座標
		private var _initY:Number;         // 無効になったときにオブジェクトを戻す y 座標
		private var _activeBorderX:Number; // 有効境界の x 座標
		private var _activeBorderY:Number; // 有効境界の y 座標
		
		private var _nowActive:Boolean; // 現在有効なら true
		
		/**
		 * 無効になったときにオブジェクトを戻す <code>x</code> 座標です.
		 */
		public function get initX():Number { return _initX; }
		/** @private */
		public function set initX(value:Number):void { _initX = value; }
		/**
		 * 無効になったときにオブジェクトを戻す <code>y</code> 座標です.
		 */
		public function get initY():Number { return _initY; }
		/** @private */
		public function set initY(value:Number):void { _initY = value; }
		/**
		 * 有効無効を切り替える境界の <code>x</code> 座標です.
		 * <p>
		 * <code>MapViewer</code> オブジェクトで現在表示されている画面の左右枠からどれだけ離れた位置を境界とするかを設定します。
		 * </p>
		 */
		public function get activeBorderX():Number { return _activeBorderX; }
		/** @private */
		public function set activeBorderX(value:Number):void { _activeBorderX = value; }
		/**
		 * 有効無効を切り替える境界の <code>y</code> 座標です.
		 * <p>
		 * <code>MapViewer</code> オブジェクトで現在表示されている画面の上下枠からどれだけ離れた位置を境界とするかを設定します。
		 * </p>
		 */
		public function get activeBorderY():Number { return _activeBorderY; }
		/** @private */
		public function set activeBorderY(value:Number):void { _activeBorderY = value; }
		
		/**
		 * @private
		 * 現在有効なら <code>true</code> が設定されています.
		 */
		internal function get nowActive():Boolean { return _nowActive; }
		/** @private */
		internal function set nowActive(value:Boolean):void { _nowActive = value; }
		
		/**
		 * 新しい <code>ActiveSetting</code> クラスのインスタンスを生成します.
		 */
		public function ActiveSetting() 
		{
			_initX = 0;
			_initY = 0;
			_activeBorderX = 0;
			_activeBorderY = 0;
			
			_nowActive = false;
		}
	}
}
