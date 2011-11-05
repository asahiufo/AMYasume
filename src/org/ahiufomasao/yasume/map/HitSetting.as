package org.ahiufomasao.yasume.map 
{
	import org.ahiufomasao.utility.Validator;
	
	/**
	 * <code>HitSetting</code> クラスは当たり設定を保持します.
	 * 
	 * @author asahiufo/AM902
	 */
	public class HitSetting
	{
		private var _rightHittable:Boolean;  // このオブジェクトの右辺に対して当たり判定がある場合 true
		private var _leftHittable:Boolean;   // このオブジェクトの左辺に対して当たり判定がある場合 true
		private var _topHittable:Boolean;    // このオブジェクトの上辺に対して当たり判定がある場合 true
		private var _bottomHittable:Boolean; // このオブジェクトの下辺に対して当たり判定がある場合 true
		private var _throughRight:Boolean;   // 右方向へすり抜け可能である場合 true
		private var _throughLeft:Boolean;    // 左方向へすり抜け可能である場合 true
		private var _throughUp:Boolean;      // 上方向へすり抜け可能である場合 true
		private var _throughDown:Boolean;    // 下方向へすり抜け可能である場合 true
		
		private var _kind:String;            // 当たり種類
		
		/**
		 * このオブジェクトの右辺に対して当たり判定がある場合 <code>true</code> です.
		 */
		public function get rightHittable():Boolean { return _rightHittable; }
		/** @private */
		public function set rightHittable(value:Boolean):void { _rightHittable = value; }
		/**
		 * このオブジェクトの左辺に対して当たり判定がある場合 <code>true</code> です.
		 */
		public function get leftHittable():Boolean { return _leftHittable; }
		/** @private */
		public function set leftHittable(value:Boolean):void { _leftHittable = value; }
		/**
		 * このオブジェクトの上辺に対して当たり判定がある場合 <code>true</code> です.
		 */
		public function get topHittable():Boolean { return _topHittable; }
		/** @private */
		public function set topHittable(value:Boolean):void { _topHittable = value; }
		/**
		 * このオブジェクトの下辺に対して当たり判定がある場合 <code>true</code> です.
		 */
		public function get bottomHittable():Boolean { return _bottomHittable; }
		/** @private */
		public function set bottomHittable(value:Boolean):void { _bottomHittable = value; }
		/**
		 * 右方向へすり抜け可能である場合 <code>true</code> です.
		 */
		public function get throughRight():Boolean { return _throughRight; }
		/** @private */
		public function set throughRight(value:Boolean):void { _throughRight = value; }
		/**
		 * 左方向へすり抜け可能である場合 <code>true</code> です.
		 */
		public function get throughLeft():Boolean { return _throughLeft; }
		/** @private */
		public function set throughLeft(value:Boolean):void { _throughLeft = value; }
		/**
		 * 上方向へすり抜け可能である場合 <code>true</code> です.
		 */
		public function get throughUp():Boolean { return _throughUp; }
		/** @private */
		public function set throughUp(value:Boolean):void { _throughUp = value; }
		/**
		 * 下方向へすり抜け可能である場合 <code>true</code> です.
		 */
		public function get throughDown():Boolean { return _throughDown; }
		/** @private */
		public function set throughDown(value:Boolean):void { _throughDown = value; }
		
		/**
		 * 当たりの種類を定義するための識別子です.
		 */
		public function get kind():String { return _kind; }
		/** @private */
		public function set kind(value:String):void {　_kind = value;　}
		
		/**
		 * 新しい <code>HitSetting</code> クラスのインスタンスを生成します.
		 */
		public function HitSetting() 
		{
			_rightHittable  = false;
			_leftHittable   = false;
			_topHittable    = false;
			_bottomHittable = false;
			_throughRight   = false;
			_throughLeft    = false;
			_throughUp      = false;
			_throughDown    = false;
			
			_kind = "";
		}
		
		/**
		 * 16　進数の値でプロパティを設定します.
		 * 
		 * @param value 3 桁の 16 進数です。頭に <code>0x</code> を記述する必要はありません。
		 */
		public function setByHexValue(value:String):void
		{
			if (value.length != 3)
			{
				throw new ArgumentError("value パラメータは 3 桁で指定します。[value=" + value + "]");
			}
			if (!Validator.validateUint("0x" + value))
			{
				throw new ArgumentError("value パラメータは 16 進数の形式で指定します。[value=" + value + "]");
			}
			
			var num:uint = parseInt("0x" + value);
			
			_rightHittable  = !((num & Math.pow(2, 1 - 1)) == 0);
			_leftHittable   = !((num & Math.pow(2, 2 - 1)) == 0);
			_topHittable    = !((num & Math.pow(2, 3 - 1)) == 0);
			_bottomHittable = !((num & Math.pow(2, 4 - 1)) == 0);
			_throughRight   = !((num & Math.pow(2, 5 - 1)) == 0);
			_throughLeft    = !((num & Math.pow(2, 6 - 1)) == 0);
			_throughUp      = !((num & Math.pow(2, 7 - 1)) == 0);
			_throughDown    = !((num & Math.pow(2, 8 - 1)) == 0);
			
			_kind = value.charAt(0);
		}
	}
}