package org.ahiufomasao.yasume.utils 
{
	import flash.errors.IllegalOperationError;
	
	/**
	 * <code>ChainCounter</code> クラスは、連鎖回数のカウントと、
	 * 連鎖数に応じたスコアの取得を行います.
	 * <p>
	 * 最初に <code>setScoreSetting</code> メソッドを呼び出し、
	 * 連鎖数毎のスコアを設定します。
	 * 変わりに <code>setDefaultScoreSetting</code> メソッドを呼び出すことで、
	 * <code>ChainCounter</code> クラスのデフォルトのスコアを設定することもできます。
	 * </p>
	 * <p>
	 * 以降、連鎖するたびに <code>count</code> メソッドを呼び出し、
	 * 連鎖数に応じたスコアを <code>currentScore</code> プロパティより取得します。
	 * </p>
	 * @example 次のコードは <code>ChainCounter</code> クラスの基本的な使用方法です。
	 * <listing version="3.0">
	 * var chainCounter:ChainCounter = new ChainCounter();
	 * var scoreSetting:Vector.&lt;Number&gt; = new Vector.&lt;Number&gt;();
	 * scoreSetting.push(0);
	 * scoreSetting.push(100);
	 * scoreSetting.push(200);
	 * scoreSetting.push(300);
	 * chainCounter.setScoreSetting(scoreSetting);
	 * 
	 * chainCounter.count();
	 * trace("1連鎖: スコア " + chainCounter.currentScore);
	 * chainCounter.count();
	 * trace("2連鎖: スコア " + chainCounter.currentScore);</listing>
	 * 
	 * @author asahiufo/AM902
	 * @see #setScoreSetting()
	 * @see #setDefaultScoreSetting()
	 * @see #count()
	 * @see #currentScore
	 */
	public class ChainCounter 
	{
		private var _currentCount:uint;            // 連鎖カウント
		private var _scoreSetting:Vector.<Number>; // スコア設定
		
		/**
		 * 現在の連鎖数です.
		 */
		public function get currentCount():uint { return _currentCount; }
		
		/**
		 * 現在の連鎖に伴うスコアです.
		 * 
		 * @throws IllegalOperationError スコアが設定されていない場合にスローされます。
		 */
		public function get currentScore():Number
		{
			if (_scoreSetting == null)
			{
				throw new IllegalOperationError("スコアを設定してから参照して下さい。");
			}
			return _scoreSetting[_currentCount];
		}
		
		/**
		 * 新しい <code>ChainCounter</code> クラスのインスタンスを生成します.
		 */
		public function ChainCounter() 
		{
			_scoreSetting = null;
			
			reset();
		}
		
		/**
		 * デフォルトのスコアを設定します.
		 * <p>
		 * 以下のスコアが設定されます。
		 * <table>
		 * <tr><th>連鎖数</th><th>スコア</th></tr>
		 * <tr><td>0</td><td>0</td></tr>
		 * <tr><td>1</td><td>100</td></tr>
		 * <tr><td>2</td><td>200</td></tr>
		 * <tr><td>3</td><td>400</td></tr>
		 * <tr><td>4</td><td>800</td></tr>
		 * <tr><td>5</td><td>1000</td></tr>
		 * <tr><td>6</td><td>2000</td></tr>
		 * <tr><td>7</td><td>5000</td></tr>
		 * <tr><td>8</td><td>8000</td></tr>
		 * <tr><td>9</td><td>10000</td></tr>
		 * </table>
		 * </p>
		 */
		public function setDefaultScoreSetting():void
		{
			var scoreSetting:Vector.<Number> = new Vector.<Number>();
			scoreSetting.push(0);
			scoreSetting.push(100);
			scoreSetting.push(200);
			scoreSetting.push(400);
			scoreSetting.push(800);
			scoreSetting.push(1000);
			scoreSetting.push(2000);
			scoreSetting.push(5000);
			scoreSetting.push(8000);
			scoreSetting.push(10000);
			setScoreSetting(scoreSetting);
		}
		
		/**
		 * スコアを設定します.
		 * <p>
		 * インデックスの番号を連鎖数、そのインデックスに設定された値をスコアとした
		 * <code>Vector.&lt;Number&gt;</code> 型のリストでスコアを設定します。
		 * </p>
		 * 
		 * @param scoreSetting インデックスの番号を連鎖数、そのインデックスに設定された値をスコアとしたリストです。
		 * 
		 * @throws ArgumentError <code>scoreSetting</code> パラメータに <code>null</code> を指定した場合スローされます。
		 * @throws ArgumentError <code>scoreSetting</code> パラメータに長さが 0 のリストを設定した場合スローされます。
		 */
		public function setScoreSetting(scoreSetting:Vector.<Number>):void
		{
			if (scoreSetting == null)
			{
				throw new ArgumentError("スコア設定に null は使用できません。");
			}
			if (scoreSetting.length == 0)
			{
				throw new ArgumentError("0 件でスコア設定することはできません。");
			}
			_scoreSetting = scoreSetting;
			
			reset();
		}
		
		/**
		 * 連鎖状態を初期化します.
		 */
		public function reset():void
		{
			_currentCount = 0;
		}
		
		/**
		 * 連鎖数を +1 します.
		 * 
		 * @throws IllegalOperationError スコアが設定されていない場合にスローされます。
		 */
		public function count():void
		{
			if (_scoreSetting == null)
			{
				throw new IllegalOperationError("スコアを設定してから実行して下さい。");
			}
			_currentCount++;
			// 連鎖設定の上限を超えたら補正する
			if (_currentCount >= _scoreSetting.length)
			{
				_currentCount = _scoreSetting.length - 1;
			}
		}
	}
}
