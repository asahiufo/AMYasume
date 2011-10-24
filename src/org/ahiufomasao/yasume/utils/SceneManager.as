package org.ahiufomasao.yasume.utils 
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	// TODO: テスト
	// TODO: asdoc
	/**
	 * シーンマネージャー
	 * 
	 * @author asahiufo/AM902
	 */
	public class SceneManager 
	{
		private var _scenes:Dictionary;  // シーンリスト
		private var _currentScene:Scene; // 処理中のシーン
		private var _nextScene:Scene;    // 次のシーン
		
		private var _task:Task; // タスク
		
		/**
		 * コンストラクタ
		 */
		public function SceneManager() 
		{
			_scenes       = new Dictionary();
			_currentScene = null;
			_nextScene    = null;
			
			_task = new Task();
			_task.changeExec(_execInitializeScene);
		}
		
		/**
		 * シーン追加
		 * 
		 * @param name  シーン名（登録済み名前を指定した場合上書きされる）
		 * @param scene 追加するシーン
		 * 
		 * @return 追加したシーン
		 */
		public function addScene(name:String, scene:Scene):Scene
		{
			if (scene.addedSceneManager != null)
			{
				throw new IllegalOperationError("シーンマネージャー登録済みのシーンは登録できません。");
			}
			_scenes[name] = scene;
			scene.setAddedSceneManager(this);
			if (_currentScene == null)
			{
				_currentScene = scene;
			}
			return scene;
		}
		
		/**
		 * シーン取得
		 * 
		 * @param name 取得するシーン名
		 * 
		 * @return 指定した名前のシーン
		 */
		public function getScene(name:String):Scene
		{
			if (_scenes[name] == undefined)
			{
				throw new ArgumentError("指定した名前のシーンは登録されていません。[name = " + name + "]");
			}
			return Scene(_scenes[name]);
		}
		
		/**
		 * シーン変更
		 * 
		 * @param name 変更するシーン名
		 */
		public function changeScene(name:String):void
		{
			if (_scenes[name] == undefined)
			{
				throw new ArgumentError("指定した名前のシーンは登録されていません。[name = " + name + "]");
			}
			_nextScene = Scene(_scenes[name]);
		}
		
		/**
		 * 実行
		 * 
		 * @param context 実行コンテキスト
		 */
		public function exec(context:Object):void
		{
			_task.exec(context);
		}
		/**
		 * 描画
		 * 
		 * @param context 描画コンテキスト
		 */
		public function draw(context:Object):void
		{
			_task.draw(context);
		}
		
		/**
		 * シーン初期処理実行関数
		 * 
		 * @param context 実行コンテキスト
		 */
		private function _execInitializeScene(context:Object):void
		{
			_currentScene.runInitializeFunction(context);
			
			// ローディングが必要な場合
			if (_currentScene.preLoadingNecessity || _currentScene.mainLoadingNecessity)
			{
				// ローディング開始効果が必要な場合
				if (_currentScene.loadingStartEffectNecessity)
				{
					// ローディング開始効果実行
					_currentScene.initializeLoadingStartEffect();
					_task.changeExec(_execLoadingStartEffect);
					_task.changeDraw(_drawLoadingStartEffect);
					
					// ローディングの初期化も実行
					if (_currentScene.preLoadingNecessity)
					{
						_currentScene.initializePreLoading();
						return;
					}
					_currentScene.initializeMainLoading();
					return;
				}
				// 設定ローディングが必要な場合
				if (_currentScene.preLoadingNecessity)
				{
					// 設定ローディング実行
					_currentScene.initializePreLoading();
					_task.changeExec(_execPreLoading);
					_task.changeDraw(_drawPreLoading);
					return;
				}
				// データローディング実行
				_currentScene.initializeMainLoading();
				_task.changeExec(_execMainLoading);
				_task.changeDraw(_drawMainLoading);
				return;
			}
			// シーン開始効果が必要な場合
			if (_currentScene.sceneStartEffectNecessity)
			{
				// シーン開始効果実行
				_currentScene.initializeSceneStartEffect();
				_task.changeExec(_execSceneStartEffect);
				_task.changeDraw(_drawSceneStartEffect);
				return;
			}
			// シーン実行
			_task.changeExec(_execScene);
			_task.changeDraw(_drawScene);
		}
		
		/**
		 * ローディング開始効果実行関数
		 * 
		 * @param context 実行コンテキスト
		 */
		private function _execLoadingStartEffect(context:Object):void
		{
			// 1フェーズ分のローディング効果実行
			if (_currentScene.preLoadingNecessity)
			{
				_currentScene.executePreLoading();
			}
			else if (_currentScene.mainLoadingNecessity)
			{
				_currentScene.executeMainLoading();
			}
			
			if (!_currentScene.executeLoadingStartEffect())
			{
				return;
			}
			_currentScene.terminateLoadingStartEffect();
			// 設定ローディングが必要な場合
			if (_currentScene.preLoadingNecessity)
			{
				// 設定ローディング実行
				_currentScene.initializePreLoading();
				_task.changeExec(_execPreLoading);
				_task.changeDraw(_drawPreLoading);
				return;
			}
			// データローディング実行
			_currentScene.initializeMainLoading();
			_task.changeExec(_execMainLoading);
			_task.changeDraw(_drawMainLoading);
		}
		/**
		 * ローディング開始効果描画関数
		 * 
		 * @param context 描画コンテキスト
		 */
		private function _drawLoadingStartEffect(context:Object):void
		{
			// 1フェーズ分のローディング効果実行
			if (_currentScene.preLoadingNecessity)
			{
				_currentScene.drawPreLoading();
			}
			else if (_currentScene.mainLoadingNecessity)
			{
				_currentScene.drawMainLoading();
			}
			
			_currentScene.drawLoadingStartEffect();
		}
		
		/**
		 * 設定ローディング実行関数
		 * 
		 * @param context 実行コンテキスト
		 */
		private function _execPreLoading(context:Object):void
		{
			if (!_currentScene.executePreLoading())
			{
				return;
			}
			_currentScene.terminatePreLoading();
			// データローディングが必要な場合
			if (_currentScene.mainLoadingNecessity)
			{
				// データローディング実行
				_currentScene.initializeMainLoading();
				_task.changeExec(_execMainLoading);
				_task.changeDraw(_drawMainLoading);
				return;
			}
			// ローディング終了効果が必要な場合
			if (_currentScene.loadingEndEffectNecessity)
			{
				// ローディング終了効果実行
				_currentScene.initializeLoadingEndEffect();
				_task.changeExec(_execLoadingEndEffect);
				_task.changeDraw(_drawLoadingEndEffect);
				return;
			}
			// シーン開始効果が必要な場合
			if (_currentScene.sceneStartEffectNecessity)
			{
				// シーン開始効果実行
				_currentScene.initializeSceneStartEffect();
				_task.changeExec(_execSceneStartEffect);
				_task.changeDraw(_drawSceneStartEffect);
				return;
			}
			// シーン実行
			_task.changeExec(_execScene);
			_task.changeDraw(_drawScene);
		}
		/**
		 * 設定ローディング描画関数
		 * 
		 * @param context 描画コンテキスト
		 */
		private function _drawPreLoading(context:Object):void
		{
			_currentScene.drawPreLoading();
		}
		
		/**
		 * データローディング実行関数
		 * 
		 * @param context 実行コンテキスト
		 */
		private function _execMainLoading(context:Object):void
		{
			if (!_currentScene.executeMainLoading())
			{
				return;
			}
			_currentScene.terminateMainLoading();
			// ローディング終了効果が必要な場合
			if (_currentScene.loadingEndEffectNecessity)
			{
				// ローディング終了効果実行
				_currentScene.initializeLoadingEndEffect();
				_task.changeExec(_execLoadingEndEffect);
				_task.changeDraw(_drawLoadingEndEffect);
				return;
			}
			// シーン開始効果が必要な場合
			if (_currentScene.sceneStartEffectNecessity)
			{
				// シーン開始効果実行
				_currentScene.initializeSceneStartEffect();
				_task.changeExec(_execSceneStartEffect);
				_task.changeDraw(_drawSceneStartEffect);
				return;
			}
			// シーン実行
			_task.changeExec(_execScene);
			_task.changeDraw(_drawScene);
		}
		/**
		 * データローディング描画関数
		 * 
		 * @param context 描画コンテキスト
		 */
		private function _drawMainLoading(context:Object):void
		{
			_currentScene.drawMainLoading();
		}
		
		/**
		 * ローディング終了効果実行関数
		 * 
		 * @param context 実行コンテキスト
		 */
		private function _execLoadingEndEffect(context:Object):void
		{
			if (!_currentScene.executeLoadingEndEffect())
			{
				return;
			}
			_currentScene.terminateLoadingEndEffect();
			// シーン開始効果が必要な場合
			if (_currentScene.sceneStartEffectNecessity)
			{
				// シーン開始効果実行
				_currentScene.initializeSceneStartEffect();
				_task.changeExec(_execSceneStartEffect);
				_task.changeDraw(_drawSceneStartEffect);
				return;
			}
			// シーン実行
			_task.changeExec(_execScene);
			_task.changeDraw(_drawScene);
		}
		/**
		 * ローディング終了効果描画関数
		 * 
		 * @param context 描画コンテキスト
		 */
		private function _drawLoadingEndEffect(context:Object):void
		{
			_currentScene.drawLoadingEndEffect();
		}
		
		/**
		 * シーン開始効果実行関数
		 * 
		 * @param context 実行コンテキスト
		 */
		private function _execSceneStartEffect(context:Object):void
		{
			_currentScene.exec(context);
			if (!_currentScene.executeSceneStartEffect())
			{
				return;
			}
			_currentScene.terminateSceneStartEffect();
			// シーン実行
			_task.changeExec(_execScene);
			_task.changeDraw(_drawScene);
		}
		/**
		 * シーン開始効果描画関数
		 * 
		 * @param context 描画コンテキスト
		 */
		private function _drawSceneStartEffect(context:Object):void
		{
			_currentScene.draw(context);
			_currentScene.drawSceneStartEffect();
		}
		
		/**
		 * シーン実行関数
		 * 
		 * @param context 実行コンテキスト
		 */
		private function _execScene(context:Object):void
		{
			_currentScene.exec(context);
			// シーンが変更されていない場合
			if (_nextScene == null)
			{
				return;
			}
			// シーン終了効果が必要な場合
			if (_currentScene.sceneEndEffectNecessity)
			{
				// シーン終了効果実行
				_currentScene.initializeSceneEndEffect();
				_task.changeExec(_execSceneEndEffect);
				_task.changeDraw(_drawSceneEndEffect);
				return;
			}
			_currentScene.runTerminateFunction(context);
			
			// シーン切り替え
			_currentScene = _nextScene;
			_nextScene = null;
			
			// シーン処理開始
			_execInitializeScene(context);
		}
		/**
		 * シーン描画関数
		 * 
		 * @param context 描画コンテキスト
		 */
		private function _drawScene(context:Object):void
		{
			_currentScene.draw(context);
		}
		
		/**
		 * シーン終了効果実行関数
		 * 
		 * @param context 実行コンテキスト
		 */
		private function _execSceneEndEffect(context:Object):void
		{
			if (!_currentScene.executeSceneEndEffect())
			{
				return;
			}
			_currentScene.terminateSceneEndEffect();
			_currentScene.runTerminateFunction(context);
			
			// シーン切り替え
			_currentScene = _nextScene;
			_nextScene = null;
			
			// シーン処理開始
			_execInitializeScene(context);
		}
		/**
		 * シーン終了効果描画関数
		 * 
		 * @param context 描画コンテキスト
		 */
		private function _drawSceneEndEffect(context:Object):void
		{
			_currentScene.drawSceneEndEffect();
		}
	}
}