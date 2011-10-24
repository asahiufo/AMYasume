package org.ahiufomasao.yasume.utils 
{
	import org.ahiufomasao.utility.net.LoaderCollection;
	import org.ahiufomasao.yasume.effects.IEffect;
	
	// TODO: asdoc
	// TODO: テスト
	/**
	 * シーン
	 * 
	 * @author asahiufo/AM902
	 */
	public class Scene extends Task 
	{
		private static const _INITIALIZE_FUNCTION_NAME:String = "initialize"; // 初期処理メソッド名
		private static const _TERMINATE_FUNCTION_NAME:String  = "terminate";  // 終了処理メソッド名
		
		private var _addedSceneManager:SceneManager; // このシーンが登録されているシーンマネージャー
		
		private var _loadingStartEffect:IEffect; // ローディング開始効果
		private var _loadingEndEffect:IEffect;   // ローディング終了効果
		private var _preLoadingEffect:IEffect;   // プレローディング効果
		private var _mainLoadingEffect:IEffect;  // メインローディング効果
		private var _sceneStartEffect:IEffect;   // シーン開始効果
		private var _sceneEndEffect:IEffect;     // シーン終了効果
		
		private var _preLoaderCollection:LoaderCollection;  // プレローダーコレクション
		private var _mainLoaderCollection:LoaderCollection; // メインローダーコレクション
		
		/** このシーンが登録されているシーンマネージャー */
		public function get addedSceneManager():SceneManager { return _addedSceneManager; }
		/** @private */
		internal function setAddedSceneManager(value:SceneManager):void { _addedSceneManager = value; }
		
		/** ローディング開始効果 */
		protected function setLoadingStartEffect(value:IEffect):void { _loadingStartEffect = value; }
		/** ローディング終了効果 */
		protected function setLoadingEndEffect(value:IEffect):void { _loadingEndEffect = value; }
		/** プレローディング効果 */
		protected function setPreLoadingEffect(value:IEffect):void { _preLoadingEffect = value; }
		/** メインローディング効果 */
		protected function setMainLoadingEffect(value:IEffect):void { _mainLoadingEffect = value; }
		/** シーン開始効果 */
		protected function setSceneStartEffect(value:IEffect):void { _sceneStartEffect = value; }
		/** シーン終了効果 */
		protected function setSceneEndEffect(value:IEffect):void { _sceneEndEffect = value; }
		
		/** プレローダーコレクション */
		protected function get preLoaderCollection():LoaderCollection { return _preLoaderCollection; }
		/** メインローダーコレクション */
		protected function get mainLoaderCollection():LoaderCollection { return _mainLoaderCollection; }
		
		/** プレローディングが必要なら true */
		internal function get preLoadingNecessity():Boolean { return _preLoaderCollection != null && _preLoaderCollection.bytesTotal != 0; }
		/** メインローディングが必要なら true */
		internal function get mainLoadingNecessity():Boolean { return _mainLoaderCollection != null && _mainLoaderCollection.bytesTotal != 0; }
		/** ローディング開始効果が必要なら true */
		internal function get loadingStartEffectNecessity():Boolean { return (preLoadingNecessity || mainLoadingNecessity) && _loadingStartEffect != null; }
		/** ローディング終了効果が必要なら true */
		internal function get loadingEndEffectNecessity():Boolean { return (preLoadingNecessity || mainLoadingNecessity) && _loadingEndEffect != null; }
		/** プレローディング効果が必要なら true */
		internal function get preLoadingEffectNecessity():Boolean { return preLoadingNecessity && _preLoadingEffect != null; }
		/** メインローディング効果が必要なら true */
		internal function get mainLoadingEffectNecessity():Boolean { return mainLoadingNecessity && _mainLoadingEffect != null; }
		/** シーン開始効果が必要なら true */
		internal function get sceneStartEffectNecessity():Boolean { return _sceneStartEffect != null; }
		/** シーン終了効果が必要なら true */
		internal function get sceneEndEffectNecessity():Boolean { return _sceneEndEffect != null; }
		
		/**
		 * コンストラクタ
		 */
		public function Scene() 
		{
			super();
			
			_addedSceneManager = null;
			
			_loadingStartEffect = null;
			_loadingEndEffect   = null;
			_preLoadingEffect   = null;
			_mainLoadingEffect  = null;
			_sceneStartEffect   = null;
			_sceneEndEffect     = null;
			
			_preLoaderCollection  = null;
			_mainLoaderCollection = null;
		}
		
		/**
		 * 初期処理メソッド実行
		 * 
		 * @param context 実行コンテキスト
		 */
		internal function runInitializeFunction(context:Object):void
		{
			// メソッドが設定されていない場合終了
			if (!(_INITIALIZE_FUNCTION_NAME in this))
			{
				return;
			}
			
			var func:Function = this[_INITIALIZE_FUNCTION_NAME] as Function;
			
			_preLoaderCollection  = new LoaderCollection();
			_mainLoaderCollection = new LoaderCollection();
			
			func(context);
		}
		
		/**
		 * 終了処理メソッド実行
		 * 
		 * @param context 実行コンテキスト
		 */
		internal function runTerminateFunction(context:Object):void
		{
			// メソッドが設定されていない場合終了
			if (!(_TERMINATE_FUNCTION_NAME in this))
			{
				return;
			}
			
			var func:Function = this[_TERMINATE_FUNCTION_NAME] as Function;
			
			func(context);
		}
		
		/**
		 * ロード開始効果初期処理
		 */
		internal function initializeLoadingStartEffect():void
		{
			_loadingStartEffect.initialize();
		}
		/**
		 * ロード開始効果実行
		 */
		internal function executeLoadingStartEffect():Boolean
		{
			return _loadingStartEffect.exec();
		}
		/**
		 * ロード開始効果描画
		 */
		internal function drawLoadingStartEffect():void
		{
			_loadingStartEffect.draw();
		}
		/**
		 * ロード開始効果終了処理
		 */
		internal function terminateLoadingStartEffect():void
		{
			_loadingStartEffect.terminate();
		}
		
		/**
		 * プレローディング初期処理
		 */
		internal function initializePreLoading():void
		{
			_preLoaderCollection.loadAll();
			_preLoadingEffect.initialize();
		}
		/**
		 * プレローディング実行
		 */
		internal function executePreLoading():Boolean
		{
			if (_preLoadingEffect != null)
			{
				return _preLoadingEffect.exec();
			}
			return _preLoaderCollection.complete;
		}
		/**
		 * プレローディング描画
		 */
		internal function drawPreLoading():void
		{
			_preLoadingEffect.draw();
		}
		/**
		 * プレローディング終了処理
		 */
		internal function terminatePreLoading():void
		{
			_preLoadingEffect.terminate();
		}
		/**
		 * メインローディング初期処理
		 */
		internal function initializeMainLoading():void
		{
			_mainLoaderCollection.loadAll();
			_mainLoadingEffect.initialize();
		}
		/**
		 * メインローディング実行
		 */
		internal function executeMainLoading():Boolean
		{
			if (_mainLoadingEffect != null)
			{
				return _mainLoadingEffect.exec();
			}
			return _mainLoaderCollection.complete;
		}
		/**
		 * メインローディング描画
		 */
		internal function drawMainLoading():void
		{
			_mainLoadingEffect.draw();
		}
		/**
		 * メインローディング終了処理
		 */
		internal function terminateMainLoading():void
		{
			_mainLoadingEffect.terminate();
		}
		
		/**
		 * ロード終了効果初期処理
		 */
		internal function initializeLoadingEndEffect():void
		{
			_loadingEndEffect.initialize();
		}
		/**
		 * ロード終了効果実行
		 */
		internal function executeLoadingEndEffect():Boolean
		{
			return _loadingEndEffect.exec();
		}
		/**
		 * ロード終了効果描画
		 */
		internal function drawLoadingEndEffect():void
		{
			_loadingEndEffect.draw();
		}
		/**
		 * ロード終了効果終了処理
		 */
		internal function terminateLoadingEndEffect():void
		{
			_loadingEndEffect.terminate();
		}
		
		/**
		 * シーン開始効果初期処理
		 */
		internal function initializeSceneStartEffect():void
		{
			_sceneStartEffect.initialize();
		}
		/**
		 * シーン開始効果実行
		 */
		internal function executeSceneStartEffect():Boolean
		{
			return _sceneStartEffect.exec();
		}
		/**
		 * シーン開始効果描画
		 */
		internal function drawSceneStartEffect():void
		{
			_sceneStartEffect.draw();
		}
		/**
		 * シーン開始効果終了処理
		 */
		internal function terminateSceneStartEffect():void
		{
			_sceneStartEffect.terminate();
		}
		
		/**
		 * シーン終了効果初期処理
		 */
		internal function initializeSceneEndEffect():void
		{
			_sceneEndEffect.initialize();
		}
		/**
		 * シーン終了効果実行
		 */
		internal function executeSceneEndEffect():Boolean
		{
			return _sceneEndEffect.exec();
		}
		/**
		 * シーン終了効果描画
		 */
		internal function drawSceneEndEffect():void
		{
			_sceneEndEffect.draw();
		}
		/**
		 * シーン終了効果終了処理
		 */
		internal function terminateSceneEndEffect():void
		{
			_sceneEndEffect.terminate();
		}
	}
}
