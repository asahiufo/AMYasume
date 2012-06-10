package tasks.main 
{
	import org.ahiufomasao.yasume.utils.Task;
	
	/**
	 * テンプタスク
	 * 
	 * @author temp@temp
	 */
	public class TempTask extends Task 
	{
		/**
		 * コンテキスト
		 */
		public function TempTask() 
		{
			super();
		}
		
		/**
		 * 初期処理
		 * 
		 * @param context 実行コンテキスト
		 */
		public function initialize(context:ITempTaskExecCtx):void
		{
			changeExec(_execMain);
			changeDraw(_drawMain);
		}
		/**
		 * 終了処理
		 * 
		 * @param context 実行コンテキスト
		 */
		public function terminate(context:ITempTaskExecCtx):void
		{
		}
		
		/**
		 * メイン実行関数
		 * 
		 * @param context 実行コンテキスト
		 */
		private function _execMain(context:ITempTaskExecCtx):void
		{
		}
		
		/**
		 * メイン描画関数
		 * 
		 * @param context 描画コンテキスト
		 */
		private function _drawMain(context:ITempTaskDrawCtx):void
		{
		}
	}
}