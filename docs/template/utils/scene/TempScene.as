package  
{
	import org.ahiufomasao.yasume.utils.Scene;
	
	/**
	 * テンプシーン
	 * 
	 * @author temp@temp
	 */
	public class TempScene extends Scene 
	{
		/**
		 * コンストラクタ
		 */
		public function TempScene() 
		{
			super();
		}
		
		/**
		 * シーン初期処理
		 * 
		 * @param context コンテキスト
		 */
		public function initialize(context:ITempSceneExecCtx):void
		{
			changeExec(_execTemp);
		}
		
		/**
		 * シーン終了処理
		 * 
		 * @param context コンテキスト
		 */
		public function terminate(context:ITempSceneExecCtx):void
		{
		}
		
		/**
		 * テンプ実行関数
		 * 
		 * @param context コンテキスト
		 */
		private function _execTemp(context:ITempSceneExecCtx):void
		{
		}
		
		/**
		 * テンプ描画関数
		 * 
		 * @param context コンテキスト
		 */
		private function _drawTemp(context:ITempSceneDrawCtx):void
		{
		}
	}
}