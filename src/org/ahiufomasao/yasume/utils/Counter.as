package org.ahiufomasao.yasume.utils 
{
	
	/**
	 * <code>Counter</code> クラスは、カウント機能を提供します.
	 * <p>
	 * <code>start</code> メソッドでカウントの目標値を設定し、
	 * <code>count</code> メソッドを呼び出すことで +1 ずつカウントを進めます。
	 * <code>count</code> メソッドは、カウント後のカウント数が
	 * 目標値に達していない場合、<code>false</code> を、
	 * 目標値に達した場合、<code>true</code> を返します。
	 * </p>
	 * @example 次のコードは <code>Counter</code> クラスの基本的な使用方法です。
	 * <listing version="3.0">
	 * var counter:Counter = new Counter();
	 * counter.start(3); // 目標値 3 でカウント開始
	 * while (true)
	 * {
	 *     trace(counter.currentCount + " 回目のカウント");
	 *     if (counter.count())
	 *     {
	 *         trace("終了");
	 *         break;
	 *     }
	 * }</listing>
	 * 
	 * @author asahiufo/AM902
	 * @see #start()
	 * @see #count()
	 */
	public class Counter
	{
		private var _targetCount:uint;  // 目標値
		private var _currentCount:uint; // 現在のカウント
		
		/**
		 * カウントの目標値です。
		 */
		public function get targetCount():uint { return _targetCount; }
		/**
		 * 現在のカウント数です.
		 * <p>
		 * このプロパティは <code>targetCount</code> プロパティの値を超えることはありません。
		 * </p>
		 */
		public function get currentCount():uint { return _currentCount; }
		/**
		 * カウントが目標値に達しているなら <code>true</code>、達していないなら <code>false</code> が返されます.
		 */
		public function get end():Boolean { return _currentCount >= _targetCount; }
		
		/**
		 * 新しい <code>Counter</code> クラスのインスタンスを生成します.
		 */
		public function Counter() 
		{
			_targetCount  = 0;
			_currentCount = 0;
		}
		
		/**
		 * 新しい目標値でカウントを開始します.
		 * <p>
		 * このメソッドが呼び出されると、カウント数はリセットされます。
		 * </p>
		 * 
		 * @param targetCount カウントの目標値です。
		 * 
		 * @throws ArgumentError カウントの目標値に <code>uint.MAX_VALUE</code> 以上の値が設定された場合にスローされます。
		 */
		public function start(targetCount:uint):void
		{
			if (targetCount >= uint.MAX_VALUE)
			{
				throw new ArgumentError("目標値は " + uint.MAX_VALUE + " 未満で指定して下さい。");
			}
			_targetCount  = targetCount;
			reset();
		}
		
		/**
		 * カウント数を +1 します.
		 * 
		 * @return カウントした結果が目標値に達しているなら <code>true</code>、達していないなら <code>false</code> が返されます。
		 */
		public function count():Boolean
		{
			_currentCount++;
			if (_currentCount >= _targetCount)
			{
				_currentCount = _targetCount;
				return true;
			}
			return false;
		}
		
		/**
		 * カウントをリセットします.
		 * <p>
		 * カウントの目標値は変更されません。
		 * </p>
		 */
		public function reset():void
		{
			_currentCount = 0;
		}
	}
}
