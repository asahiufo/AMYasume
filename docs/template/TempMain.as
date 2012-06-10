package  
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import org.ahiufomasao.utility.display.BitmapCanvas;
	import org.ahiufomasao.yasume.utils.SceneManager;
	import scenes.ITempSceneDrawCtx;
	import scenes.ITempSceneExecCtx;
	import scenes.SceneName;
	import scenes.TempScene;
	
	/**
	 * ドキュメントクラス
	 * 
	 * @author temp@temp
	 */
	public class TempMain extends Sprite implements
		ITempSceneExecCtx,
		ITempSceneDrawCtx
	{
		private var _sceneManager:SceneManager;
		
		private var _screenEffectCanvas:BitmapCanvas;
		private var _rootSp:Sprite;
		
		/**
		 * @inheritDoc
		 */
		public function get screenEffectCanvas():BitmapCanvas { return _screenEffectCanvas; }
		/**
		 * @inheritDoc
		 */
		public function get rootSp():Sprite { return _rootSp; }
		
		/**
		 * コンストラクタ
		 */
		public function TempMain() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		/**
		 * ステージ追加イベントハンドラ
		 * 
		 * @param event イベント
		 */
		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align     = StageAlign.TOP_LEFT;
			
			_screenEffectCanvas = new BitmapCanvas(stage.stageWidth, stage.stageHeight);
			_rootSp = new Sprite();
			addChild(_rootSp);
			_screenEffectCanvas.added(this);
			
			_sceneManager = new SceneManager();
			_sceneManager.addScene(SceneName.TITLE, new TempScene());
			_sceneManager.addScene(SceneName.MAIN, new TempScene());
			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		/**
		 * エンターフレームイベントハンドラ
		 * 
		 * @param event イベント
		 */
		private function _onEnterFrame(event:Event):void
		{
			_sceneManager.exec(this);
			_sceneManager.draw(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function changeMainScene():void 
		{
			_sceneManager.changeScene(SceneName.MAIN);
		}
	}
}