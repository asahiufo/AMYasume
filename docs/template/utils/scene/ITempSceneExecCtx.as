package scenes 
{
	import flash.display.Sprite;
	import org.ahiufomasao.utility.display.BitmapCanvas;
	
	/**
	 * テンプシーン実行コンテキスト
	 * 
	 * @author temp@temp
	 */
	public interface ITempSceneExecCtx 
	{
		/**
		 * 画面効果用キャンバス
		 */
		function get screenEffectCanvas():BitmapCanvas;
		/**
		 * ルートスプライト
		 */
		function get rootSp():Sprite;
		/**
		 * メインシーンへ遷移
		 */
		function changeMainScene():void;
	}
}